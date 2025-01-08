import 'dart:async';

import 'package:celloapp/models/Anomalia.dart';
import 'package:celloapp/screens/pastel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'dart:io';

import 'package:just_audio/just_audio.dart' as just_audio;
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import '../models/Analisis.dart';
import '../models/Obra.dart';
import '../models/Usuario.dart';
import '../services/ApiService.dart';
import '../services/Catalogo_controlador.dart';
import '../services/Usuario_controlador.dart';
import 'linea.dart';

class vista_analisis extends StatefulWidget {
  const vista_analisis({super.key});
  @override
  State<StatefulWidget> createState() => _AnalisisState();
}

class _AnalisisState extends State<vista_analisis> {
  final just_audio.AudioPlayer _audioPlayer = just_audio.AudioPlayer();
  final ApiService apiService = ApiService();
  late Future<List<dynamic>> datos;
  late Future<String> hola;
  late Analisis analisis;
  late List<Anomalia> anomalias;
  late List<Map<String, Duration>> grabaciones = [];
  late List<int> compas_anomalia = [];
  late double bpm;
  late double bpm_ajustado;
  late String retro;

  late final RecorderController recorderController;
  String? path;
  String? musicFile;
  bool isRecording = false;
  bool isRecordingCompleted = false;
  bool isAnalizando = false;
  bool isAnalizandoCompleted = false;
  bool isLoading = true;
  late Directory appDirectory;
  String _fileName = "";
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final User? UsuarioActual = FirebaseAuth.instance.currentUser;
  final Usuario_controlador controlador_usuario = Usuario_controlador();

  late Future<List<Obra>> listaFuture;
  List<Obra> lista = [];
  Obra? selectedObra;

  late Future<Usuario?> usuario;
  Usuario? login;

  Future<Usuario?> datos_usuario() async {
    final data = await controlador_usuario.obtener_usuario(UsuarioActual?.email);
    setState(() {
      login = data;
    });
    return data;
  }

  Future<List<Obra>> llenaSelect() async {
    Catalogo_controlador catalogo_controlador = Catalogo_controlador();
    final data = await catalogo_controlador.listaCatalogo();
    setState(() {
      lista = data;
      selectedObra = lista.isNotEmpty ? lista.first : null;
    });
    return data;
  }

  @override
  void initState() {
    super.initState();
    _getDir();
    _initialiseControllers();
    hola = apiService.hola();
    listaFuture = llenaSelect();
    usuario = datos_usuario();
    bpm = 0.0;
    bpm_ajustado = 0.0;
    retro = "Por evaluar";
  }

  void _getDir() async {
    appDirectory = await getApplicationDocumentsDirectory();
    _fileName = 'recording_${DateTime.now().millisecondsSinceEpoch}.m4a';
    path = '${appDirectory.path}/$_fileName';
    isLoading = false;
    setState(() {});
  }

  void _initialiseControllers() {
    recorderController = RecorderController()
      ..androidEncoder = AndroidEncoder.aac
      ..androidOutputFormat = AndroidOutputFormat.mpeg4
      ..iosEncoder = IosEncoder.kAudioFormatMPEG4AAC
      ..bitRate = 128000
      ..sampleRate = 44100;
  }

