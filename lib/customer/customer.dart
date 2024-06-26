// ignore_for_file: prefer_const_constructors, must_be_immutable, unused_field, non_constant_identifier_names, prefer_final_fields, nullable_type_in_catch_clause, unused_local_variable

import 'package:find_bill/common/App_store.dart';
import 'package:find_bill/customer/layout/scan_qr_page.dart';
import 'package:find_bill/home/models/verified_user.dart';
import 'package:find_bill/utils/app_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../analysis/customer_line_chart_page.dart';

class Customer extends StatefulWidget {
  Customer({super.key, required this.user});
  VerifiedUser user;
  @override
  State<Customer> createState() => _CustomerState();
}

class _CustomerState extends State<Customer> {
  String _scanBarcode = 'Unknown';
  Map<String, dynamic> identifier_dict = {};
  AppStore store = AppStore();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backGroundColor,
      body: SafeArea(
          child: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: AppTheme.getMobileWidth(context) / 2.5,
                  child: RichText(
                      text: TextSpan(children: [
                    TextSpan(
                        text: "Hi,",
                        style: AppTheme.titleText(
                            size: AppTheme.getMobileWidth(context) * 0.12,
                            color: AppTheme.nearlyBlue,
                            weight: FontWeight.bold)),
                    TextSpan(
                        text: "\n${widget.user.name}",
                        style: AppTheme.titleText(
                            size: AppTheme.getMobileWidth(context) / 15,
                            color: AppTheme.nearlyGrey,
                            weight: FontWeight.bold))
                  ])),
                ),
                Image.asset(
                  "assets/images/money_qr.png",
                  height: AppTheme.getMobileWidth(context) / 2.5,
                  width: AppTheme.getMobileWidth(context) / 2.2,
                )
              ],
            ),
            Container(
              height: 0.4,
              margin: EdgeInsets.only(top: 10, bottom: 10),
              width: AppTheme.getMobileWidth(context),
              color: AppTheme.nearlyGrey.withOpacity(0.6),
            ),
            Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(top: 10),
                  child: Text("Scan QR",
                      style: AppTheme.titleText(
                          size: AppTheme.getMobileWidth(context) / 11,
                          color: AppTheme.darkishGrey,
                          weight: FontWeight.bold)),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text("Scan your bills and save it to your profile.",
                      style: AppTheme.subtitleText(
                          size: AppTheme.getMobileWidth(context) / 27,
                          color: AppTheme.nearlyGrey,
                          weight: FontWeight.w500)),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: ElevatedButton(
                  onPressed: () {
                    scanQR().then((value) {
                      if (_scanBarcode != "-1" &&
                          (_scanBarcode.startsWith("https://ipfs.io/ipfs/"))) {
                        PersistentNavBarNavigator.pushNewScreen(context,
                            screen: ScanQrPage(scanCode: _scanBarcode),
                            withNavBar: false,
                            pageTransitionAnimation:
                                PageTransitionAnimation.scale);
                      } else {
                        Fluttertoast.showToast(
                            msg: "Please Scan a valid QR to show your Bill ",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: AppTheme.darkishGrey,
                            textColor: Colors.white,
                            fontSize: AppTheme.getMobileWidth(context) / 30);
                      }
                    });
                  },
                  style: AppTheme.buttonStyle(
                    backColor: AppTheme.nearlyBlue,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 7, top: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/images/qr.png",
                          height: AppTheme.getMobileWidth(context) / 4,
                          width: AppTheme.getMobileWidth(context) / 4,
                          color: AppTheme.backGroundColor,
                        ),
                        SizedBox(
                          width: AppTheme.getMobileWidth(context) / 2.25,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text("Scan QR",
                                  textAlign: TextAlign.center,
                                  style: AppTheme.titleText(
                                      size:
                                          AppTheme.getMobileWidth(context) / 16,
                                      color: AppTheme.darkishGrey,
                                      weight: FontWeight.bold)),
                              Text(
                                  "Make sure that the QR fits within the frame of the scanner.",
                                  textAlign: TextAlign.center,
                                  style: AppTheme.subtitleText(
                                      size:
                                          AppTheme.getMobileWidth(context) / 31,
                                      color: AppTheme.backGroundColor,
                                      weight: FontWeight.w600))
                            ],
                          ),
                        )
                      ],
                    ),
                  )),
            ),
            Container(
              height: 0.4,
              margin: EdgeInsets.only(top: 30, bottom: 10),
              width: AppTheme.getMobileWidth(context),
              color: AppTheme.nearlyGrey.withOpacity(0.6),
            ),
            Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(top: 10),
                  child: Text("Spendings",
                      style: AppTheme.titleText(
                          size: AppTheme.getMobileWidth(context) / 11,
                          color: AppTheme.darkishGrey,
                          weight: FontWeight.bold)),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text("View all your spendings, analytics and data.",
                      style: AppTheme.subtitleText(
                          size: AppTheme.getMobileWidth(context) / 27,
                          color: AppTheme.nearlyGrey,
                          weight: FontWeight.w500)),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: store.getCustomerSpendings(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.data() != null) {
                      int totalSpends = 0;
                      snapshot.data!.data()!.forEach((key, value) {
                        totalSpends += int.parse(value["total"]);
                      });
                      int total_bills = snapshot.data!.data()!.length;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text("Total Spendings",
                                style: AppTheme.titleText(
                                    size: AppTheme.getMobileWidth(context) / 21,
                                    color: AppTheme.nearlyBlue,
                                    weight: FontWeight.w700)),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.only(bottom: 10),
                            child: Text("₹ $totalSpends",
                                style: AppTheme.titleText(
                                    size: AppTheme.getMobileWidth(context) / 16,
                                    color: AppTheme.darkishGrey,
                                    weight: FontWeight.bold)),
                          ),
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: AppTheme.nearlyGrey.withOpacity(0.2),
                                )),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text("Total bills",
                                          style: AppTheme.titleText(
                                              size: AppTheme.getMobileWidth(
                                                      context) /
                                                  26,
                                              color: AppTheme.nearlyBlue,
                                              weight: FontWeight.w600)),
                                    ),
                                    Container(
                                      alignment: Alignment.centerRight,
                                      child: Text(total_bills.toString(),
                                          style: AppTheme.titleText(
                                              size: AppTheme.getMobileWidth(
                                                      context) /
                                                  24,
                                              color: AppTheme.darkishGrey,
                                              weight: FontWeight.bold)),
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      alignment: Alignment.centerRight,
                                      child: Text("Average order value",
                                          style: AppTheme.titleText(
                                              size: AppTheme.getMobileWidth(
                                                      context) /
                                                  26,
                                              color: AppTheme.nearlyBlue,
                                              weight: FontWeight.w600)),
                                    ),
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                          "₹ ${(totalSpends / total_bills).round()}",
                                          style: AppTheme.titleText(
                                              size: AppTheme.getMobileWidth(
                                                      context) /
                                                  24,
                                              color: AppTheme.darkishGrey,
                                              weight: FontWeight.bold)),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      );
                    } else {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text("Total Spendings",
                                style: AppTheme.titleText(
                                    size: AppTheme.getMobileWidth(context) / 21,
                                    color: AppTheme.nearlyBlue,
                                    weight: FontWeight.w700)),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.only(bottom: 10),
                            child: Text("₹ 0000",
                                style: AppTheme.titleText(
                                    size: AppTheme.getMobileWidth(context) / 16,
                                    color: AppTheme.darkishGrey,
                                    weight: FontWeight.bold)),
                          ),
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: AppTheme.nearlyGrey.withOpacity(0.2),
                                )),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text("Total bills",
                                          style: AppTheme.titleText(
                                              size: AppTheme.getMobileWidth(
                                                      context) /
                                                  26,
                                              color: AppTheme.nearlyBlue,
                                              weight: FontWeight.w600)),
                                    ),
                                    Container(
                                      alignment: Alignment.centerRight,
                                      child: Text("0000",
                                          style: AppTheme.titleText(
                                              size: AppTheme.getMobileWidth(
                                                      context) /
                                                  24,
                                              color: AppTheme.darkishGrey,
                                              weight: FontWeight.bold)),
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      alignment: Alignment.centerRight,
                                      child: Text("Average order value",
                                          style: AppTheme.titleText(
                                              size: AppTheme.getMobileWidth(
                                                      context) /
                                                  26,
                                              color: AppTheme.nearlyBlue,
                                              weight: FontWeight.w600)),
                                    ),
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text("₹ 00",
                                          style: AppTheme.titleText(
                                              size: AppTheme.getMobileWidth(
                                                      context) /
                                                  24,
                                              color: AppTheme.darkishGrey,
                                              weight: FontWeight.bold)),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      );
                    }
                  } else {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text("Total Spendings",
                              style: AppTheme.titleText(
                                  size: AppTheme.getMobileWidth(context) / 21,
                                  color: AppTheme.nearlyBlue,
                                  weight: FontWeight.w700)),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.only(bottom: 10),
                          child: Text("₹ 0000",
                              style: AppTheme.titleText(
                                  size: AppTheme.getMobileWidth(context) / 16,
                                  color: AppTheme.darkishGrey,
                                  weight: FontWeight.bold)),
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: AppTheme.nearlyGrey.withOpacity(0.2),
                              )),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    child: Text("Total bills",
                                        style: AppTheme.titleText(
                                            size: AppTheme.getMobileWidth(
                                                    context) /
                                                26,
                                            color: AppTheme.nearlyBlue,
                                            weight: FontWeight.w600)),
                                  ),
                                  Container(
                                    alignment: Alignment.centerRight,
                                    child: Text("0000",
                                        style: AppTheme.titleText(
                                            size: AppTheme.getMobileWidth(
                                                    context) /
                                                24,
                                            color: AppTheme.darkishGrey,
                                            weight: FontWeight.bold)),
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    alignment: Alignment.centerRight,
                                    child: Text("Average order value",
                                        style: AppTheme.titleText(
                                            size: AppTheme.getMobileWidth(
                                                    context) /
                                                26,
                                            color: AppTheme.nearlyBlue,
                                            weight: FontWeight.w600)),
                                  ),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    child: Text("₹ 00",
                                        style: AppTheme.titleText(
                                            size: AppTheme.getMobileWidth(
                                                    context) /
                                                24,
                                            color: AppTheme.darkishGrey,
                                            weight: FontWeight.bold)),
                                  )
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    );
                  }
                }),
            SizedBox(
              height: 20,
            ),
            Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(bottom: 10),
                  child: Text("SPENDINGS OVER TIME",
                      style: AppTheme.titleText(
                          size: AppTheme.getMobileWidth(context) / 23,
                          color: AppTheme.darkishGrey,
                          weight: FontWeight.w700)),
                ),
                SizedBox(
                  height: AppTheme.getMobileHeight(context) * 0.4,
                  width: AppTheme.getMobileWidth(context),
                  child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                    stream: store.getCustomerGraph(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data!.data() != null) {
                          List<FlSpot> plotPts = [];
                          var bufferHelper = {};
                          var helperList = [];
                          snapshot.data!.data()!.forEach((key, value) => {
                                bufferHelper[
                                        DateTime.fromMillisecondsSinceEpoch(
                                                int.parse(key))
                                            .minute
                                            .toString()] =
                                    value["total"].toString(),
                                helperList.add(
                                    DateTime.fromMillisecondsSinceEpoch(
                                            int.parse(key))
                                        .minute),
                              });
                          helperList.sort();
                          for (var element in helperList) {
                            plotPts.add(FlSpot(
                                double.parse(element.toString()),
                                double.parse(bufferHelper[element.toString()]
                                    .toString())));
                          }
                          return LineChartCustomer(plotPts);
                        } else {
                          return Center(
                              child: Text("No Data for analysis",
                                  style: AppTheme.subtitleText(
                                      size:
                                          AppTheme.getMobileWidth(context) / 26,
                                      color: AppTheme.darkishGrey,
                                      weight: FontWeight.w500)));
                        }
                      } else {
                        return Text("No Data for analysis",
                            style: AppTheme.subtitleText(
                                size: AppTheme.getMobileWidth(context) / 26,
                                color: AppTheme.darkishGrey,
                                weight: FontWeight.w500));
                      }
                    },
                  ),
                )
              ],
            ),
          ],
        ),
      )),
    );
  }
}
