import 'dart:io';

import 'package:autoclinch_customer/network/api_service.dart';
import 'package:autoclinch_customer/network/model/common_response.dart';
import 'package:autoclinch_customer/network/model/login_response.dart';
import 'package:autoclinch_customer/network/model/payments_outstanding_response.dart';
import 'package:autoclinch_customer/network/model/payments_vehicle_response.dart';
import 'package:autoclinch_customer/notifiers/loader_notifier.dart';
import 'package:autoclinch_customer/screens/home/rating_screen.dart';
import 'package:autoclinch_customer/utils/extensions.dart';
import 'package:autoclinch_customer/utils/preference_util.dart';
import 'package:autoclinch_customer/widgets/payment/payment_gateways.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
//import 'package:upi_pay/upi_pay.dart' show UpiTransactionResponse, UpiTransactionStatus;

class PaymentScreenForOutstanding extends StatelessWidget {
  final PaymentOutstandingIntentData? intentData;
  PaymentScreenForOutstanding(this.intentData, {Key? key}) : super(key: key);

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
        body: FutureBuilder<PaymentOutstandingResponse?>(
          future: ApiService().execute<PaymentOutstandingResponse>(
            'payment-on-finish?booking_id=${intentData?.bookingId ?? ''}',
            isGet: true,
            isThrowExc: true,
          ),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(child: CircularProgressIndicator());
              default:
                if (snapshot.hasError) {
                  ////("Data is Has error null");

                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.data?.data != null) {
                  ////("Data is not null");

                  return _PaymentScreen(intentData!, snapshot.data!.data!);
                }
                return Text('Result: ${snapshot.data}');
            }
          },
        ));
  }
}

class PaymentOutstandingIntentData {
  final String bookingId, id;

  PaymentOutstandingIntentData({required this.bookingId, required this.id});
}

