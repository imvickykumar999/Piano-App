import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]).then((_) => runApp(PianoApp()));
}

class PianoApp extends StatefulWidget {
  @override
  _PianoAppState createState() => _PianoAppState();
}

class _PianoAppState extends State<PianoApp> {
  final player = AudioPlayer();
  Map<String, bool> keyPressed = {
    'C1': false,
    'D1': false,
    'E1': false,
    'F1': false,
    'G1': false,
    'A1': false,
    'B1': false,
  };

  void playNote(String fileName) {
    player.play(AssetSource(fileName));
  }

  void handleKeyPress(String keyLabel, bool isPressed) {
    setState(() {
      keyPressed[keyLabel] = isPressed;
    });
  }

  Widget buildWhiteKey(String label, String fileName) {
    return Expanded(
      child: GestureDetector(
        onTapDown: (_) {
          handleKeyPress(label, true); // Key pressed down
          playNote(fileName);
        },
        onTapUp: (_) {
          handleKeyPress(label, false); // Key released
        },
        onTapCancel: () {
          handleKeyPress(label, false); // Cancel if tap is interrupted
        },
        child: Container(
          margin: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: keyPressed[label]! ? Colors.grey.shade400 : Colors.white, // Change color when pressed
            borderRadius: BorderRadius.circular(6),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.6),
                spreadRadius: 2,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                keyPressed[label]! ? Colors.grey.shade500 : Colors.white,
                keyPressed[label]! ? Colors.grey.shade300 : Colors.grey.shade200,
              ], // Gradient when key is pressed
            ),
          ),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildBlackKey(
    String label,
    String fileName,
    double positionFactor,
    double keyWidth,
  ) {
    return Positioned(
      left: positionFactor * keyWidth - (keyWidth / 4),
      top: 0,
      width: keyWidth / 2,
      height: 140,
      child: GestureDetector(
        onTapDown: (_) {
          playNote(fileName);
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(6),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.7),
                spreadRadius: 2,
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.black, Colors.grey.shade900],
            ),
          ),
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              label,
              style: const TextStyle(fontSize: 12, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final whiteKeyCount = 7;  // Adjusted for 7 keys instead of 8
              final keyWidth = constraints.maxWidth / whiteKeyCount;

              return Stack(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      buildWhiteKey('C1', 'c1.wav'),
                      buildWhiteKey('D1', 'd1.wav'),
                      buildWhiteKey('E1', 'e1.wav'),
                      buildWhiteKey('F1', 'f1.wav'),
                      buildWhiteKey('G1', 'g1.wav'),
                      buildWhiteKey('A1', 'a1.wav'),
                      buildWhiteKey('B1', 'b1.wav'),
                    ],
                  ),
                  // Positioned black keys
                  buildBlackKey('C#1', 'c1s.wav', 1, keyWidth),
                  buildBlackKey('D#1', 'd1s.wav', 2, keyWidth),
                  buildBlackKey('F#1', 'f1s.wav', 4, keyWidth),
                  buildBlackKey('G#1', 'g1s.wav', 5, keyWidth),
                  buildBlackKey('A#1', 'a1s.wav', 6, keyWidth),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
