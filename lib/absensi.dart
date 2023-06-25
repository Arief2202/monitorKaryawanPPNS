// ignore_for_file: curly_braces_in_flow_control_structures, prefer_const_constructors, sort_child_properties_last, unused_local_variable, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:monitoring_karyawan_ppns/global_variables.dart' as global;
import 'package:http/http.dart' as http;
import 'dart:convert' show jsonDecode;
import 'dart:async';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'dart:developer';

class AbsensiPage extends StatefulWidget {
  int id;
  AbsensiPage({super.key, required this.id});

  @override
  State<AbsensiPage> createState() => AbsensiPageState(id: id);
}

class AbsensiPageState extends State<AbsensiPage> {
  // List<dynamic> data = [
  //   {"Nuid": 1, "Name": "Test", "Ruang": "M102", "Pesan": "Keluar M102", "Timestamp": "2023-04-13 03:02:24"},
  //   {"Nuid": 2, "Name": "Test", "Ruang": "M102", "Pesan": "Keluar M102", "Timestamp": "2023-04-13 03:02:24"},
  //   {"Nuid": 2, "Name": "Test", "Ruang": "M102", "Pesan": "Keluar M102", "Timestamp": "2023-04-13 03:02:24"},
  //   {"Nuid": 2, "Name": "Test", "Ruang": "-", "Pesan": "Keluar M102", "Timestamp": "2023-04-13 03:02:24"},
  //   {"Nuid": 1, "Name": "Test", "Ruang": "-", "Pesan": "Keluar M102", "Timestamp": "2023-04-13 03:02:24"},
  //   {"Nuid": 1, "Name": "Test", "Ruang": "M102", "Pesan": "Keluar M102", "Timestamp": "2023-04-13 03:02:24"},
  // ];
  int id;
  AbsensiPageState({required this.id});

  late List<dynamic>? data;
  List<dynamic> filteredData = [];
  final searchController = TextEditingController();

  Timer? timer;
  // late List<UserLocation>? userLocation;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(milliseconds: 1000), (Timer t) => updateValue());
  }

  @override
  void dispose() {
    searchController.dispose();
    timer?.cancel();
    super.dispose();
  }

  void updateValue() async {
    var url = Uri.parse(global.endpoint_monitor_karyawan_get_all);
    var response = await http.get(url);
    if (response.statusCode == 200) {
      setState(() {
        data = List<dynamic>.from((jsonDecode(response.body) as List));
        data = data!.where((item) => item['nuid'].toString().toLowerCase().contains(id.toString())).toList();
        filteredData = searchController.text.isEmpty ? data! : data!.where((item) => item['name'].toLowerCase().contains(searchController.text.toLowerCase()) || item['ruang'].toLowerCase().contains(searchController.text.toLowerCase()) || item['pesan'].toLowerCase().contains(searchController.text.toLowerCase()) || item['timestamp'].toLowerCase().contains(searchController.text.toLowerCase())).toList();
      });
    }
  }

  void _onSearchTextChanged(String text) {
    setState(() {
      filteredData = text.isEmpty ? data! : data!.where((item) => item['Name'].toLowerCase().contains(text.toLowerCase()) || item['Role'].toLowerCase().contains(text.toLowerCase())).toList();
    });
  }

  Widget build(BuildContext context) {
    double mapWidth = MediaQuery.of(context).size.width / 1.2;

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => {
                    timer?.cancel(),
                    Navigator.pop(context),
                  }),
          title: Text("History Lokasi"),
        ),
        body: Stack(children: <Widget>[
          Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: searchController,
                decoration: const InputDecoration(
                  hintText: 'Search...',
                  border: OutlineInputBorder(),
                ),
                onChanged: _onSearchTextChanged,
              ),
            ),
          ),
          Positioned(
              top: 80,
              bottom: 0,
              left: 0,
              right: 0,
              child: SingleChildScrollView(
                  child: Stack(children: <Widget>[
                Column(children: [
                  SizedBox(
                    width: double.infinity,
                    child: DataTable(
                      columns: const <DataColumn>[
                        DataColumn(
                          label: Text('Nuid'),
                        ),
                        DataColumn(
                          label: Text('Name'),
                        ),
                        DataColumn(
                          label: Text('Ruang'),
                        ),
                        DataColumn(
                          label: Text('Pesan'),
                        ),
                        DataColumn(
                          label: Text('Timestamp'),
                        ),
                      ],
                      rows: List.generate(filteredData.length, (index) {
                        final item = filteredData[index];
                        return DataRow(
                          cells: [
                            DataCell(Text(item['nuid'].toString())),
                            DataCell(Text(item['name'])),
                            DataCell(Text(item['ruang'])),
                            DataCell(Text(item['pesan'])),
                            DataCell(Text(item['timestamp'])),
                          ],
                        );
                      }),
                    ),
                  ),
                ])
              ]))),
        ]));
  }
}
