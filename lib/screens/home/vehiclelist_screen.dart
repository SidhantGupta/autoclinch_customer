import 'package:autoclinch_customer/network/api_service.dart';
import 'package:autoclinch_customer/network/model/vehicle_arguments.dart';
import 'package:autoclinch_customer/network/model/vehiclelist_response.dart';
import 'package:flutter/material.dart';

class VehicleListScreen extends StatefulWidget {
  // List<Data> vehicleList = List.empty();
  // VendorDetailsData vendorDetailsData;
  const VehicleListScreen({Key? key}) : super(key: key);

  @override
  _VendorDetailsScreenState createState() => _VendorDetailsScreenState();
}

class _VendorDetailsScreenState extends State<VehicleListScreen> {
  final TextStyle style = TextStyle(fontSize: 14.0);

  List<VehicleData> _vehicles = List.empty();

  final TextStyle _labelStyle = TextStyle(fontSize: 14.0, color: Color(0xFF2A2935));

  late VehicleArg vehiclearg;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, _vehicles);
        return false;
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text(
              'Vehicle List',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),

            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.black),
            centerTitle: true,
            automaticallyImplyLeading: true,
            // leading: IconButton(onPressed: null , Icon(Icons.arrow_forward_ios_outlined)),
          ),
          body: FutureBuilder<VehicleListModel?>(
            future: ApiService().execute<VehicleListModel>('getVehicleList',
                params: {'customer_id': '1'},
                // future: ApiService().execute<ProfileResponse>('vendor/businessprofile',
                isGet: true,
                isThrowExc: true),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Center(child: CircularProgressIndicator());
                default:
                  if (snapshot.hasError) {
                    ////("Data is Has error null");

                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.data?.data != null) {
                    _vehicles = snapshot.data?.data ?? List.empty();
                    ////("Data is not null");

                    // VehicleList();
                    return vehicleListWidget(snapshot.data!.data!);
                  }
                  return Text('Result: ${snapshot.data}');
              }
            },
          )),
    );
  }

  Widget loginButon() => Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(5.0),
        color: Theme.of(context).primaryColor,
        child: MaterialButton(
          minWidth: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          onPressed: () async {
            final isAdded = await Navigator.of(context).pushNamed("/addvehiclescreen");
            ////('Navigator result: $isAdded');
            if (isAdded is bool && isAdded) {
              setState(() {});
            }
          },
          child: Text("Add Vehicle",
              textAlign: TextAlign.center, style: style.copyWith(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      );

  Widget vehicleListWidget(vehicleList) {
    ////("ListLength : ");
    ////(vehicleList.length);

    return Column(
      children: <Widget>[
        new Flexible(
            flex: 7,
            child: ListView.builder(
              itemCount: vehicleList.length,
              itemBuilder: (context, index) {
                return Card(
                  child: InkWell(
                    // onTap: () =>
                    // Navigator.of(context).pushNamed('/vendordetails'),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              const SizedBox(height: 7),
                              Text(
                                vehicleList[index].make.toString(),
                                style: _labelStyle.copyWith(fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              const SizedBox(height: 3),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  new Flexible(
                                    flex: 1,
                                    child: Row(
                                      children: [
                                        const SizedBox(width: 4),
                                        Icon(
                                          Icons.airport_shuttle_outlined,
                                          color: Color.fromARGB(255, 141, 158, 166),
                                        ),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Text(vehicleList[index].model.toString(),
                                              style: TextStyle(color: Color.fromARGB(255, 98, 99, 112))),
                                        ),
                                      ],
                                    ),
                                  ),
                                  new Flexible(
                                    flex: 1,
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        const SizedBox(width: 4),
                                        Icon(
                                          Icons.support_outlined,
                                          color: Color.fromARGB(255, 141, 158, 166),
                                        ),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Text(vehicleList[index].kilometer.toString(),
                                              style: TextStyle(color: Color.fromARGB(255, 98, 99, 112))),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  new Flexible(
                                    flex: 1,
                                    child: Row(
                                      children: [
                                        const SizedBox(width: 4),
                                        Icon(
                                          Icons.twenty_four_mp_outlined,
                                          color: Color.fromARGB(255, 141, 158, 166),
                                        ),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Text(vehicleList[index].rcNumber.toString(),
                                              style: TextStyle(color: Color.fromARGB(255, 98, 99, 112))),
                                        ),
                                      ],
                                    ),
                                  ),
                                  new Flexible(
                                    flex: 1,
                                    child: Row(
                                      children: [
                                        const SizedBox(width: 4),
                                        Icon(
                                          Icons.ev_station_outlined,
                                          color: Color.fromARGB(255, 141, 158, 166),
                                        ),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Text(vehicleList[index].fuelType.toString(),
                                              style: TextStyle(color: Color.fromARGB(255, 98, 99, 112))),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  new Flexible(
                                    flex: 1,
                                    child: Row(
                                      children: [
                                        const SizedBox(width: 4),
                                        Icon(
                                          Icons.date_range_outlined,
                                          color: Color.fromARGB(255, 141, 158, 166),
                                        ),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Text(vehicleList[index].year.toString(),
                                              style: TextStyle(color: Color.fromARGB(255, 98, 99, 112))),
                                        ),
                                      ],
                                    ),
                                  ),
                                  new Flexible(
                                    flex: 1,
                                    child: Container(
                                      // color: Colors.amber,
                                      height: 40,
                                      width: 150,
                                      child: Card(
                                        child: InkWell(
                                          onTap: () async {
                                            vehiclearg = new VehicleArg(
                                                id: vehicleList[index].id,
                                                rcNumber: vehicleList[index].rcNumber,
                                                make: vehicleList[index].make,
                                                model: vehicleList[index].model,
                                                fuelType: vehicleList[index].fuelType,
                                                kilometer: vehicleList[index].kilometer,
                                                year: vehicleList[index].year);

                                            final isAdded =
                                                await Navigator.of(context).pushNamed("/addvehiclescreen", arguments: vehiclearg);
                                            ////('Navigator result: $isAdded');
                                            if (isAdded is bool && isAdded) {
                                              setState(() {});
                                            }
                                          },
                                          child: Row(
                                            children: [
                                              const SizedBox(width: 4),
                                              Icon(
                                                Icons.edit_outlined,
                                                color: Color.fromARGB(255, 141, 158, 166),
                                              ),
                                              const SizedBox(width: 4),
                                              Text("Edit Vehicle", style: TextStyle(color: Color.fromARGB(255, 98, 99, 112))),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(height: 8),
                            ],
                          ))
                        ],
                      ),
                    ),
                  ),
                );
              },
            )),
        Flexible(
            flex: 1,
            child: Container(
              padding: EdgeInsets.only(left: 10, right: 10),
              alignment: Alignment.center,
              child: loginButon(),
            ))
      ],
    );
  }

  Widget _listItem(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        Divider(),
        new Row(
          children: <Widget>[
            new Flexible(
              child: Container(
                height: 80,
                child: Image.asset(
                  'assets/images/logo/samplepin.jpeg',
                  width: 70,
                  height: 70,
                  fit: BoxFit.contain,
                ),
              ),
              flex: 1,
            ),
            new Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    // padding: const EdgeInsets.only(left: 10),
                    width: double.infinity,

                    // height: 20,
                    child: Text("Trevino Hammaondd", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    alignment: Alignment.center,
                  ),
                  Container(
                    // padding: const EdgeInsets.only(left: 10),
                    width: double.infinity,
                    // height: 20,
                    child: Text("Test test dfsajjksdf",
                        style: TextStyle(color: Color.fromARGB(255, 190, 195, 199), fontWeight: FontWeight.normal, fontSize: 15)),
                    alignment: Alignment.center,
                  )
                ],
              ),
              flex: 3,
            ),
            new Flexible(
              flex: 1,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                // margin: const EdgeInsets.fromLTRB(16, 10, 16, 10),

                color: Color.fromARGB(255, 249, 227, 206),

                child: Container(
                  // alignment: Alignment.centerLeft,

                  padding: const EdgeInsets.only(left: 2.0, right: 2.0, bottom: 5.0, top: 5.0),

                  // color: Colors.amberAccent,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '3.53',
                        style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14.0, color: Color.fromARGB(255, 246, 130, 30)

                            // double
                            ),
                      ),
                      Icon(Icons.star_outlined, size: 17, color: Color.fromARGB(255, 246, 130, 30)),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
        const SizedBox(height: 10),
        Container(
            child: Text(
                " but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software",
                style: TextStyle(color: Color.fromARGB(255, 190, 195, 199), fontWeight: FontWeight.normal, fontSize: 15))),
      ],
    );
  }
}
