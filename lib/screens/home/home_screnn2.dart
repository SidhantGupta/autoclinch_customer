import 'dart:developer';
import 'package:autoclinch_customer/screens/home/services/service_details.dart';
import 'package:autoclinch_customer/screens/home/services/service_screen.dart';
import 'package:autoclinch_customer/widgets/home/corosel_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import '../../network/api_service.dart';
import '../../network/model/login_response.dart';
import '../../network/model/service_model.dart';
import '../../network/model/vehiclelist_response.dart';
import '../../notifiers/loader_notifier.dart';
import '../../utils/constants.dart';
import '../../utils/preference_util.dart';
import '../../widgets/home/webview.dart';
import '../../widgets/payment/vehicle_dropdown.dart';

class HomeScreen2 extends StatefulWidget {
  HomeScreen2(this.navigationHelper, {Key? key}) : super(key: key);
  final void Function(int) navigationHelper;

  @override
  State<HomeScreen2> createState() => _HomeScreen2State();
}

class _HomeScreen2State extends State<HomeScreen2> {
  late Future<ServiceModel?> _future;
  List<VehicleData> _vehicles = List.empty();

  String location = '';
  String Address = 'null';
  Position? position;
  List<Placemark>? placemarks;
  Placemark? place;
  Future<void> getlocation() async {
    position = await _getGeoLocationPosition();
    location = 'Lat: ${position!.latitude} , Long: ${position!.longitude}';
    print(location);
    placemarks =
        await placemarkFromCoordinates(position!.latitude, position!.longitude);
    print(placemarks);
    place = placemarks![0];

    GetAddressFromLatLong(position!);
    print(place!.country.toString());
  }

  Future<void> GetAddressFromLatLong(Position position) async {
    placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    print(placemarks);
    place = placemarks![0];
    Address =
        '${place!.street}, ${place!.subLocality}, ${place!.locality}, ${place!.postalCode}, ${place!.country}';
  }

  VehicleData? _selectedVehicle;
  double? mrp;
  late Future<VehicleListModel?> _furuService;
  void _profileApi({bool isWantApicall = false}) async {
    if (!isWantApicall && _profileData != null) {
      return;
    }
    // _loadingNotifier?.isLoading = true;
    final LoginResponse? response = await ApiService().execute<LoginResponse>(
      'get-my-profile',
      isGet: true,
      loadingNotifier: _loadingNotifier,
    );
    _profileData = response?.data;
    // _loadingNotifier?.isLoading = false;
  }

  @override
  void initState() {
    getService();
    _furuService = ApiService().execute<VehicleListModel>('getVehicleList',
        isGet: true, isThrowExc: true);
    _loadingNotifier =
        Provider.of<ProfileLoadingNotifier>(context, listen: false);
    _loadingNotifier?.reset(loading: false);
    _profileApi();
    getlocation();
    super.initState();
  }

  getService() async {
    _future = ApiService().execute<ServiceModel>('all-packages', isGet: true);
  }

  Future<Position> _getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      // await Geolocator.requestPermission();
      await Geolocator.requestPermission()
          .then((value) {})
          .onError((error, stackTrace) {
        print('error');
      });
      return await Geolocator.getCurrentPosition();
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  ProfileLoadingNotifier? _loadingNotifier;

