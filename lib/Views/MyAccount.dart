import 'dart:convert';
import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:jdx/AuthViews/ChangePassword.dart';
import 'package:jdx/AuthViews/LoginScreen.dart';
import 'package:jdx/CustomWidgets/CustomElevetedButton.dart';
import 'package:jdx/Models/order_accept_response.dart';
import 'package:jdx/Utils/ApiPath.dart';
import 'package:jdx/Views/Feedback.dart';
import 'package:jdx/Views/MyProfile.dart';
import 'package:jdx/Views/PaymentScreen.dart';
import 'package:jdx/Views/driver_payment_system.dart';
import 'package:jdx/Views/past_parcel_history.dart';
import 'package:jdx/Views/share_qr/scan_qr.dart';
import 'package:jdx/services/api_services/request_key.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../Models/GetProfileModel.dart';

class MyAccount extends StatefulWidget {
  const MyAccount({Key? key}) : super(key: key);

  @override
  State<MyAccount> createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  openLogoutDialog() {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: const Text(
                "Are you sure want to logout app ?",
                style: TextStyle(
                    fontFamily: 'Serif',
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w500),
              ),
              content: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()));
                      prefs.setString('userId', "");
                      setState(() {});
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      alignment: Alignment.center,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: Colors.green,
                      ),
                      child: Text(
                        "Confirm",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            fontFamily: 'Serif'),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      alignment: Alignment.center,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: Colors.red,
                      ),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            fontFamily: 'Serif'),
                      ),
                    ),
                  ),
                ],
              ),
            );
          });
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(milliseconds: 300), () {
      return getProfile();
    });
  }

  GetProfileModel? getProfileModel;
  String qrCodeResult = "Not Yet Scanned";

  getProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString("userId");
    print(" this is  User++++++++++++++>${userId}");
    var headers = {
      'Cookie': 'ci_session=6de5f73f50c4977cb7f3af6afe61f4b340359530'
    };
    var request = http.MultipartRequest(
        'POST', Uri.parse('${Urls.baseUrl}User_Dashboard/getUserProfile'));
    request.fields.addAll({'user_id': userId.toString()});
    print(" this is  User++++++++++++++>${request.fields}");
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      final result = await response.stream.bytesToString();
      var finalResult = GetProfileModel.fromJson(jsonDecode(result));
      print("thisi is ============>${finalResult.data?.first.userImage}");
      setState(() {
        getProfileModel = finalResult;
        print('${getProfileModel!.data![0].userImage}_________________');
        Fluttertoast.showToast(msg: qrCodeResult);

      });
    } else {
      print(response.reasonPhrase);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFF222443),
        title: const Padding(
          padding: EdgeInsets.only(left: 48.0),
          child: Text('My Account'),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 28.0, left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  getProfileModel == null
                      ? const Center(child: CircularProgressIndicator())
                      : Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100)),
                              height: 80,
                              width: 80,
                              child: getProfileModel!.data![0].userImage ==
                                          null ||
                                      getProfileModel!.data![0].userImage == ""
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: Image.asset(
                                        "assets/images/profileImage.jpg",
                                        fit: BoxFit.fill,
                                      ))
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: Image.network(
                                        "${getProfileModel!.data![0].userImage}",
                                        fit: BoxFit.fill,
                                      )),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    "${getProfileModel!.data![0].userFullname}"),
                                Text('${getProfileModel!.data![0].userEmail}'),
                              ],
                            ),
                          ],
                        ),
                  Row(
                    children: [
                      InkWell(
                        onTap: getProfileModel == null
                            ? null
                            : () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Myprofile(
                                            getProfileModel: getProfileModel)));
                              },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                  color: Colors.redAccent.withOpacity(0.10),
                                  borderRadius: BorderRadius.circular(50)),
                              child: Icon(
                                Icons.edit,
                              )),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0, left: 5,right: 5),
              child: Container(
                height: 80,
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(11)),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(children: [
                          Icon(Icons.more_time_sharp),
                          const Padding(
                            padding: EdgeInsets.only(left: 28.0),
                            child: Text(
                              'Payment History',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],),
                        Padding(
                            padding: const EdgeInsets.only(left: 110.0),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PaymentScreen(),
                                    ));
                              },
                              child: Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                      color: Colors.redAccent.withOpacity(0.10),
                                      borderRadius: BorderRadius.circular(50)),
                                  child: Icon(
                                    Icons.arrow_forward_ios,
                                  )),
                            ))
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0, left: 5,right: 5),
              child: Container(
                height: 80,
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(11)),
                  child: Padding(
                     padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(children: [
                          Icon(Icons.more_time_sharp),
                          Padding(
                            padding: const EdgeInsets.only(left: 28.0),
                            child: Text(
                              'Driver Payment System',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DriverPaymentSystem()));
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 70.0),
                            child: Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                    color: Colors.redAccent.withOpacity(0.10),
                                    borderRadius: BorderRadius.circular(50)),
                                child: Icon(
                                  Icons.arrow_forward_ios,
                                )),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0, left: 5,right: 5),
              child: Container(
                height: 80,
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(11)),
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(children: [
                          Icon(Icons.more_time_sharp),
                          Padding(
                            padding: const EdgeInsets.only(left: 28.0),
                            child: Text(
                              'Get Feedback',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const UserFeedback()));
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 128.0),
                            child: Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                    color: Colors.redAccent.withOpacity(0.10),
                                    borderRadius: BorderRadius.circular(50)),
                                child: Icon(
                                  Icons.arrow_forward_ios,
                                )),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0, left: 5,right: 5),
              child: Container(
                height: 80,
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(11)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(children: [
                          Icon(Icons.more_time_sharp),
                          Padding(
                            padding: const EdgeInsets.only(left: 28.0),
                            child: Text(
                              'Parcel History',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const PastParcelHistory()));
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 128.0),
                            child: Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                    color: Colors.redAccent.withOpacity(0.10),
                                    borderRadius: BorderRadius.circular(50)),
                                child: Icon(
                                  Icons.arrow_forward_ios,
                                )),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0, left: 5,right: 5),
              child: Container(
                height: 80,
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(11)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(children: [
                          Icon(Icons.qr_code_scanner_outlined),
                          Padding(
                            padding: const EdgeInsets.only(left: 28.0),
                            child: Text(
                              'Scan QR Code',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],),
                        InkWell(
                          onTap: () {
                            scanQR();
                          },
                          child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                  color: Colors.redAccent.withOpacity(0.10),
                                  borderRadius: BorderRadius.circular(50)),
                              child: Icon(
                                Icons.arrow_forward_ios,
                              )),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0, left: 5,right: 5),
              child: Container(
                height: 80,
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(11)),
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(children: [
                          Icon(Icons.lock),
                          Padding(
                            padding: const EdgeInsets.only(left: 28.0),
                            child: Text(
                              'Change Password',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ChangePass()));
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 105.0),
                            child: Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                    color: Colors.redAccent.withOpacity(0.10),
                                    borderRadius: BorderRadius.circular(50)),
                                child: Icon(
                                  Icons.arrow_forward_ios,
                                )),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 58.0),
              child: SizedBox(
                width: 170,
                height: 50,
                child: CustomElevatedButton(
                  text: 'Log Out',
                  icon: Icons.logout,
                  onPressed: () {
                    openLogoutDialog();
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
  Future<void> scanQR() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);

    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      qrCodeResult = barcodeScanRes;

      if(qrCodeResult == '-1'){

      }else{
        acceptTransferredParcel();
      }

      print('${barcodeScanRes}________________');
    });
  }

  void acceptTransferredParcel() async {

    /*if (isRejected ?? false) {
      *//*orderHistoryList.removeAt(index);
      setState(() {

      });*//*
    }*/
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
      "order_id": qrCodeResult,
      "status":  '2'
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
      var res = await api.orderRejectOrAccept(body);


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
    } finally {}
  }*/

  }



  // Future<void> _getCurrentLocation() async {
  //   try {
  //     log("----- error log --_getCurrentLocation- ",error: "ngnkdfnkgkdf");
  //
  //     /// tested om android and its working fine
  //     /// but not working on ios
  //     await Firebase.initializeApp(
  //       options: DefaultFirebaseOptions.currentPlatform,
  //     );
  //
  //     Location location = Location();
  //     bool serviceEnabled;
  //     PermissionStatus permissionGranted;
  //
  //     serviceEnabled = await location.serviceEnabled();
  //     if (!serviceEnabled) {
  //       serviceEnabled = await location.requestService();
  //       if (!serviceEnabled) {
  //       }
  //     }
  //
  //     location.enableBackgroundMode(enable: true);
  //     permissionGranted = await location.requestPermission();
  //     print("-----print----- permissionGranted  ${permissionGranted}");
  //     if (permissionGranted != PermissionStatus.granted) {
  //     }
  //
  //     var position = await Geolocator.getCurrentPosition();
  //     /*var collection = FirebaseFirestore.instance.collection('location');
  //     collection.add(
  //       {
  //         "lat": position.latitude.toString(),
  //         "long": position.longitude.toString(),
  //         "current_date": ' ${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}',
  //       },
  //     );*/
  //   } catch (e) {
  //     print("Error getting location: ${e.toString()}");
  //   }
  //   // Wait for 10 seconds before getting the location again
  //   await Future.delayed(const Duration(seconds: 10));
  //   await _getCurrentLocation();
  // }

}
