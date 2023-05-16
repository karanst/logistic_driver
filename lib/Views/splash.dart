import 'dart:async';
import 'package:flutter/material.dart';
import 'package:jdx/AuthViews/LoginScreen.dart';
import 'package:jdx/Controller/BottomNevBar.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    // TODO: implement initState
    //Timer(Duration(seconds: 5), () {Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> SignInScreen()));});
    super.initState();
    Future.delayed(Duration(milliseconds: 300),(){
      return checkLogin();
    });

    Future.delayed(Duration(seconds: 2),(){
      if(userid == null || userid == ""){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> LoginScreen()));
      }
      else{
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BottomNav()));
      }
    });
  }

  String? userid;
  void checkLogin()async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    userid = pref.getString('userId');
    print(" this is iser============> ${userid}");
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
            decoration: BoxDecoration(
                image:DecorationImage(
                    image:AssetImage('assets/images/splash.png'),
                    fit: BoxFit.fill
                )
            )
        ),
      ),
    );
  }
}