  LoginData? _profileData;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Consumer<ProfileLoadingNotifier>(
            builder: (context, value, child) => Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome, ${_profileData!.name ?? ''}',
                      style: theme.textTheme.titleLarge!
                          .copyWith(color: Colors.white),
                    ),
                    Text(
                      '${placemarks![0].street} ${placemarks![0].subLocality} ,${placemarks![0].locality}',
                      style: TextStyle(fontSize: 18),
                    )
                  ],
                )),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ImageCorousel(),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text('Daily Auto Care',
                      style: theme.textTheme.titleLarge!),
                ),
                SizedBox(
                  height: 198,
                  child: FutureBuilder<ServiceModel?>(
                    future: _future,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data?.data?.packageDatas == null ||
                            snapshot.data!.data!.packageDatas!.isEmpty) {
                          return Center(child: Text('No services available'));
                        }
                        return GridView.builder(
                          scrollDirection: Axis.horizontal,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 1),
                          itemCount: snapshot.data!.data!.packageDatas!.length,
                          itemBuilder: (context, index) {
                            final service =
                                snapshot.data!.data!.packageDatas![index];
                            mrp =
                                service.price! * .2 + service.price!.toDouble();
                            String mrps = mrp.toString();
                            var arr = mrps.split('.');

                            return Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: GestureDetector(
                                onTap: () {
                                  //remove packageHistory if the vehicle is null
                                  if (snapshot
                                          .data!.data!.packagePurchasehistory !=
                                      null) {
                                    snapshot.data!.data!.packagePurchasehistory
                                        ?.removeWhere(
                                            (element) => element.make == null);
                                  }
                                  List<PackagePurchasehistory>? packageHistory =
                                      snapshot
                                          .data!.data!.packagePurchasehistory;
                                  //return only the package history of the selected service
                                  if (packageHistory != null) {
                                    packageHistory = packageHistory
                                        .where((element) =>
                                            element.packageId == service.id)
                                        .toList();
                                  }
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ServiceDetails(
                                        service: service,
                                        purchaseHistory: packageHistory ?? [],
                                      ),
                                    ),
                                  );
                                },
                                // borderRadius: BorderRadius.circular(10.0),
                                child: Card(
                                  elevation: 2,
                                  child: Column(children: [
                                    Container(
                                      child: Image.network(
                                        BASE_URL +
                                            'images/package/' +
                                            service.image.toString(),
                                        fit: BoxFit.cover,
                                        height: 110,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Image.asset(
                                            'assets/images/logo/autoclinch_logo.png',
                                            width: 100,
                                            height: 100,
                                          );
                                        },
                                        loadingBuilder:
                                            (context, child, loadingProgress) =>
                                                loadingProgress == null
                                                    ? child
                                                    : Center(
                                                        child:
                                                            CircularProgressIndicator(
                                                          value: loadingProgress
                                                                      .expectedTotalBytes !=
                                                                  null
                                                              ? loadingProgress
                                                                      .cumulativeBytesLoaded /
                                                                  loadingProgress
                                                                      .expectedTotalBytes!
                                                              : null,
                                                        ),
                                                      ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 2,
                                    ),
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text(service.title.toString(),
                                          maxLines: 2,
                                          style: theme.textTheme.titleLarge!
                                              .copyWith(
                                            fontSize: 15,
                                          )),
                                    ),
                                    ButtonBar(
                                      children: [
                                        if (service.price != null)
                                          Row(
                                            children: [
                                              Text('Rs. ${service.price}',
                                                  style: theme
                                                      .textTheme.titleLarge!
                                                      .copyWith(fontSize: 19)),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              service.days! != 30
                                                  ? Row(
                                                      children: [
                                                        Text(
                                                          arr[0],
                                                          style: theme.textTheme
                                                              .titleLarge!
                                                              .copyWith(
                                                                  decoration:
                                                                      TextDecoration
                                                                          .lineThrough,
                                                                  fontSize: 19),
                                                        ),
                                                        Text('/-')
                                                      ],
                                                    )
                                                  : Text(''),
                                            ],
                                          )
                                      ],
                                    )
                                  ]),
                                ),
                              ),
                            );
                          },
                        );
                      } else if (snapshot.hasError) {
                        return Text('${snapshot.error}');
                      }
                      return const Center(child: CircularProgressIndicator());
                    },
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ServiceScreen(),
                    ));
                  },
                  child: Column(
                    //   mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          MaterialButton(
                            onPressed: () {},
                            child: Text(
                              'Explore plans',
                              style: theme.textTheme.titleMedium,
                            ),
                          ),
                          Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(50)),
                              child: Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                              ))
                        ],
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text('Insurance', style: theme.textTheme.titleLarge!),
                ),
                SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DashBoard(
                                        url:
                                            'https://www.smcinsurance.com/Myaccount/Account/LoginLink?Token=05b209b0428b4c57b2f959bce811071d',
                                      )));
                        },
                        child: Column(
                          children: [
                            Material(
                              elevation: 10,
                              borderRadius: BorderRadius.circular(40),
                              child: Container(
                                width: 70,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(40),
                                ),
                                height: 70,
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.asset(
                                    'assets/images/bike.png',
                                    height: 35,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Text(
                              "Bike",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DashBoard(
                                        url:
                                            'https://www.smcinsurance.com/Myaccount/Account/LoginLink?Token=05b209b0428b4c57b2f959bce811071d',
                                      )));
                        },
                        child: Column(
                          children: [
                            Material(
                              elevation: 10,
                              borderRadius: BorderRadius.circular(40),
                              child: Container(
                                width: 70,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(40),
                                ),
                                height: 70,
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.asset(
                                    'assets/images/car.png',
                                    height: 35,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Text(
                              "Car",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DashBoard(
                                        url:
                                            'https://www.smcinsurance.com/Myaccount/Account/LoginLink?Token=05b209b0428b4c57b2f959bce811071d',
                                      )));
                        },
                        child: Column(
                          children: [
                            Material(
                              elevation: 10,
                              borderRadius: BorderRadius.circular(40),
                              child: Container(
                                width: 70,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(40),
                                ),
                                height: 70,
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.asset(
                                    'assets/images/hand_family.png',
                                    height: 35,
                                    color: Colors.black,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Text(
                              "Health",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DashBoard(
                                        url:
                                            'https://www.smcinsurance.com/Myaccount/Account/LoginLink?Token=05b209b0428b4c57b2f959bce811071d',
                                      )));
                        },
                        child: Column(
                          children: [
                            Material(
                              elevation: 10,
                              borderRadius: BorderRadius.circular(40),
                              child: Container(
                                width: 70,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(40),
                                  //   color: Colors.amber,
                                ),
                                height: 70,
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.asset(
                                    'assets/images/help.png',
                                    height: 35,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Text(
                              "Life",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DashBoard(
                                  url:
                                      'https://www.smcinsurance.com/Myaccount/Account/LoginLink?Token=05b209b0428b4c57b2f959bce811071d',
                                )));
                  },
                  child: Column(
                    //   mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          MaterialButton(
                            onPressed: () {},
                            child: Text(
                              'More',
                              style: theme.textTheme.titleMedium,
                            ),
                          ),
                          Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(50)),
                              child: Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                              ))
                        ],
                      )
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 2),
                  child: Text('Repair and Maintenance',
                      style: theme.textTheme.titleLarge!),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap: () => _showBottomSheet(context, 'breakdown'),
                      child: Column(
                        children: [
                          Material(
                            elevation: 10,
                            borderRadius: BorderRadius.circular(40),
                            child: Container(
                              width: 70,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40),
                                color: theme.primaryColor,
                              ),
                              height: 70,
                              alignment: Alignment.center,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset(
                                  'assets/images/breakdown.png',
                                  height: 40,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                          Text(
                            "Sudden \n Breakdown",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      /*    child: ClipRRect(
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
                              height: 80,
                              child: Row(
                                children: <Widget>[
                                  new Flexible(
                                    child: Container(
                                      height: 60,
                                      alignment: Alignment.center,
                                      width: double.infinity,
                                      child: Image.asset(
                                        'assets/images/breakdown.png',
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    flex: 2,
                                  ),
                                  new Flexible(
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: 60,
                                      width: double.infinity,
                                      child: Text(
                                        "SUDDEN\nBREAKDOWN",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    flex: 3,
                                  ),
                                ],
                              ),
                            )),
                      ),*/
                    ),
                    InkWell(
                        onTap: () => _showBottomSheet(context, 'maintenance'),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Material(
                              elevation: 10,
                              borderRadius: BorderRadius.circular(40),
                              child: Container(
                                width: 70,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(40),
                                  color: theme.primaryColor,
                                ),
                                height: 70,
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.asset(
                                    'assets/images/repair.png',
                                    height: 40,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              "Maintenance &\n Repair",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ))
                  ],
                ),
                const SizedBox(height: 10),
                /*   InkWell(
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
                          height: 80,
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
                                      fontSize: 16,
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
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                flex: 2,
                              ),
                            ],
                          ),
                        )),
                  ),
                ),*/
                SizedBox(
                  height: 10,
                ),

                //   const SizedBox(height: 10),
              ]),
        ),
      ),
    );
  }

  void _showBottomSheet(BuildContext context, String type) async {
    log(type);
    if (_vehicles.isEmpty) {
      final _result =
          await Navigator.of(context).pushNamed('/vehiclelistscreen');
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
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
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
                          await Navigator.pushNamed(
                              context, '/addvehiclescreen');
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
                  VehicleDropdown(_vehicles,
                      selectListner: (value) => _selectedVehicle = value),
                  const Divider(),
                  ElevatedButton(
                    child: Text(
                      'Save',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(),
                    onPressed: () async {
                      if (_selectedVehicle != null) {
                        Navigator.pop(context);
                        await SharedPreferenceUtil().storeServiceType(type);
                        await SharedPreferenceUtil()
                            .storeVehicleName(_selectedVehicle!.id.toString());
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
