import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:speedometer_chart/speedometer_chart.dart';
import 'package:rxdart/rxdart.dart';

class vista_afinador extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AfinadorPageState();
}

class _AfinadorPageState extends State<vista_afinador> {
  double _lowerValue = -20;
  double _upperValue = 20;
  int start = -50;
  int end = 50;
  double cents = 0.0;

  int counter = 0;

  PublishSubject<double> eventObservable = PublishSubject();
  @override
  void initState() {
    super.initState();
    const click = const Duration(milliseconds: 2000);
    var rng = Random();
    Timer.periodic(click, (Timer t) => eventObservable.add(cents));
  }

  final AudioRecorder _recorder = AudioRecorder();
  bool isRecording = false;
  bool isAfinando = false;
  String? _filePath;
  String note = "";

  @override
  void dispose() {
    _recorder.dispose();
    super.dispose();
  }

  Future<void> cambiaEstado() async {
    isAfinando = !isAfinando;
  }

  Future<void> startRecording() async {
    final bool isPermissionGranted = await _recorder.hasPermission();
    if (!isPermissionGranted) {
      return;
    }

    final directory = await getApplicationDocumentsDirectory();
    // Generate a unique file name using the current timestamp
    String fileName = 'recording_${DateTime.now().millisecondsSinceEpoch}.wav';
    _filePath = '${directory.path}/$fileName';

    // Define the configuration for the recording
    const config = RecordConfig(
      // Specify the format, encoder, sample rate, etc., as needed
      encoder: AudioEncoder.wav, // For example, using AAC codec
      sampleRate: 44100, // Sample rate
      bitRate: 128000, // Bit rate
    );

    // Start recording to file with the specified configuration
    await _recorder.start(config, path: _filePath!);
    setState(() {
      isRecording = true;
    });
  }

  Future<void> stopRecording() async {
    try {
      final path = await _recorder.stop();
      setState(() {
        isRecording = false;
      });

      if (path != null) {
        Uint8List audioData = await File(path).readAsBytes();
        int sampleRate = 44100; // Define tu sample rate aquí
        double frequency = obtenerFrecuencia(audioData.toList(), sampleRate);
        //print("Ojo con la frecuencia :$frequency  ");
        String calculatedNote = notaCercana(frequency);
        //print("Nota calculada: $calculatedNote, Cents: $cents");
        setState(() => note = calculatedNote);
      }
    } catch (e) {
      //print('Error al detener la grabación: $e');
    }
  }

  // Lógica de frecuencia y nota (reutiliza el código que ya tienes)
  double obtenerFrecuencia(List<int> audioData, int sampleRate) {
    int peakIndex = audioData.indexOf(audioData.reduce(max));
    double frequency = (sampleRate * peakIndex) / audioData.length;
    return frequency;
  }

  String notaCercana(double frecuencia) {
    List<String> notas = [
      'C',
      'C#',
      'D',
      'D#',
      'E',
      'F',
      'F#',
      'G',
      'G#',
      'A',
      'A#',
      'B'
    ];
    double A4_frecuencia = 440.0;
    int A4_indice = 9;

    if (frecuencia.isNaN) {
      frecuencia = A4_frecuencia;
    }

    int numMitadPasos = (12 * log(frecuencia / A4_frecuencia) / log(2)).round();
    int indiceNota = (A4_indice + numMitadPasos) % 12;
    int octava = 4 + (A4_indice + numMitadPasos) ~/ 12;

    // Calcular la frecuencia exacta de la nota
    double frequencyOfNearestNote = A4_frecuencia * pow(2, numMitadPasos / 12);
    cents = calcularCents(frecuencia, frequencyOfNearestNote);

    print(
        "Frecuencia: $frecuencia, Mitad pasos: $numMitadPasos, indice Nota: $indiceNota ,octava $octava,cents $cents");

    // Retornar tanto la nota como la frecuencia exacta de la nota
    return '${notas[indiceNota]}$octava';
  }

  double calcularCents(double frecuencia, double frequencyOfNearestNote) {
    return 1200 * log(frecuencia / frequencyOfNearestNote) / log(2);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = ThemeData();
    ThemeData somTheme = theme.copyWith(
      colorScheme: theme.colorScheme.copyWith(
        primary: Theme.of(context).colorScheme.secondary,
        secondary: Theme.of(context).colorScheme.primary,
        background: Colors.grey,
      ),
    );
    var speedOMeter = SpeedometerChart(
      animationDuration: 1000,
      dimension: 400,
      minValue: 0,
      maxValue: 100,
      value: cents + 50,
      hasIconPointer: true,
      //graphColor: [Colors.blue,Colors.blueAccent],
      graphColor: [
        Colors.red,
        Colors.yellow,
        Colors.yellow,
        Colors.green,
        Colors.yellow,
        Colors.yellow,
        Colors.red
      ],
      pointerColor: Colors.black,
      minWidget: Text("-50",
          style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold)),
      maxWidget: Text("+50",
          style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold)),
    );
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isAfinando ? "Grabando..." : "Presiona para grabar",
              style: TextStyle(
                  fontSize: 20, color: Theme.of(context).colorScheme.primary),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await cambiaEstado();
                while (isAfinando) {
                  await startRecording();
                  await Future.delayed(Duration(seconds: 1));
                  await stopRecording();
                }
              },
              child: Text(
                isAfinando ? "Detener grabación" : "Iniciar grabación",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimary),
              ),
            ),
            SizedBox(height: 20),
            Text(
              note.isNotEmpty
                  ? "Nota detectada: $note"
                  : "No se ha detectado ninguna nota",
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary),
            ),
            Padding(
              padding: EdgeInsets.all(40.0),
              child: speedOMeter,
            ),
          ],
        ),
      ),
    );
  }
}
