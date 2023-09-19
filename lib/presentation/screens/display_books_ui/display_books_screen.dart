import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_pdf_library/data/models/auth_utility.dart';
import 'package:flutter_pdf_library/data/models/display_books_model.dart';
import 'package:flutter_pdf_library/data/models/network_response.dart';
import 'package:flutter_pdf_library/data/services/network_caller.dart';
import 'package:flutter_pdf_library/data/utils/urls.dart';
import 'package:flutter_pdf_library/presentation/screens/display_books_ui/book_list_card_widgets.dart';
import 'package:flutter_pdf_library/presentation/screens/display_books_ui/books_details_screen.dart';
import 'package:http/http.dart' as http;


class DisplayBookLists extends StatefulWidget {
  const DisplayBookLists({super.key});

  @override
  _DisplayBookListsState createState() => _DisplayBookListsState();
}

class _DisplayBookListsState extends State<DisplayBookLists> {
  List<dynamic> books = [];
  //final BookListModel _bookListModel= BookListModel();
  @override
  void initState() {
    super.initState();
    fetchBooks();
    // getNewBooks();
  }

  Future<void> fetchBooks() async {
    final userData = await AuthUtility.getUserInfo();
    final String token = userData.accessToken.toString();

    final response = await http.get(
      Uri.parse('http://20.239.87.34:8080/books'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        books = json.decode(response.body)['rows'];
      });
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Failed')));
      }
    }
  }

  Future<void> getNewBooks() async {
    final userData = await AuthUtility.getUserInfo();
    final String token = userData.accessToken.toString();

    final NetworkResponse response =
    await NetworkCaller().getRequest(Urls.addBooks);

    if (mounted) {
      setState(() {});
    }
    if (response.isSuccess) {
      //final List<dynamic> responseList = jsonDecode(response.body);

      setState(() {
        // books = responseList;
      });
      // _getBookFile = GetBookFile.fromJson(response.body!);
      // books = _getBookFile.rows ?? [];
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Failed')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     // appBar: const ProfileAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14.0),
            child: Row(
              children: [
                const Text(
                  'Discover Books!',
                  style: TextStyle(fontSize: 26, color: Colors.black),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () {
                    getNewBooks();
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 8.0, vertical: 20.0),
              child: GridView.builder(
                itemCount: books.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const DisplayBooksDetailsScreen()),
                      );
                    },
                    child: BookListCard(
                      bookName: books[index]['name'],
                      bookAuthorName: books[index]['author_name'],
                      imageUrl: 'imageUrl',
                    ),
                  );
                },
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
