import 'package:flutter/material.dart';
import 'package:flutter_pdf_library/presentation/screens/splash_ui/splash_screen.dart';

void main() {
  runApp(const LibraryDashboard());
}

class LibraryDashboard extends StatelessWidget {
  static GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();

  const LibraryDashboard({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      key: globalKey,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: SplashScreen(),
    );
  }
}
