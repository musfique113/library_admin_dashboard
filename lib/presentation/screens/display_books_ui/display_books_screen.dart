import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_pdf_library/data/models/auth_utility.dart';
import 'package:flutter_pdf_library/data/models/display_books_model.dart';
import 'package:flutter_pdf_library/data/models/network_response.dart';
import 'package:flutter_pdf_library/data/services/network_caller.dart';
import 'package:flutter_pdf_library/data/utils/urls.dart';

class DisplayBooksScreen extends StatefulWidget {
  const DisplayBooksScreen({super.key});

  @override
  State<DisplayBooksScreen> createState() => _DisplayBooksScreenState();
}

class _DisplayBooksScreenState extends State<DisplayBooksScreen> {
  bool _getBookListInProgress = false;
  List<dynamic> books = [];

  @override
  void initState() {
    super.initState();
    // after widget binding
    getInProgressTasks();
  }

  Future<void> getInProgressTasks() async {
    _getBookListInProgress = true;
    if (mounted) {
      setState(() {});
    }
    final NetworkResponse response =
    await NetworkCaller().getRequest(Urls.displayBooksList);
    if (response.isSuccess) {
      BookListModel bookListModel= BookListModel.fromJson(response.body!);
      await AuthUtility.getBooksList(bookListModel);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Book List getting successful')));
    } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed')));
    }
    _getBookListInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book List'),
      ),
      body: Column(
        children: [
          Container(
            child: ElevatedButton(
              onPressed: (){
                getInProgressTasks();
              } ,
              child: Text(AuthUtility.bookListInfo.pageNo.toString() ?? ''),
            ),
          ),
        ],
      )
    );
  }
}
