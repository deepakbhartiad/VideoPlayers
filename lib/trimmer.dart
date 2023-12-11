import 'dart:io';
import 'package:easy_audio_trimmer/easy_audio_trimmer.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class AudioTrimmerView extends StatefulWidget {
  final File file;

   AudioTrimmerView({Key? key, required this.file}) : super(key: key);
  @override
  State<AudioTrimmerView> createState() => _AudioTrimmerViewState();
}

class _AudioTrimmerViewState extends State<AudioTrimmerView> {
  final Trimmer _trimmer = Trimmer();
  // final controller = Get.find<ArGearController>();
  double _startValue = 0.0;
  double _endValue = 0.0;

  bool _isPlaying = false;
  bool _progressVisibility = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
print("paaaxxxxxwddwth${widget.file}");
    _loadAudio();
  }

  void _loadAudio() async {
    setState(() {
      isLoading = true;
    });
    await _trimmer.loadAudio(audioFile: widget.file);
    setState(() {
      isLoading = false;
    });
  }
  _saveAudio() async {
    setState(() {
      _progressVisibility = true;
    });

    final storageDir = await getExternalStorageDirectory();
    final directoryPath = '${storageDir?.path}/MyAudioFilesConverterTrimFolder';
    final directory = Directory(directoryPath);
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }
    final convertAudioFilePath = '$directoryPath/audio_${DateTime.now().millisecondsSinceEpoch}.mp3';
    try {
        _trimmer.saveTrimmedAudio(
        startValue: _startValue,
        endValue: _endValue,
        audioFileName: DateTime.now().millisecondsSinceEpoch.toString(),
          onSave: (String? outputPath) {
            setState(() {
              _progressVisibility = false;
            });
            debugPrint('OUTPUT PATH: $outputPath');
          },
      );

    } catch (e) {
      // Handle any exceptions that occur during audio trimming or saving
      debugPrint('Error: $e');
      setState(() {
        _progressVisibility = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (Navigator.of(context).userGestureInProgress) {
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: SizedBox.expand(
            //backgroundColor: ColorConstants.APPPRIMARYBLACKCOLOR,
            child: isLoading
                ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.red
                ))
                : Container(
              padding: const EdgeInsets.only(bottom: 30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[

                  Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            // Get.back();
                          },
                          icon: Icon(
                            Icons.cancel_outlined,
                            size: 22,
                            color: Colors.blue,
                          )),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          _saveAudio();
                        },
                        child: Text(
                          "Done",
                         style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                  Visibility(
                      visible: _progressVisibility,
                      child: const LinearProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.orangeAccent),
                        color: Colors.white,
                        backgroundColor: Colors.white,
                      )),
          
                  //AudioViewer(trimmer: _trimmer),
                  const Spacer(),
                  Row(
                    children: [
                      SizedBox(
                        width: 60,
                        child: IconButton(
                          icon: Icon(
                            _isPlaying ? Icons.pause : Icons.play_arrow,
                            size: 36.0,
                            color:Colors.green
                                .withOpacity(0.80),
                          ),
                          onPressed: () async {
                            bool playbackState =
                            await _trimmer.audioPlaybackControl(
                              startValue: _startValue,
                              endValue: _endValue,
                            );
                            setState(() => _isPlaying = playbackState);
                          },
                        ),
                      ),
                      TrimViewer(
                        trimmer: _trimmer,
                        viewerHeight: 60,
                        viewerWidth: MediaQuery.of(context).size.width / 1.3,
                        backgroundColor: Colors.grey.withOpacity(0.08),
                        maxAudioLength: const Duration(seconds: 60),
                        barColor: Colors.blue
                            .withOpacity(0.50),
                        editorProperties: TrimEditorProperties(
                          circleSize: 7,
                          borderPaintColor: Colors.blue
                              .withOpacity(0.50),
                          borderWidth: 3,
                          borderRadius: 3,
                          circleSizeOnDrag: 4,
                          circlePaintColor:Colors.blue
                              .withOpacity(0.99),
                        ),
                        areaProperties:
                        TrimAreaProperties.edgeBlur(blurEdges: false),
                        onChangeStart: (value) => _startValue = value,
                        onChangeEnd: (value) => _endValue = value,
                        onChangePlaybackState: (value) {
                          if (mounted) {
                            setState(() => _isPlaying = value);
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
