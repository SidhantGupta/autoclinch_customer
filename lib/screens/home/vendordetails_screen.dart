import 'package:autoclinch_customer/custom/rating_stars.dart';
import 'package:autoclinch_customer/network/api_service.dart';
import 'package:autoclinch_customer/network/model/vendor_details_response.dart';
import 'package:autoclinch_customer/utils/constants.dart';
import 'package:autoclinch_customer/utils/preference_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// import '/screens/home/payment_screen.dart' show PaymentIntentData;
import '/screens/home/countdown_screen.dart' show TimerIntentData;

class VendorDetailsScreen extends StatefulWidget {
  final String vendorId;
  const VendorDetailsScreen(this.vendorId, {Key? key}) : super(key: key);

  @override
  State<VendorDetailsScreen> createState() => _VendorDetailsScreenState();
}

class _VendorDetailsScreenState extends State<VendorDetailsScreen> {
  late Future<VendorDetailsResponse?> _futureVendorDetails;

  @override
  void initState() {
    _futureVendorDetails = ApiService().execute<VendorDetailsResponse>('getvendordetails/${widget.vendorId}',
        // future: ApiService().execute<ProfileResponse>('vendor/businessprofile',
        isGet: true,
        isThrowExc: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // return Profile();
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Vendor Details',
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),

          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          centerTitle: true,
          automaticallyImplyLeading: true,
          // leading: IconButton(onPressed: null , Icon(Icons.arrow_forward_ios_outlined)),
        ),
        body: FutureBuilder<VendorDetailsResponse?>(
          future: _futureVendorDetails,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(child: CircularProgressIndicator());
              default:
                if (snapshot.hasError) {
                  // ////("Data is Has error null");
                  return Center(child: Text('Unable to fetch data'));
                } else if (snapshot.data?.data != null) {
                  // ////("Data is not null");
                  return VendorDetails(snapshot.data!.data!);
                }
                return Text('Result: ${snapshot.data}');
            }
          },
        ));
  }
}

class VendorDetails extends StatelessWidget {
  final Data vendorDetailsData;
  VendorDetails(this.vendorDetailsData, {Key? key}) : super(key: key);
  final List<Services> _selecteServices = List.empty(growable: true);

  void bookService(BuildContext context) async {
    // final input = PaymentIntentData(
    //     vendorId: vendorDetailsData.vendor?.id ?? '',
    //     services: _selecteServices
    //         .map((e) => e.id ?? '')
    //         .where((element) => element.isNotEmpty)
    //         .toList());

    final _serviceList = _selecteServices.map((e) => e.id ?? '').where((element) => element.isNotEmpty).toList();

    if (vendorDetailsData.vendor == null) {
      ////('vendorDetailsData.vendor == null');
      ApiService().showToast('Vendor object is null');
    } else if (_serviceList.isEmpty) {
      ////('Please select services');
      ApiService().showToast('Please select services');
    } else {
      _showBottomSheet(
          'Enter your issue and vehicle details', 'Remarks', context, vendorDetailsData.vendor!, _serviceList);
      //     submit: (remarks) {

      // });
    }
  }

