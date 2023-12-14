import 'dart:developer';

import 'package:autoclinch_customer/network/model/vehiclelist_response.dart';
import 'package:autoclinch_customer/screens/home/services/service_screen.dart';
import 'package:autoclinch_customer/utils/extensions.dart';
import 'package:autoclinch_customer/utils/preference_util.dart';
import 'package:autoclinch_customer/widgets/payment/vehicle_dropdown.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../network/api_service.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen(this.navigationHelper, {Key? key}) : super(key: key);
  final void Function(int) navigationHelper;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<VehicleData> _vehicles = List.empty();

  VehicleData? _selectedVehicle;

  late Future<VehicleListModel?> _furuService;

  @override
  void initState() {
    _furuService = ApiService().execute<VehicleListModel>('getVehicleList', isGet: true, isThrowExc: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          iconTheme: IconThemeData(color: Colors.black),
          centerTitle: true,
        ),
        body: LayoutBuilder(builder: (context, constrains) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constrains.maxHeight,
              ),
              child: FutureBuilder<VehicleListModel?>(
                future: _furuService,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Center(child: CircularProgressIndicator());
                    default:
                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (snapshot.data?.data != null) {
                        _vehicles = snapshot.data?.data ?? List.empty();

                        return Container(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: Text(
                                    'Choose the \nservice you require',
                                    style: TextStyle(
                                      fontSize: 35,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 25),
                                InkWell(
                                  onTap: () => _showBottomSheet(context, 'breakdown'),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(35.0),
                                    child: Container(
                                        decoration: BoxDecoration(
                                          color: Color(0xFF49284D),
                                          gradient: LinearGradient(
                                            colors: [
                                              Color(0xFF94469C),
                                              Color(0xFF49284D),
                                            ],
                                          ),
                                        ),
                                        padding: EdgeInsets.all(10),
                                        child: Container(
                                          width: double.infinity,
                                          height: 120,
                                          child: Row(
                                            children: <Widget>[
                                              new Flexible(
                                                child: Container(
                                                  height: 80,
                                                  alignment: Alignment.center,
                                                  width: double.infinity,
                                                  child: Image.asset(
                                                    'assets/images/breakdown.png',
                                                    width: 70,
                                                    height: 70,
                                                    fit: BoxFit.contain,
                                                  ),
                                                ),
                                                flex: 2,
                                              ),
                                              new Flexible(
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  height: 80,
                                                  width: double.infinity,
                                                  child: Text(
                                                    "SUDDEN\nBREAKDOWN",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 19,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                flex: 3,
                                              ),
                                            ],
                                          ),
                                        )),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                InkWell(
                                  onTap: () {
                                    _showBottomSheet(context, 'maintenance');
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(35.0),
                                    child: Container(
                                        decoration: BoxDecoration(
                                          color: Color.fromARGB(255, 244, 132, 32),
                                          gradient: LinearGradient(
                                            colors: [
                                              Color(0xFFC96B19),
                                              Color(0xFFF48422),
                                            ],
                                          ),
                                        ),
                                        padding: EdgeInsets.all(10),
                                        child: Container(
                                          width: double.infinity,
                                          height: 120,
                                          child: Row(
                                            children: <Widget>[
                                              new Flexible(
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  height: 80,
                                                  width: double.infinity,
                                                  child: Text(
                                                    "MAINTENANCE &\nREPAIR",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 19,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                flex: 3,
                                              ),
                                              Flexible(
                                                child: Container(
                                                  height: 80,
                                                  alignment: Alignment.center,
                                                  width: double.infinity,
                                                  child: Image.asset(
                                                    'assets/images/repair.png',
                                                    width: 70,
                                                    height: 70,
                                                    fit: BoxFit.contain,
                                                  ),
                                                ),
                                                flex: 2,
                                              ),
                                            ],
                                          ),
                                        )),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                InkWell(
                                  onTap: () => Navigator.of(context).pushNamed('/sos'),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(35.0),
                                    child: Container(
                                        color: Color(0xFFEBB93C),
                                        padding: EdgeInsets.all(10),
                                        child: Container(
                                          width: double.infinity,
                                          height: 120,
                                          child: Row(
                                            children: <Widget>[
                                              new Flexible(
                                                child: Container(
                                                  height: 80,
                                                  alignment: Alignment.center,
                                                  width: double.infinity,
                                                  child: Image.asset(
                                                    'assets/images/sos.png',
                                                    width: 70,
                                                    height: 70,
                                                    fit: BoxFit.contain,
                                                  ),
                                                ),
                                                flex: 2,
                                              ),
                                              new Flexible(
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  height: 80,
                                                  width: double.infinity,
                                                  child: Text(
                                                    "SAFETY\nASSISTANCE",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 19,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                flex: 3,
                                              ),
                                            ],
                                          ),
                                        )),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                InkWell(
                                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => ServiceScreen(),
                                  )),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(35.0),
                                    child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.red,
                                              Colors.red.shade800,
                                            ],
                                          ),
                                        ),
                                        padding: EdgeInsets.all(10),
                                        child: Container(
                                          width: double.infinity,
                                          height: 120,
                                          child: Row(
                                            children: <Widget>[
                                              new Flexible(
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  height: 80,
                                                  width: double.infinity,
                                                  child: Text(
                                                    "SERVICES",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 19,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                flex: 3,
                                              ),
                                              Flexible(
                                                child: Container(
                                                  height: 80,
                                                  alignment: Alignment.center,
                                                  width: double.infinity,
                                                  child: Image.asset(
                                                    'assets/images/wrench.png',
                                                    width: 70,
                                                    height: 70,
                                                    fit: BoxFit.contain,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                flex: 2,
                                              ),
                                            ],
                                          ),
                                        )),
                                  ),
                                ),
                                SizedBox(height: 10),
                              ],
                            ),
                          ),
                        );
                      }
                      return Text('Result: ${snapshot.data}');
                  }
                },
              ),
            ),
          );
        })).addSafeArea(context: context, color: Colors.white);
  }

  void _showBottomSheet(BuildContext context, String type) async {
    log(type);
    if (_vehicles.isEmpty) {
      final _result = await Navigator.of(context).pushNamed('/vehiclelistscreen');
      if (_result is List<VehicleData>) {
        _vehicles = _result;
      }
      if (_vehicles.isEmpty) {
        return;
      }
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          color: Color(0xff757575),
          child: Container(
            padding: EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
            ),
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton.icon(
                        onPressed: () async {
                          await Navigator.pushNamed(context, '/addvehiclescreen');
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.add),
                        label: Text('Add vehicle'),
                      ),
                      IconButton(
                        color: Theme.of(context).primaryColor,
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(CupertinoIcons.minus_circled),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  VehicleDropdown(_vehicles, selectListner: (value) => _selectedVehicle = value),
                  const Divider(),
                  ElevatedButton(
                    child: Text(
                      'Save',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(primary: Theme.of(context).primaryColor),
                    onPressed: () async {
                      if (_selectedVehicle != null) {
                        Navigator.pop(context);
                        await SharedPreferenceUtil().storeServiceType(type);
                        await SharedPreferenceUtil().storeVehicleName(_selectedVehicle!.id.toString());
                        Navigator.of(context).pushNamed('/vendors');
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
