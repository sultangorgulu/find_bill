import 'package:find_bill/app/app.dart';
import 'package:find_bill/login/layout/login_page.dart';
import 'package:find_bill/register/models/user_type_model.dart';
import 'package:find_bill/register/service/register_service.dart';
import 'package:find_bill/utils/app_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  RegisterService service = RegisterService();
  UserType userType = UserType.customer;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: AppTheme.backGroundColor,
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Already have an Account?",
                style: AppTheme.subtitleText(
                  size: AppTheme.getMobileWidth(context) / 28,
                  weight: FontWeight.w500,
                  color: AppTheme.darkishGrey,
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                    return const LoginPage();
                  }));
                },
                child: Text(
                  "Login",
                  style: AppTheme.subtitleText(
                    size: AppTheme.getMobileWidth(context) / 28,
                    weight: FontWeight.bold,
                    color: AppTheme.nearlyBlue,
                  ),
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
                  height: AppTheme.getMobileWidth(context) * 0.4,
                  width: AppTheme.getMobileWidth(context) * 0.4,
                  alignment: Alignment.topLeft,
                  child: Image.asset("assets/images/team.png"),
                ),
                Column(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Get On Board!",
                        textDirection: TextDirection.ltr,
                        style: AppTheme.titleText(
                          letterSpacing: -1,
                          size: AppTheme.getMobileWidth(context) / 12.5,
                          weight: FontWeight.bold,
                          color: AppTheme.darkishGrey,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Create your profile to start your Journey.",
                        textDirection: TextDirection.ltr,
                        style: AppTheme.titleText(
                          size: AppTheme.getMobileWidth(context) / 24,
                          weight: FontWeight.w500,
                          color: AppTheme.nearlyGrey,
                        ),
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
                          controller: _nameController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter full name";
                            }
                            return null;
                          },
                          cursorColor: AppTheme.nearlyBlue,
                          style: AppTheme.subtitleText(
                            size: AppTheme.getMobileWidth(context) / 24,
                            weight: FontWeight.normal,
                            color: AppTheme.nearlyGrey,
                          ),
                          decoration: AppTheme.waInputDecoration(
                            hint: "Name",
                            fontSize: AppTheme.getMobileWidth(context) / 24,
                            prefixIcon: Icons.person_4_outlined,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      SizedBox(
                        width: AppTheme.getMobileWidth(context),
                        child: TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
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
                            color: AppTheme.nearlyGrey,
                          ),
                          decoration: AppTheme.waInputDecoration(
                            hint: "Email",
                            fontSize: AppTheme.getMobileWidth(context) / 24,
                            prefixIcon: CupertinoIcons.mail,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      SizedBox(
                        width: AppTheme.getMobileWidth(context),
                        child: TextFormField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter phone number";
                            }
                            return null;
                          },
                          cursorColor: AppTheme.nearlyBlue,
                          style: AppTheme.subtitleText(
                            size: AppTheme.getMobileWidth(context) / 24,
                            weight: FontWeight.normal,
                            color: AppTheme.nearlyGrey,
                          ),
                          decoration: AppTheme.waInputDecoration(
                            hint: "Phone No",
                            fontSize: AppTheme.getMobileWidth(context) / 24,
                            prefixIcon: Icons.phone_outlined,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
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
                          cursorColor: AppTheme.nearlyBlue,
                          style: AppTheme.subtitleText(
                            size: AppTheme.getMobileWidth(context) / 24,
                            weight: FontWeight.normal,
                            color: AppTheme.nearlyGrey,
                          ),
                          decoration: AppTheme.waInputDecoration(
                            hint: "Password",
                            fontSize: AppTheme.getMobileWidth(context) / 24,
                            prefixIcon: Icons.fingerprint,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "What type of user are you?",
                            style: AppTheme.titleText(
                              size: AppTheme.getMobileWidth(context) / 28,
                              weight: FontWeight.w500,
                              color: AppTheme.nearlyGrey,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: RadioListTile<UserType>(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  activeColor: AppTheme.nearlyBlue,
                                  controlAffinity:
                                      ListTileControlAffinity.platform,
                                  dense: true,
                                  tileColor:
                                      AppTheme.nearlyBlue.withOpacity(0.1),
                                  title: Text(
                                    UserType.customer.name,
                                    style: AppTheme.subtitleText(
                                      size: AppTheme.getMobileWidth(context) /
                                          28,
                                      weight: FontWeight.w600,
                                      color: AppTheme.darkishGrey,
                                    ),
                                  ),
                                  value: UserType.customer,
                                  groupValue: userType,
                                  onChanged: (x) {
                                    setState(() {
                                      userType = x!;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                  height: AppTheme.getMobileWidth(context) / 7,
                  width: AppTheme.getMobileWidth(context),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          isLoading = true;
                        });
                        service
                            .createUser(
                              user_type: userType.name.trim(),
                              name: _nameController.text.trim(),
                              phone: _phoneController.text.trim(),
                              email: _emailController.text.trim(),
                              password: _passwordController.text.trim(),
                              context: context,
                            )
                            .then((value) {
                          setState(() {
                            isLoading = false;
                          });
                          if (value is UserCredential) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) {
                                return const App();
                              }),
                            );
                          }
                        });
                      }
                    },
                    style: AppTheme.buttonStyle(
                      backColor: AppTheme.nearlyBlue,
                    ),
                    child: isLoading
                        ? SizedBox(
                            height: AppTheme.getMobileWidth(context) / 20,
                            width: AppTheme.getMobileWidth(context) / 20,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppTheme.backGroundColor,
                            ),
                          )
                        : Text(
                            "SIGNUP",
                            style: AppTheme.subtitleText(
                              color: AppTheme.backGroundColor,
                              size: AppTheme.getMobileWidth(context) / 25,
                              weight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
