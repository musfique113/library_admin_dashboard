import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_pdf_library/data/models/network_response.dart';
import 'package:flutter_pdf_library/data/services/network_caller.dart';
import 'package:flutter_pdf_library/data/utils/urls.dart';
import 'package:flutter_pdf_library/presentation/screens/auth/admin_login_ui/admin_login_screen.dart';
import 'package:flutter_pdf_library/presentation/ui_component/app_colors.dart';
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

    // final NetworkResponse response = await NetworkCaller()
    //     .getRequest(Urls.otpVerify());


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
                builder: (context) => (
                  LoginScreen()
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
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 150,
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  "test",
                  style: Theme.of(context)
                      .textTheme
                      .headlineLarge
                      ?.copyWith(fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 2,
                ),
                const Text(
                  "ConstString.otpSent",
                  style: TextStyle(color: Colors.grey, fontSize: 18),
                ),
                const SizedBox(
                  height: 16,
                ),
                const SizedBox(
                  height: 24,
                ),
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
                    child: Visibility(
                      visible: _otpVerificationInProgress == false,
                      replacement: const Center(
                        child: CircularProgressIndicator(),
                      ),
                      child: ElevatedButton(
                          onPressed: () {
                            verifyOTP();
                          },
                          child: const Text("Next")),
                    )),
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
                  style: TextButton.styleFrom(foregroundColor: Colors.grey),
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
    );
  }

  void _resendCode() {
    // Implement code to resend the authentication code here
    // You can also start the countdown timer again here
    //TODO: set the countdown to 120
    _countdown = 20; // Reset the countdown to 120 seconds
    _startCountdown();
  }

// void _submitForm() {
//   if (_formKey.currentState!.validate()) {
//     final otp = _otpTEController.text;
//     print('OTP submitted: $otp');
//     //Get.offAll(const CompleteProfileScreen());
//     Get.to(const CompleteProfileScreen());
//   }
// }

// void _submitForm() {
//   if (_formKey.currentState!.validate()) {
//     final otp = _otpTEController.text;
//     print('OTP submitted: $otp');
//     //Get.offAll(const CompleteProfileScreen());
//     Get.to(const CompleteProfileScreen());
//   }
// }
}
