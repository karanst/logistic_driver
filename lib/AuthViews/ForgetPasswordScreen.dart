import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jdx/AuthViews/LoginScreen.dart';
import 'package:jdx/CustomWidgets/CustomElevetedButton.dart';
import 'package:jdx/CustomWidgets/CustomTextformfield.dart';
import 'package:jdx/services/api_services/api.dart';

import '../Utils/CustomColor.dart';
import '../services/api_services/request_key.dart';

class Forget extends StatefulWidget {
  const Forget({Key? key}) : super(key: key);

  @override
  State<Forget> createState() => _ForgetState();
}

class _ForgetState extends State<Forget> {
  TextEditingController emailController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 180,
                      decoration:  BoxDecoration(
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
                    top: 130,
                    left: 10,
                    right: 10,
                    child: SizedBox(
                      height: 320,
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Padding(
                          padding:
                              EdgeInsets.only(left: 15, right: 15, top: 10),
                          child: Column(
                            children: [
                              Image.asset(
                                'assets/images/forgetpass.png',
                                height: 160,
                              ),
                              const Text(
                                'We will send reset link to your email \n address',
                                style: TextStyle(
                                  fontSize: 17,
                                ),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                      color: CustomColors.TransparentColor,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: CustomTextFormField(
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter some text';
                                      }
                                      return null;
                                    },
                                    prefixIcon: Icons.email,
                                    controller: emailController,
                                    hintText: 'Enter Email',
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 80,
                    left: 30,
                    right: 30,
                    child: SizedBox(
                        height: 45,
                        child: isLoading
                            ? const Center(
                                child: CircularProgressIndicator(color: Colors.grey,),
                              )
                            : CustomElevatedButton(
                                text: 'Send',
                                icon: Icons.send,
                                onPressed: () {
                                  forgotPasswordApi();
                                },
                              )),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void forgotPasswordApi() async {
    if(emailController.text.isEmpty){
      Fluttertoast.showToast(msg: 'Please add email');
    }else {
      isLoading = true;
      Api api = Api();
      try {
        Map<String, String> body = {};
        body[RequestKeys.email] = emailController.text.trim();
        var res = await api.forgotPassword(body);
        if (res.status ?? false) {
          print('_____success____');

          Fluttertoast.showToast(
              msg: res.message ?? 'Verification link has sent to your email');
          isLoading = false;
Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen(),));
          // responseData = res.data?.userid.toString();
        } else {
          Fluttertoast.showToast(msg: res.message ?? 'Not Valid email');
          isLoading = false;
        }
      } catch (e) {
        Fluttertoast.showToast(msg: "Invalid Email & Password");
      } finally {
        isLoading = false;
      }
    }
  }
}
