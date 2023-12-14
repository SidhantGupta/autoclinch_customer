import 'package:autoclinch_customer/custom/rating_stars.dart';
import 'package:autoclinch_customer/network/api_service.dart';
import 'package:autoclinch_customer/network/model/allreviews_response.dart';
import 'package:flutter/material.dart';

class AllReviewsScreen extends StatelessWidget {
  final id;

  AllReviewsScreen({Key? key, @required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return Profile();
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'All Reviews',
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),

          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          centerTitle: true,
          automaticallyImplyLeading: true,
          // leading: IconButton(onPressed: null , Icon(Icons.arrow_forward_ios_outlined)),
        ),
        body: ReviewList(id));
  }
}

class ReviewList extends StatefulWidget {
  // List<Data> vehicleList = List.empty();
  // VendorDetailsData vendorDetailsData;
  String? id;
  ReviewList(this.id, {Key? key}) : super(key: key);

  @override
  _VendorDetailsScreenState createState() => _VendorDetailsScreenState(id);
}

class _VendorDetailsScreenState extends State<ReviewList> {
  final TextStyle style = TextStyle(fontSize: 14.0);
  String? _id;

  final TextStyle _labelStyle = TextStyle(fontSize: 14.0, color: Color(0xFF2A2935));

  _VendorDetailsScreenState(this._id);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AllReviewResponse?>(
      future: ApiService().execute<AllReviewResponse>('getallreviews/' + _id!,
          // params: {'customer_id': '1'},
          // future: ApiService().execute<ProfileResponse>('vendor/businessprofile',
          isGet: true,
          isThrowExc: true),
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

              // VehicleList();
              return AllReviewsListWidget(snapshot.data!.data!);
            }
            return Text('Result: ${snapshot.data}');
        }
      },
    );
  }

  Widget AllReviewsListWidget(Data? data) {
    // ////("ListLength : ");

    List<Reviews>? vehicleList = data!.reviews;

    // //(vehicleList!.length);

    return Card(
        child: Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            alignment: Alignment.center,
            child: Text(data.reviewCount ?? '0', style: TextStyle(fontWeight: FontWeight.normal, fontSize: 24)),
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            alignment: Alignment.center,
            child: RatingStars(
              starSize: 34,
              value: double.tryParse(data.totalReviewStar ?? '5') ?? 5,
              starColor: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            alignment: Alignment.center,
            child: Text("Reviews (${data.reviewCount ?? 0})",
                style: TextStyle(color: Color.fromARGB(255, 190, 195, 199), fontWeight: FontWeight.normal, fontSize: 15)),
          ),

          //11listview
          ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: vehicleList!.length,
              itemBuilder: (context, index) {
                final reviews = vehicleList[index];
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
                              Text(reviews.customerName ?? 'Verified Customer',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                              Text(reviews.reviewTitle ?? '',
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 190, 195, 199), fontWeight: FontWeight.normal, fontSize: 15))
                            ],
                          ),
                        ),
                        const SizedBox(width: 5),
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
                    Text(reviews.description ?? '',
                        style: TextStyle(color: Color.fromARGB(255, 190, 195, 199), fontWeight: FontWeight.normal, fontSize: 15)),
                  ],
                );

                // return Column(
                //   children: [
                //     const SizedBox(height: 10),
                //     Divider(),
                //     new Row(
                //       children: <Widget>[
                //         new Flexible(
                //           child: Container(
                //             height: 80,
                //             child: Image.asset(
                //               'assets/images/logo/samplepin.jpeg',
                //               width: 70,
                //               height: 70,
                //               fit: BoxFit.contain,
                //             ),
                //           ),
                //           flex: 1,
                //         ),
                //         new Flexible(
                //           child: Column(
                //             crossAxisAlignment: CrossAxisAlignment.center,
                //             mainAxisAlignment: MainAxisAlignment.center,
                //             children: [
                //               Container(
                //                 // padding: const EdgeInsets.only(left: 10),
                //                 width: double.infinity,

                //                 // height: 20,
                //                 child: Text(
                //                     vehicleList[index].customerName ??
                //                         'Verified Customer',
                //                     style: TextStyle(
                //                         fontWeight: FontWeight.bold,
                //                         fontSize: 15)),
                //                 alignment: Alignment.center,
                //               ),
                //               Container(
                //                 // padding: const EdgeInsets.only(left: 10),
                //                 width: double.infinity,
                //                 // height: 20,
                //                 child: Text(vehicleList[index].reviewTitle!,
                //                     style: TextStyle(
                //                         color:
                //                             Color.fromARGB(255, 190, 195, 199),
                //                         fontWeight: FontWeight.normal,
                //                         fontSize: 15)),
                //                 alignment: Alignment.center,
                //               )
                //             ],
                //           ),
                //           flex: 3,
                //         ),
                //         new Flexible(
                //           flex: 1,
                //           child: Card(
                //             shape: RoundedRectangleBorder(
                //               borderRadius: BorderRadius.circular(15.0),
                //             ),
                //             // margin: const EdgeInsets.fromLTRB(16, 10, 16, 10),

                //             color: Color.fromARGB(255, 249, 227, 206),

                //             child: Container(
                //               // alignment: Alignment.centerLeft,

                //               padding: const EdgeInsets.only(
                //                   left: 2.0, right: 2.0, bottom: 5.0, top: 5.0),

                //               // color: Colors.amberAccent,
                //               child: Row(
                //                 mainAxisAlignment: MainAxisAlignment.center,
                //                 crossAxisAlignment: CrossAxisAlignment.center,
                //                 children: [
                //                   Text(
                //                     vehicleList[index].star!,
                //                     style: TextStyle(
                //                         fontWeight: FontWeight.normal,
                //                         fontSize: 14.0,
                //                         color: Color.fromARGB(255, 246, 130, 30)

                //                         // double
                //                         ),
                //                   ),
                //                   Icon(Icons.star_outlined,
                //                       size: 17,
                //                       color: Color.fromARGB(255, 246, 130, 30)),
                //                 ],
                //               ),
                //             ),
                //           ),
                //         )
                //       ],
                //     ),
                //     const SizedBox(height: 10),
                //     Container(
                //         child: Text(vehicleList[index].description!,
                //             style: TextStyle(
                //                 color: Color.fromARGB(255, 190, 195, 199),
                //                 fontWeight: FontWeight.normal,
                //                 fontSize: 15))),
                //   ],
                // );
              }),
        ],
      ),
    ));
  }

  // Widget _listItem(BuildContext context, int index) {
  //   return Column(
  //     children: [
  //       const SizedBox(height: 10),
  //       Divider(),
  //       new Row(
  //         children: <Widget>[
  //           new Flexible(
  //             child: Container(
  //               height: 80,
  //               child: Image.asset(
  //                 'assets/images/logo/samplepin.jpeg',
  //                 width: 70,
  //                 height: 70,
  //                 fit: BoxFit.contain,
  //               ),
  //             ),
  //             flex: 1,
  //           ),
  //           new Flexible(
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.center,
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 Container(
  //                   // padding: const EdgeInsets.only(left: 10),
  //                   width: double.infinity,

  //                   // height: 20,
  //                   child: Text("Trevino Hammaondd",
  //                       style: TextStyle(
  //                           fontWeight: FontWeight.bold, fontSize: 15)),
  //                   alignment: Alignment.center,
  //                 ),
  //                 Container(
  //                   // padding: const EdgeInsets.only(left: 10),
  //                   width: double.infinity,
  //                   // height: 20,
  //                   child: Text("widget.",
  //                       style: TextStyle(
  //                           color: Color.fromARGB(255, 190, 195, 199),
  //                           fontWeight: FontWeight.normal,
  //                           fontSize: 15)),
  //                   alignment: Alignment.center,
  //                 )
  //               ],
  //             ),
  //             flex: 3,
  //           ),
  //           new Flexible(
  //             flex: 1,
  //             child: Card(
  //               shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(15.0),
  //               ),
  //               // margin: const EdgeInsets.fromLTRB(16, 10, 16, 10),

  //               color: Color.fromARGB(255, 249, 227, 206),

  //               child: Container(
  //                 // alignment: Alignment.centerLeft,

  //                 padding: const EdgeInsets.only(
  //                     left: 2.0, right: 2.0, bottom: 5.0, top: 5.0),

  //                 // color: Colors.amberAccent,
  //                 child: Row(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   crossAxisAlignment: CrossAxisAlignment.center,
  //                   children: [
  //                     Text(
  //                       '3.53',
  //                       style: TextStyle(
  //                           fontWeight: FontWeight.normal,
  //                           fontSize: 14.0,
  //                           color: Color.fromARGB(255, 246, 130, 30)

  //                           // double
  //                           ),
  //                     ),
  //                     Icon(Icons.star_outlined,
  //                         size: 17, color: Color.fromARGB(255, 246, 130, 30)),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           )
  //         ],
  //       ),
  //       const SizedBox(height: 10),
  //       Container(
  //           child: Text(
  //               " but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software",
  //               style: TextStyle(
  //                   color: Color.fromARGB(255, 190, 195, 199),
  //                   fontWeight: FontWeight.normal,
  //                   fontSize: 15))),
  //     ],
  //   );
  // }
}
