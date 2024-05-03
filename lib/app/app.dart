// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, library_private_types_in_public_api
import 'package:find_bill/common/App_store.dart';
import 'package:find_bill/customer/customer.dart';
import 'package:find_bill/home/home.dart';
import 'package:find_bill/home/models/verified_user.dart';
import 'package:find_bill/settings/profile.dart';
import 'package:find_bill/utils/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../bills/bills.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);
  AppStore store = AppStore();
  bool loader = false;
  late VerifiedUser user;

  @override
  void initState() {
    getUserDetails();
    super.initState();
  }

  getUserDetails() {
    setState(() {
      loader = true;
    });
    store.getUserDetails().then((value) {
      setState(() {
        loader = false;
      });
      user = value!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      if (loader) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Scaffold(
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
                    child: Text("Rolling In",
                        style: AppTheme.titleText(
                            size: AppTheme.getMobileWidth(context) / 18,
                            color: AppTheme.nearlyGrey,
                            weight: FontWeight.bold)),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Text("Gathering stuffs!",
                        style: AppTheme.titleText(
                            size: AppTheme.getMobileWidth(context) / 28,
                            color: AppTheme.nearlyGrey.withOpacity(0.8),
                            weight: FontWeight.w500)),
                  ),
                ],
              ),
            ),
          ),
        );
      } else {
        return buildWidget(context);
      }
    });
  }

  Widget buildWidget(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: PersistentTabView(
        context,
        backgroundColor: AppTheme.backGroundColor,
        screenTransitionAnimation: const ScreenTransitionAnimation(
          animateTabTransition: true,
          curve: Curves.easeIn,
        ),
        decoration: NavBarDecoration(
            border:
                Border(top: BorderSide(color: Colors.grey.withOpacity(0.2)))),
        screens: [
          Home(
            user: user,
          ),
          BillingHistory(),
          Profile(
            user: user,
          ),
        ],
        items: [
          PersistentBottomNavBarItem(
              icon: Icon(CupertinoIcons.house,
                  size: AppTheme.getMobileWidth(context) / 17),
              inactiveColorPrimary: Colors.grey,
              activeColorSecondary: Colors.white,
              activeColorPrimary: AppTheme.nearlyBlue,
              title: "Home",
              textStyle: AppTheme.subtitleText(
                  size: AppTheme.getMobileWidth(context) / 30,
                  weight: FontWeight.w600)),
          PersistentBottomNavBarItem(
              icon: Icon(
                Icons.history_sharp,
                size: AppTheme.getMobileWidth(context) / 17,
              ),
              inactiveColorPrimary: Colors.grey,
              activeColorSecondary: Colors.white,
              activeColorPrimary: AppTheme.nearlyBlue,
              title: "Bills",
              textStyle: AppTheme.subtitleText(
                  size: AppTheme.getMobileWidth(context) / 30,
                  weight: FontWeight.w600)),
          PersistentBottomNavBarItem(
              icon: Icon(
                CupertinoIcons.settings,
                size: AppTheme.getMobileWidth(context) / 17,
              ),
              inactiveColorPrimary: Colors.grey,
              activeColorSecondary: Colors.white,
              activeColorPrimary: AppTheme.nearlyBlue,
              title: "Settings",
              textStyle: AppTheme.subtitleText(
                  size: AppTheme.getMobileWidth(context) / 30,
                  weight: FontWeight.w600)),
        ],
        controller: _controller,
        confineInSafeArea: true,
        handleAndroidBackButtonPress: true,
        resizeToAvoidBottomInset: true,
        stateManagement: true,
        hideNavigationBarWhenKeyboardShows: false,
        popAllScreensOnTapOfSelectedTab: true,
        popActionScreens: PopActionScreensType.all,
        navBarStyle: NavBarStyle.style10,
      ),
    );
  }
}
