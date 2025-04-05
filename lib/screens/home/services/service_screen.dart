import 'package:autoclinch_customer/network/model/service_model.dart';
import 'package:autoclinch_customer/screens/home/services/service_details.dart';
import 'package:flutter/material.dart';
//import 'package:marquee/marquee.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

import '../../../network/api_service.dart';
import '../../../utils/constants.dart';
import '../../../widgets/home/whatsaap_logo.dart';

class ServiceScreen extends StatefulWidget {
  const ServiceScreen({Key? key}) : super(key: key);

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

late VideoPlayerController _controller;
late Future<void> _initializeVideoPlayerFuture;

class _ServiceScreenState extends State<ServiceScreen> {
  late Future<ServiceModel?> _future;

  double? mrp;
  @override
  void initState() {
    getService();
    _controller = VideoPlayerController.asset('assets/images/car.mp4');

    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.play();
    _controller.setLooping(true);
    super.initState();
  }

  getService() async {
    _future = ApiService().execute<ServiceModel>('all-packages', isGet: true);
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('Choose your service'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () async {
                var uri = Uri.parse('tel:+919643105456');
                if (!await launchUrl(uri)) {
                  throw 'Could not launch $uri';
                }
              },
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 50,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                 /*   child: Marquee(
                      text:
                          'For free demo/queries contact customer care at +91 9643105456',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: theme.primaryColor,
                      ),
                      scrollAxis: Axis.horizontal,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      blankSpace: 20.0,
                      velocity: 50.0,
                      pauseAfterRound: Duration(milliseconds: 100),
                      startPadding: 10.0,
                      accelerationCurve: Curves.linear,
                      decelerationDuration: Duration(milliseconds: 500),
                      decelerationCurve: Curves.easeOut,
                    ),z*/
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            // Use a FutureBuilder to display a loading spinner while waiting for the
// VideoPlayerController to finish initializing.
            FutureBuilder(
              future: _initializeVideoPlayerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  // If the VideoPlayerController has finished initialization, use
                  // the data it provides to limit the aspect ratio of the video.
                  return AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    // Use the VideoPlayer widget to display the video.
                    child: VideoPlayer(_controller),
                  );
                } else {
                  // If the VideoPlayerController is still initializing, show a
                  // loading spinner.
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Daily Car & Bike Cleaning',
              style: theme.textTheme.titleLarge,
            ),
            Expanded(
              child: FutureBuilder<ServiceModel?>(
                future: _future,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data?.data?.packageDatas == null ||
                        snapshot.data!.data!.packageDatas!.isEmpty) {
                      return Center(child: Text('No services available'));
                    }
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3),
                      itemCount: snapshot.data!.data!.packageDatas!.length,
                      itemBuilder: (context, index) {
                        final service =
                            snapshot.data!.data!.packageDatas![index];
                        mrp = service.price! * .2 + service.price!.toDouble();
                        String mrps = mrp.toString();
                        var arr = mrps.split('.');

                        //    if (service.days == 90) //print(service.days);
                        return Container(
                          height: 160,
                          width: 150,
                          child: GestureDetector(
                            onTap: () {
                              //remove packageHistory if the vehicle is null
                              if (snapshot.data!.data!.packagePurchasehistory !=
                                  null) {
                                snapshot.data!.data!.packagePurchasehistory
                                    ?.removeWhere(
                                        (element) => element.make == null);
                              }
                              List<PackagePurchasehistory>? packageHistory =
                                  snapshot.data!.data!.packagePurchasehistory;
                              //return only the package history of the selected service
                              if (packageHistory != null) {
                                packageHistory = packageHistory
                                    .where((element) =>
                                        element.packageId == service.id)
                                    .toList();
                              }
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ServiceDetails(
                                    service: service,
                                    purchaseHistory: packageHistory ?? [],
                                  ),
                                ),
                              );
                            },
                            // borderRadius: BorderRadius.circular(10.0),
                            child: Card(
                              elevation: 2,
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: Image.network(
                                        BASE_URL +
                                            'images/package/' +
                                            service.image.toString(),
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Image.asset(
                                            'assets/images/logo/autoclinch_logo.png',
                                            width: 100,
                                            height: 95,
                                          );
                                        },
                                        loadingBuilder:
                                            (context, child, loadingProgress) =>
                                                loadingProgress == null
                                                    ? child
                                                    : Center(
                                                        child:
                                                            CircularProgressIndicator(
                                                          value: loadingProgress
                                                                      .expectedTotalBytes !=
                                                                  null
                                                              ? loadingProgress
                                                                      .cumulativeBytesLoaded /
                                                                  loadingProgress
                                                                      .expectedTotalBytes!
                                                              : null,
                                                        ),
                                                      ),
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.only(top: 1.0),
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            service.title.toString(),
                                            style: TextStyle(fontSize: 12),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 2,
                                        ),
                                        if (service.price != null)
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Text('Rs. ${service.price}',
                                                  style: theme
                                                      .textTheme.titleLarge!
                                                      .copyWith(fontSize: 12)),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              service.days! != 30
                                                  ? Row(
                                                      children: [
                                                        Text(
                                                          arr[0],
                                                          style: theme.textTheme
                                                              .titleLarge!
                                                              .copyWith(
                                                                  decoration:
                                                                      TextDecoration
                                                                          .lineThrough,
                                                                  fontSize: 12),
                                                        ),
                                                        Text('/-')
                                                      ],
                                                    )
                                                  : Text(''),
                                            ],
                                          )
                                      ],
                                    ),
                                  ]),
                            ),
                            //     borderRadius: BorderRadius.circular(10.0),
                            /* child: Container(
                              height: 280,
                              width: 30,
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    blurRadius: 7,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Hero(
                                      tag: service.id ?? '',
                                      child: ClipRRect(
                                        child: Image.network(
                                          BASE_URL +
                                              'images/package/' +
                                              service.image.toString(),
                                          width: 80,
                                          height: 75,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return Image.asset(
                                              'assets/images/logo/autoclinch_logo.png',
                                              width: 40,
                                              height: 45,
                                            );
                                          },
                                          loadingBuilder: (context, child,
                                                  loadingProgress) =>
                                              loadingProgress == null
                                                  ? child
                                                  : Center(
                                                      child:
                                                          CircularProgressIndicator(
                                                        value: loadingProgress
                                                                    .expectedTotalBytes !=
                                                                null
                                                            ? loadingProgress
                                                                    .cumulativeBytesLoaded /
                                                                loadingProgress
                                                                    .expectedTotalBytes!
                                                            : null,
                                                      ),
                                                    ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                  service.title ?? 'N/A',
                                                  style: TextStyle(
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.w700)),
                                            ),
                                            // Visibility(
                                            //   visible: service.isPurchased != null ? service.isPurchased! : false,
                                            //   child: Chip(
                                            //     visualDensity: VisualDensity.compact,
                                            //     label: Text('Purchased'),
                                            //     padding: EdgeInsets.symmetric(horizontal: 2, vertical: 1),
                                            //     backgroundColor: Colors.green.withOpacity(0.1),
                                            //     labelStyle: theme.textTheme.caption!.copyWith(color: Colors.green),
                                            //   ),
                                            // )
                                          ],
                                        ),
                                        /*Text(service.shortDesc ?? 'N/A'),*/
                                        if (service.price != null)
                                          Row(
                                            children: [
                                              Text('Rs. ${service.price}',
                                                  style: theme
                                                      .textTheme.headline6!
                                                      .copyWith(fontSize: 13)),
                                              SizedBox(
                                                width: 2,
                                              ),
                                              service.days! != 30
                                                  ? Row(
                                                      children: [
                                                        Text(
                                                          arr[0]
                                                          // ' ${mrp = service.price! * .2 + service.price!.toDouble()}',
                                                          ,
                                                          style: theme.textTheme
                                                              .headline6!
                                                              .copyWith(
                                                                  fontSize: 12,
                                                                  decoration:
                                                                      TextDecoration
                                                                          .lineThrough),
                                                        ),
                                                        Text('/-')
                                                      ],
                                                    )
                                                  : Text('')
                                            ],
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),*/
                          ),
                        );
                      },
                      /*  separatorBuilder: (context, index) =>*/
                      /*  SizedBox(height: 10),*/
                    );
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
            Row(
              children: [
                Center(
                  child: WhatsAppButton(
                    phoneNumber:
                        '919643105456', // Replace with the phone number
                    message: 'Hello!', // Replace with your message
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: () {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(builder: (context) => CalenderScreen()),
      //     );
      //   },
      //   icon: const Icon(Icons.calendar_month),
      //   label: const Text('Tracking'),
      //   backgroundColor: theme.appBarTheme.backgroundColor,
      // ),
    );
  }
}

class Services {
  Services({required this.name, required this.color, this.description});

  Color color;
  String? description;
  String name;
}
