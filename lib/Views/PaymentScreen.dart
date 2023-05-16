import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:jdx/Models/payment_history_response.dart';
import 'package:jdx/Utils/CustomColor.dart';
import 'package:jdx/services/api_services/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/api_services/request_key.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  Api api = Api();

  List<PaymentHistoryDataList> paymentHistoryList = [];
  bool isLoading = false ;
  int selectedSegmentVal = 0 ;

  @override
  void initState() {
    // TODO: implement initState
    getPaymentHistory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Payment'),
          centerTitle: true,
          backgroundColor: const Color(0xFF222443),
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                  height: 23,
                  width: 23,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30)),
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  )),
            ),
          )),
      body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 40,
                ),
                Align(
                  alignment: Alignment.center,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 55,
                    child: Image.asset('assets/images/cash.png', fit: BoxFit.cover),
                  ),
                ),
                const Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Cash On Delivery Amount ',
                      style: TextStyle(color: Colors.black38, fontSize: 16),
                    )),
                const SizedBox(
                  height: 40,
                ),
                const Text(
                  'Payment History',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 10,),
                _segmentButton(),
                SizedBox(
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: paymentHistoryList.length,
                    itemBuilder: (context, index) {
                      return   isLoading
                      ? const Center(child: CircularProgressIndicator(color: Colors.grey,)) : productCard(index);
                    },
                  ),
                )
              ],
            ),
          )),
    );
  }

  Widget textColumn(String title, String subTitle) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 12, color: Colors.red),
        ),
        const SizedBox(height: 8),
        Text(
          subTitle,
          style: const TextStyle(fontSize: 14, color: Colors.black),
        )
      ],
    );
  }

  Widget productCard(int index) {
    var item = paymentHistoryList[index];
    return Container(
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(
              color: Colors.black38,
              blurRadius: 5,
              spreadRadius: 1,
              offset: Offset(2, 3))
        ],
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      margin: const EdgeInsets.only(bottom: 20, left: 10, right: 10),
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              clipBehavior: Clip.antiAlias,
              height: 50,
              width: 50,
              child: Image.network(item.attachment ?? '--')),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.id ?? '',
                  style: const TextStyle(color: Colors.red),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    textColumn('Id', item.id ?? '-'),
                    textColumn('Status', item.status ?? '-'),
                    textColumn('City', item.status ?? '-'),
                    textColumn('Date', item.createDt ?? '-'),
                    // textColumn('Rate', '\u{20B9}${item.rate.toString()}'),
                    Column(
                      children: [
                        const Text(
                          'Amount',
                          style: TextStyle(fontSize: 12, color: Colors.red),
                        ),
                        const SizedBox(height: 8),
                        FittedBox(
                          child: Text(
                            '\u{20B9} ${item.amount ?? '-'}',
                            style: const TextStyle(
                                color: Colors.black, fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                    //textColumn('Amount', '\u{20B9}${item.amount.toString()}'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void getPaymentHistory() async {
    isLoading =true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');

    try {
      Map<String, String> body = {};
      body[RequestKeys.userId] = userId ?? '';
      var res = await api.getPaymentHistoryData(body);
      if (res.status ?? false) {
        print('_____success____');
        Fluttertoast.showToast(msg: res.message ?? '');
        // responseData = res.data?.userid.toString();
        paymentHistoryList = res.data ?? [];
        setState(() {
          isLoading =false;
        });
      } else {
        Fluttertoast.showToast(msg: res.message ?? '');
        isLoading =false;
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Invalid Password");
    } finally {
      isLoading =false;
    }
  }

  setSegmentValue(int i) {
    selectedSegmentVal = i;
    String status;
    if (i == 0) {
     // parcelHistory(2);
    } else if (i == 1) {
      //parcelHistory(1);
    }
    setState(() {

    });
    // getOrderList(status: status);

  }

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
                'To Receive',
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
                  'To Pay',
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
      ],
    ),
  );
}
