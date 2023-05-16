import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:jdx/CustomWidgets/CustomElevetedButton.dart';
import 'package:jdx/Models/order_history_response.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share/share.dart';

class ShareQRCode extends StatefulWidget {
  const ShareQRCode({Key? key, this.parcel, this.qrimage}) : super(key: key);

  final ParcelDetail? parcel;
  final String? qrimage;

  @override
  State<ShareQRCode> createState() => _ShareQRCodeState();
}

class _ShareQRCodeState extends State<ShareQRCode> {
  @override
  ScreenshotController screenshotController = ScreenshotController();
  final TextEditingController tfController = TextEditingController();

  String baseURL = 'https://developmentalphawizz.com/JDX/api/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        title: const Text('Share Your Parcel QR'),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView(
          children: [
                 Screenshot(
                controller: screenshotController,
                child: widget.qrimage == null ? Image.asset('assets/images/jdx_logo.png') :Image.network('${baseURL}${widget.parcel?.barcodeLink ??''}') ),
            const SizedBox(height: 20),

            const SizedBox(height: 20),
            /*ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 12),
                backgroundColor: Colors.blue,
                textStyle: TextStyle(color: Colors.white,)
                ,),
              child: Text('Generate QR Code'),
              onPressed: () => setState(() {}),

            ),*/
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: CustomElevatedButton(
                text: 'Share QR Code',
                icon: Icons.qr_code,
                onPressed: () {

                    _shareQrCode();

                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  _shareQrCode() async {
    PermissionStatus storagePermission = await Permission.storage.request();
    if (storagePermission == PermissionStatus.granted) {
      final directory = (await getApplicationDocumentsDirectory()).path;
      screenshotController.capture().then((Uint8List? image) async {
        if (image != null) {
          try {
            String fileName = DateTime.now().microsecondsSinceEpoch.toString();
            final imagePath = await File('$directory/$fileName.png').create();
            if (imagePath != null) {
              await imagePath.writeAsBytes(image);
              Share.shareFiles([imagePath.path]);
            }
          } catch (error) {}
        }
      }).catchError((onError) {
        print('Error --->> $onError');
      });
    }else if (storagePermission == PermissionStatus.denied) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('This Permission is recommended')));

    } else if (storagePermission == PermissionStatus.permanentlyDenied) {
      openAppSettings().then((value) {

      });
    }

  }
}
