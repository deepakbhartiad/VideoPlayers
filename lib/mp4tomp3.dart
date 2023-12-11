import 'dart:developer';
import 'dart:io';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit_config.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_session.dart';
import 'package:ffmpeg_kit_flutter/log.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:ffmpeg_kit_flutter/session.dart';
import 'package:ffmpeg_kit_flutter/statistics.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sample/trimmer.dart';


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


  void converterAudioFile() async {
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
      void executeCallback(FFmpegSession session) {
        print("FFmpeg process started");
        session.getOutput().then((output) => print("FFmpeg process output: $output"));
        session.getReturnCode().then((error) => print("FFmpeg process error: $error"));
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
      String ffmpegCommand =
          "-hide_banner -y -f lavfi -i sine=frequency=1000:duration=5 -c:a pcm_s16le ${ convertAudioFile.path}";
      executeCallback(session) {
        print("FFmpeg process started");
        session.getOutput().then((output) => print("FFmpeg process output: $output"));
        session.getError().then((error) => print("FFmpeg process error: $error"));
      }
      await FFmpegKit.execute(ffmpegCommand);
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
      body: SingleChildScrollView(
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
                //  ConverterAudioFile();
                 encodeAudio();
                 systemAdioPicker();
              },
              child: Text("convert audio"),
            ),

            Text(Mp3ConvertPath),

            Text(_outputText)
          ],
        ),
      ),
    );
  }
  String _outputText = '';
  void logCallback(Log log) {
    print("er${log.getMessage()}");
    this.appendOutput(log.getMessage());
  }

  void appendOutput(String logMessage) {
    _outputText += logMessage;
  }
  String AutoCreateWavePath = '';
  @override
  void initState() {
    super.initState();
    createAudioSample();
 //   FFmpegKitConfig.enableLogCallback(this.logCallback);

  }
  void createAudioSample() {
    print("Creating AUDIO sample before the test.");

    getAudioSampleFile().then((audioSampleFile) {

      String ffmpegCommand =
          "-hide_banner -y -f lavfi -i sine=frequency=1000:duration=5 -c:a pcm_s16le ${audioSampleFile.path}";

      print("Creating audio sample with '$ffmpegCommand'.");
      print("Creating audio sample with path '${audioSampleFile.path}'.");
      setState(() {
        AutoCreateWavePath = audioSampleFile.path;
      });
      FFmpegKit.execute(ffmpegCommand).then((session) async {
        final state =
        FFmpegKitConfig.sessionStateToString(await session.getState());
        final returnCode = await session.getReturnCode();
        final failStackTrace = await session.getFailStackTrace();

        if (ReturnCode.isSuccess(returnCode)) {
          print("AUDIO sample created");
        } else {
          print(
              "Creating AUDIO sample failed with state ${state} and rc ${returnCode}.${(failStackTrace, "\n")}");
          showPopup(
              "Creating AUDIO sample failed. Please check log for the details.");
        }
      });
    });
  }
  String notNull(String? string, [String valuePrefix = ""]) {
    return (string == null) ? "" : valuePrefix + string;
  }

/*        return "-hide_banner -y -i $audioSampleFile -c:a libmp3lame -qscale:a 2 $audioOutputFile";
      case "mp3 (libshine)":
        return "-hide_banner -y -i $audioSampleFile -c:a libshine -qscale:a 2 $audioOutputFile";*/

  systemAdioPicker()async{
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
    );

    if (result != null) {
      PlatformFile file = result.files.first;
      File files = File(result.files.single.path!);
      Navigator.push(context, MaterialPageRoute(builder: (context)=> AudioTrimmerView(file: files)));
      print(file.name);
      print(file.bytes);
      print(file.size);
      print(file.extension);
      print(file.path);
    } else {
      // User canceled the picker
    }
}

  void encodeAudio() async {
    final storageDir = await getExternalStorageDirectory();
    final directoryPath = '${storageDir?.path}/MyAudioFilesConverter';
    final directory = Directory(directoryPath);

    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }

    final convertAudioFilePath = File('$directoryPath/audio_${DateTime.now().millisecondsSinceEpoch}.aac');
    final convertedMP3FilePath = File('${convertAudioFilePath.path}.mp3'); // New file path with .mp3 extension

    String ffmpegCommand = "-hide_banner -y -i $SaveMp4Path -c:a aac -b:a 192k ${convertAudioFilePath.path}";

    await FFmpegKit.execute(ffmpegCommand).then((session) async {
      final state = FFmpegKitConfig.sessionStateToString(await session.getState());
      final returnCode = await session.getReturnCode();
      final failStackTrace = await session.getFailStackTrace();

      if (ReturnCode.isSuccess(returnCode)) {
        showPopup("Encode completed successfully.");
        print("Encode completed successfully.");

        await convertAudioFilePath.rename(convertedMP3FilePath.path); // Rename AAC file to MP3 file

        String newPath = convertedMP3FilePath.path.replaceAll(RegExp(r'\.aac$'), '.mp3'); // Replace .aac with .mp3
        await convertedMP3FilePath.rename(newPath); // Rename to remove .aac extension
        Navigator.push(context, MaterialPageRoute(builder: (context)=> AudioTrimmerView(file: convertedMP3FilePath)));
        setState(() {
          Mp3ConvertPath = newPath; // Update path to the MP3 file
        });
      } else {
        showPopup("Encode failed. Please check log for the details.");
        print("Encode failed with state ${state} and rc ${returnCode}.${notNull(failStackTrace, "\n")}");
      }
    });

    FFmpegKitConfig.enableLogCallback(this.logCallback);
  }

  Future<File> getAudioSampleFile() async {
    Directory? documentsDirectory = await VideoUtil.documentsDirectory;
    return new File("${documentsDirectory!.path}/audio-sample.wav");
  }


}
void showPopup(String text) {
  if (Platform.isAndroid || Platform.isIOS) {
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.white70,
        textColor: Colors.black87,
        fontSize: 16.0);
  }
}
class VideoUtil{
  static Future<Directory?> get documentsDirectory async {
    return await getExternalStorageDirectory();
  }


}