import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Linea extends StatefulWidget {
  const Linea({super.key});

  @override
  State<Linea> createState() => _LineaState();
}

class _LineaState extends State<Linea> {
  List<Color> gradientColors = [Colors.cyan, Colors.blue];

  bool showAvg = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1.70,
          child: Padding(
            padding: const EdgeInsets.only(
              right: 18,
              left: 12,
              top: 24,
              bottom: 12,
            ),
            child: LineChart(
               mainData(),
            ),
          ),
        ),
        SizedBox(
          width: 60,
          height: 34,
          child: TextButton(
            onPressed: () {
              setState(() {
                showAvg = !showAvg;
              });
            },
            child: Text(
              'avg',
              style: TextStyle(
                fontSize: 12,
                color: showAvg ? Colors.white.withAlpha(5) : Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;
    switch (value.toInt()) {
      case 2:
        text = const Text('MAR', style: style);
        break;
      case 5:
        text = const Text('JUN', style: style);
        break;
      case 8:
        text = const Text('SEP', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );
    String text;
    switch (value.toInt()) {
      case 1:
        text = '10K';
        break;
      case 3:
        text = '30k';
        break;
      case 5:
        text = '50k';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  LineChartData mainData() {
    List<Coordenada> coordenadas =
    generarCoordenadasProgresivas(1000); // Generar hasta 10 coordenadas
    List<FlSpot> puntos = [];
    for (var c in coordenadas) {
      print('x: ${c.x}, y: ${c.y}');
      puntos.add(FlSpot(c.x.toDouble(),c.y.toDouble()));
    }
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Colors.white,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Colors.white,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: 1000000,
      minY: 0,
      maxY: 1000000,
      lineBarsData: [
        LineChartBarData(
          spots: puntos,
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors:
                  gradientColors.map((color) => color.withAlpha(5)).toList(),
            ),
          ),
        ),
      ],
    );
  }
}

class Coordenada {
  final int x;
  final int y;

  Coordenada(this.x, this.y);

  @override
  String toString() => '($x, $y)';
}

List<Coordenada> generarCoordenadasProgresivas(int cantidad) {
  Random random = Random();
  List<Coordenada> coordenadas = [];
  int ultimoX = 0; // Empezar desde (0, 0)
  int ultimoY = 0;

  while (coordenadas.length < cantidad) {
    // Generar nuevos valores x e y
    int nuevoX = ultimoX + random.nextInt(10); // Progresión de 0 a 2
    int nuevoY = ultimoY + random.nextInt(10);

    // Crear nueva coordenada
    Coordenada nueva = Coordenada(nuevoX, nuevoY);

    // Verificar que no se repita
    if (!coordenadas.contains(nueva)) {
      coordenadas.add(nueva);
      ultimoX = nuevoX; // Actualizar el último valor
      ultimoY = nuevoY;
    }
  }

  return coordenadas;
}
