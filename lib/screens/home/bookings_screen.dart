import 'dart:async';
import 'dart:developer';

import 'package:autoclinch_customer/network/api_service.dart';
import 'package:autoclinch_customer/network/model/booking_args.dart';
import 'package:autoclinch_customer/network/model/bookings_response.dart';
import 'package:autoclinch_customer/screens/home/invoice.dart';
import 'package:autoclinch_customer/screens/home/payment_screen_outstanding.dart';
import 'package:autoclinch_customer/utils/extensions.dart' show ScreenLoader;
import 'package:autoclinch_customer/utils/preference_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '/notifiers/loader_notifier.dart' show BookingLoadingNotifier;
import '/screens/home/track_vendor.dart' show TrackingIntent;
import '../../custom/rating_stars.dart';

class BookingScreen extends StatefulWidget {
  final String? id;

  BookingScreen({this.id});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  late Future<BookingResponse?> _futureBooking;

  late Timer _timer;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _futureBooking = ApiService().execute<BookingResponse>(
        'get-bookings-history',
        isGet: true,
        isThrowExc: true);
    showStatusSheet();
    super.initState();
  }

  showStatusSheet() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _timer = Timer.periodic(Duration(seconds: 45), (timer) async {
        return ApiService()
            .execute<StatusModel>(
          'work-status-flash',
          isGet: true,
          isThrowExc: true,
        )
            .then(
          (value) async {
            if (value != null) {
              if (value.status?.vendorAlert != null &&
                  value.status!.vendorAlert != '') {
                log('${value.status!.vendorAlert}');

                String _status = await getStatus();
                log('$_status');
                if (_status != value.status!.vendorAlert) {
                  return showModalBottomSheet(
                    context: context,
                    builder: (ctx) => StatusWidget(
                      status: value.status!.vendorAlert!,
                    ),
                  );
                } else {
                  return;
                }
              }
            }
            return;
          },
        );
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<String> getStatus() async {
    return await SharedPreferences.getInstance().then((prefs) {
      return prefs.getString('status') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          elevation: 1,
          title: Text(
            'Bookings',
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          centerTitle: true,
        ),
        body: FutureBuilder<BookingResponse?>(
          future: _futureBooking,
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

                  return Booking(snapshot.data!.data, widget.id, refresh);
                }
                return Text('Result: ${snapshot.data}');
            }
          },
        ));
  }

  void refresh() {
    setState(() {
      _futureBooking = ApiService().execute<BookingResponse>(
          'get-bookings-history',
          isGet: true,
          isThrowExc: true);
    });
  }
}

class StatusWidget extends StatefulWidget {
  const StatusWidget({Key? key, required this.status}) : super(key: key);

  final String status;

  @override
  State<StatusWidget> createState() => _StatusWidgetState();
}

class _StatusWidgetState extends State<StatusWidget> {
  Timer? _timer;
  closeThePage() {
    _timer = Timer.periodic(Duration(seconds: 40), (timer) async {
      Navigator.of(context).pop();
    });
  }

  @override
  void initState() {
    closeThePage();
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    storeStatus(widget.status);
    super.dispose();
  }

  storeStatus(String status) async {
    await SharedPreferences.getInstance().then((prefs) {
      prefs.setString('status', status);
    });
  }

  @override
  Widget build(BuildContext context) {
    Color startedColor = Colors.grey;
    IconData startedIcon = CupertinoIcons.clock;
    if (widget.status == "started" || widget.status == "reached") {
      startedColor = Colors.green;
    }
    if (widget.status == "reached" || widget.status == "started") {
      startedIcon = Icons.check_circle;
    }
    IconData endedIcon = CupertinoIcons.clock;

    Color reachedColor = Colors.grey;
    if (widget.status == "reached") {
      reachedColor = Colors.green;
    }
    if (widget.status == "reached") {
      endedIcon = Icons.check_circle;
    }
    TextStyle startedStyle = TextStyle(color: Colors.grey, fontSize: 13);
    TextStyle reachedStyle = TextStyle(color: Colors.grey, fontSize: 13);

    if (widget.status == "started" || widget.status == "reached") {
      startedStyle = TextStyle(
          color: Colors.green, fontSize: 15, fontWeight: FontWeight.bold);
    }
    if (widget.status == "reached") {
      reachedStyle = TextStyle(
          color: Colors.green, fontSize: 15, fontWeight: FontWeight.bold);
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                visualDensity: VisualDensity.compact,
                //   primary: Colors.red,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ),
          ListTile(
            leading: Icon(Icons.check_circle),
            visualDensity: VisualDensity.compact,
            title: Text('Vender accepted your request',
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                )),
            selected: true,
            selectedColor: Colors.green,
          ),
          ListTile(
            visualDensity: VisualDensity.compact,
            title: Text('Vender started your location', style: startedStyle),
            leading: Icon(startedIcon),
            selected: true,
            selectedColor: startedColor,
          ),
          ListTile(
            visualDensity: VisualDensity.compact,
            title: Text('Vender reached your location', style: reachedStyle),
            leading: Icon(endedIcon),
            selected: true,
            selectedColor: reachedColor,
          ),
          SizedBox(height: 15),
        ],
      ),
    );
  }
}

