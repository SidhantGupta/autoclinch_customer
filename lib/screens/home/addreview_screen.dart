import 'package:autoclinch_customer/custom/rating_stars.dart';
import 'package:autoclinch_customer/network/api_service.dart';
import 'package:autoclinch_customer/network/model/booking_args.dart';
import 'package:autoclinch_customer/network/model/common_response.dart';
import 'package:autoclinch_customer/notifiers/loader_notifier.dart' show AddReviewNotifier;
import 'package:autoclinch_customer/utils/extensions.dart';
import 'package:autoclinch_customer/widgets/user/textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart' show Provider;

// ignore: must_be_immutable

class AddReviewScreen extends StatelessWidget {
  // const ProfileScreen({Key? key}) : super(key: key);
  late final BookingArg? booking_arg;

  AddReviewScreen({this.booking_arg, Key? key});

  @override
  Widget build(BuildContext context) {
    return AddReview(booking_arg_new: booking_arg);
  }
}

class AddReview extends StatefulWidget {
  late final BookingArg? booking_arg_new;

  // final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextStyle style = TextStyle(fontSize: 14.0);
  final TextStyle labelTextstyle = TextStyle(fontSize: 14.0);

  AddReview({this.booking_arg_new, Key? key}) : super(key: key);
  // AddReview createState() => _MyAppHomeState();

  @override
  _AddReviewScreen createState() => _AddReviewScreen(booking_arg_new);
}

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class _AddReviewScreen extends State<AddReview> {
  BookingArg? _bookingArg;
  _AddReviewScreen(this._bookingArg);

  @override
  void initState() {
    super.initState();
    _loadingNotifier = Provider.of<AddReviewNotifier>(context, listen: false);
  }

  String title = "", subtitle = "";
  double valu = 0.0;
  AddReviewNotifier? _loadingNotifier;

  final TextStyle style = TextStyle(fontSize: 14.0);

  final TextStyle _labelStyle = TextStyle(fontSize: 14.0, color: Color(0xFF2A2935));

  @override
  Widget build(BuildContext context) {
    _loadingNotifier?.reset();
    ////("ListLength : ");
    // ////(widget.vehicleList.length);

    final updateButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(5.0),
      color: Theme.of(context).primaryColor,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        onPressed: () async {
          if (_formKey.currentState?.validate() == true) {
            _formKey.currentState?.save();
            ////("All fields are filled");

            ////("Title : " + title);
            ////("SubTitle : " + subtitle);

            _loadingNotifier?.isLoading = true;

            final CommonResponse2? response = await ApiService().execute<CommonResponse2>(
              'submit-review',
              params: {
                'vendor_id': _bookingArg?.vendor_id,
                'userrequest_id': _bookingArg?.booking_id,
                'star': "4",
                'review_title': title,
                'description': subtitle,
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
        }

        // Navigator.of(context).pushNamed("/paymentscreen");
        ,
        child: Text("Submit",
            textAlign: TextAlign.center, style: style.copyWith(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Rating',
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
          children: [
            const SizedBox(
              height: 40,
            ),
            Container(
                width: double.infinity,
                margin: new EdgeInsets.symmetric(horizontal: 15.0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 20, 8, 20),
                    child: Container(
                      // color: Colors.amberAccent,
                      alignment: Alignment.center,
                      child: RatingStars(
                          starSize: 40,
                          value: valu,
                          starCount: 5,
                          starOffColor: const Color(0xffe7e8ea),
                          starColor: Theme.of(context).primaryColor,
                          onValueChanged: (v) {
                            ////("Value is : " + v.toString());
                            //
                            setState(() {
                              ////("Value is1 : " + v.toString());

                              valu = v;

                              ////("Value is2 : " + valu.toString());
                            });
                          }),
                    ),
                  ),
                )
                // margin: new EdgeInsets.symmetric(horizontal: 8.0),
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
                    TextFieldWithPadding(
                      hintText: "Enter the title",
                      labelText: 'Title',
                      iconData: Icons.subtitles_outlined,
                      onSaved: (newValue) => title = newValue ?? "",
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
                      hintText: "Enter the description",
                      labelText: "Description",
                      iconData: Icons.description_outlined,
                      onSaved: (newValue) => subtitle = newValue ?? "",
                      validator: (value) {
                        if ((value ?? "").trim().isEmpty) {
                          return 'This field is required';
                        } else {
                          return null;
                        }
                      },
                      keyboardType: TextInputType.emailAddress,
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
            Container(
              margin: new EdgeInsets.symmetric(horizontal: 15.0),
              child: updateButon,
            ),
          ],
        ),
      ).setScreenLoader<AddReviewNotifier>(),
    );
  }
}
