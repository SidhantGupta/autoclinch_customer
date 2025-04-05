import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class WhatsAppButton extends StatelessWidget {
  final String phoneNumber;
  final String message;

  WhatsAppButton({required this.phoneNumber, required this.message});

  void launchWhatsApp() async {
    var whatsappUrl =
        "https://wa.me/$phoneNumber/?text=${Uri.encodeComponent(message)}";
    launchUrl(Uri.parse(whatsappUrl), mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ButtonStyle(
        shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
        backgroundColor: MaterialStateProperty.resolveWith((states) {
          // If the button is pressed, return green, otherwise blue
          if (states.contains(MaterialState.pressed)) {
            return Colors.white;
          }
          return Colors.white;
        }),
      ),
      onPressed: launchWhatsApp,
      icon: SizedBox(
        width: 24,
        height: 24,
        child: Image.asset(
          'assets/images/whatsaap_logoo.png',
          color: Colors.green,
        ), // Replace with your WhatsApp logo asset
      ),
      label: Text(
        'Get a free demo now',
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}
