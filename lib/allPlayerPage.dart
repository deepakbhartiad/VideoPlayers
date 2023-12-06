import 'package:flutter/material.dart';
import 'package:sample/pages/welcome_page.dart';

import 'VidiosSdkView/Custom_VideoPlayer.dart';
import 'VidiosSdkView/Video_Viewer_page.dart';
import 'mp4tomp3.dart';

class AllPlayerPage extends StatefulWidget {
  const AllPlayerPage({super.key});

  @override
  State<AllPlayerPage> createState() => _AllPlayerPageState();
}

class _AllPlayerPageState extends State<AllPlayerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  ListView(
        children: [
          ElevatedButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>WelcomePage()));
          }, child: Text("Better Player SDK")),




          // ElevatedButton(onPressed: (){
          //    Navigator.push(context, MaterialPageRoute(builder: (context)=>VidoeViwerView()));
          // }, child: const Text("Video Viewer SDK")),


          ElevatedButton(onPressed: (){
             Navigator.push(context, MaterialPageRoute(builder: (context)=>CustomVideoPlayer()));
          }, child: const Text("Custom Video Player SDK")),


        ElevatedButton(onPressed: (){
             Navigator.push(context, MaterialPageRoute(builder: (context)=>DOWNLOADPage()));
          }, child: const Text("ffmpeg mp4 to mpe")),




        ],
      ),

    );
  }
}
