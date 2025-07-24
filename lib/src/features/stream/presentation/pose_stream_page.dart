import 'dart:async';
import 'dart:convert';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class PoseStreamPage extends StatefulWidget {
  @override
  _PoseStreamPageState createState() => _PoseStreamPageState();
}

class _PoseStreamPageState extends State<PoseStreamPage> {
  CameraController? _cameraController;
  late Future<void> _initializeCameraFuture;
  late WebSocketChannel channel;

  String? base64Image; // frame from server
  String? feedback; // feedback from server
  Timer? _frameTimer;

  @override
  void initState() {
    super.initState();

    _initializeCameraFuture = _setupCamera();

    channel = WebSocketChannel.connect(
      Uri.parse('wss://fitness-server-8ht3.onrender.com/ws/pose'),
    );

    channel.stream.listen((message) {
      final data = jsonDecode(message);
      setState(() {
        base64Image = data['frame'];
        feedback = data['feedback'];
      });
    });

    channel.sink.add(jsonEncode({
      "exercise": "squats",
      "reps": 5,
      "sets": 1,
      "source": "webcam",
    }));
  }

  Future<void> _setupCamera() async {
    try {
      final cameras = await availableCameras();
      final camera = cameras.firstWhere(
        (cam) => cam.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      _cameraController = CameraController(
        camera,
        ResolutionPreset.low,
        enableAudio: false,
      );

      await _cameraController!.initialize();

      _frameTimer = Timer.periodic(Duration(seconds: 1), (_) => _sendFrame());
    } catch (e) {
      print('Camera initialization error: $e');
    }
  }

  Future<void> _sendFrame() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    try {
      final picture = await _cameraController!.takePicture();
      final bytes = await picture.readAsBytes();
      final base64Frame = base64Encode(bytes);

      channel.sink.add(jsonEncode({
        "frame": base64Frame,
      }));
    } catch (e) {
      print('Error sending frame: $e');
    }
  }

  @override
  void dispose() {
    _frameTimer?.cancel();

    _cameraController?.dispose();

    try {
      channel.sink.close();
    } catch (e) {
      print('Error closing websocket: $e');
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final imageBytes = base64Image != null ? base64Decode(base64Image!) : null;

    return Scaffold(
      appBar: AppBar(title: Text("Pose Stream")),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: FutureBuilder<void>(
              future: _initializeCameraFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    _cameraController != null &&
                    _cameraController!.value.isInitialized) {
                  return CameraPreview(_cameraController!);
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Column(
                children: [
                  if (imageBytes != null)
                    Expanded(
                      child: Image.memory(imageBytes, gaplessPlayback: true),
                    ),
                  if (feedback != null)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(feedback!, style: TextStyle(fontSize: 16)),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
