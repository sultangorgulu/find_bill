// ignore_for_file: prefer_const_constructors, avoid_print, unused_field, must_be_immutable, non_constant_identifier_names, avoid_function_literals_in_foreach_calls, unused_local_variable

import 'package:find_bill/home/layout/bill_generator_page.dart';
import 'package:find_bill/home/models/verified_user.dart';
import 'package:find_bill/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class Home extends StatefulWidget {
  Home({super.key, required this.user});
  VerifiedUser user;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

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
                      "assets/images/dreamer.png",
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
                      child: Text("Start Scanning",
                          style: AppTheme.titleText(
                              size: AppTheme.getMobileWidth(context) / 11,
                              color: AppTheme.darkishGrey,
                              weight: FontWeight.bold)),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text("Generate Qr-bill using barcode Scanner",
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
                ElevatedButton(
                    onPressed: () {
                      PersistentNavBarNavigator.pushNewScreen(context,
                          screen: BillGeneratorPage(),
                          withNavBar: false,
                          pageTransitionAnimation: PageTransitionAnimation.scale);
                    },
                    style: AppTheme.buttonStyle(
                      backColor: AppTheme.nearlyBlue,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 7),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/images/barcode.png",
                            height: AppTheme.getMobileWidth(context) / 4,
                            width: AppTheme.getMobileWidth(context) / 4,
                            color: AppTheme.backGroundColor,
                          ),
                          SizedBox(
                            width: AppTheme.getMobileWidth(context) / 2.25,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text("Scan Barcode",
                                    style: AppTheme.titleText(
                                        size: AppTheme.getMobileWidth(context) / 16,
                                        color: AppTheme.darkishGrey,
                                        weight: FontWeight.bold)),
                                Text(
                                    "Make sure that the barcode fits within the frame of the scanner.",
                                    textAlign: TextAlign.end,
                                    style: AppTheme.subtitleText(
                                        size: AppTheme.getMobileWidth(context) / 31,
                                        color: AppTheme.backGroundColor,
                                        weight: FontWeight.w600))
                              ],
                            ),
                          )
                        ],
                      ),
                    )),
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
                      child: Text("Current Stock",
                          style: AppTheme.titleText(
                              size: AppTheme.getMobileWidth(context) / 11,
                              color: AppTheme.darkishGrey,
                              weight: FontWeight.bold)),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                          "View availability of products in your inventory.",
                          style: AppTheme.subtitleText(
                              size: AppTheme.getMobileWidth(context) / 27,
                              color: AppTheme.nearlyGrey,
                              weight: FontWeight.w500)),
                    ),
                  ],
                ),
              ],
            ),
          )),
    );
  }
}
