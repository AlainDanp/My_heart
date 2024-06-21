import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

// Fonction pour déterminer l'état du patient en fonction des valeurs de pression artérielle
String determinePatientState(double systole, double diastole, double pulse) {
  if (systole >= 140 && diastole >= 90) {
    return "Hypertendu";
  }
  else if (systole >= 180 && diastole >= 110) {
    return "hypertension séver";
  }
  else if (systole >= 140 && diastole >= 100) {
    return "hypertension modérer";
  }
  else if ((systole >= 120 && systole < 140) && (diastole >= 80 && diastole < 90)) {
    return "Pré-hypertendu";
  } else if ((systole >= 90 && systole < 120) && (diastole >= 60 && diastole < 80)) {
    return "Normotendu ou Normal";
  } else {
    return "Hypotendu";
  }
}

String determinePulseState(double pulse) {
  if (pulse < 60) {
    return "Bradycardie";
  } else if (pulse > 100) {
    return "Tachycardie";
  } else {
    return "Normal";
  }
}

class BarChartPage extends StatefulWidget {
  final String poids;
  final String diastole;
  final String systole;
  final String pulse;

  BarChartPage({
    required this.poids,
    required this.diastole,
    required this.systole,
    required this.pulse,
  });

  @override
  State<BarChartPage> createState() => _BarChartPageState();
}

class _BarChartPageState extends State<BarChartPage> {
  late String patientState;
  late String pulseState;

  @override
  void initState() {
    super.initState();
    double systoleValue = double.parse(widget.systole);
    double diastoleValue = double.parse(widget.diastole);
    double pulseValue = double.parse(widget.pulse);

    // Détermination de l'état du patient
    patientState = determinePatientState(systoleValue, diastoleValue, pulseValue);
    pulseState = determinePulseState(pulseValue);

    // Utilisation de WidgetsBinding.instance.addPostFrameCallback
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showPatientStateDialog(patientState, pulseState);
    });
  }

  void _showPatientStateDialog(String state, String pulseState) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("État du Patient"),
          content: Text("Le patient est $state.\nÉtat du pouls : $pulseState.\nPoids: ${widget.poids} kg"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<BarChartPageContent> data = [
      BarChartPageContent(
        data: "Diastole",
        financial: double.parse(widget.diastole),
        color: charts.ColorUtil.fromDartColor(Colors.blue),
      ),
      BarChartPageContent(
        data: "Systole",
        financial: double.parse(widget.systole),
        color: charts.ColorUtil.fromDartColor(Colors.red),
      ),
      BarChartPageContent(
        data: "Pulse",
        financial: double.parse(widget.pulse),
        color: charts.ColorUtil.fromDartColor(Colors.green),
      ),
    ];

    List<charts.Series<BarChartPageContent, String>> series = [
      charts.Series(
        id: "financial",
        data: data,
        domainFn: (BarChartPageContent series, _) => series.data,
        measureFn: (BarChartPageContent series, _) => series.financial,
        colorFn: (BarChartPageContent series, _) => series.color,
        labelAccessorFn: (BarChartPageContent series, _) =>
        '${series.data}: ${series.financial}',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text("État du Patient"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 400, // Définir une hauteur fixe pour le graphique
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
              child: charts.BarChart(
                series,
                animate: true,
                barRendererDecorator: charts.BarLabelDecorator<String>(),
                domainAxis: charts.OrdinalAxisSpec(
                  renderSpec: charts.SmallTickRendererSpec(
                    labelStyle: charts.TextStyleSpec(
                      fontSize: 14,
                      color: charts.MaterialPalette.black,
                    ),
                    lineStyle: charts.LineStyleSpec(
                      thickness: 2,
                      color: charts.MaterialPalette.gray.shadeDefault,
                    ),
                  ),
                ),
                primaryMeasureAxis: charts.NumericAxisSpec(
                  tickProviderSpec:
                  charts.BasicNumericTickProviderSpec(desiredTickCount: 10),
                  renderSpec: charts.GridlineRendererSpec(
                    labelStyle: charts.TextStyleSpec(
                      fontSize: 14,
                      color: charts.MaterialPalette.black,
                    ),
                    lineStyle: charts.LineStyleSpec(
                      thickness: 1,
                      color: charts.MaterialPalette.gray.shadeDefault,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "État du patient : $patientState\nÉtat du pouls : $pulseState\nPoids: ${widget.poids} kg",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BarChartPageContent {
  final String data;
  final double financial;
  final charts.Color color;

  BarChartPageContent({
    required this.data,
    required this.financial,
    required this.color,
  });
}
