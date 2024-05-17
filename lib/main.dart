import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:task_managment/presentation/pages/homepage.dart';
import 'package:task_managment/presentation/pages/register/register.dart';

import 'presentation/pages/login/login.dart';
import 'package:permission_handler/permission_handler.dart';

import 'presentation/pages/tablepage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  runApp(
    GetMaterialApp(
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        /* dark theme settings */
      ),
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      initialRoute: '/loginpage',
      routes: {
        '/loginpage': (context) => const LoginScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
    ),
  );
}