  @override
  Widget build(BuildContext context) {
    _selecteServices.clear();
    _totalNotifier.reset();
    final TextStyle style = TextStyle(fontSize: 14.0);

    // final loginButon = Material(
    //   elevation: 5.0,
    //   borderRadius: BorderRadius.circular(5.0),
    //   color: Theme.of(context).primaryColor,
    //   child: MaterialButton(
    //     minWidth: MediaQuery.of(context).size.width,
    //     padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
    //     onPressed: () async {
    //       final input = PaymentIntentData(
    //           vendorId: vendorDetailsData.vendor?.id ?? '',
    //           services: _selecteServices
    //               // .map((e) => e.id ?? '')
    //               .map((e) => e.serviceName ?? '')
    //               .where((element) => element.isNotEmpty)
    //               .toList());
    //       if (input.vendorId.isEmpty || input.services.isEmpty) {
    //         ApiService().showToast('Please select services');
    //       } else {
    //         Navigator.of(context).pushNamed("/paymentscreen", arguments: input);
    //       }
    //     },
    //     child: Text("Book this Service",
    //         textAlign: TextAlign.center,
    //         style: style.copyWith(
    //             fontSize: 18,
    //             color: Colors.white,
    //             fontWeight: FontWeight.bold)),
    //   ),
    // );

    final pageController = PageController();

    return Scaffold(
        body: Column(
      children: <Widget>[
        Expanded(
          child: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              // height: 200,
              // color: Colors.amberAccent,
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    child: Stack(alignment: Alignment.bottomCenter, children: [
                      Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            height: 170,
                            child: PageView(
                              controller: pageController,
                              children: vendorDetailsData.images != null && vendorDetailsData.images!.isNotEmpty
                                  ? vendorDetailsData.images!
                                      .map((e) => FadeInImage(
                                            width: double.infinity,
                                            height: double.infinity,
                                            fit: BoxFit.cover,
                                            placeholder: AssetImage(placeholder),
                                            image: NetworkImage(e.imageUrl),
                                          ))
                                      .toList()
                                  : List.of({
                                      Image.asset(
                                        placeholder,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: double.infinity,
                                      )
                                    }, growable: false),
                            ),
                          ),
                          const SizedBox(
                            height: 60,
                          ),
                        ],
                      ),
                      Positioned(
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              width: double.infinity,
                              child: Column(
                                children: [
                                  const SizedBox(height: 20),
                                  Container(),
                                  new Row(
                                    children: <Widget>[
                                      new Flexible(
                                        child: Container(
                                          padding: const EdgeInsets.only(left: 10),
                                          width: double.infinity,
                                          height: 20,
                                          child: Text(vendorDetailsData.vendor?.businessName ?? '',
                                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                                          alignment: Alignment.centerLeft,
                                        ),
                                        flex: 4,
                                      ),
                                      new Flexible(
                                        child: Container(
                                          padding: const EdgeInsets.only(right: 10),
                                          width: double.infinity,
                                          height: 20,
                                          child: Text("Starting from"),
                                          alignment: Alignment.centerRight,
                                        ),
                                        flex: 2,
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 15),
                                  new Row(
                                    children: <Widget>[
                                      new Flexible(
                                        child: Container(
                                          padding: const EdgeInsets.only(left: 10),
                                          width: double.infinity,
                                          height: 20,
                                          alignment: Alignment.centerLeft,
                                          child: Row(
                                            children: [
                                              RatingStars(
                                                value: vendorDetailsData.totalReviewDouble,
                                                starColor: Theme.of(context).primaryColor,
                                              ),
                                              Text(
                                                "Reviews (${vendorDetailsData.totalReviewCount})",
                                              )
                                            ],
                                          ),
                                        ),
                                        flex: 4,
                                      ),
                                      new Flexible(
                                        child: Container(
                                          padding: const EdgeInsets.only(right: 10),
                                          width: double.infinity,
                                          // height: 20,
                                          child: Text("Rs." + vendorDetailsData.priceStartFrom.toString(),
                                              style: TextStyle(
                                                  fontSize: 25,
                                                  color: Theme.of(context).primaryColor,
                                                  fontWeight: FontWeight.w500)),
                                          alignment: Alignment.centerRight,
                                        ),
                                        flex: 2,
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ]),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Services",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text("(* approx charge)",
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.normal, color: Colors.red)),
                  const SizedBox(height: 15),
                  SizedBox(
                    width: double.infinity,
                    child: Column(
                        children: vendorDetailsData.services
                                ?.map((e) => FilterChipWidget(
                                      e,
                                      selectListener: _selectService,
                                    ))
                                .toList() ??
                            List.empty()),
                  ),
                  const SizedBox(height: 10),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Minimum Service Charge',
                              style: const TextStyle(fontSize: 16, color: Colors.black),
                            ),
                          ),
                          Text(
                            '₹${vendorDetailsData.basePrice}',
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    margin: const EdgeInsets.only(top: 20),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(20),
                      // height: 200,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text("Description", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                          Divider(),
                          Text(vendorDetailsData.vendor?.description ?? '',
                              style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 15,
                                  color: Color.fromARGB(255, 98, 99, 112))),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    margin: const EdgeInsets.only(top: 20),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      // height: 200,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text("Mechanics", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                          Divider(),
                        ]..addAll(vendorDetailsData.mechanics.map((e) => Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Row(
                                children: [Expanded(child: Text(e.name)), Text(e.contactNo)],
                              ),
                            ))),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (vendorDetailsData.vendor?.paymentOption != null && vendorDetailsData.vendor?.paymentOption != '')
                    Card(
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.payment_outlined, color: Colors.orange),
                                SizedBox(width: 10),
                                Text(vendorDetailsData.vendor?.paymentOption ?? '',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    )),
                                SizedBox(width: 3),
                                Text('Available', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  Card(
                      margin: const EdgeInsets.only(top: 10),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            new Row(
                              children: <Widget>[
                                new Flexible(
                                  child: Container(
                                    // padding: const EdgeInsets.only(left: 10),
                                    width: double.infinity,
                                    // height: 20,
                                    child: Text("Reviews & Ratings",
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                                    alignment: Alignment.centerLeft,
                                  ),
                                  flex: 4,
                                ),
                                new Flexible(
                                  child: Container(
                                    // padding: const EdgeInsets.only(right: 10),
                                    width: double.infinity,
                                    // height: 20,
                                    child: InkWell(
                                        onTap: () async {
                                          Navigator.of(context)
                                              .pushNamed("/allreviewscreen", arguments: vendorDetailsData.vendor!.id);
                                        },
                                        child: Text("View All",
                                            style: TextStyle(
                                                // fontSize: 25,
                                                color: Theme.of(context).primaryColor,
                                                fontWeight: FontWeight.normal))),

                                    alignment: Alignment.centerRight,
                                  ),
                                  flex: 2,
                                )
                              ],
                            ),
                            const SizedBox(height: 10),
                            Divider(),
                            const SizedBox(height: 10),
                            Container(
                              width: double.infinity,
                              alignment: Alignment.center,
                              child: Text(vendorDetailsData.totalReview,
                                  style: TextStyle(fontWeight: FontWeight.normal, fontSize: 24)),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              width: double.infinity,
                              alignment: Alignment.center,
                              child: RatingStars(
                                starSize: 34,
                                value: vendorDetailsData.totalReviewDouble,
                                starColor: Theme.of(context).primaryColor,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              width: double.infinity,
                              alignment: Alignment.center,
                              child: Text("Reviews (${vendorDetailsData.totalReviewCount})",
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 190, 195, 199),
                                      fontWeight: FontWeight.normal,
                                      fontSize: 15)),
                            ),

                            // 11listview
                          ],
                        ),
                      )),
                  const SizedBox(height: 10),
                  vendorDetailsData.reviews!.isNotEmpty
                      ? ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: vendorDetailsData.reviews!.length,
                          itemBuilder: (context, index) => _listItem(context, vendorDetailsData.reviews![index]),
                        )
                      : SizedBox(),
                ],
              ),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          alignment: Alignment.center,
          child: ChangeNotifierProvider<_TotalNotifier>.value(
            value: _totalNotifier,
            child: _BookButton(onPressed: () {
              if (vendorDetailsData.vendor?.alreadyOngoing == true) {
                bookService(context);
              } else {
                ApiService().showToast(
                    "You have already booked a service. Please book this service after the current service completion");
              }
            }),
          ),
        )
      ],
    ));
  }

  _TotalNotifier _totalNotifier = _TotalNotifier();

  void _selectService(Services service, bool isSeleced) {
    _selecteServices.remove(service);
    if (isSeleced) {
      _selecteServices.add(service);
    }
    double _total = _selecteServices
        .map((e) => double.tryParse(e.price ?? '0') ?? 0.0)
        .fold(0, (previousValue, element) => (previousValue) + element);
    ////('total: $_total}');
    if (_total > 0) {
      _total += vendorDetailsData.basePriceDouble;
    }
    _totalNotifier.total = _total;
  }

  Widget _listItem(BuildContext context, Reviews reviews) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Divider(),
        Row(
          children: <Widget>[
            Container(
              height: 80,
              child: Image.asset(
                'assets/images/logo/samplepin.jpeg',
                width: 70,
                height: 70,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(width: 5),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(reviews.customer_name ?? 'Verified Customer',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  Text(reviews.review_title!,
                      style: TextStyle(
                        color: Color.fromARGB(255, 190, 195, 199),
                        fontWeight: FontWeight.normal,
                        fontSize: 15,
                      ))
                ],
              ),
            ),
            const SizedBox(width: 5),
            if (reviews.star != null)
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                // margin: const EdgeInsets.fromLTRB(16, 10, 16, 10),

                color: Color.fromARGB(255, 249, 227, 206),

                child: Container(
                  // alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(left: 7.0, right: 7.0, bottom: 5.0, top: 5.0),

                  // color: Colors.amberAccent,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        reviews.star!,
                        style: TextStyle(
                            fontWeight: FontWeight.normal, fontSize: 14.0, color: Color.fromARGB(255, 246, 130, 30)
                            // double
                            ),
                      ),
                      Icon(Icons.star_outlined, size: 17, color: Color.fromARGB(255, 246, 130, 30)),
                    ],
                  ),
                ),
              )
          ],
        ),
        const SizedBox(height: 10),
        Container(
            child: Text(reviews.description!,
                style:
                    TextStyle(color: Color.fromARGB(255, 190, 195, 199), fontWeight: FontWeight.normal, fontSize: 15))),
      ],
    );
  }

  void _sendtonextpage(
    BuildContext context,
    String? vehiclename,
    String? issuetext,
    Vendor vendor,
    List<String> serviceList,
    String serviceType,
  ) {
    ////("Vehicle Name : " + vehiclename!);
    ////("Issue Text : " + issuetext!);

    final input = TimerIntentData(
      vendor: vendor,
      services: serviceList,
      remarks: issuetext,
      vehicle_det: vehiclename,
      serviceType: serviceType,
    );
    // Navigator.of(context).pushNamed("/paymentscreen", arguments: input);
    Navigator.of(context).pushNamed("/countdown", arguments: input);
  }

  // {void Function(String)? submit}

  void _showBottomSheet(
      String? title, String? subtitle, BuildContext context, Vendor vendor, List<String> serviceList) {
    final TextEditingController _textController = TextEditingController();
    final TextEditingController _textController1 = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          color: Color(0xff757575),
          child: Container(
            padding: EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
            ),
            child: Column(
              children: [
                Center(child: Text("Enter your Issue")),
                const SizedBox(
                  height: 15,
                ),
                // TextFormField(
                //   decoration: InputDecoration(
                //     border: OutlineInputBorder(),
                //     labelText: "Vehicle details",
                //     hintText: "Enter your vehicle details",
                //     alignLabelWithHint: true,
                //   ),
                //   minLines: 1,
                //   maxLines: 2,
                //   textInputAction: null,
                //   keyboardType: TextInputType.multiline,
                //   controller: _textController1,
                // ),
                // const SizedBox(
                //   height: 8,
                // ),
                TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Enter your Issue",
                    hintText: "Enter your Issue",
                    alignLabelWithHint: true,
                  ),
                  minLines: 5,
                  maxLines: 5,
                  textInputAction: null,
                  keyboardType: TextInputType.multiline,
                  controller: _textController,
                ),
                const SizedBox(
                  height: 25,
                ),
                ElevatedButton(
                  child: Text(
                    'Confirm',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(primary: Colors.blue),
                  onPressed: () async {
                    String vehiclename = await SharedPreferenceUtil().getVehicleName();
                    String serviceType = await SharedPreferenceUtil().getServiceType();

                    _sendtonextpage(context, vehiclename, _textController.text, vendor, serviceList, serviceType);

                    // if (submit != null) {
                    //   submit(_textController.text);
                    // }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TotalNotifier extends ChangeNotifier {
  double _total = 0.0;

  double get total => _total;
  set total(newTotal) {
    _total = newTotal;
    notifyListeners();
  }

  void reset({double newTotal = 0.0}) {
    _total = newTotal;
  }
}

class _BookButton extends StatelessWidget {
  final VoidCallback? onPressed;
  const _BookButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _provider = context.watch<_TotalNotifier>();
    return SizedBox(
      width: double.infinity,
      height: 45,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text("Book this Service ₹${_provider.total}",
            // child: Text("Book this Service ₹50",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
        style: ElevatedButton.styleFrom(
            primary: Theme.of(context).primaryColor,
            shadowColor: Theme.of(context).primaryColor,
            elevation: 7,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
      ),
    );
  }
}

class FilterChipWidget extends StatefulWidget {
  final Services _services;
  final Function(Services, bool) selectListener;

  FilterChipWidget(this._services, {Key? key, required this.selectListener}) : super(key: key);

  @override
  _FilterChipWidgetState createState() => _FilterChipWidgetState();
}

class _FilterChipWidgetState extends State<FilterChipWidget> {
  var _isSelected = false;
  final labelStyle = TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          setState(() {
            _isSelected = !_isSelected;
            widget.selectListener(widget._services, _isSelected);
          });
        },
        child: Card(
          child: Container(
            margin: EdgeInsets.fromLTRB(10, 10, 15, 10),
            child: Row(
              children: [
                SizedBox(
                  child: _isSelected
                      ? Icon(Icons.radio_button_checked, color: Color.fromARGB(255, 246, 130, 30))
                      : Icon(Icons.radio_button_unchecked),
                  // ? Icon(Icons.check_circle_outline_outlined)
                  // : SizedBox(),
                  width: 30,
                  height: 30,
                ),
                const SizedBox(width: 10),
                Expanded(
                    child: Text(
                  widget._services.serviceName ?? '',
                  style: labelStyle,
                )),
                const SizedBox(width: 10),
                Text(
                  '₹${widget._services.price}',
                  style: labelStyle,
                )
              ],
            ),
          ),
        ));
    // return FilterChip(
    //   label: Text(widget._services.nameWithPrice),
    //   labelStyle: TextStyle(
    //       color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15),
    //   selected: _isSelected,
    //   onSelected: (isSelected) {
    //     setState(() {
    //       _isSelected = isSelected;
    //       widget.selectListener(widget._services, isSelected);
    //     });
    //   },
    //   selectedColor: Theme.of(context).primaryColor,
    // );
  }
}
