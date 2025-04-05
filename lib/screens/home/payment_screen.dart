import 'package:autoclinch_customer/network/api_service.dart';
import 'package:autoclinch_customer/network/model/common_response.dart';
import 'package:autoclinch_customer/network/model/login_response.dart';
import 'package:autoclinch_customer/network/model/payments_vehicle_response.dart';
import 'package:autoclinch_customer/network/model/vehiclelist_response.dart';
import 'package:autoclinch_customer/network/model/vendor_details_response.dart';
import 'package:autoclinch_customer/notifiers/loader_notifier.dart';
import 'package:autoclinch_customer/utils/extensions.dart';
import 'package:autoclinch_customer/utils/preference_util.dart';
import 'package:autoclinch_customer/widgets/payment/payment_gateways.dart';
import 'package:autoclinch_customer/widgets/payment/vehicle_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:map_place_picker/map_place_picker.dart' hide StringNullOrEmpty;
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentScreen extends StatelessWidget {
  final PaymentIntentData? intentData;
  PaymentScreen(this.intentData, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (intentData == null) {
      return Container();
    }
    // return Profile();
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Checkout',
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
          elevation: 1,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          centerTitle: true,
          automaticallyImplyLeading: true,
        ),
        body: _PaymentScreen(intentData!.paymentVehicleData, intentData!));
  }
}

class PaymentIntentData {
  final Vendor vendor;
  final List<String> services;
  final PaymentVehicleData paymentVehicleData;

  PaymentIntentData(
      {required this.vendor,
      required this.services,
      required this.paymentVehicleData});
}

