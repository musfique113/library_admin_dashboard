import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdf_library/data/models/auth_utility.dart';
import 'package:flutter_pdf_library/data/models/network_response.dart';
import 'package:flutter_pdf_library/data/services/network_caller.dart';
import 'package:flutter_pdf_library/data/utils/urls.dart';
import 'package:flutter_pdf_library/presentation/custom_widgets/responsive_widgets.dart';
import 'package:flutter_pdf_library/presentation/screens/admin_login_ui/admin_login_screen.dart';
import 'package:flutter_pdf_library/presentation/screens/display_books_ui/display_books_screen.dart';
import 'package:flutter_pdf_library/presentation/ui_component/app_colors.dart';
import 'package:flutter_pdf_library/presentation/ui_component/app_style.dart';
import 'package:flutter_pdf_library/test/test_homepage.dart';
import 'package:image_picker/image_picker.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController authorIdController = TextEditingController();
  final TextEditingController noOfPagesController = TextEditingController();
  final TextEditingController publisherIdController = TextEditingController();
  final TextEditingController categoryIdController = TextEditingController();
  final TextEditingController publishYearController = TextEditingController();

  XFile? imageFile;
  ImagePicker picker = ImagePicker();
  File? pdf;
  String fileText = "";
  bool _addBookInProgress = false;

  Future<void> addBooksToServer() async {
    _addBookInProgress = true;
    setState(() {});

    final Map<String, dynamic> requestBody = {
      "name": nameController.text,
      "author_id": int.parse(authorIdController.text),
      "no_of_pages": int.parse(noOfPagesController.text),
      "publisher_id": int.parse(publisherIdController.text),
      "category_id": int.parse(categoryIdController.text),
      "publish_year": int.parse(publishYearController.text),
      "image": imageFile,
      "pdf": pdf,
    };

    final NetworkResponse response =
        await NetworkCaller().postRequest(Urls.addBooks, requestBody);
    _addBookInProgress = false;

    if (mounted) {
      setState(() {});
    }

    if (response.isSuccess) {
      if (mounted) {
        print("Upload Successful");
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Upload Successful')));
      }
    } else {
      if (mounted) {
        print("Upload Failed");
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Upload Failed')));
      }
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
          '${AuthUtility.userInfo.user?.name ?? ''}',
          style: ralewayStyle.copyWith(
            fontWeight: FontWeight.w400,
            color: AppColors.blueDarkColor.withOpacity(0.5),
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
                                controller: nameController,
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
                              child: Text("Author",
                                  style: TextStyle(color: Colors.white))),
                        ),
                        Container(
                          child: Expanded(
                            child: Padding(
                              padding: const EdgeInsetsDirectional.all(1),
                              child: TextFormField(
                                autofocus: true,
                                controller: authorIdController,
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
                              child: Text("No of Page",
                                  style: TextStyle(color: Colors.white))),
                        ),
                        Container(
                          child: Expanded(
                            child: Padding(
                              padding: const EdgeInsetsDirectional.all(1),
                              child: TextFormField(
                                autofocus: true,
                                controller: noOfPagesController,
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
                              child: Text("Publisher ID",
                                  style: TextStyle(color: Colors.white))),
                        ),
                        Container(
                          child: Expanded(
                            child: Padding(
                              padding: const EdgeInsetsDirectional.all(1),
                              child: TextFormField(
                                autofocus: true,
                                controller: publisherIdController,
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
                              child: Text("Category ID",
                                  style: TextStyle(color: Colors.white))),
                        ),
                        Container(
                          child: Expanded(
                            child: Padding(
                              padding: const EdgeInsetsDirectional.all(1),
                              child: TextFormField(
                                autofocus: true,
                                controller: categoryIdController,
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
                              child: Text("Year",
                                  style: TextStyle(color: Colors.white))),
                        ),
                        Container(
                          child: Expanded(
                            child: Padding(
                              padding: const EdgeInsetsDirectional.all(1),
                              child: TextFormField(
                                autofocus: true,
                                controller: publishYearController,
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
                      height: 12,
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
                      height: 15,
                    ),
                    InkWell(
                      onTap: () {
                        selectPDF();
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
                                'PDF',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                            Visibility(
                              visible: pdf != null,
                              child: Text(
                                fileText,
                                overflow: TextOverflow.fade,
                                softWrap: true,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),

                    SizedBox(
                      width: double.infinity,
                      height: 45,
                      child: Visibility(
                        visible: !_addBookInProgress, // Change this line
                        replacement:
                            const Center(child: CircularProgressIndicator()),
                        child: ElevatedButton(
                          onPressed: addBooksToServer,
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

                    const SizedBox(height: 20.0),
                    SizedBox(
                      width: double.infinity,
                      height: 45,
                      child: ElevatedButton(
                        onPressed: () {
                          print(
                              "AccessToken: ${AuthUtility.userInfo.accessToken.toString()}");
                          logOut();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.mainBlueColor,
                          // Change the button color here
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                        ),
                        child: Text(
                          'Sign Out',
                          style: ralewayStyle.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.whiteColor,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20.0),

                    SizedBox(
                      width: double.infinity,
                      height: 45,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const DisplayBooksScreen()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.mainBlueColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                        ),
                        child: Text(
                          'View Book List',
                          style: ralewayStyle.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.whiteColor,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomePageTest()),
                        );
                      },
                      child: const Text('thes screen'),
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

  void selectPDF() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    if (result != null) {
      PlatformFile file = result.files.first;
      pdf = File(file.path!);
      setState(() {
        fileText = file.name;
      });
    } else {}
  }

  void logOut() async {
    await AuthUtility.clearUserInfo();
    if (mounted) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false);
    }
  }
}
