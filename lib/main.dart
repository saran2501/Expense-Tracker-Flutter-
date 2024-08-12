import 'package:flutter/material.dart';
import 'package:expense_tracker/widget/expenses.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((_) {
    runApp(
      MaterialApp(
        theme: ThemeData(
          colorScheme: const ColorScheme(
            primary: Color(0xFF00FF9F),
            primaryContainer: Color(0xFF005F4E),
            secondary: Color(0xFFFF3F81),
            secondaryContainer: Color(0xFFB3225B),
            surface: Color(0xFF222222),
            background: Color(0xFF141414),
            error: Color(0xFFFF0075),
            onPrimary: Color(0xFF000000),
            onSecondary: Color(0xFFFFFFFF),
            onSurface: Color(0xFFFFE600),
            onBackground: Color(0xFFFFE600),
            onError: Color(0xFF000000),
            brightness: Brightness.dark,
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color.fromARGB(123, 26, 243, 163), // Updated darker color
            centerTitle: true,
            titleTextStyle: TextStyle(
              color: Color(0xFF000000),
              fontSize: 26,
              fontWeight: FontWeight.bold,
              fontFamily: 'Orbitron',
            ),
            elevation: 10,
            shadowColor: Color(0xFF00FF9F),
            iconTheme: IconThemeData(
              color: Color(0xFFFFE600),
              size: 30,
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF3F81),
              foregroundColor: const Color(0xFFFFFFFF),
              textStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFamily: 'Orbitron',
              ),
            ),
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              backgroundColor: const Color(0xFF00FF9F),
              foregroundColor: const Color(0xFF000000),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                fontFamily: 'Orbitron',
              ),
            ),
          ),
          iconTheme: const IconThemeData(
            color: Color(0xFFFFE600),
          ),
          inputDecorationTheme: const InputDecorationTheme(
            filled: true,
            fillColor: Color(0xFF222222),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF00FF9F)),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFFFE600)),
            ),
            labelStyle: TextStyle(
              color: Color(0xFFFFE600),
              fontWeight: FontWeight.bold,
              fontFamily: 'Orbitron',
            ),
          ),
          cardTheme: const CardTheme(
            color: Color(0xFF222222),
            shadowColor: Color(0xFF00FF9F),
            elevation: 6,
            margin: EdgeInsets.all(8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              side: BorderSide(color: Color(0xFFFF3F81), width: 2),
            ),
          ),
          textTheme: const TextTheme(
            titleLarge: TextStyle(
              color: Color(0xFFFF3F81),
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFamily: 'Orbitron',
            ),
            bodyLarge: TextStyle(
              color: Color(0xFFFFE600),
              fontSize: 18,
              fontFamily: 'Orbitron',
            ),
          ),
        ),
        home: const Expenses(),
      ),
    );
  });
}