class _PaymentScreen extends StatefulWidget {
  final PaymentIntentData intentData;
  final PaymentVehicleData paymentData;
  _PaymentScreen(this.paymentData, this.intentData, {Key? key})
      : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<_PaymentScreen> {
  late Razorpay _razorpay = Razorpay();
  PaymentLoadingNotifier? _loadingNotifier;
  @override
  void initState() {
    _checkVehicles();
    super.initState();
    _loadingNotifier =
        Provider.of<PaymentLoadingNotifier>(context, listen: false);
  }

  void _chcekOrderStatus() async {
    _loadingNotifier?.isLoading = true;
    final PaymentVehicleResponse? response = await ApiService()
        .execute<PaymentVehicleResponse>('check-vendor-api',
            params: {'vendor_id': widget.intentData.vendor.id});
    _loadingNotifier?.isLoading = false;
    if (response?.data?.vehicles != null &&
        response?.data?.vehicles.isNotEmpty == true) {
      setState(() {
        widget.paymentData.repolaceVehicles(response!.data!.vehicles);
      });
    }
  }

  void _checkVehicles() {
    if (widget.paymentData.vehicles.isEmpty) {
      WidgetsBinding.instance
          .addPostFrameCallback((_) => _openVehicleListPage());
    }
  }

  void _openVehicleListPage() async {
    await Navigator.of(context).pushNamed('/vehiclelistscreen');
    _chcekOrderStatus();
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  VehicleData? _selectedVehicle;
  PaymentGateways? _selectedGateway;

  void _placeTempOrder() async {
    if (_tempOrder?.tempId.isNotNullOrEmpty == true) {
      _gotoPayment();
      return;
    }
    // LoginData? _loginData = await SharedPreferenceUtil().getUserDetails();
    // if (_loginData == null) {
    //   return;
    // }

    MapAddress? _mapAddress = await SharedPreferenceUtil().getMapAddress();
    if (_mapAddress == null) {
      return;
    }

    _loadingNotifier?.isLoading = true;

    final PaymentVehicleResponse? apiResponse =
        await ApiService().execute<PaymentVehicleResponse>(
      'user-request-api',
      params: {
        'amount': widget.paymentData.totalAmount,
        'request_id': widget.paymentData.requestId,
        'vendor_id': widget.intentData.vendor.id,
        'vehicle_id': _selectedVehicle?.id?.toString() ?? '',
        'lat': _mapAddress.latitude.toString(),
        'lng': _mapAddress.longitude.toString(),
      }..addAll(widget.intentData.services
          .asMap()
          .map((key, value) => MapEntry("services[$key]", value))),
    );

    _loadingNotifier?.isLoading = false;
    if (apiResponse?.data?.tempId == null) {
      return;
    }
    _tempOrder = apiResponse!.data!;
    _gotoPayment();
  }

  PaymentVehicleData? _tempOrder;

  void _gotoPayment() async {
    if (_selectedGateway == PaymentGateways.UPI) {
      ////("***1:");
      final String? _upiId = widget.paymentData.gpay?.upiId;
      if (_upiId.isNullOrEmpty || _tempOrder?.tempId.isNullOrEmpty == true) {
        ////("***2:RETURNED ");

        ////("***2a:RETURNED " + _upiId.toString());
        // ////("***2b:RETURNED ");

        return;
      }
      /*   final UpiTransactionResponse? response = await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => UPIApp(
                upiId: _upiId!,
                tempOrderId: _tempOrder!.tempId,
                amount: _tempOrder!.totalAmount,
              )));*/

      /*   if (response != null && response.status == UpiTransactionStatus.success) {
        String _referenceNo = '';

        ////(response.toString());

        if (Platform.isAndroid) {
          _referenceNo = response.txnRef ?? '';
        }
        _completePayment(_referenceNo);
      }
    } else if (_selectedGateway == PaymentGateways.RAZER_PAY) {
      openCheckout();
    }*/
    }

    void _handlePaymentSuccess(PaymentSuccessResponse response) {
      ////("Payment Success");

      //  _completePayment(response.paymentId);
      // if (apiResponse?.data?.vehicles != null) {
      //
      // }
    }

    void _completePayment(String? paymentId) async {
      _loadingNotifier?.isLoading = true;
      final CommonResponse2? response = await ApiService()
          .execute<CommonResponse2>('booking-payment-finish', params: {
        'booking_id': _tempOrder?.tempId,
        'referance_number': paymentId
      });
      _loadingNotifier?.isLoading = false;
      if (response?.success == true) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/home', (route) => false);
      }
    }

    void _handlePaymentError(PaymentFailureResponse response) {
      ////("Payment Failure");
    }

    void _handleExternalWallet(ExternalWalletResponse response) {
      ////("External Wallet");
    }

    void openCheckout() async {
      if (_tempOrder == null) {
        return;
      }

      LoginData? loginData = await SharedPreferenceUtil().getUserDetails();
      if (loginData == null) {
        return;
      }

      ////('mjm tempId: ${_tempOrder!.tempId}');

      var options = {
        "key": "rzp_live_4Tspwhh7iniy28",
        "amount": double.parse(_tempOrder!.totalAmount) * 100,
        "name": "Autoclinch services",
        "description": "Payment for Autoclinch services",
        "order_id": _tempOrder!.tempId,
        "prefill": {
          "contact": loginData.mobile ?? "8075893358",
          "email": loginData.email ?? "ranjithkadumeni@gmail.com"
        },
        "external": {
          "wallets": ["paytm"]
        }
      };

      try {
        _razorpay.open(options);
      } catch (err) {
        ////("Error RPAY : " + err.toString());
      }
    }

    final TextStyle style = TextStyle(fontSize: 14.0);

    @override
    Widget build(BuildContext context) {
      _loadingNotifier?.reset();
      return Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, top: 30),
                child: Column(
                  children: [
                    VehicleDropdown(widget.paymentData.vehicles,
                        selectListner: (value) => _selectedVehicle = value),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Icon(
                          Icons.credit_card_outlined,
                        ),
                        const SizedBox(width: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Payment Option",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            const SizedBox(height: 7),
                            Text("Select your prefered payment mode"),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                    GatewayWidget(widget.paymentData,
                        (value) => _selectedGateway = value),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
          Container(
              padding: const EdgeInsets.only(left: 10, right: 10),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(10.0),
                    topRight: const Radius.circular(10.0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      offset: Offset(0, 4),
                      blurRadius: 7,
                      spreadRadius: 5,
                    )
                  ]),
              alignment: Alignment.centerLeft,
              child: Column(children: [
                Row(
                  children: [
                    Card(
                      margin: const EdgeInsets.only(top: 10),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            // height: 80,
                            child: Image.asset(
                              'assets/images/grill.jpg',
                              width: 70,
                              height: 70,
                              fit: BoxFit.contain,
                            ),
                          ),
                          Container(
                            width: 70,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 0, vertical: 5),
                            color: Color(0xFFEBEBEB),
                            child: Text(
                              'Offline',
                              style: TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFFD9D9D9),
                                  fontWeight: FontWeight.w500),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                        child: Container(
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                widget.intentData.vendor.businessName ?? '',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              )),
                          Divider(),
                          Container(
                            child: Row(
                              children: [
                                new Flexible(
                                  flex: 3,
                                  child: Container(
                                    width: double.infinity,
                                    child: Text(
                                      "Service Payment",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                  ),
                                ),
                                new Flexible(
                                  flex: 1,
                                  child: Container(
                                    width: double.infinity,
                                    child: Text(
                                      "Rs. ${widget.paymentData.totalAmount}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          // Container(
                          //   child: Row(
                          //     children: [
                          //       new Flexible(
                          //         flex: 3,
                          //         child: Container(
                          //           width: double.infinity,
                          //           child: Text(
                          //             "Tax",
                          //             style: TextStyle(
                          //                 fontWeight: FontWeight.bold,
                          //                 fontSize: 15),
                          //           ),
                          //         ),
                          //       ),
                          //       new Flexible(
                          //         flex: 1,
                          //         child: Container(
                          //           width: double.infinity,
                          //           child: Text(
                          //             "Rs. 8.81",
                          //             style: TextStyle(
                          //                 fontWeight: FontWeight.bold,
                          //                 fontSize: 15),
                          //           ),
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          const SizedBox(height: 10),
                          Divider(),
                          const SizedBox(height: 10),
                          Container(
                            child: Row(
                              children: [
                                new Flexible(
                                  flex: 3,
                                  child: Container(
                                    width: double.infinity,
                                    child: Text(
                                      "Total",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                  ),
                                ),
                                new Flexible(
                                  flex: 1,
                                  child: Container(
                                    width: double.infinity,
                                    child: Text(
                                      "Rs. ${widget.paymentData.totalAmount}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                    child: Text("Pay Now",
                        textAlign: TextAlign.center,
                        style: style.copyWith(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                    onPressed: () {
                      if (widget.paymentData.vehicles.isEmpty) {
                        _openVehicleListPage();
                        return;
                      }
                      if (_selectedVehicle == null ||
                          _selectedGateway == null) {
                        return;
                      }
                      _placeTempOrder();
                    },
                    style: ElevatedButton.styleFrom(
                        shadowColor: Theme.of(context).primaryColor,
                        elevation: 7,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5))),
                  ),
                ),
                const SizedBox(height: 20),
              ])),
        ],
      ).setScreenLoader<PaymentLoadingNotifier>();
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
