import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Controller/BottomNevBar.dart';
import '../Models/login_model.dart';
import '../Utils/CustomColor.dart';
import 'ForgetPasswordScreen.dart';
import 'SignUpScreen.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoading = false;

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  getLoginApi() async {
    isLoading = true;
    setState(() {

    });
    var headers = {
      'Cookie': 'ci_session=c7d48d7dcbb70c45bae12c8d08e77251655897e8'
    };
    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            'https://developmentalphawizz.com/JDX/api/Authentication/DeliveryLogin'));
    request.fields.addAll({
      'user_email': emailController.text,
      'user_password': passwordController.text,
      'firebaseToken': '4'
    });
    print("this isn ==========>${request.fields}");
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final reslut = await response.stream.bytesToString();
      var finalResult = LoginModel.fromJson(json.decode(reslut));
      //var finalResult = json.decode(reslut);

      if (finalResult.status == true) {
        String? userId = finalResult.data?.userId;
        String? userName = finalResult.data?.userFullname;
        print("User id+++++++++++++++++>${userId}");
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("userId", userId ?? '-id--');
        prefs.setString("userName", userName ?? '-username-');
        isLoading = false;

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => BottomNav()));
      } else {
        Fluttertoast.showToast(msg: "${finalResult.message}");
        isLoading = false;
      }
      setState(() {
        emailController.clear();
        passwordController.clear();
      });
    } else {
      print(response.reasonPhrase);
      isLoading = false;
      setState(() {

      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Confirm Exit"),
                content: Text("Are you sure you want to exit?"),
                actions: <Widget>[
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: CustomColors.accentColor),
                    child: Text("YES"),
                    onPressed: () {
                      SystemNavigator.pop();
                    },
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: CustomColors.accentColor),
                    child: Text("NO"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            });
        // if (_tabController.index != 0) {
        //   _tabController.animateTo(0);
        //   return false;
        // }
        return true;
      },
      child: Scaffold(
        body: Form(
          key: _formKey,
          child: Container(
            child: Stack(
              children: <Widget>[
                Positioned(
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 200,
                    width: 400,
                    decoration: const  BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            CustomColors.accentColor,
                            CustomColors.DarkBrownColor,
                            CustomColors.DarkYellowColor,
                            CustomColors.darkBlueColor
                          ],
                          stops: [
                            0,
                            1,
                            2,
                            3
                          ]),
                    ),
                  ),
                ),
                Positioned(
                  top: 110,
                  left: 25,
                  right: 25,
                  height: 350,
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                ),
                Positioned(
                  top: 152,
                  left: 35,
                  right: 35,
                  child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 70,
                          width: MediaQuery.of(context).size.width / 1.3,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: CustomColors.TransparentColor),
                          child: TextFormField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              prefixIcon: Padding(
                                padding: const EdgeInsets.only(top: 15),
                                child: Icon(
                                  Icons.email,
                                  color: CustomColors.accentColor,
                                ),
                              ),
                              contentPadding: EdgeInsets.only(top: 24, left: 5),
                              border: InputBorder.none,
                              hintText: "Email",
                            ),
                            validator: (v) {
                              if (v!.isEmpty) {
                                return "Email is required";
                              }
                              if (!v.contains("@")) {
                                return "Enter Valid Email Id";
                              }
                            },
                          ),
                        ),
                      )),
                ),
                Positioned(
                  top: 230,
                  left: 35,
                  right: 35,
                  child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 70,
                          width: MediaQuery.of(context).size.width / 1.3,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: CustomColors.TransparentColor),
                          child: TextFormField(
                            controller: passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              prefixIcon: Padding(
                                padding: const EdgeInsets.only(top: 12),
                                child: Icon(
                                  Icons.lock,
                                  color: CustomColors.accentColor,
                                ),
                              ),
                              contentPadding: EdgeInsets.only(top: 22, left: 5),
                              border: InputBorder.none,
                              hintText: "Password",
                            ),
                            validator: (v) {
                              if (v!.isEmpty) {
                                return "Password is required";
                              }
                            },
                          ),
                        ),
                      )),
                ),
                Positioned(
                    top: 300,
                    right: 5,
                    width: 250,
                    height: 45,
                    child: TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Forget()));
                        },
                        child: const Text(
                          'Forget password',
                          style: TextStyle(color: Colors.red),
                        ))),
                Positioned(
                    top: 370,
                    left: 65,
                    right: 65,
                    height: 45,
                    child: InkWell(
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          getLoginApi();
                        } else {
                          Fluttertoast.showToast(
                              msg: "All Fields are required");
                          //Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
                        }
                      },
                      child: Center(
                        child: Container(
                          decoration: BoxDecoration(
                              color: CustomColors.accentColor,
                              borderRadius: BorderRadius.circular(20)),
                          child: isLoading ? const Center(child: CircularProgressIndicator(color: Colors.white,),)  :  const Center(
                              child: Text(
                            "Sign In",
                            style: TextStyle(
                                color: CustomColors.White,
                                fontWeight: FontWeight.bold),
                          ),),
                        ),
                      ),
                    )),
                Positioned(
                    top: 490,
                    left: 70,
                    width: 250,
                    height: 45,
                    child: Row(
                      children: [
                        Text('Do not have an Account?'),
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SignUpScreen()));
                            },
                            child: isLoading
                                ? Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(
                                    'SignUp',
                                    style: TextStyle(color: Colors.red),
                                  ))
                      ],
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
