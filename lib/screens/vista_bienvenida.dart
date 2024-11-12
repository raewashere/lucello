import 'package:flutter/material.dart';

class vista_bienvenida extends StatelessWidget {  @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Theme.of(context).colorScheme.onPrimary,
    body: Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: Container(),
          ),
          Expanded(
            flex: 8,
            child: Column(
              children: [
                _buildSection(
                  context,
                  icon: Icons.album,
                  title: "Bienvenido",
                  subtitle: "Tu plataforma de análisis de interpretaciones",
                ),
                _buildSection(
                  context,
                  icon: Icons.music_note,
                  title: "Afina tu instrumento",
                  subtitle: "Un instrumento afinado ayuda a hacer un mejor análisis",
                ),
                _buildSection(
                  context,
                  icon: Icons.analytics,
                  title: "Analiza tu ejecución",
                  subtitle: "Recibe retroalimentación de cómo tocas",
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(),
          ),
        ],
      ),
    ),
  );
}

Widget _buildSection(BuildContext context,
    {required IconData icon, required String title, required String subtitle}) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 10.0),
    child: Column(
      children: [
        ListTile(
          textColor: Theme.of(context).colorScheme.tertiary,
          leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
          title: Text(title, style: TextStyle(color: Theme.of(context).colorScheme.primary)),
          subtitle: Text(subtitle, style: TextStyle(color: Theme.of(context).colorScheme.secondary)),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () {
                // Acción de botón Afinador
              },
              child: Text("Afinador"),
            ),
            TextButton(
              onPressed: () {
                // Acción de botón Analizar
              },
              child: Text("Analizar"),
            ),
          ],
        ),
      ],
    ),
  );
}
}