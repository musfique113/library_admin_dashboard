import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdf_library/data/models/auth_utility.dart';
import 'package:flutter_pdf_library/data/utils/urls.dart';
import 'package:flutter_pdf_library/presentation/custom_widgets/responsive_widgets.dart';
import 'package:flutter_pdf_library/presentation/screens/admin_login_ui/admin_login_screen.dart';
import 'package:flutter_pdf_library/presentation/screens/display_books_ui/display_books_screen.dart';
import 'package:flutter_pdf_library/presentation/ui_component/app_colors.dart';
import 'package:flutter_pdf_library/presentation/ui_component/app_style.dart';
import 'package:flutter_pdf_library/test/test_homepage.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';

class AddBooksScreen extends StatefulWidget {
  @override
  _AddBooksScreenState createState() => _AddBooksScreenState();
}

class _AddBooksScreenState extends State<AddBooksScreen> {
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

  Future<void> uploadBookData() async {
    setState(() {
      _addBookInProgress = true;
    });

    final String apiUrl = Urls.addBooks;
    String name = nameController.text;
    int authorId = int.parse(authorIdController.text);
    int noOfPages = int.parse(noOfPagesController.text);
    int publisherId = int.parse(publisherIdController.text);
    int categoryId = int.parse(categoryIdController.text);
    int publishYear = int.parse(publishYearController.text);

    if (imageFile == null || pdf == null) {
      print('Image and PDF must be selected.');
      setState(() {
        _addBookInProgress = false; // Stop the progress indicator
      });
      return;
    }

    // Create a multipart request
    final request = http.MultipartRequest('POST', Uri.parse(apiUrl));
    // Set authorization header
    request.headers['Authorization'] =
    'Bearer ${AuthUtility.userInfo.accessToken.toString()}';

    // Add form fields
    request.fields['name'] = name;
    request.fields['author_id'] = authorId.toString();
    request.fields['no_of_pages'] = noOfPages.toString();
    request.fields['publisher_id'] = publisherId.toString();
    request.fields['category_id'] = categoryId.toString();
    request.fields['publish_year'] = publishYear.toString();

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

    // Add the PDF file
    List<int> pdfBytes = await pdf!.readAsBytes();
    String pdfMimeType = lookupMimeType(pdf!.path)!;
    request.files.add(http.MultipartFile(
      'pdf',
      http.ByteStream.fromBytes(pdfBytes),
      pdfBytes.length,
      filename: 'book.pdf', // Change the filename if needed
      contentType: MediaType.parse(pdfMimeType),
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
        _addBookInProgress = false; // Stop the progress indicator
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
                        child: Visibility(
                          visible: _addBookInProgress == false,
                          replacement: const Center(child: CircularProgressIndicator(),),
                          child: ElevatedButton(
                            onPressed: uploadBookData,
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
                                    DisplayBooksScreen()),
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
                      child: const Text('test screen'),
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
