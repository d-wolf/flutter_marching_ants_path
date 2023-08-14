import 'package:flutter/material.dart';
import 'marching_ants_path_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Marching Ants',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var milliseconds = 500;
  var dashWidth = 10.0;
  var dashSpace = 2.0;
  var strokeWidth = 2.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Marching Ants'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: LayoutBuilder(builder: (context, constraints) {
                final r = Rect.fromLTWH(
                    0, 0, constraints.maxWidth, constraints.maxHeight);

                return DashedLineWidget(
                  points: [
                    r.topLeft,
                    r.topRight,
                    r.bottomRight,
                    r.bottomLeft,
                    r.center,
                    r.topLeft,
                    r.bottomLeft
                  ],
                  dashWidth: dashWidth,
                  dashSpace: dashSpace,
                  strokeWidth: strokeWidth,
                  duration: Duration(milliseconds: milliseconds),
                );
              }),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Duration (ms)'),
                  Slider(
                      value: milliseconds.toDouble(),
                      min: 10,
                      max: 1000,
                      label: '$milliseconds',
                      onChanged: (update) {
                        setState(() {
                          milliseconds = update.toInt();
                        });
                      }),
                  const Text('Dash Width'),
                  Slider(
                      value: dashWidth,
                      min: 1.0,
                      max: 100,
                      label: '$dashWidth',
                      onChanged: (update) {
                        setState(() {
                          dashWidth = update;
                        });
                      }),
                  const Text('Dash Space'),
                  Slider(
                      value: dashSpace,
                      min: 1.0,
                      max: 100,
                      label: '$dashSpace',
                      onChanged: (update) {
                        setState(() {
                          dashSpace = update;
                        });
                      }),
                  const Text('Stroke Width'),
                  Slider(
                      value: strokeWidth,
                      min: 0.1,
                      max: 10,
                      label: '$strokeWidth',
                      onChanged: (update) {
                        setState(() {
                          strokeWidth = update;
                        });
                      })
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
