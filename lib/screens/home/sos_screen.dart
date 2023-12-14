import 'package:autoclinch_customer/keys.dart';
import 'package:autoclinch_customer/utils/preference_util.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;
import 'package:map_place_picker/map_place_picker.dart';
import 'package:url_launcher/url_launcher.dart';

class SOSScreen extends StatelessWidget {
  final bool isFromTab;
  SOSScreen({Key? key, this.isFromTab = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextStyle _labelStyle = TextStyle(fontSize: 14.0, color: Color(0xFF2A2935));
    _openMap(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'SOS',
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: true,
        automaticallyImplyLeading: true,
        // leading: IconButton(onPressed: null , Icon(Icons.arrow_forward_ios_outlined)),
      ),
      body: Container(
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              RawMaterialButton(
                onPressed: () {
                  _makePhoneCall('tel:102');
                },
                elevation: 2.0,
                fillColor: Colors.white,
                child: Icon(
                  Icons.notifications_active_outlined,
                  size: 35,
                ),
                padding: EdgeInsets.all(15.0),
                shape: CircleBorder(),
              ),
              RawMaterialButton(
                onPressed: () {
                  _makePhoneCall('tel:108');
                },
                elevation: 2.0,
                fillColor: Colors.white,
                child: Icon(
                  Icons.local_hospital_outlined,
                  size: 35,
                ),
                padding: EdgeInsets.all(15.0),
                shape: CircleBorder(),
              ),
              FutureBuilder<String>(
                future: SharedPreferenceUtil().getEmergencyNumber(),
                builder: (context, snapshot) {
                  if (snapshot.data.isNotNullOrEmpty) {
                    return Row(
                      children: [
                        const SizedBox(width: 10),
                        RawMaterialButton(
                          onPressed: () {
                            _makePhoneCall('tel:${snapshot.data}');
                          },
                          elevation: 2.0,
                          fillColor: Colors.white,
                          child: Icon(
                            Icons.people_outlined,
                            size: 35,
                          ),
                          padding: EdgeInsets.all(15.0),
                          shape: CircleBorder(),
                        ),
                      ],
                    );
                  }
                  return const SizedBox();
                },
              ),
            ],
          )),
    );
  }

  void _openMap(BuildContext context) async {
    if (isFromTab) {
      return;
    }
    MapAddress? _mapAddress = await SharedPreferenceUtil().getMapAddress();
    final LatLng? _latLng = _mapAddress == null ? null : LatLng(_mapAddress.latitude, _mapAddress.longitude);
    MapPicker.show(context, MAP_API_KEY, (address) {
      if (address != null) {
        SharedPreferenceUtil().storeMapAddress(address);
        _mapAddress = address;
        // call sos api
      }
    }, initialLocation: _latLng, title: 'Pick your location');
  }

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
