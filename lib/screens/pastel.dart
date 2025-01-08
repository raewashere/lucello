import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'indicador.dart';

class Pastel extends StatefulWidget {
  final double _afinadas;
  final double _desafinadas;

  const Pastel({
    required double afinadas,
    required double desafinadas,
  })  : _afinadas = afinadas,
        _desafinadas = desafinadas;

  double get afinadas => _afinadas;
  double get desafinadas => _desafinadas;

  @override
  State<StatefulWidget> createState() => PieChart2State();
}

class PieChart2State extends State<Pastel> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.3,
      child: Row(
        children: <Widget>[
          const SizedBox(
            height: 18,
          ),
          Expanded(
            child: AspectRatio(
              aspectRatio: 1,
              child: PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      setState(() {
                        if (!event.isInterestedForInteractions ||
                            pieTouchResponse == null ||
                            pieTouchResponse.touchedSection == null) {
                          touchedIndex = -1;
                          return;
                        }
                        touchedIndex = pieTouchResponse
                            .touchedSection!.touchedSectionIndex;
                      });
                    },
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  sectionsSpace: 0,
                  centerSpaceRadius: 40,
                  // Accede a los valores desde widget
                  sections: showingSections(widget.afinadas, widget.desafinadas),
                ),
              ),
            ),
          ),
          const Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Indicator(
                color: Color(0xFF29A797),
                text: 'Afinadas',
                isSquare: true,
              ),
              SizedBox(
                height: 4,
              ),
              Indicator(
                color: Color(0xFFCC3448),
                text: 'Desafinadas',
                isSquare: true,
              ),
              SizedBox(
                height: 18,
              ),
            ],
          ),
          const SizedBox(
            width: 28,
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> showingSections(
      double afinadas, double desafinadas) {
    return List.generate(2, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 20.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Theme.of(context).colorScheme.secondaryContainer,
            value: afinadas,
            title: '${afinadas}%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSecondaryContainer,
              shadows: shadows,
            ),
          );
        case 1:
          return PieChartSectionData(
            color: Theme.of(context).colorScheme.primaryContainer,
            value: desafinadas,
            title: '${desafinadas}%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
              shadows: shadows,
            ),
          );
        default:
          throw Error();
      }
    });
  }
}
