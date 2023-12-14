import 'package:autoclinch_customer/custom/custom_tabview.dart';
import 'package:autoclinch_customer/network/api_service.dart';
import 'package:autoclinch_customer/network/model/help_faq_response.dart';
import 'package:flutter/material.dart';

class HelpAndFaqScreen extends StatelessWidget {
  const HelpAndFaqScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text('Help & Faq'),
          centerTitle: true,
        ),
        body: FutureBuilder<HelpFaqResponse?>(
          future: ApiService().execute<HelpFaqResponse>('get-faq', isGet: true, isThrowExc: true),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(child: CircularProgressIndicator());
              default:
                if (snapshot.hasError) {
                  // ////("Data is Has error null");
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.data?.faqs != null) {
                  // ////("Data is not null");
                  // return VendorDetails(snapshot.data!.data!);
                  return _getView(context, snapshot.data!.faqs!);
                }
                return Text('Result: ${snapshot.data}');
            }
          },
        ));
  }

  Widget _getView(BuildContext context, List<HelpFaq> faqs) => CustomTabView(
        itemCount: faqs.length,
        tabBuilder: (context, index) => Tab(text: faqs[index].title),
        pageBuilder: (context, index) => SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 25, 20, 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '  Help & Support',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  '  Most frequently asked questions',
                  style: TextStyle(color: Colors.blueGrey),
                ),
                const SizedBox(height: 10),
                _listview(faqs[index].faqs ?? List.empty())
              ],
            ),
          ),
        ),
        onPositionChange: (index) {
          ////('current position: $index');
          // initPosition = index;
        },
        // onScroll: (position) => ////('$position'),
      );

  Widget _listview(List<Faq> faqs) => ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) => Card(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(faqs[index].question, style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal, fontSize: 14)),
                // const SizedBox(height: 4),
                const Divider(height: 20, thickness: 1),
                // const SizedBox(height: 4),
                Text(
                  faqs[index].answer,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        itemCount: faqs.length,
      );
}
