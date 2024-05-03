// ignore_for_file: non_constant_identifier_names, must_be_immutable, unnecessary_null_comparison, unused_field

import 'package:find_bill/app/app.dart';
import 'package:find_bill/common/App_store.dart';
import 'package:find_bill/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrGeneratorPage extends StatefulWidget {
  QrGeneratorPage({super.key, required this.cid_data});
  String cid_data;
  @override
  State<QrGeneratorPage> createState() => _QrGeneratorPageState();
}

class _QrGeneratorPageState extends State<QrGeneratorPage> {
  AppStore store = AppStore();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: AppTheme.backGroundColor,
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SizedBox(
            height: AppTheme.getMobileWidth(context) / 8,
            child: ElevatedButton(
                onPressed: () {
                  PersistentNavBarNavigator.pushNewScreen(context,
                      screen: const App(),
                      pageTransitionAnimation: PageTransitionAnimation.scale);
                },
                style: AppTheme.buttonStyle(backColor: AppTheme.nearlyBlue),
                child: Text(
                  "DONE",
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
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(
            "QR Bill",
            style: AppTheme.titleText(
                color: AppTheme.nearlyBlue,
                size: AppTheme.getMobileWidth(context) / 13,
                weight: FontWeight.bold),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: FutureBuilder(
                    future: store.getUserDetails(),
                    builder: (_, snapshot) {
                      if (snapshot.hasData && snapshot != null) {
                        return SizedBox(
                          width: AppTheme.getMobileWidth(context),
                          child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(children: [
                                TextSpan(
                                    text: snapshot.data!.name,
                                    style: AppTheme.titleText(
                                        size: AppTheme.getMobileWidth(context) /
                                            16,
                                        color: AppTheme.darkishGrey,
                                        weight: FontWeight.bold)),
                                TextSpan(
                                    text: "\n${snapshot.data!.email}",
                                    style: AppTheme.subtitleText(
                                        size: AppTheme.getMobileWidth(context) /
                                            28,
                                        color:
                                            AppTheme.nearlyGrey.withOpacity(0.8),
                                        weight: FontWeight.w500))
                              ])),
                        );
                      } else {
                        return RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(children: [
                              TextSpan(
                                  text: "User",
                                  style: AppTheme.titleText(
                                      size:
                                          AppTheme.getMobileWidth(context) / 16,
                                      color: AppTheme.darkishGrey,
                                      weight: FontWeight.bold)),
                              TextSpan(
                                  text: "\nuser@gmail.com",
                                  style: AppTheme.subtitleText(
                                      size:
                                          AppTheme.getMobileWidth(context) / 28,
                                      color:
                                          AppTheme.nearlyGrey.withOpacity(0.8),
                                      weight: FontWeight.w500))
                            ]));
                      }
                    }),
              ),
              SizedBox(
                height: AppTheme.getMobileWidth(context) / 10,
              ),
              QrImage(
                data: widget.cid_data,
                size: AppTheme.getMobileHeight(context) * 0.33,
              ),
              Container(
                margin: const EdgeInsets.only(top: 20),
                width: AppTheme.getMobileWidth(context) / 1.3,
                alignment: Alignment.center,
                child: Text(
                  "Scan QR with your mobile phone or with the help of our App to get your Qr-Bill.",
                  textAlign: TextAlign.center,
                  style: AppTheme.subtitleText(
                      color: AppTheme.nearlyGrey,
                      size: AppTheme.getMobileWidth(context) / 28,
                      weight: FontWeight.w600),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
