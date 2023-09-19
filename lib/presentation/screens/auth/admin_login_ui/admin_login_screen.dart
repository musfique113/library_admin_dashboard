import 'package:flutter/material.dart';
import 'package:flutter_pdf_library/data/models/auth_utility.dart';
import 'package:flutter_pdf_library/data/models/login_model.dart';
import 'package:flutter_pdf_library/data/models/network_response.dart';
import 'package:flutter_pdf_library/data/services/network_caller.dart';
import 'package:flutter_pdf_library/data/utils/urls.dart';
import 'package:flutter_pdf_library/presentation/custom_widgets/responsive_widgets.dart';
import 'package:flutter_pdf_library/presentation/screens/auth/sign_up_ui/sign_up_screen.dart';
import 'package:flutter_pdf_library/presentation/screens/bottom_nav_bar_ui/bottom_nav_bar_screen.dart';
import 'package:flutter_pdf_library/presentation/ui_component/app_colors.dart';
import 'package:flutter_pdf_library/presentation/ui_component/app_style.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailTEController =
      TextEditingController(text: "musfique113@gmail.com");
  final TextEditingController _passwordTEController =
      TextEditingController(text: "password");

  bool _passwordVisible = false;
  bool _signInProgress = false;

  Future<void> logIn() async {
    _signInProgress = true;
    setState(() {});

    Map<String, dynamic> requestBody = {
      "email": _emailTEController.text.trim(),
      "password": _passwordTEController.text,
    };

    final NetworkResponse response =
        await NetworkCaller().postRequest(Urls.login, requestBody);
    _signInProgress = false;
    if (mounted) {
      setState(() {});
    }

    if (response.isSuccess) {
      LoginModel model = LoginModel.fromJson(response.body!);
      await AuthUtility.saveUserInfo(model);
      if (mounted) {
        print("Login Sucess");
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const BottomNavbarScreen()),
            (route) => false);
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Incorrect email or password')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColors.backColor,
      body: SizedBox(
        height: height,
        width: width,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ResponsiveLayout.isPhone(context)
                ? const SizedBox()
                : Expanded(
                    child: Container(
                      height: height,
                      color: AppColors.mainBlueColor,
                      child: Center(
                        child: Text(
                          'PDF Library',
                          style: ralewayStyle.copyWith(
                            fontSize: 48.0,
                            color: AppColors.whiteColor,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ),
            Expanded(
              child: Container(
                height: height,
                margin: EdgeInsets.symmetric(
                    horizontal: ResponsiveLayout.isPhone(context)
                        ? height * 0.032
                        : height * 0.12),
                color: AppColors.backColor,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 40.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: height * 0.2),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                                text: 'Let’s',
                                style: ralewayStyle.copyWith(
                                  fontSize: 25.0,
                                  color: AppColors.blueDarkColor,
                                  fontWeight: FontWeight.normal,
                                )),
                            TextSpan(
                              text: ' Sign In 👇',
                              style: ralewayStyle.copyWith(
                                fontWeight: FontWeight.w800,
                                color: AppColors.blueDarkColor,
                                fontSize: 25.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: height * 0.02),
                      Text(
                        'Hey, Enter your details to get sign in \nto your account.',
                        style: ralewayStyle.copyWith(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textColor,
                        ),
                      ),
                      SizedBox(height: height * 0.064),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            width: 90.0,
                            height: 48.0,
                            decoration: const BoxDecoration(
                              color: AppColors.mainBlueColor,
                            ),
                            child: const Center(
                                child: Text("Email",
                                    style: TextStyle(color: Colors.white))),
                          ),
                          Expanded(
                            child: Container(
                              child: Padding(
                                padding: const EdgeInsetsDirectional.all(1),
                                child: TextFormField(
                                  controller: _emailTEController,
                                  obscureText: false,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            width: 90.0,
                            height: 48.0,
                            decoration: const BoxDecoration(
                              color: AppColors.mainBlueColor,
                            ),
                            child: const Center(
                                child: Text("Password",
                                    style: TextStyle(color: Colors.white))),
                          ),
                          Expanded(
                            child: Container(
                              child: Padding(
                                padding: const EdgeInsetsDirectional.all(1),
                                child: TextFormField(
                                  controller: _passwordTEController,
                                  obscureText: !_passwordVisible,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    suffixIcon: IconButton(
                                      icon: _passwordVisible
                                          ? const Icon(Icons.visibility)
                                          : const Icon(Icons.visibility_off),
                                      onPressed: () {
                                        setState(() {
                                          _passwordVisible = !_passwordVisible;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: height * 0.01),
                      SizedBox(
                        width: double.infinity,
                        height: 45,
                        child: Visibility(
                          visible: _signInProgress == false,
                          replacement:
                              const Center(child: CircularProgressIndicator()),
                          child: ElevatedButton(
                            onPressed: () {
                              print(
                                  "AccessToken: ${AuthUtility.userInfo.accessToken.toString()}");
                              logIn();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.mainBlueColor,
                              // Change the button color here
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                            ),
                            child: Text(
                              'Sign In',
                              style: ralewayStyle.copyWith(
                                fontWeight: FontWeight.w700,
                                color: AppColors.whiteColor,
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: height * 0.01),
                      SizedBox(
                        width: double.infinity,
                        height: 45,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignUpScreen()));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.mainBlueColor,
                            // Change the button color here
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                          ),
                          child: Text(
                            'Sign Up',
                            style: ralewayStyle.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.whiteColor,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
