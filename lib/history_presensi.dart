// ignore_for_file: curly_braces_in_flow_control_structures, prefer_const_constructors, sort_child_properties_last, unused_local_variable, prefer_const_literals_to_create_immutables, unused_import, must_be_immutable

import 'package:flutter/material.dart';
import 'package:monitoring_karyawan_ppns/global_variables.dart' as global;
import 'package:http/http.dart' as http;
import 'dart:convert' show jsonDecode;
import 'dart:async';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'dart:developer';
import 'package:intl/intl.dart';

class HistoryPresensiPage extends StatefulWidget {
  int id;
  HistoryPresensiPage({super.key, required this.id});

  @override
  State<HistoryPresensiPage> createState() => HistoryPresensiPageState(id: id);
}

class HistoryPresensiPageState extends State<HistoryPresensiPage> {
  List<String> month = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December",
  ];
  int id;
  bool first = true;
  HistoryPresensiPageState({required this.id});
  late List<dynamic>? data;
  late List<dynamic>? dataUser;
  List<dynamic>? filteredDataTgl = [];
  List<dynamic>? filteredDataSearch = [];
  final searchController = TextEditingController();
  final searchTglController = TextEditingController();
  DateTime current_date = DateTime.now();
  Timer? timer;
  Timer? timer2;
  final formatter = new NumberFormat('00');
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
    var url = Uri.parse(global.endpoint_history_presensi_get_all);
    var response = await http.get(url);
    if (response.statusCode == 200) {
      setState(() {
        data = List<dynamic>.from((jsonDecode(response.body) as List));
        data = data!.where((item) => item['nuid'].toString().toLowerCase().contains(id.toString())).toList();
        filteredDataTgl = searchTglController.text.isEmpty ? data! : data!.where((item) => item['timestamp'].toString().toLowerCase().contains(searchTglController.text)).toList();
        filteredDataSearch = searchController.text.isEmpty ? filteredDataTgl! : filteredDataTgl!.where((item) => item['name'].toLowerCase().contains(searchController.text.toLowerCase()) || item['aksi'].toLowerCase().contains(searchController.text.toLowerCase()) || item['pesan'].toLowerCase().contains(searchController.text.toLowerCase()) || item['timestamp'].toLowerCase().contains(searchController.text.toLowerCase())).toList();
      });
    }
    var url2 = Uri.parse(global.endpoint_list_karyawan_get_all);
    var response2 = await http.get(url2);
    if (response2.statusCode == 200) {
      setState(() {
        dataUser = List<dynamic>.from((jsonDecode(response2.body) as List));        
        dataUser = dataUser!.where((item) => item['nuid'].toString().toLowerCase().contains(id.toString())).toList();
      });
    }
    if(first){      
      String formattedDate = DateFormat('yyyy-MM-dd').format(current_date);
      setState(() {
        searchTglController.text = formattedDate; //set output date to TextField value.
        filteredDataTgl = data!.where((item) => item['timestamp'].toString().toLowerCase().contains(searchTglController.text)).toList();
        filteredDataSearch = filteredDataTgl;
        first = false;
      });
    }
  }

  void _onSearchTextChanged(String text) {
    setState(() {
      filteredDataSearch = text.isEmpty ? filteredDataTgl! : filteredDataTgl!.where((item) => item['name'].toLowerCase().contains(searchController.text.toLowerCase()) || item['aksi'].toLowerCase().contains(searchController.text.toLowerCase()) || item['pesan'].toLowerCase().contains(searchController.text.toLowerCase()) || item['timestamp'].toLowerCase().contains(searchController.text.toLowerCase())).toList();
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
          title: Text("History Presensi"),
        ),
        body: Stack(children: <Widget>[
          
          Positioned(
            top: 20,
            bottom: 0,
            left: 0,
            right: 0,
            child:  Column(
              children: [
                dataUser![0]['foto'] == null ? 
                CircleAvatar(
                  radius:70,
                  backgroundImage: AssetImage('img/default-profile.jpg'),
                ) :
                 CircleAvatar(
                  radius:70,
                  backgroundImage: NetworkImage(dataUser![0]['foto']),
                ),
                Container(height: 10),
                Text(dataUser![0]['name'],
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Container(height: 10),
                Text("${DateFormat('EEEE').format(current_date)}, ${formatter.format(current_date.day)} ${month[current_date.month-1]} ${current_date.year}",
                  style: TextStyle(
                    fontSize: 20,
                    color: Color.fromARGB(150, 0, 0, 0),
                  ),
                ),
              ]
            )
          ),
          Positioned(
            top: 250,
            bottom: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: 
              
              TextField(
              controller: searchTglController,
              //editing controller of this TextField
              decoration: InputDecoration(
                  icon: Icon(Icons.calendar_today), //icon of text field
                  labelText: "Select Date" //label text of field
                  ),
              readOnly: true,
              //set it true, so that user will not able to edit text
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1950),
                    //DateTime.now() - not to allow to choose before today.
                    lastDate: DateTime(2100));

                if (pickedDate != null) {
                  print( pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                  String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                  print(formattedDate); //formatted date output using intl package =>  2021-03-16
                  setState(() {
                    searchTglController.text = formattedDate; //set output date to TextField value.
                    filteredDataTgl = data!.where((item) => item['timestamp'].toString().toLowerCase().contains(searchTglController.text)).toList();
                    filteredDataSearch = filteredDataTgl;
                  });
                } else {}
              },
            ),

            ),
          ),
          Positioned(
            top: 330,
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
              top: 410,
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
                          label: Text('Aksi'),
                        ),
                        DataColumn(
                          label: Text('Pesan'),
                        ),
                        DataColumn(
                          label: Text('Timestamp'),
                        ),
                      ],
                      rows: List.generate(filteredDataSearch!.length, (index) {
                        final item = filteredDataSearch![index];
                        return DataRow(
                          cells: [
                            DataCell(Text(item['nuid'].toString(), style: TextStyle(color: item['color'] == 'red' ? Colors.red : Colors.black))),
                            DataCell(Text(item['name'], style: TextStyle(color: item['color'] == 'red' ? Colors.red : Colors.black))),
                            DataCell(Text(item['aksi'], style: TextStyle(color: item['color'] == 'red' ? Colors.red : Colors.black))),
                            DataCell(Text(item['pesan'], style: TextStyle(color: item['color'] == 'red' ? Colors.red : Colors.black))),
                            DataCell(Text(item['timestamp'], style: TextStyle(color: item['color'] == 'red' ? Colors.red : Colors.black))),
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