class Booking extends StatefulWidget {
  Data? data;
  String? _id;
  Function? refresh;
  Booking(this.data, this._id, this.refresh, {Key? key}) : super(key: key);

  @override
  _BookingState createState() => _BookingState(_id);
}

class _BookingState extends State<Booking> {
  String? __id;

  _BookingState(this.__id);

  BookingLoadingNotifier? _loadingNotifier;

  final TextStyle _tabNoramlStyle = TextStyle(
    fontSize: 14.0,
  );

  final TextStyle _labelStyle =
      TextStyle(fontSize: 14.0, color: Color(0xFF2A2935));

  final String _ONGOING = 'Ongoing';

  final String _COMPLETED = 'Completed';

  late BookingArg bookingarg;

  // final String _ARCHIVED = 'Archived';

  String _selectedTab = '';

  @override
  void initState() {
    super.initState();
    _loadingNotifier =
        Provider.of<BookingLoadingNotifier>(context, listen: false);
    if (__id != null) {
      if (__id == "1") {
        _selectedTab = _COMPLETED;
      } else {
        _selectedTab = _ONGOING;
      }
    } else {
      _selectedTab = _ONGOING;
    }

    ////("IDBOOK => : $__id");
  }

  @override
  Widget build(BuildContext context) {
    final List<BookingData> bookingList = (_selectedTab == _COMPLETED
            ? widget.data?.booked
            : _selectedTab == _ONGOING
                ? widget.data?.ongoing
                : List.empty()) ??
        List.empty();
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14.0),
      child: Column(
        children: [
          SizedBox(height: 10),
          Row(
            children: [
              _tab(context, _ONGOING),
              SizedBox(width: 18),
              _tab(context, _COMPLETED),
              // SizedBox(width: 18),
              // _tab(context, _ARCHIVED),
            ],
          ),
          Expanded(
            child: bookingList.isEmpty
                ? Center(
                    child: Text('No data found'),
                  )
                : SingleChildScrollView(
                    child: Column(
                    children: [
                      const SizedBox(height: 20),
                      listview(bookingList),
                      const SizedBox(height: 20),
                    ],
                  )),
          ),
        ],
      ),
    ).setScreenLoader<BookingLoadingNotifier>());
  }

  Widget listview(List<BookingData> bookingList) => ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: bookingList.length,
        itemBuilder: (context, index) =>
            _listItem(context, _selectedTab, bookingList[index]),
      );

  Widget _listItem(
      BuildContext context, String title, BookingData bookingData) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/images/logo/autoclinch_logo.png',
                  width: 70,
                  height: 70,
                  fit: BoxFit.contain,
                ),
                const SizedBox(width: 10),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Row(
                      children: [
                        Text(
                          bookingData.vendorName ?? '',
                          style:
                              _labelStyle.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 5),

                        new Flexible(
                          flex: 1,
                          child: Container(
                            // height: 10,
                            // color: Colors.amberAccent,
                            alignment: Alignment.centerRight,
                            child: _selectedTab == _ONGOING
                                ? showTAG(bookingData.is_otp_verified)
                                : showTAG1("yes"),
                          ),
                        )
                        // _selectedTab == _ONGOING
                        //     ? showTAG(bookingData.is_otp_verified)
                        //     : showEmpty,
                      ],
                    ),

                    const SizedBox(height: 3),
                    Divider(),
                    const SizedBox(height: 3),

                    _selectedTab == _COMPLETED
                        ? StarRating(bookingData)
                        : ShowStatus(bookingData),
                    // StarRating(),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(child: Text('Time', style: _labelStyle)),
                        Text(
                          bookingData.getDateTime,
                          style: TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                            child: Text('Total Price', style: _labelStyle)),
                        Text(
                          '₹',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        Text(
                          bookingData.amount.toString(),
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    _selectedTab == _COMPLETED
                        ? ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size.fromHeight(40),
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => InvoiceScreen(
                                        url:
                                            'https://autoclinch.in/getCustomerInvoice/' +
                                                bookingData.id.toString(),
                                        header: 'yes'),
                                  ));
                            },
                            label: Text(
                              'Invoice',
                            ),
                            icon: Icon(Icons.inventory_outlined))
                        : Container(),
                  ],
                ))
              ],
            ),
            // const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                bookingData.star_rate_enabled == true
                    ? ElevatedButton(
                        onPressed: () async {
                          bookingarg = new BookingArg(
                              booking_id: bookingData.id,
                              vendor_id: bookingData.vendorId);

                          final isAdded = await Navigator.of(context)
                              .pushNamed("/add_review", arguments: bookingarg);

                          if (isAdded is bool && isAdded) {
                            setState(() {});
                          }
                        },
                        child: Text(
                          'Rating',
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            //  side: BorderSide(color: _bgColor)
                          ),
                        ),
                      )
                    : SizedBox(),
                if (_selectedTab == _ONGOING)
                  if (bookingData.vendorMobile != null &&
                      bookingData.vendorMobile != '')
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          //  side: BorderSide(color: _bgColor)
                        ),
                      ),
                      child: Text(
                        'Call',
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                      onPressed: () async {
                        if (await canLaunch(
                            'tel:' + bookingData.vendorMobile!)) {
                          await canLaunch('tel:' + bookingData.vendorMobile!);
                        } else {
                          return;
                        }
                      },
                    ),
                const SizedBox(width: 10),
                if (_selectedTab == _ONGOING)
                  if (bookingData.allowed_payment == "no")
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          //  side: BorderSide(color: _bgColor)
                        ),
                      ),
                      child: Text(
                        'Status',
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                      onPressed: () async {
                        showModalBottomSheet(
                            context: context,
                            builder: (ctx) {
                              return StatusSheet(bookingId: bookingData.id!);
                            });
                      },
                    ),

                const SizedBox(width: 10),
                _selectedTab == _ONGOING
                    ? ElevatedButton(
                        onPressed: () async {
                          final _mapAddress =
                              await SharedPreferenceUtil().getMapAddress();
                          // if (_mapAddress == null) {
                          //   // ApiService().showToast('message');
                          //   return;
                          // }
                          Navigator.of(context).pushNamed('/trackvendor',
                              arguments: TrackingIntent(
                                // vendorId: bookingData.vendorId ?? '',
                                bookingId: bookingData.id ?? '',
                                // lat: _mapAddress.latitude.toString(),
                                // lng: _mapAddress.longitude.toString(),
                              ));
                        },
                        child: Text(
                          'Tracking',
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            //  side: BorderSide(color: _bgColor)
                          ),
                        ),
                      )
                    : SizedBox(),
                const SizedBox(width: 10),
                _selectedTab == _ONGOING
                    /*&&  bookingData.remainingAmount <= 0*/
                    ? bookingData.allowed_payment == "no"
                        ? ElevatedButton(
                            onPressed: () async {
                              final data =
                                  await ApiService().execute<BookingResponse>(
                                'cancel-request',
                                params: {'id': bookingData.id},
                                loadingNotifier: _loadingNotifier,
                              );
                              if (widget.refresh != null) widget.refresh!();

                              setState(() {
                                widget.data = data!.data;
                              });
                            },
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor),
                            ),
                            style: ElevatedButton.styleFrom(
                              //        primary: Color(0xFFFEF2E6),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                //  side: BorderSide(color: _bgColor)
                              ),
                            ),
                          )
                        : SizedBox()
                    : SizedBox(),
                const SizedBox(width: 10),
                bookingData.remainingAmount > 0
                    ? bookingData.allowed_payment == "yes"
                        ? ElevatedButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pushNamed('/payment_outstanding_screen',
                                      arguments: PaymentOutstandingIntentData(
                                        bookingId: bookingData.bookingId ?? '',
                                        id: bookingData.id ?? '',
                                      ));
                            },
                            child: Text(
                              'Pay ₹${bookingData.remainingAmount}',
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor),
                            ),
                            style: ElevatedButton.styleFrom(
                              //       primary: Color(0xFFFEF2E6),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                //  side: BorderSide(color: _bgColor)
                              ),
                            ),
                          )
                        : SizedBox()
                    : SizedBox(),
                // const SizedBox(width: 5),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _tab(BuildContext context, String title) {
    final bool _isSelected = _selectedTab == title;
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedTab = title;
          });
        },
        child: Ink(
          child: Center(
            child: Text(
              title,
              style: _tabNoramlStyle.copyWith(
                  color: _isSelected
                      ? Colors.white
                      : Theme.of(context).primaryColor),
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: _isSelected
                ? Theme.of(context).primaryColor
                : Color(0xFFF7E6CA),
          ),
        ),
      ),
    );
  }

  ShowStatus(BookingData bookingData) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(child: Text('Status', style: _labelStyle)),
        // Text(
        //   '\$',
        //   style: TextStyle(
        //       fontSize: 11,
        //       fontWeight: FontWeight.w500,
        //       color: Theme.of(context).primaryColor),
        // ),
        Text(
          bookingData.status ?? '',
          style: TextStyle(color: Colors.grey, fontSize: 13),
        ),
      ],
    );
  }

  StarRating(BookingData bookingData) {
    //var strVal = double.parse(bookingData.rating_star ?? 0);
    var myDouble = double.parse(bookingData.rating_star!);
    assert(myDouble is double);
    ////(myDouble); // 123.45

    return Row(
      children: [
        Expanded(child: Text('Your Review', style: _labelStyle)),
        RatingStars(
          value: myDouble,
          starColor: Theme.of(context).primaryColor,
        ),
      ],
    );
  }

  showRatingButton() {
    return;
  }

  showEmpty() {}

  showTAG1(String? isOtpVerified) {
    //  title: Text(
    //         'Bookings',
    //         style: TextStyle(color: Theme.of(context).primaryColor),
    //       ),

    return Text("Completed", style: TextStyle(color: Colors.green));
  }

  showTAG(String? isOtpVerified) {
    //  title: Text(
    //         'Bookings',
    //         style: TextStyle(color: Theme.of(context).primaryColor),
    //       ),

    ////("ONGOING CAMEEEEEEEEEEEEE");
    ////(is_otp_verified);

    if (isOtpVerified == "yes") {
      return Text("ongoing", style: TextStyle(color: Colors.green));
    } else {
      return Text("ongoing",
          style: TextStyle(color: Theme.of(context).primaryColor));
    }
  }
}

