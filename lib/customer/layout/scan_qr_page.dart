// ignore_for_file: must_be_immutable, depend_on_referenced_packages, non_constant_identifier_names, avoid_print, unused_field, unused_local_variable, prefer_interpolation_to_compose_strings, unused_element, deprecated_member_use, use_build_context_synchronously

import 'dart:async';
import 'dart:io';
import 'package:find_bill/common/App_store.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:find_bill/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf_viewer_plugin/pdf_viewer_plugin.dart';
import 'package:url_launcher/url_launcher.dart';

class ScanQrPage extends StatefulWidget {
  ScanQrPage({super.key, required this.scanCode});
  String scanCode;
  @override
  State<ScanQrPage> createState() => _ScanQrPageState();
}

class _ScanQrPageState extends State<ScanQrPage> {
  late File pdf_file;
  bool isLoading = false;
  Map<String, dynamic> paymentJson = {};
  int? pages = 0;
  bool isReady = false;
  AppStore store = AppStore();
  String _scanBarcode = "Unknown";

  Future<void> scanQR() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }

  void loadNetwork() async {
    setState(() {
      isLoading = true;
    });
    var url = widget.scanCode;
    final response = await http.get(Uri.parse(url));
    final bytes = response.bodyBytes;
    final filename = basename(url);
    final dir = await getApplicationDocumentsDirectory();
    File file = File('${dir.path}/$filename');
    file.writeAsBytes(bytes, flush: true).then((value) {
      saveBill().then((v) {
        if (v.isNotEmpty) {
          setState(() {
            pdf_file = file;
            paymentJson = v;
            isLoading = false;
          });
        }
      });
    });
  }

  Future<Map<String, dynamic>> saveBill() async {
    Map<String, dynamic> json =
        await store.customerBillSaver(scanBarCode: widget.scanCode);
    return json;
  }

  @override
  void initState() {
    loadNetwork();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      if (isLoading) {
        return Scaffold(
          backgroundColor: AppTheme.backGroundColor,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: AppTheme.getMobileWidth(context) / 15,
                  width: AppTheme.getMobileWidth(context) / 15,
                  child: const CircularProgressIndicator(
                      strokeWidth: 3, color: AppTheme.nearlyBlue),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  child: Text("Wait a sec",
                      style: AppTheme.titleText(
                          size: AppTheme.getMobileWidth(context) / 18,
                          color: AppTheme.nearlyGrey,
                          weight: FontWeight.bold)),
                ),
                Container(
                  alignment: Alignment.center,
                  child: Text("Parsing your pdf",
                      style: AppTheme.titleText(
                          size: AppTheme.getMobileWidth(context) / 28,
                          color: AppTheme.nearlyGrey.withOpacity(0.8),
                          weight: FontWeight.w500)),
                ),
              ],
            ),
          ),
        );
      } else {
        return buildWidget(context);
      }
    });
  }

  Widget buildWidget(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backGroundColor,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SizedBox(
          height: AppTheme.getMobileWidth(context) / 8,
          child: ElevatedButton(
              onPressed: () {
                scanQR().then((value) async {
                  String gpayUrl = "$_scanBarcode&am=" + paymentJson["total"];
                  bool result = await launch(gpayUrl);
                  if (result) {
                    Fluttertoast.showToast(
                        msg: "Successful payment",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: AppTheme.darkishGrey,
                        textColor: Colors.white,
                        fontSize: AppTheme.getMobileWidth(context) / 30);
                  }
                });
              },
              style: AppTheme.buttonStyle(backColor: AppTheme.nearlyBlue),
              child: Text(
                "Pay using UPI",
                style: AppTheme.titleText(
                    color: AppTheme.backGroundColor,
                    size: AppTheme.getMobileWidth(context) / 20,
                    weight: FontWeight.bold),
              )),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: AppTheme.darkishGrey,
        elevation: 0.0,
        automaticallyImplyLeading: true,
        title: Text(
          "Scan QR",
          style: AppTheme.titleText(
              color: AppTheme.darkishGrey,
              size: AppTheme.getMobileWidth(context) / 20,
              weight: FontWeight.bold),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              "PDF Copy of Bill",
              style: AppTheme.titleText(
                  color: AppTheme.nearlyBlue,
                  size: AppTheme.getMobileWidth(context) / 14,
                  weight: FontWeight.bold),
            ),
          ),
          Container(
            height: 0.4,
            margin:
                const EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
            width: AppTheme.getMobileWidth(context),
            color: AppTheme.nearlyGrey.withOpacity(0.6),
          ),
          Expanded(
            child: PdfView(path: pdf_file.path),
          ),
        ],
      ),
    );
  }
}
