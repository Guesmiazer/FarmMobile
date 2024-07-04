// import 'dart:convert';
// import 'package:flutter/material.dart';

// import 'api_service.dart';

// class HomePage extends StatefulWidget {
//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   ApiService apiService = ApiService();
//   List<SerreData> serres = [];
//   SerreData? selectedSerre;
//   String? errorMessage;

//   @override
//   void initState() {
//     super.initState();
//     loadSerres();
//   }

//   void loadSerres() async {
//     try {
//       final response = await apiService.getSerresByUserId();
//       final List<dynamic> data = jsonDecode(response.body);
//       setState(() {
//         serres = data.map((e) => SerreData.fromJson(e)).toList();
//       });
//     } catch (error) {
//       setState(() {
//         errorMessage = error.toString();
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Home'),
//       ),
//       body: Column(
//         children: [
//           if (serres.isEmpty)
//             Center(child: CircularProgressIndicator())
//           else
//             DropdownButton<SerreData>(
//               hint: Text('Select Serre'),
//               value: selectedSerre,
//               onChanged: (SerreData? newValue) {
//                 setState(() {
//                   selectedSerre = newValue;
//                 });
//               },
//               items: serres.map<DropdownMenuItem<SerreData>>((SerreData serre) {
//                 return DropdownMenuItem<SerreData>(
//                   value: serre,
//                   child: Text('Serre ${serre.serreId}'),
//                 );
//               }).toList(),
//             ),
//           if (selectedSerre != null)
//             Expanded(
//               child: SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: SizedBox(
//                         height: 300,
//                         child: charts.TimeSeriesChart(
//                           _createTemperatureData(),
//                           animate: true,
//                           dateTimeFactory: const charts.LocalDateTimeFactory(),
//                         ),
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: SizedBox(
//                         height: 300,
//                         child: charts.TimeSeriesChart(
//                           _createHumiditeData(),
//                           animate: true,
//                           dateTimeFactory: const charts.LocalDateTimeFactory(),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           if (errorMessage != null)
//             Text(
//               errorMessage!,
//               style: TextStyle(color: Colors.red),
//             ),
//         ],
//       ),
//     );
//   }

//   List<charts.Series<TimeSeriesData, DateTime>> _createTemperatureData() {
//     final data = selectedSerre!.mesures.map((Mesure mesure) {
//       return TimeSeriesData(DateTime.parse(mesure.date), mesure.temperature);
//     }).toList();

//     return [
//       charts.Series<TimeSeriesData, DateTime>(
//         id: 'Temperature',
//         colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
//         domainFn: (TimeSeriesData data, _) => data.time,
//         measureFn: (TimeSeriesData data, _) => data.value,
//         data: data,
//       )
//     ];
//   }

//   List<charts.Series<TimeSeriesData, DateTime>> _createHumiditeData() {
//     final data = selectedSerre!.mesures.map((Mesure mesure) {
//       return TimeSeriesData(DateTime.parse(mesure.date), mesure.humidite);
//     }).toList();

//     return [
//       charts.Series<TimeSeriesData, DateTime>(
//         id: 'Humidite',
//         colorFn: (_, __) => charts.MaterialPalette.purple.shadeDefault,
//         domainFn: (TimeSeriesData data, _) => data.time,
//         measureFn: (TimeSeriesData data, _) => data.value,
//         data: data,
//       )
//     ];
//   }
// }

// class SerreData {
//   final List<Mesure> mesures;
//   final int serreId;

//   SerreData({required this.mesures, required this.serreId});

//   factory SerreData.fromJson(Map<String, dynamic> json) {
//     var list = json['mesures'] as List;
//     List<Mesure> mesuresList = list.map((i) => Mesure.fromJson(i)).toList();
//     return SerreData(mesures: mesuresList, serreId: json['serreId']);
//   }
// }

// class Mesure {
//   final String date;
//   final double niveauEau;
//   final double humiditeSol;
//   final double humidite;
//   final double temperature;

//   Mesure({required this.date, required this.niveauEau, required this.humiditeSol, required this.humidite, required this.temperature});

//   factory Mesure.fromJson(Map<String, dynamic> json) {
//     return Mesure(
//       date: json['date'],
//       niveauEau: json['niveauEau'],
//       humiditeSol: json['humiditeSol'],
//       humidite: json['humidite'],
//       temperature: json['temperature'],
//     );
//   }
// }

// class TimeSeriesData {
//   final DateTime time;
//   final double value;

//   TimeSeriesData(this.time, this.value);
// }
