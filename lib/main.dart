import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:taskist_app/constants/app_theme.dart';
import 'package:taskist_app/model/project.dart';
import 'package:taskist_app/model/task.dart';
import 'package:taskist_app/providers/bottom_nav_provider.dart';
import 'package:taskist_app/providers/login_provider.dart';
import 'package:taskist_app/providers/project_provider.dart';
import 'package:taskist_app/providers/register_provider.dart';
import 'package:taskist_app/view/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //Initialize Hive
  await Hive.initFlutter();

  //Register adapters
  Hive.registerAdapter(ProjectAdapter());
  Hive.registerAdapter(TaskAdapter());

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => BottomNavProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => RegisterProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => LoginProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ProjectProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Taskist App',
      theme: taskistTheme,
      home: const SplashScreen(),
    );
  }
}