class StatusSheet extends StatefulWidget {
  final String bookingId;
  const StatusSheet({Key? key, required this.bookingId}) : super(key: key);

  @override
  State<StatusSheet> createState() => _StatusSheetState();
}

class _StatusSheetState extends State<StatusSheet> {
  late Future<StatusModel?> _futureStatus;

  @override
  void initState() {
    _futureStatus = ApiService().execute<StatusModel>(
      'work-status/${widget.bookingId}',
      isGet: true,
      isThrowExc: true,
    );
    checkStatus();
    super.initState();
  }

  checkStatus() {}

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: FutureBuilder<StatusModel?>(
        future: _futureStatus,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.active:
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.done:
            default:
              if (snapshot.hasError) {
                return Text('Unable to fetch data ${snapshot.error}');
              }
              if (snapshot.data == null) {
                return Text('No data');
              }

              var status = snapshot.data!.status!.vendorAlert;
              Color startedColor = Colors.grey;
              IconData startedIcon = CupertinoIcons.clock;
              if (status == "started" || status == "reached") {
                startedColor = Colors.green;
              }
              if (status == "reached" || status == "started") {
                startedIcon = Icons.check_circle;
              }
              IconData endedIcon = CupertinoIcons.clock;

              Color reachedColor = Colors.grey;
              if (status == "reached") {
                reachedColor = Colors.green;
              }
              if (status == "reached") {
                endedIcon = Icons.check_circle;
              }
              TextStyle startedStyle =
                  TextStyle(color: Colors.grey, fontSize: 13);
              TextStyle reachedStyle =
                  TextStyle(color: Colors.grey, fontSize: 13);

              if (status == "started" || status == "reached") {
                startedStyle = TextStyle(
                    color: Colors.green,
                    fontSize: 15,
                    fontWeight: FontWeight.bold);
              }
              if (status == "reached") {
                reachedStyle = TextStyle(
                    color: Colors.green,
                    fontSize: 15,
                    fontWeight: FontWeight.bold);
              }

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: Icon(Icons.check_circle),
                    visualDensity: VisualDensity.compact,
                    title: Text('Vender accepted your request',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        )),
                    selected: true,
                    selectedColor: Colors.green,
                  ),
                  ListTile(
                    visualDensity: VisualDensity.compact,
                    title: Text('Vender started your location',
                        style: startedStyle),
                    leading: Icon(startedIcon),
                    selected: true,
                    selectedColor: startedColor,
                  ),
                  ListTile(
                    visualDensity: VisualDensity.compact,
                    title: Text('Vender reached your location',
                        style: reachedStyle),
                    leading: Icon(endedIcon),
                    selected: true,
                    selectedColor: reachedColor,
                  ),
                ],
              );
          }
        },
      ),
    );
  }
}

class StatusModel {
  StatusModel({
    this.success,
    this.status,
    this.message,
  });

  bool? success;
  Status? status;
  String? message;

  factory StatusModel.fromJson(Map<String, dynamic> json) => StatusModel(
        success: json["success"],
        status: Status.fromJson(json["data"]),
        message: json["message"],
      );
}

class Status {
  Status({this.vendorAlert});

  String? vendorAlert;

  factory Status.fromJson(Map<String, dynamic> json) => Status(
        vendorAlert: json["vendor_alert"],
      );
}
