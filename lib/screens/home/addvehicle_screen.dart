import 'package:autoclinch_customer/network/api_service.dart';
import 'package:autoclinch_customer/network/model/common_response.dart';
import 'package:autoclinch_customer/network/model/vehicle_arguments.dart';
import 'package:autoclinch_customer/notifiers/loader_notifier.dart' show AddVehicleLoadingNotifier;
import 'package:autoclinch_customer/utils/extensions.dart';
import 'package:autoclinch_customer/widgets/user/textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart' show Provider;

// ignore: must_be_immutable
class AddVehicleScreen extends StatefulWidget {
  late final VehicleArg? vehiclearg;

  AddVehicleScreen({Key? key, this.vehiclearg}) : super(key: key);

  @override
  State<AddVehicleScreen> createState() => _AddVehicleScreenState();
}

class _AddVehicleScreenState extends State<AddVehicleScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextStyle style = TextStyle(fontSize: 14.0);

  final TextStyle labelTextstyle = TextStyle(fontSize: 14.0);

  AddVehicleLoadingNotifier? _loadingNotifier;

  String? vehicleType;

  @override
  Widget build(BuildContext context) {
    _loadingNotifier = Provider.of<AddVehicleLoadingNotifier>(context, listen: false);
    _loadingNotifier?.reset();
    ////("AddVehicleScreen build() ");
    // ////("ListLength : ");
    // ////(widget.vehicleList.length);

    final TextStyle style = TextStyle(fontSize: 14.0);

    final TextStyle _labelStyle = TextStyle(fontSize: 14.0, color: Color(0xFF2A2935));

    String brand = "", model = "", year = "", rcnumber = "", kilometer = "", fueltype = "";

    final loginButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(5.0),
      color: Theme.of(context).primaryColor,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        onPressed: () async {
          if (_formKey.currentState?.validate() == true) {
            // showLoaderDialog(context);
            _formKey.currentState?.save();
            ////("All fields are filled");

            _loadingNotifier?.isLoading = true;

            final CommonResponse2? response = await ApiService().execute<CommonResponse2>(
              'saveVehicle',
              params: {
                'make': brand,
                'model': model,
                'mfd_year': year,
                'rc_number': rcnumber,
                'vehicle_type': vehicleType ?? '',
                // 'customer_ids': '3',
                'fuel_type': fueltype,
                'kilometer': kilometer,
              },
            );
            _loadingNotifier?.isLoading = false;
            bool statusresp = response!.success;
            if (statusresp) {
              Navigator.pop(context);
            } else {
              // Navigator.pop(context);
            }
          }

          // Navigator.of(context).pushNamed("/paymentscreen");
        },
        child: Text(widget.vehiclearg == null ? "Add Vehicle" : "Edit Vehicle",
            textAlign: TextAlign.center, style: style.copyWith(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    final updateButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(5.0),
      color: Theme.of(context).primaryColor,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        onPressed: () async {
          if (_formKey.currentState?.validate() == true) {
            // showLoaderDialog(context);
            _formKey.currentState?.save();
            ////("All fields are filled");

            _loadingNotifier?.isLoading = true;

            final CommonResponse2? response = await ApiService().execute<CommonResponse2>(
              'updateVehicle',
              params: {
                'make': brand,
                'model': model,
                'mfd_year': year,
                'rc_number': rcnumber,
                'vehicle_type': vehicleType ?? '',
                // 'customer_ids': '3',
                'fuel_type': fueltype,
                'kilometer': kilometer,
                'vehicle_id': widget.vehiclearg?.id,
              },
            );
            _loadingNotifier?.isLoading = false;
            bool statusresp = response!.success;
            if (statusresp) {
              Navigator.pop(context, true);
            } else {
              // Navigator.pop(context);
            }
          }

          // Navigator.of(context).pushNamed("/paymentscreen");
        },
        child: Text("Update Vehicle",
            textAlign: TextAlign.center, style: style.copyWith(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Vehicle',
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),

        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: true,
        automaticallyImplyLeading: true,
        // leading: IconButton(onPressed: null , Icon(Icons.arrow_forward_ios_outlined)),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // LoginBanner(),
            const SizedBox(
              height: 15,
            ),
            Form(
              key: _formKey,
              child: Card(
                margin: EdgeInsets.fromLTRB(16, 10, 16, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 18),
                      child: Text('Type'),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 22),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: vehicleType,
                          //elevation: 5,
                          style: TextStyle(color: Colors.black),
                          isExpanded: true,
                          items: <String>[
                            'Two wheeler',
                            'Three wheeler',
                            'Four wheeler',
                            'Six wheeler',
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          hint: Row(
                            children: [
                              Icon(
                                CupertinoIcons.car_detailed,
                                color: Colors.grey.shade600,
                              ),
                              SizedBox(width: 13),
                              Text(
                                "Select vehicle type",
                                //style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          onChanged: (String? value) {
                            setState(() {
                              vehicleType = value;
                              ////(vehicleType);
                            });
                          },
                        ),
                      ),
                    ),
                    TextFieldWithPadding(
                      hintText: "Enter the brand name",
                      labelText: 'Brand',
                      initialValue: widget.vehiclearg?.make,
                      iconData: Icons.branding_watermark_outlined,
                      onSaved: (newValue) => brand = newValue ?? "",
                      validator: (value) {
                        if ((value ?? "").trim().isEmpty) {
                          return 'This field is required';
                        } else {
                          return null;
                        }
                      },
                      keyboardType: TextInputType.text,
                    ),
                    const Divider(),
                    TextFieldWithPadding(
                      hintText: "Enter the vehicle model",
                      labelText: "Model",
                      initialValue: widget.vehiclearg?.model,
                      iconData: Icons.airport_shuttle_outlined,
                      onSaved: (newValue) => model = newValue ?? "",
                      validator: (value) {
                        if ((value ?? "").trim().isEmpty) {
                          return 'This field is required';
                        } else {
                          return null;
                        }
                      },
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const Divider(),
                    TextFieldWithPadding(
                      hintText: "Enter the Manufacturing Year",
                      labelText: 'MFD Year',
                      initialValue: widget.vehiclearg?.year,

                      // prefixText: '+91 ',
                      maxLength: 4,
                      iconData: Icons.date_range_outlined,
                      onSaved: (newValue) => year = newValue ?? "",
                      validator: (value) {
                        if ((value ?? "").trim().isEmpty) {
                          return 'This field is required';
                        } else {
                          return null;
                        }
                      },
                      keyboardType: TextInputType.number,
                    ),
                    const Divider(),
                    TextFieldWithPadding(
                      hintText: "Enter your RC Number",
                      labelText: 'RC Number',
                      initialValue: widget.vehiclearg?.rcNumber,

                      // prefixText: '+91 ',
                      // maxLength: 10,
                      iconData: Icons.twenty_four_mp_outlined,
                      onSaved: (newValue) => rcnumber = newValue ?? "",
                      validator: (value) {
                        if ((value ?? "").trim().isEmpty) {
                          return 'This field is required';
                        } else {
                          return null;
                        }
                      },
                      keyboardType: TextInputType.text,
                    ),
                    const Divider(),
                    TextFieldWithPadding(
                      hintText: "Enter the Kilometer",
                      labelText: 'Kilometer',
                      initialValue: widget.vehiclearg?.kilometer,

                      // prefixText: '+91 ',
                      // maxLength: 10,
                      iconData: Icons.support_outlined,
                      onSaved: (newValue) => kilometer = newValue ?? "",
                      validator: (value) {
                        if ((value ?? "").trim().isEmpty) {
                          return 'This field is required';
                        } else {
                          return null;
                        }
                      },
                      keyboardType: TextInputType.number,
                    ),
                    const Divider(),
                    TextFieldWithPadding(
                      hintText: "Enter the fuel type",
                      labelText: 'Fuel Type',
                      initialValue: widget.vehiclearg?.fuelType,

                      // prefixText: '+91 ',
                      // maxLength: 10,
                      iconData: Icons.ev_station_outlined,
                      onSaved: (newValue) => fueltype = newValue ?? "",
                      validator: (value) {
                        if ((value ?? "").trim().isEmpty) {
                          return 'This field is required';
                        } else {
                          return null;
                        }
                      },
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 5, 16, 5),

              // vehicle(loginButon,updateButon);

              // if(updateVehicle!=null)
              // {

              // }

              child: vehicle(loginButon, updateButon),
            ),

            // Padding(
            //   padding: const EdgeInsets.fromLTRB(16.0, 5, 16, 5),

            //   // vehicle(loginButon,updateButon);

            //   // if(updateVehicle!=null)
            //   // {

            //   // }

            //   child: updateButon,
            // ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ).setScreenLoader<AddVehicleLoadingNotifier>(),
    );
  }

  vehicle(Material loginButon, Material updateButton) {
    if (widget.vehiclearg != null) {
      return updateButton;
    } else {
      return loginButon;
    }
  }

  titleText() {
    if (widget.vehiclearg != null) {
      return "Update Vehicle";
    } else {
      return "Update Vehicle";
    }
  }
}

// showLoaderDialog(BuildContext context) {
//   AlertDialog alert = AlertDialog(
//     content: new Row(
//       children: [
//         CircularProgressIndicator(),
//         Container(margin: EdgeInsets.only(left: 7), child: Text("Loading...")),
//       ],
//     ),
//   );
//   showDialog(
//     barrierDismissible: false,
//     context: context,
//     builder: (BuildContext context) {
//       return alert;
//     },
//   );
// }
