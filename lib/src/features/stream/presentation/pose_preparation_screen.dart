import 'dart:async';
import 'dart:convert';

import 'package:fitness_ui/src/features/routines/domain/routine.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class PosePreparationScreen extends StatefulWidget {
  final Routine routine;
  const PosePreparationScreen({super.key, required this.routine});

  @override
  State<PosePreparationScreen> createState() => _PosePreparationScreenState();
}

class _PosePreparationScreenState extends State<PosePreparationScreen> {
  CameraController? _cameraController;
  late Future<void> _initializeCameraFuture;
  bool _workoutStarted = false;
  int _exerciseIndex = 0;
  int _countdown = 3;
  bool _countingDown = false;
  bool _personDetected = false;

  late WebSocketChannel channel;
  Timer? _frameTimer;

  @override
  void initState() {
    super.initState();
    _initializeCameraFuture = _setupCamera();
  }

  Future<void> _setupCamera() async {
    final cameras = await availableCameras();
    final frontCamera = cameras.firstWhere(
      (cam) => cam.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );

    _cameraController = CameraController(
      frontCamera,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    await _cameraController!.initialize();
  }

  void _startCountdown() {
    setState(() {
      _countingDown = true;
      _countdown = 3;
    });

    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _countdown--;
      });

      if (_countdown == 0) {
        timer.cancel();
        _connectToWebSocket();
      }
    });
  }

  void _connectToWebSocket() {
    final currentExercise = widget.routine.exercises[_exerciseIndex];
    final title = currentExercise?.title ?? "squats";

    channel = WebSocketChannel.connect(
      Uri.parse('wss://fitness-server-8ht3.onrender.com/ws/pose'),
    );

    channel.sink.add(jsonEncode({
      "exercise": title,
      "reps": currentExercise?.sets?.first.reps ?? 5,
      "sets": currentExercise?.sets?.length ?? 1,
      "source": "webcam",
    }));

    channel.stream.listen((message) {
      final data = jsonDecode(message);
      final feedback = data['feedback']?.toLowerCase() ?? "";

      // Simulated person detection logic
      if (feedback.contains("person detected") || feedback.contains("start")) {
        if (!_personDetected) {
          _personDetected = true;
          _startWorkout();
        }
      }

      print(data['feedback']);
    });
  }

  void _startWorkout() {
    _frameTimer = Timer.periodic(Duration(seconds: 1), (_) => _sendFrame());

    setState(() {
      _workoutStarted = true;
    });
  }

  Future<void> _sendFrame() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized)
      return;

    final picture = await _cameraController!.takePicture();
    final bytes = await picture.readAsBytes();
    final base64Frame = base64Encode(bytes);

    channel.sink.add(jsonEncode({
      "frame": base64Frame,
    }));
  }

  @override
  void dispose() {
    _frameTimer?.cancel();
    channel.sink.close();
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Get Ready")),
      body: FutureBuilder(
        future: _initializeCameraFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              Expanded(flex: 3, child: CameraPreview(_cameraController!)),
              Expanded(
                flex: 2,
                child: Center(
                  child: _workoutStarted
                      ? Text("Workout in progress...",
                          style: TextStyle(fontSize: 18))
                      : _countingDown
                          ? Text("Starting in $_countdown...",
                              style: TextStyle(fontSize: 32))
                          : ElevatedButton(
                              onPressed: _startCountdown,
                              child: Text("Start Workout"),
                            ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
