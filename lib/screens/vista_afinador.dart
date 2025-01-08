import 'dart:async';

import 'package:celloapp/models/Afinador.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:math';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:speedometer_chart/speedometer_chart.dart';
import 'package:rxdart/rxdart.dart';

import '../services/ApiService.dart';

class vista_afinador extends StatefulWidget {
  const vista_afinador({super.key});

  @override
  State<StatefulWidget> createState() => _AfinadorPageState();
}

class _AfinadorPageState extends State<vista_afinador> {
  final ApiService apiService = ApiService();
  late Afinador afinador;

  int start = -50;
  int end = 50;
  double cents = 0.0;

  int counter = 0;

  PublishSubject<double> eventObservable = PublishSubject();
  @override
  void initState() {
    super.initState();
    const click = Duration(milliseconds: 2000);
    var rng = Random();
    Timer.periodic(click, (Timer t) => eventObservable.add(cents));
  }

  final AudioRecorder _recorder = AudioRecorder();
  bool isRecording = false;
  bool isAfinando = false;
  String _fileName = "";
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
    _fileName = 'recording_${DateTime.now().millisecondsSinceEpoch}.wav';
    _filePath = '${directory.path}/$_fileName';

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
        File audioData = await File(path);
        afinador = await apiService.afinador(audioData);
        note = afinador.nota;
        cents = afinador.cents;
      }
    } catch (e) {
      //print('Error al detener la grabación: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = ThemeData();
    ThemeData somTheme = theme.copyWith(
      colorScheme: theme.colorScheme.copyWith(
        primary: Theme.of(context).colorScheme.secondary,
        secondary: Theme.of(context).colorScheme.primary,
        surface: Colors.grey,
      ),
    );
    var speedOMeter = SpeedometerChart(
      animationDuration: 100,
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 100),
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
            Text(
                note.isNotEmpty
                    ? "Cents: $cents"
                    : "Cents: 0",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary))
          ],
        ),
      ),
    );
  }
}
