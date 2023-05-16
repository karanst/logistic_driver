import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jdx/AuthViews/LoginScreen.dart';
import 'package:http/http.dart' as http;
import 'package:jdx/Models/SignUpModel.dart';
import 'package:jdx/Utils/ApiPath.dart';
import '../Controller/BottomNevBar.dart';
import '../CustomWidgets/CustomElevetedButton.dart';
import '../CustomWidgets/CustomTextformfield.dart';
import '../Utils/CustomColor.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);


  @override
  State<SignUpScreen> createState() => _SignUpScreen();

}

class _SignUpScreen extends State<SignUpScreen> {

  singUpModel? information;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController VhicleController = TextEditingController();
  TextEditingController VhicletypeController = TextEditingController();
  TextEditingController LicenceController = TextEditingController();
  TextEditingController aadharController = TextEditingController();
  final _formKey = GlobalKey<FormState>();


  getNewSignUp() async {
    var headers = {
      'Cookie': 'ci_session=cd3c13dc5a076f38e4c94afe64948ac08bf8b17c'
    };
    var request = http.MultipartRequest('POST', Uri.parse('https://developmentalphawizz.com/JDX/api/Authentication/deliveryBoyRegistration'));
    request.fields.addAll({
      'user_fullname': '210                                                                         ',
      'user_email': 'test11@gmail.com',
      'user_password': '12345678',
      'user_phone': '6879889798',
      'firebaseToken': '4',
      'aadhaar_card_no': '6486',
      'vehicle_type': '9+',
      'vehicle_no': '7',
      'driving_licence_no': '7',
      'account_holder_name': '5',
      'account_number': '7',
      'ifsc_code': '4',
      'user_image': '',
      'driving_licence_photo': ''
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {

    }
    else {
    print(response.reasonPhrase);
    }

  }

  signUpApi() async {
    var headers = {
      'Cookie': 'ci_session=441db6d062b9f121348edb7be09465992a51c601'
    };
    var request = http.MultipartRequest('POST', Uri.parse('https://developmentalphawizz.com/JDX/api/Authentication/deliveryBoyRegistration'));

    request.fields.addAll({

    'user_fullname': nameController.text,
    'user_email': emailController.text,
    'user_password': passController.text,
    'user_phone':  mobController.text,
    'firebaseToken': '4',
    'aadhaar_card_no': aadharController.text,
    'vehicle_type':  VhicletypeController.text,
    'vehicle_no': VhicleController.text,
    'driving_licence_no': LicenceController.text,
    'account_holder_name': '5',
    'account_number': '7',
    'ifsc_code': '4',
    'user_image': '',
    'driving_licence_photo': ''

    });
    print(" thos sonsafsdfds=>${Urls.baseUrl}Authentication/deliveryBoyRegistration}");
    print('Data is-------${request.fields}');
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
   print(" mthis is  Re=---=>${response.statusCode}");
    if (response.statusCode == 200) {
      final str = await response.stream.bytesToString();
      var finalData = json.decode(str);
      print('this is a reso========>${finalData}');
      Fluttertoast.showToast(msg: "${finalData['message']}");

      setState(() {
        nameController.clear();
        emailController.clear();
        mobController.clear();
        passController.clear();
        VhicleController.clear();
        VhicletypeController.clear();
        LicenceController.clear();
        aadharController.clear();
      });
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
    } else {
      print(response.reasonPhrase);
    }
  }

  final ImagePicker _picker = ImagePicker();
  File? imageFile;

  _getFromGallery() async {
    PickedFile? pickedFile = await _picker.getImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
      Navigator.pop(context);
    }
  }

  _getFromCamera() async {
    PickedFile? pickedFile = await _picker.getImage(
      source: ImageSource.camera,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
      Navigator.pop(context);
    }
  }

  Future<bool> showExitPopup() async {
    return await showDialog(
          //show confirm dialogue
          //the return value will be from "Yes" or "No" options
          context: context,
          builder: (context) => AlertDialog(
              title: Text('Select Image'),
              content: Row(
                // crossAxisAlignment: CrossAxisAlignment.s,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _getFromCamera();
                    },
                    //return false when click on "NO"
                    child: Text('Camera'),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _getFromGallery();
                      // Navigator.pop(context,true);
                      // Navigator.pop(context,true);
                    },
                    //return true when click on "Yes"
                    child: Text('Gallery'),
                  ),
                ],
              )),
        ) ??
        false; //if showDialouge had returned null, then return false
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: 200,
                    width: 400,
                    decoration: const BoxDecoration(
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
                        ])),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, top: 150),
                    child: Container(
                      height: MediaQuery.of(context).size.width * 2.8,
                      width: MediaQuery.of(context).size.width / 1.1,
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 180.0, left: 45),
                    child: Column(
                      children: [
                        Container(
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
                                  controller: nameController,
                                  keyboardType: TextInputType.name,
                                  decoration: InputDecoration(
                                    prefixIcon: Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Icon(
                                        Icons.person,
                                        color: CustomColors.accentColor,
                                      ),
                                    ),
                                    contentPadding:
                                        EdgeInsets.only(top: 22, left: 5),
                                    border: InputBorder.none,
                                    hintText: "Full Name",
                                  ),
                                  validator: (v) {
                                    if (v!.isEmpty) {
                                      return "Name is required";
                                    }
                                  },
                                ),
                              ),
                            )),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
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
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Icon(
                                        Icons.email,
                                        color: CustomColors.accentColor,
                                      ),
                                    ),
                                    contentPadding:
                                        EdgeInsets.only(top: 22, left: 5),
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
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
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
                                  maxLength: 10,
                                  controller: mobController,
                                  keyboardType: TextInputType.phone,
                                  decoration: InputDecoration(
                                    counterText: "",
                                    prefixIcon: Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Icon(
                                        Icons.call,
                                        color: CustomColors.accentColor,
                                      ),
                                    ),
                                    contentPadding:
                                        EdgeInsets.only(top: 22, left: 5),
                                    border: InputBorder.none,
                                    hintText: "Mobile No",
                                  ),
                                  validator: (v) {
                                    if (v!.isEmpty) {
                                      return "Mobile is required";
                                    }
                                    if (v.length != 10) {
                                      return "Mobile Number must be of 10 digit";
                                    }
                                  },
                                ),
                              ),
                            )),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
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
                                  controller: passController,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    prefixIcon: Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Icon(
                                        Icons.lock,
                                        color: CustomColors.accentColor,
                                      ),
                                    ),
                                    contentPadding:
                                        EdgeInsets.only(top: 22, left: 5),
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
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
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
                                  controller: VhicleController,
                                  keyboardType: TextInputType.name,
                                  decoration: InputDecoration(
                                    prefixIcon: Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Icon(
                                        Icons.lock,
                                        color: CustomColors.accentColor,
                                      ),
                                    ),
                                    contentPadding:
                                        EdgeInsets.only(top: 22, left: 5),
                                    border: InputBorder.none,
                                    hintText: "Vehicle number",
                                  ),
                                  validator: (v) {
                                    if (v!.isEmpty) {
                                      return "Vehicle is required";
                                    }
                                  },
                                ),
                              ),
                            )),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
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
                                  controller: VhicletypeController,
                                  keyboardType: TextInputType.name,
                                  decoration: InputDecoration(
                                    prefixIcon: Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Icon(
                                        Icons.car_repair,
                                        color: CustomColors.accentColor,
                                      ),
                                    ),
                                    contentPadding:
                                        EdgeInsets.only(top: 22, left: 5),
                                    border: InputBorder.none,
                                    hintText: "Vehicle Type",
                                  ),
                                  validator: (v) {
                                    if (v!.isEmpty) {
                                      return "Vehicle Type is required";
                                    }
                                  },
                                ),
                              ),
                            )),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
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
                                  controller: LicenceController,
                                  keyboardType: TextInputType.name,
                                  decoration: InputDecoration(
                                    prefixIcon: Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Icon(Icons.lock,
                                          color: CustomColors.accentColor),
                                    ),
                                    contentPadding:
                                        EdgeInsets.only(top: 22, left: 5),
                                    border: InputBorder.none,
                                    hintText: "Driving Licence No",
                                  ),
                                  validator: (v) {
                                    if (v!.isEmpty) {
                                      return "Driving Licence No is required";
                                    }
                                  },
                                ),
                              ),
                            )),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
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
                                  maxLength: 12,
                                  controller: aadharController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    counterText: "",
                                    prefixIcon: Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Icon(Icons.person_pin_outlined,
                                          color: CustomColors.accentColor),
                                    ),
                                    contentPadding:
                                        EdgeInsets.only(top: 22, left: 5),
                                    border: InputBorder.none,
                                    hintText: "Aadhar Card No",
                                  ),
                                  validator: (v) {
                                    if (v!.isEmpty) {
                                      return "Aadhar is required";
                                    }
                                  },
                                ),
                              ),
                            )),
                        const SizedBox(
                          height: 20,
                        ),
                        InkWell(
                          onTap: () => showExitPopup(),
                          child: Container(
                            height: 115,
                            width: 290,
                            decoration: BoxDecoration(
                                color: CustomColors.TransparentColor,
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.file_copy,
                                  color: CustomColors.accentColor,
                                ),
                                Text(
                                  'Upload(Driving Licence ID)*',
                                  style: TextStyle(color: Colors.red),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                imageFile == null ? SizedBox() : Container(
                                  height: 60,
                                  width: 200,
                                  child:ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.file(
                                        imageFile?? File(''),
                                        fit: BoxFit.fill,
                                      )),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 70.0),
                          child: SizedBox(
                              height: 45,
                              width: 270,
                              child: CustomElevatedButton(
                                text: 'SignUp',
                                icon: Icons.send,
                                onPressed: () {
                                  if(_formKey.currentState!.validate()){
                                    signUpApi();
                                  }
                                  else{
                                    Fluttertoast.showToast(msg: "All Fields are required");
                                  }
                                },
                              )),
                        ),
                        Container(
                          height: 50,
                          width: 290,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 38.0),
                            child: Row(
                              children: [
                                Text('Already have an Account?'),
                                TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  LoginScreen()));
                                    },
                                    child: Text(
                                      'Login',
                                      style: TextStyle(color: Colors.red),
                                    ))
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
