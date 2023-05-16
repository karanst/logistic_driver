import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jdx/Models/parcel_history_response.dart';
import 'package:jdx/services/api_services/api.dart';
import 'package:jdx/services/api_services/request_key.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PastParcelHistory extends StatefulWidget {
  const PastParcelHistory({Key? key}) : super(key: key);

  @override
  State<PastParcelHistory> createState() => _PastParcelHistoryState();
}

class _PastParcelHistoryState extends State<PastParcelHistory> {
  List<ParcelHistoryDataList> parcelDataList = [];
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    getParcelHistory();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Container(
              height: 23,
              width: 23,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(30)),
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
              )),
        ),
        backgroundColor: const Color(0xFF222443),
        title: const Text('Parcel Details'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : parcelDataList.isEmpty
                ? const Center(child: Text('Data Not Available'))
                : ListView.builder(
                scrollDirection: Axis.vertical,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: parcelDataList.length,
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
                                      Text(parcelDataList[index]
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
                                      Text(parcelDataList[index].phoneNo ??
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
                                      Text(parcelDataList[index]
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
                                      Text(parcelDataList[index].senderName ??
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
                                            parcelDataList[index]
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
                                            parcelDataList[index]
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
                                      Text(parcelDataList[index]
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
                                      Text(parcelDataList[index].totalAmount ??
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
        ),
      ),
    );
  }
void getParcelHistory() async {
    Api api =Api();
    isLoading = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');

    try {
      Map<String, String> body = {};
      body[RequestKeys.userId] = userId ?? '';
      var res = await api.getParcelHistoryData(body);
      if (res.status == 1) {
        print('_____success____');
        // responseData = res.data?.userid.toString();
        parcelDataList = res.data ?? [];
        setState(() {});
      } else {
        Fluttertoast.showToast(msg: '${res.status}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Something went wrong");
    } finally {
      isLoading = false;
    }
  }

}
