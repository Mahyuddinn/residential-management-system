import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

final qrImageKey = GlobalKey();

class QrImagePage extends StatelessWidget {
  final String data;
  final String visitorId;
  final double? size;

  const QrImagePage(this.data, this.visitorId, this.size, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Log the data being used to generate the QR code
    print('Generating QR Code with Data: $data');

    return Scaffold(
      appBar: _buildAppBar(context),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RepaintBoundary(
              key: qrImageKey,
              child: Container(
                child: QrImageView(
                  data: data,
                  size: size,
                ),
              ),
            ),
            /*QrImageView(
              key: qrImageKey,
              data: data,
              size: size,
            ),*/
            SizedBox(
              height: 40,
            ),
            ElevatedButton(
              onPressed: () async {
                //capture the QR code image and upload to Firebase Storage
                RenderRepaintBoundary boundary = qrImageKey.currentContext!
                    .findRenderObject() as RenderRepaintBoundary;
                ui.Image image = await boundary.toImage(pixelRatio: 3.0);
                ByteData byteData =
                    (await image.toByteData(format: ui.ImageByteFormat.png))!;
                Uint8List pngBytes = byteData.buffer.asUint8List();

                //save QR code image to a temporary file
                final tempDir = await getTemporaryDirectory();
                final file = await File('${tempDir.path}/qrcode.png').create();
                file.writeAsBytesSync(pngBytes);

                //upload QR code image to firebase storage
                final storageRef = FirebaseStorage.instance
                    .ref()
                    .child('qr_codes/$visitorId.png');
                await storageRef.putFile(file);
                /*final storageRef = FirebaseStorage.instance
                      .ref()
                      .child('qrcodes/${DateTime.now().microsecondsSinceEpoch}.png');
                final UploadTask = storageRef.putData(pngBytes);
                final snapshot = await UploadTask.whenComplete(() {});
                final downloadUrl = await snapshot.ref.getDownloadURL();

                print('QR code image url: $downloadUrl');*/

                //Share the QR code image
                final xFile = XFile.fromData(pngBytes, mimeType: 'image/png');
                await Share.shareXFiles([xFile],
                    subject: 'QR Code Image', text: 'QR Code Image');
              },
              child: Text(
                'Share',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Colors.lightGreenAccent[700])),
            ),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        'Purpose of Visit',
        style: TextStyle(
          fontSize: 20.0,
          color: Colors.white,
        ),
      ),
      centerTitle: true,
      backgroundColor: Colors.redAccent[700],
      elevation: 0.0,
    );
  }
}
