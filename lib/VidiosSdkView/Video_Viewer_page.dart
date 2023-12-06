// import 'package:flutter/material.dart';
// import 'package:video_viewer/domain/bloc/controller.dart';
// import 'package:video_viewer/video_viewer.dart';
//
//
// class VidoeViwerView extends StatefulWidget {
//   VidoeViwerView({ Key? key}) : super(key: key);
//
//   @override
//   _VidoeViwerViewState createState() =>  _VidoeViwerViewState();
// }
//
// class _VidoeViwerViewState extends State<VidoeViwerView> {
//   final VideoViewerController controller = VideoViewerController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body:
//       VideoViewer(
//         controller: controller,
//         source: {
//           "SubRip Text": VideoSource(
//             // ignore: deprecated_member_use
//             video: VideoPlayerController.network(
//                 "https://www.speechpad.com/proxy/get/marketing/samples/standard-captions-example.mp4"),
//             subtitle: {
//               "English": VideoViewerSubtitle.network(
//                 "https://felipemurguia.com/assets/txt/WEBVTT_English.txt",
//                 type: SubtitleType.webvtt,
//               ),
//             },
//           )
//         },
//       ),
//     );
//   }
// }