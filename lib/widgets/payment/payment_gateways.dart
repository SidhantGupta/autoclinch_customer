import 'package:flutter/material.dart';

import '/network/model/payments_vehicle_response.dart' show PaymentGatewaysData;

enum PaymentGateways { UPI, RAZER_PAY, CASH }

class GatewayWidget extends StatefulWidget {
  final Function(PaymentGateways) _selectListner;
  final PaymentGatewaysData _paymentData;
  const GatewayWidget(this._paymentData, this._selectListner, {Key? key}) : super(key: key);

  @override
  _GatewayWidgetState createState() => _GatewayWidgetState();
}

class _GatewayWidgetState extends State<GatewayWidget> {
  PaymentGateways? _selectedPayment;
  @override
  void initState() {
    _selectedPayment = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        widget._paymentData.gpay?.isEnabled == true
            ? paymentCard(
                paymentGateways: PaymentGateways.UPI,
                title: 'Pay with UPI',
                description: 'UPI Payment',
                assetPath: 'assets/images/upi.png')
            : SizedBox(),
        widget._paymentData.razorpay?.isEnabled == true
            ? paymentCard(
                paymentGateways: PaymentGateways.RAZER_PAY,
                title: 'Pay with RazorPay',
                description: 'Click to pay with Razorpay gateway',
                assetPath: 'assets/images/razorpay.png')
            : SizedBox(),
        paymentCard(
            paymentGateways: PaymentGateways.CASH,
            title: 'Pay in Cash',
            description: 'Click to pay with Cash',
            assetPath: 'assets/images/rupee.png'),
      ],
    );
  }

  void _setSelection(PaymentGateways paymentGateways) {
    setState(() {
      _selectedPayment = paymentGateways;
      widget._selectListner(paymentGateways);
    });
  }

  Widget paymentCard({
    required PaymentGateways paymentGateways,
    required String title,
    required String description,
    required String assetPath,
  }) {
    final _isSelected = _selectedPayment == paymentGateways;
    return Card(
      child: InkWell(
        onTap: () => _setSelection(paymentGateways),
        child: Container(
          padding: const EdgeInsets.all(10),
          color: _isSelected ? Theme.of(context).primaryColor : Colors.white,
          child: Row(
            children: [
              Radio(
                value: paymentGateways,
                groupValue: _selectedPayment,
                activeColor: Colors.white,
                onChanged: (value) => {
                  if (value == paymentGateways) _setSelection(paymentGateways),
                },
              ),
              Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: _isSelected ? Colors.white : Colors.black),
                ),
                const SizedBox(height: 7),
                Text(
                  description,
                  style: TextStyle(color: _isSelected ? Colors.white : Colors.black),
                ),
              ])),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Image.asset(
                    assetPath,
                    height: 50,
                    width: 50,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
