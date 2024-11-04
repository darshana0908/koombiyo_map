import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as https;
import 'package:flutter/material.dart';
import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';
import 'package:quickalert/quickalert.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isLoading = false;
  String id = '';
  String long = '';
  String lat = '';

  @override
  void initState() {
    super.initState();

    // Get the 'id' parameter from the URL
    id = Uri.base.queryParameters['id'].toString();
    print('ID from URL: $id');
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
        body: Stack(
      children: [
        OpenStreetMapSearchAndPick(
          // baseUri: AutofillHints.addressCity,
          buttonTextStyle: const TextStyle(
            fontSize: 18,
            fontStyle: FontStyle.normal,
          ),

          buttonColor: Color.fromARGB(255, 28, 153, 178),
          buttonWidth: w / 2,
          buttonText: 'Update My Location',

          onPicked: (pickedData) async {
            setState(() {
              lat = pickedData.latLong.latitude.toString();
              long = pickedData.latLong.longitude.toString();
              isLoading = false;
            });
            QuickAlert.show(
                context: context,
                type: QuickAlertType.confirm,
                text: 'Do you want confirm location',
                confirmBtnText: 'Yes',
                cancelBtnText: 'No',
                confirmBtnColor: Colors.green,
                onConfirmBtnTap: () async {
                  Navigator.pop(context);
                  await data();
                });
          },
        ),
        isLoading ? Center(child: CircularProgressIndicator()) : SizedBox()
      ],
    ));
  }
// completed
  data() async {
    setState(() {
      isLoading = true;
    });
    final apiUrl =
        'https://koombiyo.lk/koombiyo.lk/pasindu_api/api.koombiyodelivery.lk/staffapi/v3/delivery/Customerlocation/users';
    // Headers

    // Make POST request
    var res = await https.post(Uri.parse(apiUrl),
        body: {"lati": lat, "longt": long, "oid": id == 'null' ? "" : id});
    print(res.body);
    Map<String, dynamic> response = jsonDecode(res.body);
    log(response.toString());

    QuickAlert.show(
      context: context,
      type: QuickAlertType.info,
      text: response['message'],
    );

    print(res.statusCode);
    print(res.body);
    setState(() {
      isLoading = false;
    });
  }
}
