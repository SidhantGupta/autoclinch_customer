import 'package:flutter/material.dart';

class LoginBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            children: [
              Container(
                width: double.infinity,
                color: Theme.of(context).primaryColor,
                padding: const EdgeInsets.only(top: 20, bottom: 45),
                child: Image.asset(
                  "assets/images/login_banner.png",
                  height: 180,
                ),
              ),
              const SizedBox(
                height: 40,
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  // color: Colors.grey[100],
                  color: const Color(0xFFFAF9F7),
                  child: Image.asset(
                    'assets/images/logo/autoclinch_logo.png',
                    height: 70,
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
