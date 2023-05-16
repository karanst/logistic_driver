import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Models/notification_response.dart';
import '../services/api_services/api.dart';
import '../services/api_services/request_key.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool isLoading = false;

  Api api = Api();

  List<NotificationDataList> notificationList = [];

  @override
  void initState() {
    // TODO: implement initState

    getNotificationList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF222443),
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
        title: const Text('Notification'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            
            SizedBox(
              height: MediaQuery.of(context).size.height,
              width: double.maxFinite,
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : notificationList.isEmpty
                      ? const Text('Data Not Available')
                      : ListView.builder(
                          scrollDirection: Axis.vertical,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: false,
                          itemCount: notificationList.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {},
                              child: Card(
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                  Row(children: [
                                    const Text('Id:               ',  style: TextStyle(color: Colors.red),),
                                    Text(notificationList[index].id ?? '')
                                  ],),
                                    const SizedBox(height: 20,),
                                    Row(children: [
                                      const Text('Date:           ',  style: TextStyle(color: Colors.red),),
                                      Text(notificationList[index].date ?? '')
                                    ],),
                                    const SizedBox(height: 20,),
                                    Row(children: [
                                      const Text('Message:',  style: TextStyle(color: Colors.red),),
                                      const SizedBox(width: 10,),
                                      SizedBox(
                                        width: 200,
                                          child: Text(notificationList[index].notification ?? ''))
                                    ],),
                              ],),
                                ),)
                            );
                          }),
            ),
          ],
        ),
      ),
    );
  }

  void getNotificationList() async {
    isLoading = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');

    try {
      Map<String, String> body = {};
      body[RequestKeys.userId] = userId ?? '';
      var res = await api.getNotificationData(body);
      if (res.status ?? false) {
        print('_____success____');
        // responseData = res.data?.userid.toString();
        notificationList = res.data ?? [];
        setState(() {});
      } else {
        Fluttertoast.showToast(msg: '');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Something went wrong");
    } finally {
      isLoading = false;
    }
  }
}
