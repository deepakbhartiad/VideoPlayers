import 'dart:io';
import 'package:flutter_audio_trimmer/flutter_audio_trimmer.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File? _file;
  File? _outputFile;

  Future<void> _onPickAudioFile() async {
    try {
      Permission permission =
      Platform.isAndroid ? Permission.storage : Permission.photos;
      if (await permission.request().isGranted) {
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          allowMultiple: false,
          type: FileType.any,
        );

        if (result != null && result.files.isNotEmpty) {
          setState(() {
            _file = File(result.files.first.path ?? '');
          });
        }
      }
    } catch (e) {
      _showSnackBar(e.toString());
    }
  }

  Future<void> _onTrimAudioFile() async {
    try {
      if (_file != null) {
        Directory directory = await getApplicationDocumentsDirectory();

        File? trimmedAudioFile = await FlutterAudioTrimmer.trim(
          inputFile: _file!,
          outputDirectory: directory,
          fileName: DateTime.now().millisecondsSinceEpoch.toString(),
          fileType: Platform.isAndroid ? AudioFileType.mp3 : AudioFileType.m4a,
          time: AudioTrimTime(
            start: const Duration(seconds: 50),
            end: const Duration(seconds: 100),
          ),
        );
        setState(() {
          _outputFile = trimmedAudioFile;
        });
      } else {
        _showSnackBar('Select audio file for trim');
      }
    } on AudioTrimmerException catch (e) {
      _showSnackBar(e.message);
    } catch (e) {
      _showSnackBar(e.toString());
    }
  }

  void _showSnackBar(String message) {
    SnackBar snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Plugin example app')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            children: [
              if (_file != null) Text(_file?.path ?? ''),
              ElevatedButton(
                onPressed: _onPickAudioFile,
                child: const Text('Pick Audio File'),
              ),
              const SizedBox(height: 20),
              if (_outputFile != null) Text(_outputFile?.path ?? ''),
              ElevatedButton(
                onPressed: _onTrimAudioFile,
                child: const Text('Trim Audio'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}