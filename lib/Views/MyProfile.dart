import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jdx/Views/EditProfile.dart';

import '../CustomWidgets/CustomElevetedButton.dart';
import '../Models/GetProfileModel.dart';

class Myprofile extends StatefulWidget {
  GetProfileModel? getProfileModel;
  Myprofile({this.getProfileModel});

  @override
  State<Myprofile> createState() => _MyprofileState();
}

class _MyprofileState extends State<Myprofile> {
  @override
  Widget build(BuildContext context) {
    print('${widget.getProfileModel!.data![0].drivingLicencePhoto}____');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF222443),
        title: Text('My Profile'),
        toolbarHeight: 150,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          children: [
            const SizedBox(
              height: 80,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('User Name'),
                  Text('${widget.getProfileModel!.data![0].userFullname}'),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Email id'),
                  Text('${widget.getProfileModel!.data![0].userEmail}'),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Mobile Number'),
                  Text('${widget.getProfileModel!.data![0].userPhone}'),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Vhicle Number'),
                  Text('${widget.getProfileModel!.data![0].vehicleNo}'),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Vhicle Type'),
                  Text('${widget.getProfileModel!.data![0].vehicleType}'),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Driving Licence No.'),
                  Text('${widget.getProfileModel!.data![0].drivingLicenceNo}'),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Driving Licence Photo'),
                  widget.getProfileModel!.data![0].drivingLicencePhoto ==
                              null ||
                          widget.getProfileModel!.data![0]
                                  .drivingLicencePhoto ==
                              ""
                      ? SizedBox(
                          height: 100,
                          width: 180,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.asset(
                                  "assets/images/profileImage.jpg")))
                      : SizedBox(
                          height: 80,
                          width: 180,
                          child: Image.network(
                              "${widget.getProfileModel!.data![0].drivingLicencePhoto}")),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 100.0),
              child: SizedBox(
                width: 280,
                height: 43,
                child: CustomElevatedButton(
                  text: 'Update Profile',
                  icon: Icons.person,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditProfile(
                                getProfileModel: widget.getProfileModel))).then((value) {
                                  if(value.toString().isNotEmpty){
                                    Navigator.pop(context);
                                  }
                    });
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
