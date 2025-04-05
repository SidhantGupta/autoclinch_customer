import 'package:carousel_slider/carousel_slider.dart';// Import for CarouselController
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ImageCorousel extends StatelessWidget {
  const ImageCorousel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CarouselOptions _controller = CarouselOptions();

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('images').snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            height: 250,
            child: Center(
              child: CircularProgressIndicator(
                color: Colors.amber,
              ),
            ),
          );
        } else {
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          } else {
            if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
              return CarouselSlider.builder(
                itemCount: snapshot.data!.docs.length,
                options: CarouselOptions(
                  autoPlay: true,
                  aspectRatio: 16 / 9,
                  autoPlayAnimationDuration: Duration(milliseconds: 8225),
                  disableCenter: false,
                  viewportFraction: 1.0,
                ),
                itemBuilder: (context, index, realIdx) {
                  var document = snapshot.data!.docs[index];
                  var imageURL = document['image'];

                  return GestureDetector(
                    onTap: () {
                      print(document['web_url']);
                      if (document['web_url'] != null) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Scaffold(
                                      body: Center(child: Text('WebView Placeholder')),
                                    )));
                      }
                    },
                    child: Image.network(
                      imageURL,
                    ),
                  );
                },
          //   carouselController: _controller,
              );
            } else {
              return Text('No images available');
            }
          }
        }
      },
    );
  }
}