  void _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      musicFile = result.files.single.path;
      path = result.files.single.path;
      setState(() {});
    } else {
      debugPrint("File not picked");
    }
  }

  @override
  void dispose() {
    recorderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        body: SingleChildScrollView(
            child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    "Elige una obra a analizar",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary),
                  ),
                )
              ],
            ),
            Card(
              color: Theme.of(context).colorScheme.secondary,
              margin: EdgeInsets.all(16),
              elevation: 4,
              child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: DropdownButton<Obra>(
                              underline: Container(),
                              isExpanded: true,
                              dropdownColor:
                                  Theme.of(context).colorScheme.secondary,
                              elevation: 8,
                              value: selectedObra,
                              onChanged: (Obra? newObra) {
                                if (newObra != null) {
                                  setState(() {
                                    selectedObra = newObra;
                                  });
                                }
                              },
                              items: lista
                                  .map<DropdownMenuItem<Obra>>((Obra obra) {
                                return DropdownMenuItem<Obra>(
                                  alignment: Alignment.topLeft,
                                  value: obra,
                                  child: Text(
                                    obra.nombreObra,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Row(children: [
                        // Mostrar detalles de la obra seleccionada
                        Flexible(
                            child: Text(
                          "Obra seleccionada: ${selectedObra?.nombreObra}",
                          style: const TextStyle(fontSize: 12),
                          maxLines: 3, // Máximo dos líneas
                          overflow: TextOverflow.ellipsis,
                        ))
                      ]),
                      Row(children: [
                        // Mostrar detalles de la obra seleccionada
                        Flexible(
                            child: Text(
                          "Compositor: ${selectedObra?.compositor}",
                          style: const TextStyle(fontSize: 12),
                          maxLines: 3, // Máximo dos líneas
                          overflow: TextOverflow.ellipsis,
                        ))
                      ])
                    ],
                  )),
            ),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    "Graba o carga un audio",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary),
                  ),
                )
              ],
            ),
            Card(
              color: Theme.of(context).colorScheme.secondary,
              margin: EdgeInsets.all(16),
              elevation: 4,
              child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Flexible(
                            child: Center(
                                child: IconButton(
                          onPressed: _pickFile,
                          icon: Icon(Icons.upload_file),
                          color: Colors.white54,
                        ))),
                        SizedBox(width: 16),
                        Flexible(
                            child: Center(
                                child: IconButton(
                          onPressed: _startOrStopRecording,
                          icon: Icon(isRecording ? Icons.stop : Icons.mic),
                          color: Colors.white54,
                          iconSize: 28,
                        ))),
                        SizedBox(width: 16),
                        Flexible(
                            child: Center(
                                child: IconButton(
                          onPressed: _refreshWave,
                          icon: Icon(Icons.delete),
                          color: Theme.of(context).colorScheme.primaryContainer,
                          iconSize: 28,
                        ))),
                        SizedBox(width: 16),
                        Flexible(
                            child: Center(
                                child: IconButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Comenzando análisis')),
                            );

                            enviarParaAnalisis(path);

                            if (isAnalizando && !isAnalizandoCompleted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Analisis en proceso')),
                              );
                            }

                            if (isAnalizando && !isAnalizandoCompleted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Análisis completado')),
                              );
                            }
                          },
                          icon: Icon(Icons.send),
                          color:
                              Theme.of(context).colorScheme.secondaryContainer,
                          iconSize: 28,
                        ))),
                      ]),
                      SizedBox(height: 16),
                      Text(isRecording
                          ? 'Grabando...'
                          : bpm > 0.0
                              ? 'Se terminó la grabación'
                              : ''),
                      SizedBox(height: 16),
                      Row(children: [
                        if (isRecordingCompleted && musicFile == null)
                          Flexible(
                              child: Center(
                                  child: WaveBubble(
                            path: path,
                            width: 200,
                            appDirectory: appDirectory,
                          ))),
                        if (musicFile != null && !isRecordingCompleted)
                          Flexible(
                              child: Center(
                                  child: WaveBubble(
                            path: musicFile,
                            width: 200,
                            appDirectory: appDirectory,
                          )))
                      ]),
                    ],
                  )),
            ),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    "Resultados análisis",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary),
                  ),
                )
              ],
            ),
            (bpm != 0.0)
                ? Card(
                    color: Theme.of(context).colorScheme.secondary,
                    margin: EdgeInsets.all(16),
                    elevation: 4,
                    child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 16),
                            Row(children: [
                              Flexible(
                                child: Center(
                                    child: Text(
                                  "Evaluación: ${retro}",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary),
                                )),
                              )
                            ]),
                            SizedBox(height: 16),
                            Row(
                              children: [
                                Flexible(
                                  child: Center(child: Text("BPM: ${bpm}")),
                                ),
                                SizedBox(width: 16),
                                Flexible(
                                  child: Center(
                                      child: Text(
                                          "BPM ajustado: ${bpm_ajustado}")),
                                ),
                              ],
                            ),
                            SizedBox(height: 24),
                            Row(children: [
                              Flexible(
                                child: Center(
                                    child: Text(
                                        "Total de notas: ${analisis.total_notas}")),
                              )
                            ]),
                            //SizedBox(height: 16),
                            //Linea(),
                            Row(children: [
                              Flexible(
                                  child: Center(
                                      child: Pastel(
                                          afinadas:
                                              analisis.porcentaje_afinadas,
                                          desafinadas:
                                              analisis.porcentaje_desfinadas)))
                            ]),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Table(
                                border: TableBorder.all(),
                                columnWidths: const {
                                  0: FlexColumnWidth(2),
                                  1: FlexColumnWidth(2),
                                  2: FlexColumnWidth(2),
                                },
                                children: [
                                  TableRow(
                                    children: [
                                      Text('Nota',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      Text('Cents',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      Text('Compas',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  ...analisis.desafinada
                                      .map((desafinada) => TableRow(children: [
                                            Container(
                                              child: Text(
                                                '  ${desafinada.nota}',
                                                style: TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onPrimaryContainer,
                                                ),
                                              ),
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onPrimary,
                                            ),
                                            Container(
                                              child: Text(
                                                '  ${desafinada.cents}',
                                                style: TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onPrimaryContainer,
                                                ),
                                              ),
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onPrimary,
                                            ),
                                            Container(
                                              child: Text(
                                                '  ${desafinada.compas}',
                                                style: TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onPrimaryContainer,
                                                ),
                                              ),
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onPrimary,
                                            ),
                                          ])),
                                ],
                              ),
                            ),
                            SizedBox(height: 16),
                            Row(children: [
                              Flexible(
                                  child: Center(
                                      child: Text(
                                          "Anomalias encontradas : ${anomalias.length}",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold))))
                            ]),
                            SizedBox(height: 16),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children:
                                  List.generate(grabaciones.length, (index) {
                                final clip = grabaciones[index];
                                return Center(
                                    child: Row(children: [
                                  Flexible(
                                      child: Center(
                                          child: ElevatedButton(
                                    onPressed: () =>
                                        _playClip(clip['start']!, clip['end']!),
                                    child: Text(
                                      'Clip ${index + 1}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimary),
                                    ),
                                  ))),
                                  Flexible(
                                      child: Center(
                                          child: Text(
                                              "Compas : ${compas_anomalia[index]}")))
                                ]));
                              }),
                            )
                          ],
                        )),
                  )
                : Card(
                    color: Theme.of(context).colorScheme.secondary,
                    margin: EdgeInsets.all(16),
                    elevation: 4,
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          SizedBox(height: 16),
                          Row(children: [
                            Flexible(
                                child: Center(
                              child: Text('No hay datos disponibles',
                                  style: TextStyle(fontSize: 16)),
                            ))
                          ]),
                        ],
                      ),
                    ))
          ],
        )));
  }

  Future<void> _playClip(Duration start, Duration end) async {
    try {
      // Cargar el clip usando setClip
      String? _audioUrl = "";
      if (isRecordingCompleted && musicFile == null) {
        _audioUrl = path;
      } else {
        if (musicFile != null && !isRecordingCompleted) {
          _audioUrl = musicFile;
        }
      }

      if (File(_audioUrl!).existsSync()) {
        try {
          final audioSource = just_audio.AudioSource.uri(Uri.file(_audioUrl));
          await _audioPlayer.setAudioSource(audioSource);
          await _audioPlayer.setClip(start: start, end: end);
          await _audioPlayer.play();
        } catch (e) {
          print("Error al reproducir el clip: $e");
        }
      } else {
        print("El archivo no existe en la ruta: $_audioUrl");
      }
    } catch (e) {
      print("Error al reproducir el clip: $e");
    }
  }

  void _startOrStopRecording() async {
    try {
      if (isRecording) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Se termino la grabacion')),
        );
        recorderController.reset();

        path = await recorderController.stop(false);

        if (path != null) {
          isRecordingCompleted = true;
          debugPrint(path);
          debugPrint("Recorded file size: ${File(path!).lengthSync()}");
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Grabando...')),
        );
        await recorderController.record(path: path); // Path is optional
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      setState(() {
        isRecording = !isRecording;
      });
    }
  }

  void _refreshWave() {
    if (isRecording) recorderController.refresh();
  }

  void enviarParaAnalisis(path) async {
    setState(() {
      isAnalizandoCompleted = false;
      isAnalizando = true;
    });
    File audioData = await File(path);
    double duracionBeat = 0.0;
    double beatsTranscurridos = 0.0;
    int compasActual = 0;
    analisis = await apiService.analizar(
        audioData,
        selectedObra!,
    login!);
    bpm = analisis.bpm;
    bpm_ajustado = analisis.bpm_ajustado;
    asignaRetro();
    anomalias = analisis.anomalias;
    for (int i = 0; i < analisis.desafinada.length; i++) {
      duracionBeat = 60 / bpm_ajustado;
      beatsTranscurridos = analisis.tiempos[i] / duracionBeat;
      int compasActual =
          ((beatsTranscurridos / selectedObra!.numerador).round());
      analisis.desafinada[i].compas = compasActual;
    }

    for (final anomalia in anomalias) {
      grabaciones.add({
        'start': Duration(seconds: anomalia.inicio.toInt()),
        'end': Duration(
            seconds: anomalia.inicio.toInt() + anomalia.duracion.toInt())
      });
      duracionBeat = 60 / bpm_ajustado;
      beatsTranscurridos = anomalia.inicio / duracionBeat;
      compasActual = ((beatsTranscurridos / selectedObra!.numerador).round());
      compas_anomalia.add(compasActual);
    }
    setState(() {
      isAnalizandoCompleted = true;
      isAnalizando = false;
    });
  }

  void asignaRetro() async {
    if (bpm == 0.0) {
      retro = "Evaluando";
    } else {
      if (analisis.porcentaje_afinadas > 95.00) {
        retro = "Perfecto tocaste impecable";
      } else {
        if (analisis.porcentaje_afinadas > 90.00 &&
            analisis.porcentaje_afinadas < 95.00) {
          retro = "Excelente ";
        } else {
          if (analisis.porcentaje_afinadas > 80.00 &&
              analisis.porcentaje_afinadas < 90.00) {
            retro = "Gran interpretación";
          } else {
            if (analisis.porcentaje_afinadas > 75.00 &&
                analisis.porcentaje_afinadas < 80.00) {
              retro = "Revisa la afinación de tu instrumento";
            } else {
              retro = "Estudia la obra y afina tu instrumento";
            }
          }
        }
      }
    }
  }
}

