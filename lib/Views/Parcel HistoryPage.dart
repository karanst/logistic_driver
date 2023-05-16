import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:jdx/Models/Acceptorder.dart';
import 'package:jdx/Models/accepted_order_response.dart';
import 'package:jdx/Models/parcel_history_response.dart';
import 'package:jdx/Utils/ApiPath.dart';
import 'package:jdx/Views/parcel_details.dart';
import 'package:jdx/Views/share_qr/share_qr.dart';
import 'package:jdx/services/location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;


import '../Models/Acceptorder.dart';
import '../services/api_services/api.dart';
import '../services/api_services/request_key.dart';

class ParcelHistory extends StatefulWidget {
  const ParcelHistory({Key? key}) : super(key: key);

  @override
  State<ParcelHistory> createState() => _ParcelHistoryState();
}

class _ParcelHistoryState extends State<ParcelHistory> {
  Api api = Api();


  //List<AccepetedOrderList> parcelDataList = [];
  Acceptorder? parcelDataList;
  bool isLoading = false;


  @override
  void initState() {
    // TODO: implement initState
    getAcceptedOrder();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        /*leading: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Container(
              height: 23,
              width: 23,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(30)),
              child: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              )),
        ),*/
        backgroundColor: const Color(0xFF222443),
        title: const Text('Accepted Parcel History'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height,
              width: double.maxFinite,
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : parcelDataList?.data?.isEmpty ?? false
                      ? const Center(child: Text('Data Not Available'))
                      : ListView.builder(
                          scrollDirection: Axis.vertical,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: false,
                          itemCount: parcelDataList?.data?.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {},
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                elevation: 2,
                                color: Colors.white,
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width / 1.1,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Padding(
                                                  padding: EdgeInsets.only(
                                                      right: 8.0),
                                                  child: Text("Order Id",
                                                      style: TextStyle(
                                                          fontSize: 13,
                                                          color: Color(
                                                              0xFFBF2331))),
                                                ),
                                                Text(parcelDataList?.data?[index]
                                                        .orderId ??
                                                    '-'),
                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Padding(
                                                  padding: EdgeInsets.only(
                                                      right: 8.0),
                                                  child: Text(
                                                      "Phone            ",
                                                      style: TextStyle(
                                                          fontSize: 13,
                                                          color: Color(
                                                              0xFFBF2331))),
                                                ),
                                                Text(parcelDataList?.data?[index].phoneNo ??
                                                    '-'),
                                              ],
                                            )
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Padding(
                                                  padding: EdgeInsets.only(
                                                      right: 8.0),
                                                  child: Text("Sender Name",
                                                      style: TextStyle(
                                                          fontSize: 13,
                                                          color: Color(
                                                              0xFFBF2331))),
                                                ),
                                                Text(parcelDataList?.data?[index]
                                                        .senderName ??
                                                    '-'),
                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Padding(
                                                  padding: EdgeInsets.only(
                                                      right: 8.0),
                                                  child: Text("Receiver Name",
                                                      style: TextStyle(
                                                          fontSize: 13,
                                                          color: Color(
                                                              0xFFBF2331))),
                                                ),
                                                Text(parcelDataList?.data?[index].senderName ??
                                                    '-'),
                                              ],
                                            )
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  "Sender Address",
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      color: Color(0xFFBF2331)),
                                                ),
                                                SizedBox(
                                                  width: 100,
                                                  child: Text(
                                                      parcelDataList?.data?[index]
                                                              .senderAddress ??
                                                          '-',
                                                      overflow:
                                                          TextOverflow.clip),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  "Receiver Address",
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      color: Color(0xFFBF2331)),
                                                ),
                                                SizedBox(
                                                  width: 100,
                                                  child: Text(
                                                      parcelDataList?.data?[index]
                                                              .senderAddress ??
                                                          '-',
                                                      overflow:
                                                          TextOverflow.fade,
                                                      maxLines: 3),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  "Date",
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      color: Color(0xFFBF2331)),
                                                ),
                                                Text(parcelDataList?.data?[index]
                                                        .onDate
                                                        .toString()
                                                        .substring(0, 10) ??
                                                    '-'),
                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const SizedBox(
                                                  width: 100,
                                                  child: Text(
                                                    "Amount",
                                                    style: TextStyle(
                                                        fontSize: 13,
                                                        color:
                                                            Color(0xFFBF2331)),
                                                  ),
                                                ),
                                                Text(parcelDataList?.data?[index]
                                                        .orderAmount ??
                                                    '-'),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        InkWell(
                                          onTap: (){
                                            Navigator.push(context, MaterialPageRoute(builder: (context) =>  ParcelDetailsView(parcelFullDetail: parcelDataList!.data![index].parcelDetails))).then((value) => getAcceptedOrder());
                                          },
                                          child: const Align(
                                            alignment: Alignment.bottomCenter,
                                              child: Text('See full details', style: TextStyle(decoration: TextDecoration.underline, color: Colors.red),)),
                                        )

                                        /* Row(
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  "Payment Method",
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      color: Color(0xFFBF2331)),
                                                ),
                                                Text(parcelDataList[index]
                                                    .paymentMethod
                                                    .toString()),
                                              ],
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),*/
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
            ),
          ],
        ),
      ),
    );
  }



  /*void getAcceptedOrder() async {
    isLoading = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');

    try {
      Map<String, String> body = {};
      body[RequestKeys.userId] = userId ?? '';
      var res = await api.getAcceptedOrderData(body);
      if (res.status == 1) {
        print('_____success____');
        // responseData = res.data?.userid.toString();
        parcelDataList = res.data ?? [];
        setState(() {});
      } else {
        Fluttertoast.showToast(msg: '');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Something went wrong");
    } finally {
      isLoading = false;
    }
  }*/
  getAcceptedOrder() async {
    isLoading = true;
    setState(() {

    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString("userId");
    print(" this is  User++++++++++++++>${userId}");
    var headers = {
    'Content-Type': 'application/json',
      'Cookie': 'ci_session=2c1b56459e9faa5d8a7a5d04455cd0c8f6cee0f0'
    };
    var request = http.Request(
        'POST', Uri.parse('${Urls.baseUrl}payment/get_order_request'));
    request.body = json.encode({'user_id': userId.toString()});
    print(" this is  User++++++++++++++>${request.body}");
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      final result = await response.stream.bytesToString();
      var finalResult = Acceptorder.fromJson(jsonDecode(result));
      isLoading = false;
      print("thisi is ============>${finalResult}");
      setState(() {
        parcelDataList = finalResult;


      });
    } else {
      isLoading = false;
      print(response.reasonPhrase);
    }
  }


}
