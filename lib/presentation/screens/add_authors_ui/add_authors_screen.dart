import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_pdf_library/data/models/auth_utility.dart';
import 'package:flutter_pdf_library/data/utils/urls.dart';
import 'package:flutter_pdf_library/presentation/custom_widgets/responsive_widgets.dart';
import 'package:flutter_pdf_library/presentation/ui_component/app_colors.dart';
import 'package:flutter_pdf_library/presentation/ui_component/app_style.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';

class AddAuthorsScreen extends StatefulWidget {
  const AddAuthorsScreen({super.key});

  @override
  State<AddAuthorsScreen> createState() => _AddAuthorsScreenState();
}

class _AddAuthorsScreenState extends State<AddAuthorsScreen> {

  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _authorNameTEController = TextEditingController();
  final TextEditingController _addressTEController = TextEditingController();

  XFile? imageFile;
  ImagePicker picker = ImagePicker();


  bool _addAuthorsProgress = false;

  Future<void> addAuthorsData() async {
    setState(() {
      _addAuthorsProgress = true;
    });

    final String apiUrl = Urls.addAuthors;
    String author_name = _authorNameTEController.text;
    String address = _addressTEController.text;
    String email = _emailTEController.text;


    if (imageFile == null ) {
      print('Image must be selected.');
      setState(() {
        _addAuthorsProgress = false; // Stop the progress indicator
      });
      return;
    }

    // Create a multipart request
    final request = http.MultipartRequest('POST', Uri.parse(apiUrl));
    // Set authorization header
    request.headers['Authorization'] =
    'Bearer ${AuthUtility.userInfo.accessToken.toString()}';

    // Add form fields
    request.fields['name'] = author_name;
    request.fields['address'] = address;
    request.fields['email'] = email;


    // Add the image file
    List<int> imageBytes = await imageFile!.readAsBytes();
    String imageMimeType = lookupMimeType(imageFile!.path)!;
    request.files.add(http.MultipartFile(
      'image',
      http.ByteStream.fromBytes(imageBytes),
      imageBytes.length,
      filename: 'image.png', // Change the filename if needed
      contentType: MediaType.parse(imageMimeType),
    ));

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
        _addAuthorsProgress = false; // Stop the progress indicator
      });
    }
  }

  void selectImage() {
    picker.pickImage(source: ImageSource.gallery).then((xFile) {
      if (xFile != null) {
        imageFile = xFile;
        if (mounted) {
          setState(() {});
        }
      }
    });
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
                              child: Text("Author Name",
                                  style: TextStyle(color: Colors.white))),
                        ),
                        Expanded(
                          child: Container(
                            child: Padding(
                              padding: const EdgeInsetsDirectional.all(1),
                              child: TextFormField(
                                autofocus: true,
                                controller: _authorNameTEController,
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
                              child: Text("Email",
                                  style: TextStyle(color: Colors.white))),
                        ),
                        Container(
                          child: Expanded(
                            child: Padding(
                              padding: const EdgeInsetsDirectional.all(1),
                              child: TextFormField(
                                autofocus: true,
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
                              child: Text("Address",
                                  style: TextStyle(color: Colors.white))),
                        ),
                        Container(
                          child: Expanded(
                            child: Padding(
                              padding: const EdgeInsetsDirectional.all(1),
                              child: TextFormField(
                                autofocus: true,
                                controller: _addressTEController,
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
                    InkWell(
                      onTap: () {
                        selectImage();
                      },
                      child: Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(14),
                              width: 90,
                              color: AppColors.mainBlueColor,
                              child: const Text(
                                'Photos',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                            Visibility(
                              visible: imageFile != null,
                              child: Text(
                                imageFile?.name ?? '',
                                overflow: TextOverflow.fade,
                                softWrap: true,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 45,
                      child: Visibility(
                        visible: !_addAuthorsProgress, // Change this line
                        replacement:
                        const Center(child: CircularProgressIndicator()),
                        child: Visibility(
                          visible: _addAuthorsProgress == false,
                          replacement: const Center(child: CircularProgressIndicator(),),
                          child: ElevatedButton(
                            onPressed: addAuthorsData,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.mainBlueColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                            ),
                            child: Text(
                              'Add Data',
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

//dafds
