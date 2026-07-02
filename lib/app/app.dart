import 'package:flutter/material.dart';
import 'package:lista_tarea/app/view/splash/splash_page.dart';
import 'package:lista_tarea/app/view/task_list/task_list_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF40B7AD);
    const texColor = Color(0xFF4A4A4A);
    const backgroundColor = Color(0xFFF5F5F5);

    return MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: primary, primary: primary),
          scaffoldBackgroundColor: backgroundColor,
          textTheme: Theme.of(context).textTheme.apply(
            fontFamily: 'Poppins',
            bodyColor: texColor,
            displayColor: texColor,
          ),
          bottomSheetTheme: const BottomSheetThemeData(
            backgroundColor: Colors.transparent,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: primary,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity,
                  54,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontSize:18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      
        home: SplashPage(),
      );
  }
}
