import 'package:flutter/material.dart';
import 'package:flutter_application_2/homepage.dart';
import 'package:flutter_application_2/screens/controller/db_helper.dart';
// Replace with the correct import path
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await DBHelper.initDb();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/', // Optional, but you can set the initial route
      routes: {
        '/': (context) => HomePage(),
      },
    );
  }
}
