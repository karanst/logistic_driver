import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:jdx/Controller/home_controller.dart';
import 'package:jdx/Models/get_driver_rating_response.dart';
import 'package:jdx/Models/order_accept_response.dart';
import 'package:jdx/Models/order_history_response.dart';
import 'package:jdx/Views/order_details.dart';
import 'package:jdx/Views/parcel_details.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Models/Acceptorder.dart';
import '../Models/parcel_history_response.dart';
import '../Utils/ApiPath.dart';
import '../Utils/CustomColor.dart';
import '../services/api_services/api.dart';
import '../services/api_services/request_key.dart';
import '../services/location/location.dart';
import 'package:http/http.dart' as http;


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Api api = Api();
  bool isSwitched = true;
  List<OrderHistoryData> orderHistoryList = [];
  Position? _position;

  bool isLoading =false ;
  String? name ;
  GetDriverRating ? _driverRating ;


  ///active order

  //List<AccepetedOrderList> parcelDataList = [];
  Acceptorder? parcelDataList;
  bool isLoading2 = false;
  List<ParcelHistoryDataList> pastParcelDataList = [];
  bool isLoading3 = false;

  @override
  void initState() {
    // TODO: implement initState
    getUserOrderHistory();
    inIt();
    super.initState();
  }


  inIt() async {

    SharedPreferences prefs1 = await SharedPreferences.getInstance();
    String? userId = prefs1.getString('userId');
    name =  prefs1.getString('userName');
    print("UserName+++++++++++++++++>${name}");

    _position = await getUserCurrentPosition();
    print("${_position!.longitude}______________");
    getDriverRating(userId ?? '300');
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: HomeController(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            leading: Image.asset('assets/images/jdx_logo.png',
                color: Colors.transparent),
            backgroundColor: Colors.cyan.withOpacity(0.10),
            elevation: 0,
            actions: [
              Row(
                children: [
                  Row(
                    children: [
                      isSwitched
                          ? const Text(
                              "Online",
                              style: TextStyle(color: Colors.green),
                            )
                          : const Text(
                              "Offline",
                              style: TextStyle(color: Colors.pink),
                            ),
                      const SizedBox(
                        width: 10,
                      ),
                      Switch.adaptive(
                          activeColor: Colors.green,
                          value: isSwitched,
                          onChanged: (val) {
                            setState(() {
                              isSwitched = val;
                              getUserStatusOnlineOrOffline();
                            });
                          }),
                    ],
                  ),
                ],
              ),
              // Container(
              //   height: 10,
              //   width: 80,
              //   child: CupertinoSwitch(
              //     value: _switchValue,
              //     onChanged: (value) {
              //       setState(() {
              //         _switchValue = value;
              //       });
              //     },
              //   ),
              // ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10,),
                _driverRating?.rating == null ? const SizedBox():Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                  Text(
                    'Hi, ${name.toString().capitalizeFirst}',
                    style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.w400,
                        fontSize:30),
                  ),
                    Row(
                    children: [
                       RatingBar.builder(
                      itemSize: 18,
                      ignoreGestures: true,
                      initialRating: double.parse(_driverRating?.rating ?? ''),
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemPadding: EdgeInsets.zero,
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.red,
                      ),
                      onRatingUpdate: (rating) {
                        print(rating);
                      },
                    ),
                    const SizedBox(width: 10,),
                     Text.rich(TextSpan(children: [
                      TextSpan(text: '${_driverRating?.rating}', style: const TextStyle(color: Colors.red)),
                      const TextSpan(text: '/5.0', style: TextStyle(color: Colors.grey)),

                    ]))
                  ],),

                ],),
                const SizedBox(height: 20,),
                const Text(
                  'Current Leads',
                  style: TextStyle(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.w400,
                      fontSize: 17),
                ),
                _segmentButton(),
                selectedSegmentVal == 0 ? SizedBox (

                  width: double.maxFinite,
                  child:isLoading ? Center(child: CircularProgressIndicator(),)  :orderHistoryList.isEmpty
                      ? const Center(child: Text('Data not available'))
                      : ListView.builder(
                      scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: orderHistoryList.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: orderHistoryList[index].isAccepted ?? false ? (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => OrderDetailView(orderDetail: orderHistoryList[index]),));
                              } : null,
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                elevation: 2,
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Padding(
                                                padding: EdgeInsets.only(
                                                    right: 8.0),
                                                child: Text("Recipient Name",
                                                    style: TextStyle(
                                                        fontSize: 13,
                                                        color: Color(
                                                            0xFFBF2331))),
                                              ),
                                              Text(orderHistoryList[index]
                                                  .senderName ?? ''),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                "Mobile No",
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    color: Color(0xFFBF2331)),
                                              ),
                                              Text(orderHistoryList[index]
                                                  .phoneNo ?? ''),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                "Material category ",
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    color: Color(0xFFBF2331)),
                                              ),
                                              SizedBox(

                                                width: 100,
                                                child: Text(orderHistoryList[index]
                                                    .senderAddress ?? '', maxLines: 3, overflow: TextOverflow.clip,),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,

                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                "Recipient Address",
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    color: Color(0xFFBF2331)),
                                              ),
                                              SizedBox(
                                                width: 100,
                                                child: Text(orderHistoryList[index]
                                                    .senderAddress?? '', maxLines: 3, overflow: TextOverflow.clip,),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 25),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  "order Amount",
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      color:
                                                          Color(0xFFBF2331)),
                                                ),
                                                Text(orderHistoryList[index]
                                                    .orderAmount?? ''),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,

                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                "Recipient Flat Number",
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    color: Color(0xFFBF2331)),
                                              ),
                                              Text(orderHistoryList[index]
                                                  .saleIds
                                                  .toString()),
                                            ],
                                          ),

                                          Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                "Date                        ",
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    color: Color(0xFFBF2331)),
                                              ),
                                              Text(orderHistoryList[index]
                                                  .onDate.toString().substring(0, 11)),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10,),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          InkWell(
                                            onTap:orderHistoryList[index].isAccepted ?? false ? null :  () {
                                              setState(() {
                                                orderHistoryList[index].isAccepted = true ;
                                                orderRejectedOrAccept(index,context);
                                              });
                                            },

                                            child: Container(
                                              padding: const EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  color: orderHistoryList[index].isAccepted ?? false ? Colors.grey : Colors.green),
                                              child:  Text(orderHistoryList[index].isAccepted ?? false ? 'Accepted' :'Accept',style: TextStyle(color: Colors.white)),
                                            ),
                                          ),
                                          const SizedBox(width: 20,),
                                          InkWell(
                                            onTap: (){
                                              orderRejectedOrAccept(index, context, isRejected:  true);
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                  BorderRadius.circular(15),
                                                  color: Colors.red),
                                              child: const Text('Reject', style: TextStyle(color: Colors.white),),
                                            ),
                                          ),

                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                ) : selectedSegmentVal == 1 ? activeOrder() :  completeOrder(),
                //SizedBox(height: 50,)
              ],
            ),
          ),
        );
      },
    );
  }

  void getUserStatusOnlineOrOffline() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');

    try {
      Map<String, String> body = {};
      body[RequestKeys.userId] = userId ?? '';
      body[RequestKeys.status] = isSwitched ? '2' : '1';
      var res = await api.userOfflineOnlineApi(body);
      if (res.status) {
        print('_____success____');

        // responseData = res.data?.userid.toString();
      } else {
        Fluttertoast.showToast(msg: '');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Invalid Email & Password");
    } finally {}
  }

  void getUserOrderHistory() async {
    isLoading = true;
    setState(() {

    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');

    try {
      Map<String, String> body = {};
      body[RequestKeys.deliveryBoyId] = userId ?? '';
      var res = await api.getOrderHistoryData(body);
      if (res.status ?? false) {
        if (kDebugMode) {
          print('_____success____');
        }
        // responseData = res.data?.userid.toString();
        orderHistoryList = res.data ?? [];
        isLoading = false;
        setState(() {});
      } else {
        Fluttertoast.showToast(msg: '${res.message}');
        isLoading = false;
        setState(() {

        });
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Invalid Email & Password");
    } finally {
      isLoading = false;
      setState(() {

      });
    }
  }

  void orderRejectedOrAccept(int index, BuildContext context, {bool? isRejected}) async {

    if (isRejected ?? false) {
      orderHistoryList.removeAt(index);
      setState(() {

      });
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');

    var headers = {
      'Content-Type': 'application/json',
      'Cookie': 'ci_session=679a0bf637c0c326b677ea0476d380fe3d31b1bf'
    };

    var request = http.Request('POST', Uri.parse('https://developmentalphawizz.com/JDX/api/Payment/accept_order_request'));
    print('${request}');
    request.body = json.encode({
      "user_id": userId ?? '',
      "order_id": orderHistoryList[index].orderId,
      "status": isRejected ?? false ? '1' : '2'
    });
    print('${request.body}');
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    http.Response.fromStream(response)
        .then((response) {
          if(response.statusCode == 200){
            log(response.body);
           var res =  OrderAcceptApiResponse.fromJson(jsonDecode(response.body));
           Fluttertoast.showToast(msg: res.message ?? '');


          }
    });


    /*try {
      Map<String, String> body = {};
      body[RequestKeys.userId] = userId ?? '';
      body[RequestKeys.orderId] = orderHistoryList[index].orderId;
      body[RequestKeys.status] = isRejected ?? false ? '1' : '2';
      var res = await api.getAcceptedOrderData(body);


      if (res.status == 1) {
        print('_____success____');
        // responseData = res.data?.userid.toString();
        Fluttertoast.showToast(msg: res.message ?? '');
        setState(() {});  Fluttertoast.showToast(msg: "Something went wrong");
      } else {
        Fluttertoast.showToast(msg: res.message ?? '');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Something went wrong");
    } finally {}*/
  }

  getDriverRating(String driverId) async{
    var headers = {
      'Cookie': 'ci_session=6e2bbfaeac31fb0c3fcbcd0ae36ef35cb60a73d9'
    };
    var request = http.MultipartRequest('POST', Uri.parse('https://developmentalphawizz.com/JDX/api/Authentication/get_delivery_boy_rating'));
    request.fields.addAll({
      RequestKeys.deliveryBoyId: driverId
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    print('__________${request.fields}_____________');

    if (response.statusCode == 200) {
      var result = await response.stream.bytesToString();
      var finalResult = GetDriverRating.fromJson(jsonDecode(result));
      _driverRating = finalResult ;
    }
    else {
      print(response.reasonPhrase);
    }
    setState(() {

    });
  }
  int selectedSegmentVal = 0 ;
  Widget _segmentButton() => Container(
    padding: const EdgeInsets.all(5),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(45),
      color: Colors.white,
    ),
    margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
    child: Row(
      children: [
        Expanded(
          child: Container(
            height: 30,
            decoration: ShapeDecoration(
                shape: const StadiumBorder(),
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: selectedSegmentVal == 0
                        ? [CustomColors.darkBlueColor, CustomColors.darkBlueColor]
                        : [Colors.transparent, Colors.transparent])),
            child: MaterialButton(
              shape: const StadiumBorder(),
              onPressed: () => setSegmentValue(0),
              child: Text(
                'Pending',
                style:  TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 14,
                    color: selectedSegmentVal == 0
                        ? Colors.white
                        : Colors.black),
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 30,
            decoration: ShapeDecoration(
                shape: const StadiumBorder(),
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: selectedSegmentVal == 1
                        ? [CustomColors.darkBlueColor, CustomColors.darkBlueColor  ]
                        : [Colors.transparent, Colors.transparent])),
            child: MaterialButton(
              shape: const StadiumBorder(),
              onPressed: () => setSegmentValue(1),
              child: FittedBox(
                child: Text(
                  'Active',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14,
                      color: selectedSegmentVal == 1
                          ? Colors.white
                          : Colors.black),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 30,
            decoration: ShapeDecoration(
                shape: const StadiumBorder(),
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: selectedSegmentVal == 2
                        ? [CustomColors.darkBlueColor, CustomColors.darkBlueColor  ]
                        : [Colors.transparent, Colors.transparent])),
            child: MaterialButton(
              shape: const StadiumBorder(),
              onPressed: () => setSegmentValue(2),
              child: FittedBox(
                child: Text(
                  'Complete',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14,
                      color: selectedSegmentVal == 2
                          ? Colors.white
                          : Colors.black),
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );


  setSegmentValue(int i) {
    selectedSegmentVal = i;
    String status;
    if (i == 0) {
      getUserOrderHistory();
      // parcelHistory(2);
    } else if (i == 1) {
      getAcceptedOrder();
    }else {
      getParcelHistory();
    }
    setState(() {

    });
    // getOrderList(status: status);

  }

  Widget activeOrder(){

    return Column(
      children: [
        isLoading2
            ? const Center(child: CircularProgressIndicator())
            : parcelDataList?.data?.isEmpty ?? false
            ? const Center(child: Text('Data Not Available'))
            : ListView.builder(
            scrollDirection: Axis.vertical,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
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
      ],
    );
  }

  Widget completeOrder(){
   return Column(
      children: [
        isLoading3
            ? const Center(child: CircularProgressIndicator())
            : pastParcelDataList.isEmpty
            ? const Center(child: Text('Data Not Available'))
            : ListView.builder(
            scrollDirection: Axis.vertical,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: pastParcelDataList.length,
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
                                  Text(pastParcelDataList[index]
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
                                  Text(pastParcelDataList[index].phoneNo ??
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
                                  Text(pastParcelDataList[index]
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
                                  Text(pastParcelDataList[index].senderName ??
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
                                        pastParcelDataList[index]
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
                                        pastParcelDataList[index]
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
                                  Text(pastParcelDataList[index]
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
                                  Text(pastParcelDataList[index].totalAmount ??
                                      '-'),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          /*InkWell(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context) =>  ParcelDetailsView(parcelFullDetail: parcelDataList!.data![index].parcelDetails)));
                                },
                                child: const Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Text('See full details', style: TextStyle(decoration: TextDecoration.underline, color: Colors.red),)),
                              )*/

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
      ],
    );
  }




  getAcceptedOrder() async {
    isLoading2 = true;
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
      isLoading2 = false;
      print("thisi is ============>${finalResult}");
      setState(() {
        parcelDataList = finalResult;


      });
    } else {
      isLoading2 = false;
      print(response.reasonPhrase);
    }
  }

  void getParcelHistory() async {
    Api api =Api();
    isLoading3 = true;
    setState(() {

    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');

    try {
      Map<String, String> body = {};
      body[RequestKeys.userId] = userId ?? '';
      var res = await api.getParcelHistoryData(body);
      if (res.status == 1) {
        print('_____success____');
        // responseData = res.data?.userid.toString();
        pastParcelDataList = res.data ?? [];
        setState(() {});
      } else {
        Fluttertoast.showToast(msg: '${res.status}');
        setState(() {
          isLoading3 = false;
        });
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Something went wrong");
    } finally {
      isLoading3 = false;
    }
  }

}
  

