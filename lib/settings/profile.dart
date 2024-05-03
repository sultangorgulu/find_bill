// ignore_for_file: must_be_immutable

import 'package:find_bill/home/models/verified_user.dart';
import 'package:find_bill/login/login.dart';
import 'package:find_bill/settings/widgets/profile_menu_widget.dart';
import 'package:find_bill/utils/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  Profile({super.key, required this.user});
  VerifiedUser user;

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppTheme.backGroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.backGroundColor,
        foregroundColor: AppTheme.darkishGrey,
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          "Profile",
          style: AppTheme.titleText(
              size: size / 15,
              weight: FontWeight.bold,
              color: AppTheme.darkishGrey),
        ),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  margin: const EdgeInsets.only(top: 40, bottom: 20),
                  height: size / 3.5,
                  width: size / 3.5,
                  alignment: Alignment.topCenter,
                  decoration: BoxDecoration(
                      color: AppTheme.nearlyBlue.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(size / 7)),
                  child: Center(
                    child: Icon(
                      CupertinoIcons.person_solid,
                      size: size / 5.5,
                      color: AppTheme.darkishGrey,
                    ),
                  )),
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(bottom: 0),
                child: Text(
                  widget.user.name!,
                  style: AppTheme.titleText(
                      size: size / 18,
                      weight: FontWeight.bold,
                      color: AppTheme.darkishGrey),
                ),
              ),
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(bottom: 20),
                child: Text(
                  widget.user.email!,
                  style: AppTheme.subtitleText(
                      size: size / 25,
                      weight: FontWeight.w600,
                      color: AppTheme.nearlyGrey.withOpacity(0.5)),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const Divider(),
                    ProfileMenuWidget(
                      onTap: () {},
                      size: size,
                      title: "Settings",
                      titleColor: AppTheme.darkishGrey,
                      iconData: CupertinoIcons.settings,
                    ),
                    ProfileMenuWidget(
                      onTap: () {},
                      size: size,
                      title: "Profile Management",
                      titleColor: AppTheme.darkishGrey,
                      iconData:
                          CupertinoIcons.person_crop_circle_badge_checkmark,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Divider(),
                    const SizedBox(
                      height: 20,
                    ),
                    ProfileMenuWidget(
                      onTap: () {},
                      size: size,
                      title: "Information",
                      titleColor: AppTheme.darkishGrey,
                      iconData: CupertinoIcons.info,
                    ),
                    ProfileMenuWidget(
                      onTap: () async {
                        SharedPreferences pref =
                            await SharedPreferences.getInstance();
                        pref.remove("session").then((value) {
                          PersistentNavBarNavigator.pushNewScreen(context,
                              screen: const Login(),
                              withNavBar: false,
                              pageTransitionAnimation:
                                  PageTransitionAnimation.scale);
                        });
                      },
                      size: size,
                      endIcon: false,
                      title: "Logout",
                      titleColor: Colors.redAccent,
                      iconData: CupertinoIcons.power,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