class _PaymentScreen extends StatefulWidget {
  final PaymentOutstandingIntentData intentData;
  final PaymentOutstandingData paymentData;
  _PaymentScreen(this.intentData, this.paymentData, {Key? key})
      : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<_PaymentScreen> {
  late Razorpay _razorpay = Razorpay();
  PaymentLoadingNotifier? _loadingNotifier;
  @override
  void initState() {
    super.initState();
    _loadingNotifier =
        Provider.of<PaymentLoadingNotifier>(context, listen: false);
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  PaymentGateways? _selectedGateway;

  void _gotoPayment() async {
    if (_selectedGateway == PaymentGateways.UPI) {
      final String? _upiId = widget.paymentData.gpay?.upiId;
      if (_upiId.isNullOrEmpty || widget.intentData.bookingId.isNullOrEmpty) {
        ////("**2: RETURNED ");
        return;
      }

      /* final UpiTransactionResponse? response = await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => UPIApp(
                upiId: _upiId!,
                tempOrderId: widget.intentData.bookingId,
                amount: widget.paymentData.totalAmount,
              )));*/

      if (true //response != null //&& response.status == UpiTransactionStatus.success
          ) {
        String _referenceNo = '';
        if (Platform.isAndroid) {
          //_referenceNo = response.approvalRefNo ?? '';
        }
        _completePayment(_referenceNo, "upi");
      }
    } else if (_selectedGateway == PaymentGateways.RAZER_PAY) {
      openCheckout();
    } else if (_selectedGateway == PaymentGateways.CASH) {
      _completePayment("", "cash");
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    ////("Payment Success");

    _completePayment(response.paymentId, "razorpay");
    // if (apiResponse?.data?.vehicles != null) {
    //
    // }
  }

  void _completePayment(String? paymentId, String? type) async {
    _loadingNotifier?.isLoading = true;
    final CommonResponse2? response = await ApiService()
        .execute<CommonResponse2>('payment-on-finish-complete', params: {
      'booking_id': widget.intentData.bookingId,
      'payment_type': type,
      'referance_number': paymentId,
      'pay_amount': widget.paymentData.totalAmount,
      'id': widget.intentData.id,
    });
    _loadingNotifier?.isLoading = false;
    if (response?.success == true) {
      // Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => RatingScreen(
                    userRequestId: widget.intentData.id,
                  )));
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    ////("Payment Failure");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    ////("External Wallet");
  }

  void openCheckout() async {
    LoginData? loginData = await SharedPreferenceUtil().getUserDetails();
    if (loginData == null) {
      return;
    }
    PaymentVehicleData? _tempOrder;
    /*  final response = await PayumoneyProUnofficial.payUParams(
        email: loginData.email ?? "ranjithkadumeni@gmail.com",
        firstName: '',
        merchantName: 'Autoclinch services',
        isProduction: true,
        merchantKey: 'jDItdV',
        merchantSalt: 'q3crLi7DqdSSVP5QD9bB7xmXwPkmZh7T',
        amount: double.parse(widget.paymentData.totalAmount).toString(),
        hashUrl:
            '<Checksum URL to generate dynamic hashes>', //nodejs code is included. Host the code and update its url here.

        productInfo: '',
        transactionId: '',
        showExitConfirmation: true,
        showLogs: false, // true for debugging, false for production

        userCredentials:
            'beb984e1c24fef03760cd06e29b489ff76a713399e44b626e75a74294fe1526c:' +
                '<Customer Email or User ID>',
        userPhoneNumber: '');
    print(response);
    if (response['status'] == PayUParams.success)
      _handlePaymentSuccess(response['']);

    if (response['status'] == PayUParams.failed)
      _handlePaymentError(response['message']);
*/
    /*   var options = {
      "key": "rzp_live_4Tspwhh7iniy28",
      "amount": double.parse(widget.paymentData.totalAmount) * 100,
      "name": "Autoclinch services",
      "description": "Payment for Autoclinch services",
      //"order_id": _tempOrder!.tempId,
      "prefill": {
        "contact": loginData.mobile ?? "8075893358",
        "email": loginData.email ?? "ranjithkadumeni@gmail.com"
      },
      "external": {
        "wallets": ["paytm"]
      }
    };
*/
    try {
      //  _razorpay.open(options);
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
                  GatewayWidget(
                      widget.paymentData, (value) => _selectedGateway = value),
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
              Column(
                children: [
                  const SizedBox(height: 20),
                  Container(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Amount Info',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          InkWell(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => CupertinoAlertDialog(
                                  title: Text('Vender Remarks'),
                                  content: Text(widget.paymentData.remarks),
                                ),
                              );
                            },
                            child: Icon(
                              Icons.info,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      )),
                  const SizedBox(height: 5),
                  Divider(),
                  const SizedBox(height: 10),
                  Container(
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Min Amount",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                        ),
                        Text(
                          "Rs. ${widget.paymentData.minAmount}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 5),
                  Divider(),
                  const SizedBox(height: 10),
                  Container(
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Service Payment",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                        ),
                        Text(
                          "Rs. ${widget.paymentData.serviceAmount}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Divider(),
                  // const SizedBox(height: 10),
                  // Container(
                  //   child: Row(
                  //     children: [
                  //       Expanded(
                  //         child: Text(
                  //           "Outstanding Amount",
                  //           style: TextStyle(
                  //               fontWeight: FontWeight.bold, fontSize: 15),
                  //         ),
                  //       ),
                  //       Text(
                  //         "Rs. ${widget.paymentData.remainingAmount}",
                  //         style: TextStyle(
                  //             fontWeight: FontWeight.bold, fontSize: 15),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // const SizedBox(height: 10),
                  // Divider(),

                  const SizedBox(height: 10),
                  Container(
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Total",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                        ),
                        Text(
                          "Rs. ${widget.paymentData.totalAmount}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  child: Text("Pay Now   Rs. ${widget.paymentData.totalAmount}",
                      textAlign: TextAlign.center,
                      style: style.copyWith(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                  onPressed: () {
                    if (_selectedGateway == null) {
                      return;
                    }
                    _gotoPayment();
                  },
                  style: ElevatedButton.styleFrom(
                      shadowColor: Theme.of(context).primaryColor,
                      elevation: 7,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5))),
                ),
              ),
              const SizedBox(height: 10),
            ])),
      ],
    ).setScreenLoader<PaymentLoadingNotifier>();
  }
}
