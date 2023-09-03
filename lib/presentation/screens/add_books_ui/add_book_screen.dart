import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdf_library/data/models/network_response.dart';
import 'package:flutter_pdf_library/data/services/network_caller.dart';
import 'package:flutter_pdf_library/data/utils/urls.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //final TextEditingController idController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController authorIdController = TextEditingController();
  final TextEditingController noOfPagesController = TextEditingController();
  final TextEditingController publisherIdController = TextEditingController();
  final TextEditingController categoryIdController = TextEditingController();
  final TextEditingController publishYearController = TextEditingController();

  XFile? imageFile;
  ImagePicker picker = ImagePicker();

  File? pdf;
  //FilePicker _filePicker = FilePicker();
  String _fileText = "";

  bool _addBookInProgress = false;


  Future<void> addBooksToServer() async {

    _addBookInProgress = true;
    setState(() {});

    final Map<String, dynamic> requestBody = {
      //"id": int.parse(idController.text),
      "name": nameController.text,
      "author_id": int.parse(authorIdController.text),
      "no_of_pages": int.parse(noOfPagesController.text),
      "publisher_id": int.parse(publisherIdController.text),
      "category_id": int.parse(categoryIdController.text),
      "publish_year": int.parse(publishYearController.text),
      "image": "imageController.text",
      "pdf": "pdfController.text",
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
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Upload Successful')));
      }
    } else {
      if (mounted) {
        print("Upload Failed");
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Upload Failed')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Send Data to Server'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            // TextField(
            //   controller: idController,
            //   decoration: InputDecoration(labelText: 'ID'),
            // ),
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: authorIdController,
              decoration: InputDecoration(labelText: 'Author ID'),
            ),
            TextField(
              controller: noOfPagesController,
              decoration: InputDecoration(labelText: 'Number of Pages'),
            ),
            TextField(
              controller: publisherIdController,
              decoration: InputDecoration(labelText: 'Publisher ID'),
            ),
            TextField(
              controller: categoryIdController,
              decoration: InputDecoration(labelText: 'Category ID'),
            ),
            TextField(
              controller: publishYearController,
              decoration: InputDecoration(labelText: 'Publish Year'),
            ),
            SizedBox(height: 20.0),
            InkWell(
              onTap: () {
                selectImage();
              },
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(color: Colors.white),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(14),
                      color: Colors.green,
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
            SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: () {
                selectPDF();
              },
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(color: Colors.white),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(14),
                      color: Colors.green,
                      child: const Text(
                        'PDF',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Visibility(
                      visible: imageFile != null,
                      child: Text(
                        _fileText,
                        overflow: TextOverflow.fade,
                        softWrap: true,
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            ElevatedButton(
              onPressed: addBooksToServer,
              child: Text('Send Data to Server'),
            ),
            SizedBox(height: 20.0),
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

void selectPDF() async{
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom,allowedExtensions: ['pdf']);
    if (result != null) {
      File file = File(result.files.single.path ?? "");
      String fileName = file.path.split('/').last;
      String filePath = file.path;
      print(fileName);
      print(filePath);


      setState(() {
        _fileText = file.path;
      });


    } else {
      // User canceled the picker
    }
  }


}
