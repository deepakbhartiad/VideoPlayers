import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sample/pages/welcome_page.dart';
import 'package:sample/secondadioTrimmer.dart';

import 'allPlayerPage.dart';

void main() {
  // Initialize FFmpegKitFlutter
  // FFmpegKitConfig.enableLogCallback(null);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shortcuts(
        shortcuts: <LogicalKeySet, Intent>{
          LogicalKeySet(LogicalKeyboardKey.select): const ActivateIntent(),
        },
        child: MaterialApp(
          title: 'video player demo',
          // localizationsDelegates: [
          //   GlobalMaterialLocalizations.delegate,
          //   GlobalWidgetsLocalizations.delegate,
          // ],
/*          supportedLocales: [
            const Locale('en', 'US'),
            const Locale('pl', 'PL'),
          ],*/
          theme: ThemeData(
            primarySwatch: Colors.green,
          ),
          home:MyHomePage(),
         // AllPlayerPage(),
        ));
  }
}
