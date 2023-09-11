import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_pdf_library/data/models/auth_utility.dart';
import 'package:flutter_pdf_library/presentation/custom_widgets/responsive_widgets.dart';
import 'package:flutter_pdf_library/presentation/ui_component/app_colors.dart';
import 'package:flutter_pdf_library/presentation/ui_component/app_style.dart';
import 'package:http/http.dart' as http;
import '../../../data/utils/urls.dart';

class AddCategoriesScreen extends StatefulWidget {
  const AddCategoriesScreen({super.key});

  @override
  State<AddCategoriesScreen> createState() => _AddCategoriesScreenState();
}

class _AddCategoriesScreenState extends State<AddCategoriesScreen> {
  final TextEditingController _nameTEController = TextEditingController();
  bool _addCategoriesProgress = false;

  Future<void> addCategoriesData() async {
    setState(() {
      _addCategoriesProgress = true;
    });

    final String apiUrl = Urls.addCategories;
    String name = _nameTEController.text;



    // Create a multipart request
    final request = http.MultipartRequest('POST', Uri.parse(apiUrl));
    // Set authorization header
    request.headers['Authorization'] =
    'Bearer ${AuthUtility.userInfo.accessToken.toString()}';

    // Add form fields
    request.fields['name'] = name;


    // Send the request
    try {
      final response = await request.send();
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Request was successful
        final responseString = await response.stream.bytesToString();
        final responseData = json.decode(responseString);
        print('Request success with status ${response.statusCode}');
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Data added success')));
      } else {
        print('Request failed with status ${response.statusCode}');
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Data added failed')));
      }
    } catch (e) {
      print('Error sending request: $e');
    } finally {
      setState(() {
        _addCategoriesProgress = false; // Stop the progress indicator
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.account_circle),
        title: Text(
          '${AuthUtility.userInfo.user?.name ?? 'AdminName'}',
          style: ralewayStyle.copyWith(
            fontWeight: FontWeight.w400,
            color: Colors.black,
            fontSize: 25.0,
          ),
        ),
      ),
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
                : Container(
              height: height,
              width: 500,
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
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    // Usage of customTextFormField:
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
                              child: Text("Name",
                                  style: TextStyle(color: Colors.white))),
                        ),
                        Expanded(
                          child: Container(
                            child: Padding(
                              padding: const EdgeInsetsDirectional.all(1),
                              child: TextFormField(
                                autofocus: true,
                                controller: _nameTEController,
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
                      height: 16,
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 45,
                      child: Visibility(
                        visible: !_addCategoriesProgress, // Change this line
                        replacement:
                        const Center(child: CircularProgressIndicator()),
                        child: Visibility(
                          visible: _addCategoriesProgress == false,
                          replacement: const Center(child: CircularProgressIndicator(),),
                          child: ElevatedButton(
                            onPressed: addCategoriesData ,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.mainBlueColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                            ),
                            child: Text(
                              'Add Categories',
                              style: ralewayStyle.copyWith(
                                fontWeight: FontWeight.w700,
                                color: AppColors.whiteColor,
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
