import 'dart:developer';
import 'dart:io';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:ffmpeg_kit_flutter/session.dart';
import 'package:ffmpeg_kit_flutter/statistics.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';


class DOWNLOADPage extends StatefulWidget {
  @override
  _DOWNLOADPageState createState() => _DOWNLOADPageState();
}

class _DOWNLOADPageState extends State<DOWNLOADPage> {
  final String audioUrl =
      'https://aac.saavncdn.com/271/aa3ede441c4b4647153f2d48e7482be6_320.mp4';
  String SaveMp4Path = '';
 bool mp4DownloadLoader = false;
  AudioPlayer player = AudioPlayer();
@override
  void initState() {
    super.initState();

  }
  @override
  void dispose() {
    super.dispose();
    player.dispose();

  }


  downloadAudio() async {
    setState(() {
      mp4DownloadLoader = true;
    });

    try {
      final storageDir = await getExternalStorageDirectory();
      final directoryPath = '${storageDir?.path}/MyAudioFiles'; // Replace 'MyAudioFiles' with your desired folder name

      final directory = Directory(directoryPath);
      if (!directory.existsSync()) {
        directory.createSync(recursive: true);
      }

      final audioFile = File('$directoryPath/depaaudio.mp4');

      final response = await http.get(Uri.parse(audioUrl));
      await audioFile.writeAsBytes(response.bodyBytes);

      setState(() {
        SaveMp4Path = audioFile.path;
        mp4DownloadLoader = false;
        print("Download Mp4 Path => $SaveMp4Path");
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  String Mp3ConvertPath ='';


/*
  Future<void> converterAudioFile() async {
    final FlutterFFmpeg _flutterFFmpeg = FlutterFFmpeg();
    try {
      final storageDir = await getExternalStorageDirectory();
      final directoryPath = '${storageDir?.path}/MyAudioFilesConverter';

      final directory = Directory(directoryPath);
      if (!directory.existsSync()) {
        directory.createSync(recursive: true);
      }
      final convertAudioFile =
      File('$directoryPath/audio_${DateTime.now().millisecondsSinceEpoch}.mp3');
      final arguments = [
        '-i',
        SaveMp4Path,
        '-c:a',
        'libmp3lame',  //change Specify encoder the like this AAC ,and impliment this encoder to change build.gradel folder
        '-b:a',
        '192k', // Adjust the audio bitrate as needed
        convertAudioFile.path,
      ];

      await _flutterFFmpeg.executeWithArguments(arguments);

      setState(() {
        Mp3ConvertPath = convertAudioFile.path;
      });
      print("Converted file path: ${convertAudioFile.path}");
    } catch (e) {
      print("Error: $e");
    }
  }
*/


  Future<void> converterAudioFile() async {
    try {
      final storageDir = await getExternalStorageDirectory();
      final directoryPath = '${storageDir?.path}/MyAudioFilesConverter';

      final directory = Directory(directoryPath);
      if (!directory.existsSync()) {
        directory.createSync(recursive: true);
      }

      final convertAudioFile =
      File('$directoryPath/audio_${DateTime.now().millisecondsSinceEpoch}.mp3');
      final arguments = [
        '-i',
        SaveMp4Path,
        '-c:a',
        'libmp3lame',
        '-b:a',
        '192k',
        convertAudioFile.path,
      ];

      final executeCallback = (session) {
        print("FFmpeg process started");
        session.getOutput().then((output) => print("FFmpeg process output: $output"));
        session.getError().then((error) => print("FFmpeg process error: $error"));
      };
      final result = await FFmpegKit.executeWithArgumentsAsync(arguments, executeCallback);
      if (result != null && result == ReturnCode.success) {
        setState(() {
          Mp3ConvertPath = convertAudioFile.path;
        });
        print("Converted file path: ${convertAudioFile.path}");
      } else {
        print("FFmpeg execution failed");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  ConverterAudioFile() async {
    try {
      final storageDir = await getExternalStorageDirectory();
      final directoryPath = '${storageDir?.path}/MyAudioFilesConverter';
      final directory = Directory(directoryPath);
      if (!directory.existsSync()) {
        directory.createSync(recursive: true);
      }
      final convertAudioFile =
      File('$directoryPath/audio_${DateTime.now().millisecondsSinceEpoch}.mp3');
      final arguments = ['-i', SaveMp4Path, '-c:a', 'libmp3lame', '-b:a', '192k', convertAudioFile.path,];
      executeCallback(session) {
        print("FFmpeg process started");
        session.getOutput().then((output) => print("FFmpeg process output: $output"));
        session.getError().then((error) => print("FFmpeg process error: $error"));
      }
      await FFmpegKit.executeWithArgumentsAsync(arguments,executeCallback);
      setState(() {
        Mp3ConvertPath = convertAudioFile.path;
      });
      print("Converted file path: ${convertAudioFile.path}");
    } catch (e) {
      print("Error: $e");
    }
  }



  playAudio() async {
    try {
      await player.setFilePath(SaveMp4Path);
    } catch (e) {
      log("Error loading audio source: $e");
    }
    player.play();
  }
  playAudiofromConvert() async {
    try {
      await player.setFilePath(Mp3ConvertPath);
    } catch (e) {
      log("Error loading audio source: $e");
    }
    player.play();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Audio Download Example'),
      ),
      body: Center(
        child: Column(
          children: [
           ElevatedButton(
              onPressed: () {
                downloadAudio();
              },
              child: Text('Download Audio'),
            ),

        mp4DownloadLoader?CircularProgressIndicator():Text(SaveMp4Path),

            ElevatedButton(
              onPressed: (){
                player.pause();
              },
              child: Text('stop Audio'),
            ),




            ElevatedButton(
              onPressed: playAudio,
              child: Text('play Audio'),
            ),


            ElevatedButton(
              onPressed: playAudiofromConvert,
              child: Text('play Audio from converter path'),
            ),


            ElevatedButton(
              onPressed: (){
                // converterAudioFile();
                 ConverterAudioFile();
              },
              child: Text("convert audio"),
            ),

            Text(Mp3ConvertPath)


          ],
        ),
      ),
    );
  }
}
