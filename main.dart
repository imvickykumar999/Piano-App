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

class PianoApp extends StatelessWidget {
  final player = AudioPlayer();

  void playNote(String fileName) {
    player.play(AssetSource(fileName));
  }

  Widget buildWhiteKey(String label, String fileName) {
    return Expanded(
      child: GestureDetector(
        onTap: () => playNote(fileName),
        child: Container(
          margin: const EdgeInsets.all(1),
          color: Colors.white,
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
        onTap: () => playNote(fileName),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Colors.black),
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
              final whiteKeyCount = 8;
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
                      buildWhiteKey('C2', 'c2.wav'),
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
