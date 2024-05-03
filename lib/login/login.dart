import 'package:find_bill/login/layout/login_page.dart';
import 'package:find_bill/register/register.dart';
import 'package:find_bill/utils/app_theme.dart';
import 'package:flutter/material.dart';


class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: AppTheme.backGroundColor,
        resizeToAvoidBottomInset: false,
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(bottom: 50, right: 10, left: 10),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: SizedBox(
                height: AppTheme.getMobileWidth(context) / 8,
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return LoginPage();
                      }));
                    },
                    style: AppTheme.buttonStyle(backColor: AppTheme.nearlyBlue),
                    child: Text("LOGIN",
                        style: AppTheme.subtitleText(
                            color: AppTheme.backGroundColor,
                            size: AppTheme.getMobileWidth(context) / 25,
                            weight: FontWeight.bold))),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: SizedBox(
                height: AppTheme.getMobileWidth(context) / 8,
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return Register();
                      }));
                    },
                    style: AppTheme.buttonStyle(
                        backColor: AppTheme.backGroundColor,
                        borderColor: AppTheme.nearlyBlue),
                    child: Text("SIGNUP",
                        style: AppTheme.subtitleText(
                            color: AppTheme.nearlyBlue,
                            size: AppTheme.getMobileWidth(context) / 25,
                            weight: FontWeight.bold))),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
          ]),
        ),
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Center(
                child: SizedBox(
                  width: AppTheme.getMobileWidth(context),
                  height: AppTheme.getMobileHeight(context) * 0.6,
                  child: Image.asset('assets/images/money.png'),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    children: [
                      Text(
                        "Reliable and Fast to use",
                        style: AppTheme.titleText(
                            size: AppTheme.getMobileWidth(context) / 15,
                            weight: FontWeight.bold),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Text(
                          "Let us manage all your inventories with just one click.",
                          textAlign: TextAlign.center,
                          style: AppTheme.subtitleText(
                              size: AppTheme.getMobileWidth(context) / 27,
                              weight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
