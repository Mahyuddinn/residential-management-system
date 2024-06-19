import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:residential_management_system/features/View/securityHomepage.dart';

class SecurityScanQr extends StatefulWidget {
  const SecurityScanQr({super.key});

  @override
  State<SecurityScanQr> createState() => _SecurityScanQrState();
}

class _SecurityScanQrState extends State<SecurityScanQr> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String? qrCodeResult;

  @override
  void reassemble() {
    super.reassemble();
    if (controller != null) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Code Scanner'),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
                borderColor: Colors.red,
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: 300,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Text(
                'Scan the QR code to validate the visitor',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
          qrCodeResult != null
              ? Expanded(
                  flex: 1,
                  child: Center(
                    child: Text(
                      'QR Code Result: $qrCodeResult',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                )
              : SizedBox.shrink(),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        qrCodeResult = scanData.code;
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}

