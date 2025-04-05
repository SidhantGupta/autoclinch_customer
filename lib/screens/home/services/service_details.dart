import 'package:autoclinch_customer/network/model/purchase_model.dart';
import 'package:autoclinch_customer/network/model/service_model.dart';
import 'package:autoclinch_customer/utils/extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../../network/api_service.dart';
import '../../../network/model/GetPackageResponse.dart';
import '../../../network/model/login_response.dart';
import '../../../network/model/vehicle_model.dart';
import '../../../notifiers/loader_notifier.dart';
import '../../../utils/constants.dart';
import '../../../utils/preference_util.dart';
import 'calender_screen.dart';

class ServiceDetails extends StatefulWidget {
  ServiceDetails(
      {Key? key, required this.service, required this.purchaseHistory})
      : super(key: key);
  final PackageData service;
  final List<PackagePurchasehistory> purchaseHistory;

  @override
  State<ServiceDetails> createState() => _ServiceDetailsState();
}

class _ServiceDetailsState extends State<ServiceDetails> {
  PaymentLoadingNotifier? _loadingNotifier;
  double? mrp;
  double? discount;
  var arr;
  @override
  void initState() {
    _loadingNotifier =
        Provider.of<PaymentLoadingNotifier>(context, listen: false);
    // _loadingNotifier?.isLoading = false;
    getVehicle();
    getPackages();
    mrp = widget.service.price! * .2 + widget.service.price!.toDouble();
    discount = (mrp! - widget.service.price!).roundToDouble();
    String mrps = mrp.toString();
    arr = mrps.split('.');

    super.initState();
  }

  String? purchaseId;

  late Future<VehicleModel?> _futureVehicle;

  late Future<GetPackageResponse?> _futurePackages;

  String? image;

  getVehicle() async {
    _futureVehicle = ApiService().execute<VehicleModel>(
      'getMyVehicleListOne/${widget.service.id}',
      isGet: true,
    );
  }

  String? vehicleId;