class WaveBubble extends StatefulWidget {
  final bool isSender;
  final int? index;
  final String? path;
  final double? width;
  final Directory appDirectory;

  const WaveBubble({
    super.key,
    required this.appDirectory,
    this.width,
    this.index,
    this.isSender = false,
    this.path,
  });

  @override
  State<WaveBubble> createState() => _WaveBubbleState();
}

class _WaveBubbleState extends State<WaveBubble> {
  File? file;

  late PlayerController controller;
  late StreamSubscription<PlayerState> playerStateSubscription;

  final playerWaveStyle = const PlayerWaveStyle(
    fixedWaveColor: Colors.white54,
    liveWaveColor: Colors.white,
    spacing: 6,
  );

  @override
  void initState() {
    super.initState();
    controller = PlayerController();
    _preparePlayer();
    playerStateSubscription = controller.onPlayerStateChanged.listen((_) {
      setState(() {});
    });
  }

  void _preparePlayer() async {
    // Opening file from assets folder
    if (widget.index != null) {
      file = File('${widget.appDirectory.path}/audio${widget.index}.mp3');
      await file?.writeAsBytes(
          (await rootBundle.load('assets/audios/audio${widget.index}.mp3'))
              .buffer
              .asUint8List());
    }
    if (widget.index == null && widget.path == null && file?.path == null) {
      return;
    }
    // Prepare player with extracting waveform if index is even.
    controller.preparePlayer(
      path: widget.path ?? file!.path,
      shouldExtractWaveform: widget.index?.isEven ?? true,
    );
    // Extracting waveform separately if index is odd.
    if (widget.index?.isOdd ?? false) {
      controller
          .extractWaveformData(
            path: widget.path ?? file!.path,
            noOfSamples:
                playerWaveStyle.getSamplesForWidth(widget.width ?? 200),
          )
          .then((waveformData) => debugPrint(waveformData.toString()));
    }
  }

  @override
  void dispose() {
    playerStateSubscription.cancel();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.path != null || file?.path != null
        ? Align(
            alignment: Alignment.center,
            child: Container(
              padding: EdgeInsets.only(
                bottom: 6,
                right: 10,
                top: 6,
              ),
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).colorScheme.secondaryContainer),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!controller.playerState.isStopped)
                    IconButton(
                      onPressed: () async {
                        controller.playerState.isPlaying
                            ? await controller.pausePlayer()
                            : await controller.startPlayer();
                        controller.setFinishMode(finishMode: FinishMode.loop);
                      },
                      icon: Icon(
                        controller.playerState.isPlaying
                            ? Icons.stop
                            : Icons.play_arrow,
                      ),
                      color: Colors.white,
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                    ),
                  AudioFileWaveforms(
                    size: Size(MediaQuery.of(context).size.width / 2, 100),
                    playerController: controller,
                    waveformType: widget.index?.isOdd ?? false
                        ? WaveformType.fitWidth
                        : WaveformType.long,
                    playerWaveStyle: playerWaveStyle,
                  ),
                  if (widget.isSender) const SizedBox(width: 10),
                ],
              ),
            ),
          )
        : const SizedBox.shrink();
  }
}
