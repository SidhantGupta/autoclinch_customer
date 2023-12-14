import 'package:autoclinch_customer/network/model/service_model.dart';
import 'package:autoclinch_customer/screens/home/services/service_details.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../network/api_service.dart';
import '../../../utils/constants.dart';
import 'calender_screen.dart';

class ServiceScreen extends StatefulWidget {
  const ServiceScreen({Key? key}) : super(key: key);

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  late Future<ServiceModel?> _future;

  @override
  void initState() {
    getService();

    super.initState();
  }

  getService() async {
    _future = ApiService().execute<ServiceModel>('all-packages', isGet: true);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose your service'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
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
                    child: Marquee(
                      text: 'For free demo/queries contact customer care at +91 9643105456',
                      style: theme.textTheme.headline6?.copyWith(
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
                    ),
                  ),
                ),
              ),
            ),
            // GestureDetector(
            //   child: Text('9643105456', style: theme.textTheme.headline6),
            //
            // ),
            SizedBox(height: 10),
            Expanded(
              child: FutureBuilder<ServiceModel?>(
                future: _future,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data?.data?.packageDatas == null || snapshot.data!.data!.packageDatas!.isEmpty) {
                      return Center(child: Text('No services available'));
                    }
                    return ListView.separated(
                      itemCount: snapshot.data!.data!.packageDatas!.length,
                      itemBuilder: (context, index) {
                        final service = snapshot.data!.data!.packageDatas![index];

                        return InkWell(
                          onTap: () {
                            //remove packageHistory if the vehicle is null
                            if (snapshot.data!.data!.packagePurchasehistory != null) {
                              snapshot.data!.data!.packagePurchasehistory
                                  ?.removeWhere((element) => element.make == null);
                            }
                            List<PackagePurchasehistory>? packageHistory = snapshot.data!.data!.packagePurchasehistory;
                            //return only the package history of the selected service
                            if (packageHistory != null) {
                              packageHistory =
                                  packageHistory.where((element) => element.packageId == service.id).toList();
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
                          borderRadius: BorderRadius.circular(10.0),
                          child: Ink(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  blurRadius: 7,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Hero(
                                    tag: service.id ?? '',
                                    child:
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10.0),
                                      child:
                                      Image.network(
                                        BASE_URL + 'images/package/' + service.image.toString(),
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Image.asset(
                                            'assets/images/logo/autoclinch_logo.png',
                                            width: 100,
                                            height: 100,
                                          );
                                        },
                                        loadingBuilder: (context, child, loadingProgress) => loadingProgress == null
                                            ? child
                                            : Center(
                                                child: CircularProgressIndicator(
                                                  value: loadingProgress.expectedTotalBytes != null
                                                      ? loadingProgress.cumulativeBytesLoaded /
                                                          loadingProgress.expectedTotalBytes!
                                                      : null,
                                                ),
                                              ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(service.title ?? 'N/A', style: theme.textTheme.headline6),
                                          ),
                                          SizedBox(width: 10),
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
                                      SizedBox(height: 5),
                                      Text(service.shortDesc ?? 'N/A'),
                                      SizedBox(height: 8),
                                      if (service.price != null)
                                        Text('Rs. ${service.price} / month', style: theme.textTheme.headline6),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => SizedBox(height: 10),
                    );
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
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
