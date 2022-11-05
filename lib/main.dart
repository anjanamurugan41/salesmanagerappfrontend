import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'Screens/SplashScreen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(SalesMangerApp());
  });
}

class SalesMangerApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.blueGrey,
          // cursorColor: Colors.blueGrey,
          canvasColor: Color(0xfff3faff),
          visualDensity: VisualDensity.adaptivePlatformDensity,
          // fontFamily: 'Montserrat'
          ),
        home: SplashScreen()
    );
  }
}
