import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

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

class MyHomePage extends HookWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final imageDataResized = useState<Uint8List?>(null);
    final imageDataOriginal = useState<Uint8List?>(null);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Center(
                child: CircularProgressIndicator(),
              ),
              ElevatedButton(
                onPressed: () async {
                  final result = await FilePicker.platform.pickFiles(
                    type: FileType.image,
                    allowMultiple: false,
                    withReadStream: true,
                  );

                  final file = result?.files.first;
                  BytesBuilder bytes = BytesBuilder(copy: false);
                  await for (var byte in file!.readStream!) {
                    bytes.add(byte);
                  }

                  final imageData = bytes.takeBytes();
                  imageDataOriginal.value = imageData;
                  print('Image: ${imageData.length}');
                },
                child: const Text('Select image'),
              ),
              if (imageDataResized.value != null)
                Image.memory(imageDataResized.value!),
              if (imageDataOriginal.value != null)
                Image.memory(imageDataOriginal.value!),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
