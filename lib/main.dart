import 'package:flutter/material.dart';
import 'package:flutter_pdf_library/presentation/screens/splash_ui/splash_screen.dart';
import 'package:flutter_pdf_library/presentation/ui_component/app_colors.dart';

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
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          border: OutlineInputBorder(borderSide: BorderSide.none),
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.mainBlueColor),
        useMaterial3: true,
      ),
      home: SplashScreen(),
    );
  }
}
