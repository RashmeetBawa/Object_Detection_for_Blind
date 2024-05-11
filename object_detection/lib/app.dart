// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// //import 'dart:ui' as ui show Canvas, Paint, Path, lerpDouble;

// class ObjectDetectionScreen extends StatefulWidget {
//   const ObjectDetectionScreen({super.key});

//   @override
//   _ObjectDetectionScreenState createState() => _ObjectDetectionScreenState();
// }

// class _ObjectDetectionScreenState extends State<ObjectDetectionScreen> {
//   List<String> detectedLabels = [];
//   final MethodChannel _channel = const MethodChannel('object_detection_channel');

//   @override
//   void initState() {
//     super.initState();
//     _startObjectDetection();
//   }

//   Future<void> _startObjectDetection() async {
//     try {
//       final List<String> labels = await _invokePythonObjectDetection();
//       setState(() {
//         detectedLabels = labels;
//       });
//     } on PlatformException catch (e) {
//       print("Error invoking object detection: ${e.message}");
//       // Handle error gracefully
//     }
//   }

//   Future<List<String>> _invokePythonObjectDetection() async {
//     try {
//       final List<dynamic> result =
//           await _channel.invokeMethod('performObjectDetection');
//       return result.cast<String>();
//     } on PlatformException catch (e) {
//       print("Error invoking Python code: ${e.message}");
//       rethrow;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Object Detection'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Text(
//               'Detected Objects:',
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 10),
//             Text(
//               detectedLabels.join(", "),
//               style: const TextStyle(fontSize: 18),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ObjectDetectionScreen extends StatefulWidget {
  const ObjectDetectionScreen({super.key});

  @override
  _ObjectDetectionScreenState createState() => _ObjectDetectionScreenState();
}

class _ObjectDetectionScreenState extends State<ObjectDetectionScreen> {
  List<String> detectedLabels = [];
  final MethodChannel _channel = const MethodChannel('object_detection_channel');

  @override
  void initState() {
    super.initState();
    _startObjectDetection();
  }

  Future<void> _startObjectDetection() async {
    try {
      _channel.setMethodCallHandler(_handleMethod);
      await _channel.invokeMethod('startObjectDetection');
    } on PlatformException catch (e) {
      print("Error invoking object detection: ${e.message}");
      // Handle error gracefully
    }
  }

  Future<void> _handleMethod(MethodCall call) async {
    if (call.method == 'updateLabels') {
      setState(() {
        detectedLabels = List<String>.from(call.arguments);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Object Detection'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Detected Objects:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              detectedLabels.join(", "),
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
