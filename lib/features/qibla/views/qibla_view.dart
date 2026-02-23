import 'package:flutter/material.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'dart:math' as math;

class QiblaView extends StatelessWidget {
  const QiblaView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('القبلة')),
      body: StreamBuilder(
        stream: FlutterQiblah.qiblahStream,
        builder: (context, AsyncSnapshot<QiblahDirection> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('خطأ: ${snapshot.error}'));
          }

          final qiblahDirection = snapshot.data!;

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Transform.rotate(
                      angle: (qiblahDirection.direction * (math.pi / 180) * -1),
                      child: const Icon(Icons.compass_calibration, size: 250, color: Colors.grey),
                    ),
                    Transform.rotate(
                      angle: (qiblahDirection.qiblah * (math.pi / 180) * -1),
                      child: const Icon(Icons.navigation, size: 150, color: Colors.green),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  'زاوية القبلة: ${qiblahDirection.offset.toStringAsFixed(2)}°',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
