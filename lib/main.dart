import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  Future<void> downloadAndLogTimeUsingDio(String url) async {
    final dio = Dio();

    final downloadStopwatch = Stopwatch()..start();
    try {
      debugPrint("Starting download with Dio...");
      final tempDir = await getTemporaryDirectory();
      final filePath = "${tempDir.path}/downloaded_file.xlsx";

      await dio.download(
        url,
        filePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            debugPrint(
                "Progress: ${(received / total * 100).toStringAsFixed(0)}%");
          }
        },
      );
      downloadStopwatch.stop();
      debugPrint(
          "Download completed. Time: ${downloadStopwatch.elapsedMilliseconds} ms");

      final file = File(filePath);
      final blobStopwatch = Stopwatch()..start();
      List<int> blob = await file.readAsBytes();
      blobStopwatch.stop();
      debugPrint(
          "Blob generation completed. Time: ${blobStopwatch.elapsedMilliseconds} ms");

      final base64Stopwatch = Stopwatch()..start();
      String base64String = base64Encode(blob);
      base64Stopwatch.stop();
      debugPrint("Base64 encoding completed. Length: ${base64String.length}");
      debugPrint(
          "Base64 encoding time: ${base64Stopwatch.elapsedMilliseconds} ms");

      debugPrint(
          "Total execution time: ${downloadStopwatch.elapsedMilliseconds + blobStopwatch.elapsedMilliseconds + base64Stopwatch.elapsedMilliseconds} ms");
    } catch (e) {
      debugPrint("Error occurred: $e");
    }
  }

  void _incrementCounter() {
    downloadAndLogTimeUsingDio("http://103.193.176.166:1500/excel");
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
      
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
  
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
