import 'package:lcpl_admin/provider/auth_provider.dart';
import 'package:lcpl_admin/provider/home_index_provider.dart';
import 'package:lcpl_admin/provider/password_visibility_provider.dart';
import 'package:lcpl_admin/provider/upload_provider.dart';
import 'package:lcpl_admin/screens/authscreen/login_screen.dart';
import 'package:lcpl_admin/theme/theme.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //  // ignore: deprecated_member_use
  //  CloudinaryContext.cloudinary =
  //     Cloudinary.fromCloudName(cloudName: 'dxhhsvyh9');
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => VisibilityProvider()),
      ChangeNotifierProvider(create: (context) => HomeIndexProvider()),
      ChangeNotifierProvider(create: (context) => AppwriteServices()),
    ],
    child: MaterialApp(
      home: const LoginScreen(),
      theme: AppTheme.lightTheme,
    ),
  ));
}
