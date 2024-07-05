import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'api_service.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ApiService apiService = ApiService();
  List<SerreData> serres = [];
  SerreData? selectedSerre;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadSerres();
  }

  void loadSerres() async {
    try {
      final response = await apiService.getSerresByUserId();
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        serres = data.map((e) => SerreData.fromJson(e)).toList();
      });
    } catch (error) {
      setState(() {
        errorMessage = error.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Serres Dashboard'),
      ),
      body: Column(
        children: [
          if (serres.isEmpty)
            Center(child: CircularProgressIndicator())
          else
            DropdownButton<SerreData>(
              hint: Text('Select Serre'),
              value: selectedSerre,
              onChanged: (SerreData? newValue) {
                setState(() {
                  selectedSerre = newValue;
                });
              },
              items: serres.map<DropdownMenuItem<SerreData>>((SerreData serre) {
                return DropdownMenuItem<SerreData>(
                  value: serre,
                  child: Text('Serre ${serre.serreId}'),
                );
              }).toList(),
            ),
          if (selectedSerre != null)
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: 300,
                        child: SfCartesianChart(
                          primaryXAxis: DateTimeAxis(),
                          series: <CartesianSeries>[
                            SplineSeries<ChartData, DateTime>(
                              dataSource: _createTemperatureData(),
                              xValueMapper: (ChartData data, _) => data.x,
                              yValueMapper: (ChartData data, _) => data.y,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: 300,
                        child: SfCartesianChart(
                          primaryXAxis: DateTimeAxis(),
                          series: <CartesianSeries>[
                            SplineSeries<ChartData, DateTime>(
                              dataSource: _createHumiditeData(),
                              xValueMapper: (ChartData data, _) => data.x,
                              yValueMapper: (ChartData data, _) => data.y,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: _buildDataTable(),
                    ),
                  ],
                ),
              ),
            ),
          if (errorMessage != null)
            Text(
              errorMessage!,
              style: TextStyle(color: Colors.red),
            ),
        ],
      ),
    );
  }

  List<ChartData> _createTemperatureData() {
    return selectedSerre!.mesures.map((Mesure mesure) {
      return ChartData(DateTime.parse(mesure.date), mesure.temperature);
    }).toList();
  }

  List<ChartData> _createHumiditeData() {
    return selectedSerre!.mesures.map((Mesure mesure) {
      return ChartData(DateTime.parse(mesure.date), mesure.humidite);
    }).toList();
  }

  Widget _buildDataTable() {
    return DataTable(
      columns: const [
        DataColumn(label: Text('Date')),
        DataColumn(label: Text("Niveau d'eau")),
        DataColumn(label: Text('Humidité du sol')),
        DataColumn(label: Text('Humidité')),
        DataColumn(label: Text('Température')),
      ],
      rows: selectedSerre!.mesures.map((Mesure mesure) {
        return DataRow(cells: [
          DataCell(Text(mesure.date)),
          DataCell(Text(mesure.niveauEau.toString())),
          DataCell(Text(mesure.humiditeSol.toString())),
          DataCell(Text(mesure.humidite.toString())),
          DataCell(Text(mesure.temperature.toString())),
        ]);
      }).toList(),
    );
  }
}

class SerreData {
  final List<Mesure> mesures;
  final int serreId;

  SerreData({required this.mesures, required this.serreId});

  factory SerreData.fromJson(Map<String, dynamic> json) {
    var list = json['mesures'] as List;
    List<Mesure> mesuresList = list.map((i) => Mesure.fromJson(i)).toList();
    return SerreData(mesures: mesuresList, serreId: json['serreId']);
  }
}

class Mesure {
  final String date;
  final double niveauEau;
  final double humiditeSol;
  final double humidite;
  final double temperature;

  Mesure({required this.date, required this.niveauEau, required this.humiditeSol, required this.humidite, required this.temperature});

  factory Mesure.fromJson(Map<String, dynamic> json) {
    return Mesure(
      date: json['date'],
      niveauEau: json['niveauEau'],
      humiditeSol: json['humiditeSol'],
      humidite: json['humidite'],
      temperature: json['temperature'],
    );
  }
}

class ChartData {
  ChartData(this.x, this.y);
  final DateTime x;
  final double y;
}
