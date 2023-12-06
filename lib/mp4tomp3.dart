import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
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

      final FlutterFFmpeg _flutterFFmpeg = FlutterFFmpeg();

      final arguments = ['-i', SaveMp4Path, '-q:a', '0', '-map', 'a', convertAudioFile.path];

      await _flutterFFmpeg.executeWithArguments(arguments);

      setState(() {
        Mp3ConvertPath = convertAudioFile.path;
      });

      print("Converted file path: ${convertAudioFile.path}");
    } catch (e) {
      print("Error: $e");
    }
  }


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
      File('$directoryPath/audio_${DateTime.now().millisecondsSinceEpoch}.aac');
      var ddfhfh = '';

      var argsuments = ["-i", SaveMp4Path, "-c:v", "mp3", convertAudioFile.path,];
      final arguments = [
        '-i',
        SaveMp4Path,
        '-c:a',
        'aac ', // Specify the AAC encoder
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
                converterAudioFile();
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
