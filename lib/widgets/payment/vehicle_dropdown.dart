import 'package:autoclinch_customer/network/model/vehiclelist_response.dart';
import 'package:flutter/material.dart';

class VehicleDropdown extends StatefulWidget {
  final List<VehicleData> vehicles;
  final Function(VehicleData) selectListner;
  const VehicleDropdown(this.vehicles, {Key? key, required this.selectListner}) : super(key: key);

  @override
  _VehicleDropdownState createState() => _VehicleDropdownState();
}

class _VehicleDropdownState extends State<VehicleDropdown> {
  var currentSelectedValue;
  @override
  void initState() {
    // ////('vehicle list size: ${widget.vehicles.length}');
    currentSelectedValue = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<VehicleData>(
      decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blueGrey),
          ),
          border: OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              const Radius.circular(5.0),
            ),
          )),
      isExpanded: true,
      hint: Text("Select Vehicle"),
      value: currentSelectedValue,
      isDense: true,
      onChanged: (newValue) {
        if (newValue != null) {
          setState(() {
            currentSelectedValue = newValue;
          });
          widget.selectListner(newValue);
        }
      },
      items: widget.vehicles.map((value) {
        return DropdownMenuItem<VehicleData>(
          value: value,
          child: Text(value.name),
        );
      }).toList(),
    );
  }
}
