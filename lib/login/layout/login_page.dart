// ignore_for_file: unused_field

import 'package:find_bill/app/app.dart';
import 'package:find_bill/login/widgets/forgot_pas_widget.dart';
import 'package:find_bill/register/register.dart';
import 'package:find_bill/register/service/register_service.dart';
import 'package:find_bill/utils/app_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading1 = false;
  bool isLoading2 = false;
  bool obscureText = true;
  RegisterService service = RegisterService();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: AppTheme.backGroundColor,
        resizeToAvoidBottomInset: false,
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Don't have an Account?",
                style: AppTheme.subtitleText(
                    size: AppTheme.getMobileWidth(context) / 28,
                    weight: FontWeight.w500,
                    color: AppTheme.darkishGrey),
              ),
              const SizedBox(
                width: 5,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                    return const Register();
                  }));
                },
                child: Text(
                  "Sign-up",
                  style: AppTheme.subtitleText(
                      size: AppTheme.getMobileWidth(context) / 28,
                      weight: FontWeight.bold,
                      color: AppTheme.nearlyBlue),
                ),
              )
            ],
          ),
        ),
        body: SafeArea(
            child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: AppTheme.getMobileWidth(context) * 0.55,
                width: AppTheme.getMobileWidth(context) * 0.55,
                alignment: Alignment.topLeft,
                child: Image.asset("assets/images/mobile.png"),
              ),
              Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Welcome Back,",
                      textDirection: TextDirection.ltr,
                      style: AppTheme.titleText(
                          letterSpacing: -1,
                          size: AppTheme.getMobileWidth(context) / 12.5,
                          weight: FontWeight.bold,
                          color: AppTheme.darkishGrey),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Have a nice day!",
                      textDirection: TextDirection.ltr,
                      style: AppTheme.titleText(
                          size: AppTheme.getMobileWidth(context) / 24,
                          weight: FontWeight.w500,
                          color: AppTheme.nearlyGrey.withOpacity(0.7)),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(
                      width: AppTheme.getMobileWidth(context),
                      child: TextFormField(
                        controller: _emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter email";
                          } else if (!RegExp(
                                  r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                              .hasMatch(value.trim())) {
                            return "Email is not valid";
                          }
                          return null;
                        },
                        cursorColor: AppTheme.nearlyBlue,
                        style: AppTheme.subtitleText(
                            size: AppTheme.getMobileWidth(context) / 24,
                            weight: FontWeight.normal,
                            color: AppTheme.nearlyGrey),
                        decoration: AppTheme.waInputDecoration(
                            hint: "Email",
                            fontSize: AppTheme.getMobileWidth(context) / 24,
                            prefixIcon: CupertinoIcons.person),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: AppTheme.getMobileWidth(context),
                      child: TextFormField(
                        controller: _passwordController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter password";
                          }
                          return null;
                        },
                        obscureText: obscureText,
                        cursorColor: AppTheme.nearlyBlue,
                        style: AppTheme.subtitleText(
                            size: AppTheme.getMobileWidth(context) / 24,
                            weight: FontWeight.normal,
                            color: AppTheme.nearlyGrey),
                        decoration: AppTheme.waInputDecoration(
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  obscureText = !obscureText;
                                });
                              },
                              child: Icon(
                                  obscureText
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: AppTheme.nearlyGrey.withOpacity(0.5)),
                            ),
                            hint: "Password",
                            fontSize: AppTheme.getMobileWidth(context) / 24,
                            prefixIcon: Icons.fingerprint),
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  buildShowModalBottomSheet(
                      context, AppTheme.getMobileWidth(context));
                },
                child: Container(
                  alignment: Alignment.centerRight,
                  margin: const EdgeInsets.only(bottom: 20, top: 10),
                  child: Text(
                    "Forgot Password?",
                    style: AppTheme.titleText(
                        size: AppTheme.getMobileWidth(context) / 28,
                        weight: FontWeight.w600,
                        color: AppTheme.nearlyBlue),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    height: AppTheme.getMobileWidth(context) / 7,
                    width: AppTheme.getMobileWidth(context),
                    child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              isLoading1 = true;
                            });
                            service
                                .loginUser(
                                    email: _emailController.text.trim(),
                                    password: _passwordController.text.trim(),
                                    context: context)
                                .then((value) {
                              setState(() {
                                isLoading1 = false;
                              });
                              if (value is UserCredential) {
                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(builder: (context) {
                                  return const App();
                                }));
                              }
                            });
                          }
                        },
                        style:
                            AppTheme.buttonStyle(backColor: AppTheme.nearlyBlue),
                        child: isLoading1
                            ? SizedBox(
                                height: AppTheme.getMobileWidth(context) / 20,
                                width: AppTheme.getMobileWidth(context) / 20,
                                child: const CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppTheme.backGroundColor),
                              )
                            : Text("LOGIN",
                                style: AppTheme.subtitleText(
                                    color: AppTheme.backGroundColor,
                                    size: AppTheme.getMobileWidth(context) / 25,
                                    weight: FontWeight.bold))),
                  ),
                ],
              )
            ],
          ),
        )),
      ),
    );
  }

  Future<dynamic> buildShowModalBottomSheet(
      BuildContext context, double width) {
    return showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (context) {
          return Container(
            padding: const EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Make Selection!",
                  style: AppTheme.titleText(
                      size: width / 15,
                      weight: FontWeight.w600,
                      color: AppTheme.darkishGrey),
                ),
                Text(
                  "Select one of the options given below to reset your password.",
                  style: AppTheme.subtitleText(
                      size: width / 25,
                      weight: FontWeight.w500,
                      color: AppTheme.darkishGrey),
                ),
                SizedBox(
                  height: width / 10,
                ),
                ForgotPassWidget(
                  width: width,
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  data: Icons.mail_outline_rounded,
                  description: "Reset via E-mail Verification.",
                  title: "E-mail",
                ),
              ],
            ),
          );
        });
  }
}
