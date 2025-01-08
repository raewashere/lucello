import 'package:celloapp/screens/vista_bienvenida.dart';
import 'package:celloapp/screens/vista_contrasenia.dart';
import 'package:celloapp/screens/vista_inicio.dart';
import 'package:celloapp/screens/vista_registro.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'screens/vista_login.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(CelloApp());
}

class CelloApp extends StatefulWidget {
  const CelloApp({super.key});

  @override
  State<StatefulWidget> createState() => _MainState();
}

class _MainState extends State<CelloApp> {
  final User? usuarioActual = FirebaseAuth.instance.currentUser;
  late String? token = "";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: const ColorScheme(
          primary: Color(0xFF58111A), // "#58111A"
          onPrimary: Color(0xFFE3E1E1), // "#E3E1E1"
          primaryContainer: Color(0xFFCC3448), // "#CC3448"
          onPrimaryContainer: Color(0xFF131010), // "#131010"

          secondary: Color(0xFF11584F), // "#11584F"
          onSecondary: Color(0xFFE3E1E1), // "#E3E1E1"
          secondaryContainer: Color(0xFF29A797), // "#29A797"
          onSecondaryContainer: Color(0xFF131010), // "#131010"

          tertiary: Color(0xFF2B1158), // "#2B1158"
          onTertiary: Color(0xFFE3E1E1), // "#E3E1E1"
          tertiaryContainer: Color(0xFF9472E7), // "#9472E7"
          onTertiaryContainer: Color(0xFF000F08), // "#CCC5B9"
          surface: Color(0xFF11584F), // Default white surface
          outline: Color(0xFFE3E1E1),
          onSurface: Color(0xFFE3E1E1), // Default on surface color
          error: Colors.red, // Default error color
          onError: Colors.white, // Default on error color
          brightness: Brightness.light, // Can be Brightness.dark for dark theme
        ),
        useMaterial3: true,
        fontFamily: 'Roboto', // Font family
        textTheme: const TextTheme(
            displayLarge: TextStyle(
              fontFamily: 'Roboto',
              fontSize:
                  57, // Tamaño sugerido por las nuevas guías de Material 3
              fontWeight: FontWeight.bold,
              letterSpacing: -0.25,
            ),
            displayMedium: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 45,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.0,
            ),
            displaySmall: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 36,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.0,
            ),
            headlineLarge: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 32,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.0,
            ),
            headlineMedium: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 28,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.0,
            ),
            headlineSmall: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 24,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.0,
            ),
            titleLarge: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 22,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.0,
            ),
            titleMedium: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 16,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.15,
            ),
            titleSmall: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.1,
            ),
            bodyLarge: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 16,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.5,
            ),
            bodyMedium: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.25,
            ),
            bodySmall: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 12,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.4,
            ),
            labelLarge: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              letterSpacing: 1.25,
            ),
            labelMedium: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 12,
              fontWeight: FontWeight.w500,
              letterSpacing: 1.0,
            ),
            labelSmall: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 11,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
            )),
      ),
      home: usuarioActual != null ? vista_inicio() : vista_login(),
      routes: {
        '/registro': (context) => vista_registro(),
        '/login': (context) => vista_login(),
        '/contrasenia': (context) => vista_contrasenia(),
        '/inicio': (context) => vista_inicio()
      },
    );
  }
}
