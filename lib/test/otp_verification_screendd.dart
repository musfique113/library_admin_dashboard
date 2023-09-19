import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_pdf_library/data/models/network_response.dart';
import 'package:flutter_pdf_library/data/services/network_caller.dart';
import 'package:flutter_pdf_library/data/utils/urls.dart';
import 'package:flutter_pdf_library/presentation/custom_widgets/responsive_widgets.dart';
import 'package:flutter_pdf_library/presentation/screens/auth/admin_login_ui/admin_login_screen.dart';
import 'package:flutter_pdf_library/presentation/ui_component/app_colors.dart';
import 'package:flutter_pdf_library/presentation/ui_component/app_style.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OTPlVerificationScreen extends StatefulWidget {
  final String email;

  const OTPlVerificationScreen({super.key, required this.email});

  @override
  State<OTPlVerificationScreen> createState() => _OTPlVerificationScreenState();
}

class _OTPlVerificationScreenState extends State<OTPlVerificationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _otpTEController =
  TextEditingController(text: "1234");

  //TODO: set the countdown to 120
  int _countdown = 20; // Initial countdown time in seconds
  late Timer _timer;
  bool _otpVerificationInProgress = false;


  Future<void> verifyOTP() async {
    _otpVerificationInProgress = true;
    if (mounted) {
      setState(() {});
    }

    Map<String, dynamic> requestBody = {
      "email": widget.email,
      "otp": _otpTEController.text,
    };


    final NetworkResponse response =
    await NetworkCaller().postRequest(Urls.otpVerify, requestBody);
    _otpVerificationInProgress = false;


    if (mounted) {
      setState(() {});
    }
    if (response.isSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('OTP Verified')));
      if (mounted) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                (
                    const LoginScreen()
                )));
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Otp verification has been failed!')));
      }
    }
  }


  @override
  void initState() {
    super.initState();

    _startCountdown();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_countdown > 0) {
          _countdown--; // Decrease the countdown by 1 second
        } else {
          // Disable the button and stop the timer when the countdown reaches 0
          timer.cancel();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery
        .of(context)
        .size
        .height;
    double width = MediaQuery
        .of(context)
        .size
        .width;
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

                      Form(
                        key: _formKey,
                        child: PinCodeTextField(
                          length: 4,
                          //validator: FormValidator.validateOTP,
                          obscureText: false,
                          controller: _otpTEController,
                          animationType: AnimationType.fade,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          keyboardType: TextInputType.number,
                          pinTheme: PinTheme(
                            shape: PinCodeFieldShape.box,
                            borderRadius: BorderRadius.circular(5),
                            fieldHeight: 50,
                            fieldWidth: 50,
                            activeFillColor: Colors.white,
                            inactiveFillColor: Colors.white,
                            selectedFillColor: Colors.white,
                            activeColor: AppColors.mainBlueColor,
                            inactiveColor: AppColors.mainBlueColor,
                            selectedColor: Colors.green,
                          ),
                          animationDuration: const Duration(milliseconds: 300),
                          enableActiveFill: true,
                          onCompleted: (v) {},
                          onChanged: (value) {},
                          beforeTextPaste: (text) {
                            return true;
                          },
                          appContext: context,
                        ),
                      ),


                      const SizedBox(
                        height: 16,
                      ),

                      SizedBox(
                        width: double.infinity,
                        height: 45,
                        child: Visibility(
                          visible: _otpVerificationInProgress == false,
                          replacement:
                          const Center(child: CircularProgressIndicator()),
                          child: ElevatedButton(
                            onPressed: () {
                              verifyOTP();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.mainBlueColor,
                              // Change the button color here
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                            ),
                            child: Text(
                              'Verify',
                              style: ralewayStyle.copyWith(
                                fontWeight: FontWeight.w700,
                                color: AppColors.whiteColor,
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(color: Colors.grey),
                          children: [
                            const TextSpan(text: 'This code will expire in '),
                            TextSpan(
                              text: '$_countdown s',
                              style: const TextStyle(
                                color: AppColors.mainBlueColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: _countdown > 0 ? null : _resendCode,
                        style: TextButton.styleFrom(
                            foregroundColor: Colors.grey),
                        child: Text(
                          _countdown > 0 ? ' ' : 'Resend Code',
                          style: const TextStyle(fontSize: 16),
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

  void _resendCode() {
    // Implement code to resend the authentication code here
    // You can also start the countdown timer again here
    //TODO: set the countdown to 120
    _countdown = 20; // Reset the countdown to 120 seconds
    _startCountdown();
  }
}