  String paymentType = 'new';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 230.0,
              floating: true,
              // backgroundColor: Colors.white,
              pinned: true,
              // snap: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(widget.service.title ?? ''),
                titlePadding: EdgeInsets.only(left: 50, bottom: 16),
                background: buildHero(),
              ),
            ),
          ];
        },
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30),
                Text(widget.service.description ?? '',
                    style: theme.textTheme.titleLarge),
                SizedBox(height: 20),
                ListTile(
                  contentPadding: EdgeInsets.only(right: 20),
                  leading: CircleAvatar(
                    backgroundColor:
                        theme.appBarTheme.backgroundColor?.withOpacity(0.1),
                    foregroundColor: theme.appBarTheme.backgroundColor,
                    child: Icon(Icons.calendar_today, size: 20),
                  ),
                  title: Text('Duration'),
                  trailing: Text(widget.service.days.toString() + ' Days'),
                ),
                ListTile(
                  contentPadding: EdgeInsets.only(right: 20),
                  leading: CircleAvatar(
                    backgroundColor:
                        theme.appBarTheme.backgroundColor?.withOpacity(0.1),
                    foregroundColor: theme.appBarTheme.backgroundColor,
                    child: Icon(Icons.monetization_on_outlined, size: 20),
                  ),
                  title: Text('Price'),
                  trailing: Text.rich(
                    TextSpan(
                      text: 'Rs. ',
                      style: TextStyle(fontSize: 16, wordSpacing: 10),
                      children: [
                        TextSpan(
                          text: widget.service.price.toString(),
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: ' ',
                          style: TextStyle(fontSize: 16, wordSpacing: 5),
                        ),
                        if (widget.service.days! != 30)
                          TextSpan(
                            text: arr[0],
                            style: TextStyle(
                                fontSize: 16,
                                decoration: TextDecoration.lineThrough,
                                wordSpacing: 5),
                          ),
                        if (widget.service.days! != 30)
                          TextSpan(
                            text: '/-',
                            style: TextStyle(fontSize: 16, wordSpacing: 5),
                          ),
                      ],
                    ),
                  ),
                ),
                if (widget.service.days! != 30)
                  ListTile(
                    contentPadding: EdgeInsets.only(right: 20),
                    leading: CircleAvatar(
                      backgroundColor:
                          theme.appBarTheme.backgroundColor?.withOpacity(0.1),
                      foregroundColor: theme.appBarTheme.backgroundColor,
                      child: Icon(Icons.savings, size: 20),
                    ),
                    title: Text('Total Savings'),
                    trailing: Text.rich(
                      TextSpan(
                        text: 'Rs. ',
                        style: TextStyle(fontSize: 16, wordSpacing: 10),
                        children: [
                          TextSpan(
                            text: discount.toString(),
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: '/-',
                            style: TextStyle(fontSize: 16, wordSpacing: 5),
                          ),
                        ],
                      ),
                    ),
                  ),
                SizedBox(height: 20),
                if (widget.service.isPurchased == false)
                  Text(
                    'Ongoing Package',
                    style: theme.textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.normal),
                  ),
                SizedBox(height: 10),
                // if (_futurePackages)
                FutureBuilder<GetPackageResponse?>(
                    future: _futurePackages,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        // setImage(snapshot);

                        return ListView.separated(
                          itemCount: snapshot.data!.data!.vehicles!.length,
                          primary: false,
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          separatorBuilder: (BuildContext context, int index) {
                            return SizedBox(height: 10);
                          },
                          itemBuilder: (BuildContext context, int index) {
                            final vehicles =
                                snapshot.data!.data!.vehicles![index];

                            return Container(
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                // boxShadow: [
                                //   BoxShadow(
                                //     color: Colors.grey.withOpacity(0.1),
                                //     spreadRadius: 5,
                                //     blurRadius: 7,
                                //     offset: Offset(0, 3), // changes position of shadow
                                //   ),
                                // ],
                                border: Border.all(
                                    color: Colors.grey.withOpacity(0.1)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            vehicles.make ?? 'N/A',
                                            style: TextStyle(fontSize: 18),
                                          ),
                                          if (vehicles.rcNumber != null)
                                            Text(
                                              vehicles.rcNumber ?? '',
                                              style: TextStyle(fontSize: 15),
                                            ),
                                        ],
                                      ),
                                      Spacer(),
                                      Visibility(
                                        visible: vehicles.kilometer != null,
                                        child: Text(
                                          vehicles.status.toString(),
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        replacement: Text(
                                          'N/A',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  // SizedBox(height: 10),
                                  Divider(),
                                  // SizedBox(height: 5),
                                  Row(
                                    children: [
                                      vehicles?.end_date != null
                                          ? Row(
                                              children: [
                                                Icon(Icons.calendar_today,
                                                    size: 15,
                                                    color: Colors.grey),
                                                SizedBox(width: 10),
                                                Text('End Date',
                                                    style: TextStyle(
                                                        color: Colors.grey)),
                                                SizedBox(width: 10),
                                                Text(
                                                  // DateFormat.yMMMMd().format(vehicles.end_date.toString() ?? DateTime.now()),
                                                  formatDate(vehicles.end_date
                                                      .toString()),
                                                  style: TextStyle(),
                                                ),
                                                // Column(
                                                //   crossAxisAlignment: CrossAxisAlignment.start,
                                                //   children: [
                                                //     Text('Start Date', style: TextStyle(color: Colors.grey)),
                                                //     SizedBox(height: 10),
                                                //     Text(
                                                //       DateFormat.yMMMMd().format(purchase.fromDate ?? DateTime.now()),
                                                //       style: TextStyle(),
                                                //     ),
                                                //   ],
                                                // ),
                                              ],
                                            )
                                          : Container(),
                                      Spacer(),
                                      //renew button
                                      // if (purchase.toDate != null && purchase.toDate!.isBefore(DateTime.now()))
                                      OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 0, vertical: 10),
                                          visualDensity: VisualDensity.compact,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          side: BorderSide(color: Colors.blue),
                                        ),
                                        onPressed: () async {
                                          openCheckout(vehicles.id!);

                                          setState(() {
                                            vehicleId =
                                                vehicles.customerId.toString();
                                            paymentType = 'renew';
                                          });
                                        },
                                        child: Text(
                                            vehicles.buttonTitle.toString()),
                                      ),
                                    ],
                                  ),

                                  Visibility(
                                    visible: vehicles?.end_date != null,
                                    child: OutlinedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CalenderScreen(
                                                    vehicleId: vehicles.id!,
                                                  )),
                                        );
                                      },
                                      style: OutlinedButton.styleFrom(
                                        backgroundColor:
                                            theme.appBarTheme.backgroundColor,
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.calendar_month,
                                            color: Colors.white,
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            'Tracking',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                        );
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    }),
              ],
            ).setScreenLoader<PaymentLoadingNotifier>(),
          ),
        ),
      ),
      // bottomNavigationBar: Padding(
      //   padding: const EdgeInsets.all(12),
      //   child: ElevatedButton.icon(
      //     style: ElevatedButton.styleFrom(
      //       backgroundColor: theme.appBarTheme.backgroundColor,
      //       minimumSize: Size.fromHeight(45),
      //       shape: RoundedRectangleBorder(
      //         borderRadius: BorderRadius.circular(10.0),
      //       ),
      //     ),
      //     onPressed: () {
      //       //
      //       setState(() => vehicleId = null);
      //       showVehicleSelectionSheet();
      //     },
      //     label: Text('Buy Now'),
      //     icon: Icon(Icons.shopping_cart_outlined, size: 20),
      //   ),
      // ),
    );
  }

  String formatDate(String inputString) {
    // Create a DateTime object from the input string
    DateTime date = DateTime.parse(inputString);

    // Create a DateFormat object with the desired output format
    DateFormat outputFormat = DateFormat('yyyy-MMM-dd', 'en_US');

    // Format the date to the desired output format
    String formattedDate = outputFormat.format(date);

    return formattedDate;
  }

  Widget buildHero() {
    return FutureBuilder<GetPackageResponse?>(
        future: _futurePackages,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.data!.image != null) {
            return Hero(
              tag: widget.service.id ?? '',
              child: Container(
                child: Visibility(
                  visible: image != null,
                  child: Container(
                    decoration:
                        BoxDecoration(color: Colors.black.withOpacity(0.5)),
                  ),
                ),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(BASE_URL +
                        'images/package/' +
                        snapshot.data!.data!.image!),
                    fit: BoxFit.cover,
                  ),
                ),
                //add black layer to make text more visible
              ),
            );
          } else {
            return Container();
          }
        });
  }

  void openCheckout(int id, {String type = 'new'}) async {
    _loadingNotifier?.isLoading = true;
    final now = DateTime.now();
    try {
      await ApiService().execute<PaymentModel>(
        'package-purchase',
        params: {
          'package_id': widget.service.id.toString(),
          'vehicle_id': id.toString(),
        },
      ).then((value) {
        if (value != null) {
          setState(() {
            purchaseId = value.purchase?.purchaseId.toString();
          });
        }
      });
    } catch (e) {
      _loadingNotifier?.isLoading = false;
    }
    Razorpay razorpay = Razorpay();
    LoginData? loginData = await SharedPreferenceUtil().getUserDetails();
    if (loginData == null) {
      return;
    }

    var options = {
      "key": "rzp_live_4Tspwhh7iniy28",
      "amount": double.parse(widget.service.price.toString()) * 100,
      "name": "Autoclinch services",
      "description": "Payment for Autoclinch services",
      "prefill": {
        "contact": loginData.mobile ?? "",
        "email": loginData.email ?? ""
      },
      "external": {
        "wallets": ["paytm"]
      }
    };

    try {
      razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentErrorResponse);
      razorpay.on(
        Razorpay.EVENT_PAYMENT_SUCCESS,
        handlePaymentSuccessResponse,
      );
      razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWalletSelected);
      razorpay.open(options);
    } on Exception catch (err) {
      _loadingNotifier?.isLoading = false;
      razorpay.clear();
      debugPrint(err.toString());
    }
  }

  void handlePaymentSuccessResponse(PaymentSuccessResponse response) {
    _completePayment(response.paymentId);
  }

  void handlePaymentErrorResponse(PaymentFailureResponse response) {
    _loadingNotifier?.isLoading = false;
    showAlertDialog(
      context,
      "Payment Failed",
      "${response.message}",
    );
  }

  void handleExternalWalletSelected(ExternalWalletResponse response) {
    _loadingNotifier?.isLoading = false;
    showAlertDialog(
        context, "External Wallet Selected", "${response.walletName}");
  }

  void _completePayment(String? paymentId) async {
    try {
      await ApiService().execute('purchase-success', params: {
        'purchase_id': purchaseId,
        'referance_no': paymentId.toString(),
        'amount': widget.service.price.toString(),
        'payment_type': paymentType,
      });
      // await ApiService().execute('purchaseVehicleUpdate', params: {
      //   'purchase_id': purchaseId,
      //   'vehicle_id': vehicleId ?? '',
      // });
      _loadingNotifier?.isLoading = false;
      showSuccessDialog();
    } on Exception catch (e) {
      _loadingNotifier?.isLoading = false;
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  void showAlertDialog(BuildContext context, String title, String message) {
    _loadingNotifier?.isLoading = false;
    Fluttertoast.showToast(msg: title, toastLength: Toast.LENGTH_LONG);
  }

  void showSuccessDialog() {
    showDialog(context: context, builder: (context) => SuccessDialog());
  }

  showVehicleSelectionSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return FutureBuilder<VehicleModel?>(
          future: _futureVehicle,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  color: Color(0xff757575),
                  child: Container(
                    padding: EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
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
                                  setState(() {
                                    _futureVehicle =
                                        ApiService().execute<VehicleModel>(
                                      'getMyVehicleListOne/${widget.service.id}',
                                      isGet: true,
                                    );
                                    vehicleId = null;
                                  });
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
                          //dropdown
                          snapshot.data!.vehicle!.isEmpty
                              ? Container(
                                  height: 120,
                                  child: Center(
                                    child: Text(
                                      'No vehicle found \n\nPlease add new vehicle to continue',
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                )
                              : DropdownButtonFormField(
                                  decoration: InputDecoration(
                                    labelText: 'Select Vehicle',
                                    labelStyle: TextStyle(color: Colors.grey),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              Theme.of(context).primaryColor),
                                    ),
                                  ),
                                  value: vehicleId,
                                  items: snapshot.data!.vehicle?.map((e) {
                                    return DropdownMenuItem(
                                      child: Text(e.make ?? ''),
                                      value: e.id,
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      vehicleId = value.toString();
                                    });
                                  },
                                ),

                          const Divider(),
                          ElevatedButton(
                            child: Text(
                              'Continue',
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).appBarTheme.backgroundColor,
                              minimumSize: Size(double.infinity, 45),
                            ),
                            onPressed: () async {
                              if (vehicleId != null) {
                                Navigator.pop(context);
                                // openCheckout();
                                // _completePayment('123456');
                              } else {
                                Fluttertoast.showToast(
                                    msg: 'Please select vehicle to continue');
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        );
      },
    );
  }

  void getPackages() {
    _futurePackages = ApiService().execute<GetPackageResponse>(
      'package/${widget.service.id}',
      isGet: true,
    );
  }

  void setImage(AsyncSnapshot<GetPackageResponse?> snapshot) {
    setState(() {
      if (snapshot.data!.data!.image != null) {
        image = snapshot.data!.data!.image!;
      }
    });
    buildHero();
  }
}

class SuccessDialog extends StatelessWidget {
  const SuccessDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            LottieBuilder.asset(
              'assets/icons/successful.json',
              height: 150,
              repeat: false,
            ),
            Text('Payment Successful', style: TextStyle(fontSize: 20)),
            SizedBox(height: 8),
            TextButton(
              onPressed: () =>
                  Navigator.of(context, rootNavigator: true).pop(true),
              child: Text('Go Back'),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }
}
