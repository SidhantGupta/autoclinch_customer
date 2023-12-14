import 'package:autoclinch_customer/network/api_service.dart';
import 'package:autoclinch_customer/network/model/common_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';

class RatingScreen extends StatefulWidget {
  final String userRequestId;
  const RatingScreen({
    Key? key,
    required this.userRequestId,
  }) : super(key: key);

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  final feedback = TextEditingController();
  String ratingStar = '';
  String ratingReview = '';
  bool isSave = false;
  bool isReview = true;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: Text(
            'Confirmation',
            style: TextStyle(
              // ignore: deprecated_member_use
              color: Theme.of(context).primaryColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!isReview) SizedBox(height: 150),
                buildHeader(),
                SizedBox(height: 30),
                if (isReview) buildFeedBack(context),
              ],
            ),
          ),
        ),
        bottomNavigationBar: buildBottom(context),
      ),
    );
  }

  Widget buildBottom(BuildContext context) {
    return Card(
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          minimumSize: Size.fromHeight(50),
          primary: Theme.of(context).primaryColor,
        ),
        onPressed: () async {
          Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
        },
        label: Text('Go to Home'),
        icon: Icon(Icons.home),
      ),
    );
  }

  Widget buildHeader() {
    return Column(
      children: [
        Stack(
          children: [
            LottieBuilder.asset(
              'assets/icons/confetti.json',
              height: 180,
              width: double.infinity,
            ),
            LottieBuilder.asset(
              'assets/icons/successful.json',
              repeat: false,
            ),
          ],
        ),
        Text(
          'Thank You !',
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      ],
    );
  }

  Widget buildFeedBack(BuildContext context) => Card(
        elevation: 6,
        shadowColor: Theme.of(context).primaryColor.withOpacity(0.4),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Center(
                child: Text(
                  'Rate your feedback',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Center(
                child: RatingBar.builder(
                  initialRating: 0,
                  minRating: 0,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    // color: Color.fromARGB(255, 244, 132, 32),
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    setState(() {
                      ratingStar = rating.toString();
                      isSave = true;
                      ////(ratingStar);
                    });
                  },
                ),
              ),
              SizedBox(height: 15),
              Text(
                'Are you satisfied with the service, \nDo you feel you are over charged \nComment below the reviews and feedback etc.',
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  // label: Text(''),
                ),
                controller: feedback,
                minLines: 3,
                maxLines: 4,
                textInputAction: TextInputAction.done,
                onChanged: (string) {
                  setState(() {
                    ratingReview = string;
                    isSave = true;
                    if (string.isEmpty) isSave = false;
                  });
                },
                // maxLength: 7,
              ),
              SizedBox(height: 5),
              if (isSave)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size.fromHeight(40),
                    primary: Theme.of(context).primaryColor,
                  ),
                  onPressed: () async => addReview(ratingStar, ratingReview),
                  child: Text('Submit'),
                )
            ],
          ),
        ),
      );

  addReview(String rating, String? ratingReview) async {
    final CommonResponse2? response = await ApiService().execute<CommonResponse2>('post-review', params: {
      'rating_star': rating,
      'rating_review': ratingReview ?? '',
      'id': widget.userRequestId,
    });

    if (response?.success == true) {
      feedback.clear();
      setState(() => isReview = false);
      Fluttertoast.showToast(msg: 'Your Review has been added');
    } else {
    Fluttertoast.showToast(msg: 'Error');  
  
    }
  }
}
