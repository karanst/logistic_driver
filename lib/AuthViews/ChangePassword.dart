import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jdx/services/api_services/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../CustomWidgets/CustomElevetedButton.dart';
import '../services/api_services/request_key.dart';

class ChangePass extends StatefulWidget {
  const ChangePass({Key? key}) : super(key: key);

  @override
  State<ChangePass> createState() => _ChangePassState();
}

final oldPasswordController = TextEditingController();
final newPasswordController = TextEditingController();
final confirmPasswordController = TextEditingController();
final _formKey = GlobalKey<FormState>();

Api api = Api();



class _ChangePassState extends State<ChangePass> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF222443),
        title: const Text('Change Password'),
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
                )),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 38.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /*Padding(
                  padding: const EdgeInsets.only(left: 18.0, right: 18),
                  child: Container(
                    height: 55,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: TextFormField(
                      validator: (value){
                        if (value!.isEmpty) {
                          return "Old password is required";
                        }
                      },
                      controller: oldPasswordController,
                      decoration: InputDecoration(
                          hintText: 'Enter your old password',
                          prefixIcon: const Icon(
                            Icons.lock,
                            color: Colors.redAccent,
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(11))),
                    ),
                  ),
                ),*/
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 18.0, right: 18),
                  child: TextFormField(

                    validator: (value){
                      if (value!.isEmpty) {
                        return "new password is required";
                      }
                    },
                    controller: newPasswordController,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                        filled: true,
                        hintText: 'Enter New Password',
                        prefixIcon: const Icon(
                          Icons.lock,
                          color: Colors.redAccent,
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(11))),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 18.0, right: 18.0),
                  child: TextFormField(

                    validator: (value){
                      if (value != newPasswordController.text) {
                        return "Password must be same ";
                      }else{
                      }
                    },
                    controller: confirmPasswordController,
                    decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        hintText: 'Confirm New Password',
                        prefixIcon: const Icon(
                          Icons.lock,
                          color: Colors.redAccent,
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(11))),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 70.0),
                  child: SizedBox(
                      height: 45,
                      width: 270,
                      child: CustomElevatedButton(
                        text: 'Save',
                        icon: Icons.send,
                        onPressed: () {
                          if(_formKey.currentState!.validate()){
                            changePassword();
                          }


                          // Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
                        },
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );

  }
  void changePassword() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');



    try {
      Map<String, String> body = {};
      body[RequestKeys.userId] = userId ?? '';
      body[RequestKeys.password] = newPasswordController.text;
      var res = await api.changePassword(body);
      newPasswordController.clear();
      confirmPasswordController.clear();
      if (res.status ?? false) {
        print('_____success____');
        Fluttertoast.showToast(msg: res.message ?? '');
        // responseData = res.data?.userid.toString();
        //orderHistoryList = res.data ?? [];
        Navigator.pop(context);
      } else {
        Fluttertoast.showToast(msg: res.message ?? '');

      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Invalid Password");
    } finally {}
  }
}
