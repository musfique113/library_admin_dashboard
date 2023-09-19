import 'package:flutter/material.dart';
import 'package:flutter_pdf_library/data/models/auth_utility.dart';
import 'package:flutter_pdf_library/data/models/display_books_model.dart';
import 'package:flutter_pdf_library/data/models/network_response.dart';
import 'package:flutter_pdf_library/data/services/network_caller.dart';
import 'package:flutter_pdf_library/data/utils/urls.dart';
import 'package:flutter_pdf_library/presentation/ui_component/app_colors.dart';
import 'package:flutter_pdf_library/presentation/ui_component/app_style.dart';

class DisplayBooksDetailsScreen extends StatefulWidget {
  const DisplayBooksDetailsScreen({super.key});

  @override
  State<DisplayBooksDetailsScreen> createState() => _DisplayBooksDetailsScreenState();
}

class _DisplayBooksDetailsScreenState extends State<DisplayBooksDetailsScreen> {
  bool _getBookListInProgress = false;
  List<dynamic> books = [];

  @override
  void initState() {
    super.initState();
    // after widget binding
    getBookList();
  }

  Future<void> getBookList() async {
    _getBookListInProgress = true;
    if (mounted) {
      setState(() {});
    }
    final NetworkResponse response =
    await NetworkCaller().getRequest(Urls.displayBooksList);
    if (response.isSuccess) {
      BookListModel bookListModel = BookListModel.fromJson(response.body!);
      await AuthUtility.getBooksList(bookListModel);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Book List getting successful')));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Failed')));
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
            Center(
                child: Icon(Icons.people)
            ),
            Text(
              'Book Name',
              style: ralewayStyle.copyWith(
                fontWeight: FontWeight.w800,
                color: AppColors.blueDarkColor,
                fontSize: 25.0,
              ),
            ),
            Text(
              'Book Category Name',
              style: ralewayStyle.copyWith(
                fontWeight: FontWeight.w800,
                color: AppColors.blueDarkColor,
                fontSize: 25.0,
              ),
            ),
            Text(
              'Book Author Name',
              style: ralewayStyle.copyWith(
                fontWeight: FontWeight.w800,
                color: AppColors.blueDarkColor,
                fontSize: 25.0,
              ),
            ),
            Text(
              'Book Publissher Name',
              style: ralewayStyle.copyWith(
                fontWeight: FontWeight.w800,
                color: AppColors.blueDarkColor,
                fontSize: 25.0,
              ),
            ),
            Text(
              'publish_year',
              style: ralewayStyle.copyWith(
                fontWeight: FontWeight.w800,
                color: AppColors.blueDarkColor,
                fontSize: 25.0,
              ),
            ),
            Text(
              'no_of_pages',
              style: ralewayStyle.copyWith(
                fontWeight: FontWeight.w800,
                color: AppColors.blueDarkColor,
                fontSize: 25.0,
              ),
            ),
            const Spacer(),
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 24.0, vertical: 18),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text(
                    'Read this Book',
                    style: ralewayStyle.copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppColors.blueDarkColor,
                      fontSize: 25.0,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 8,
            )
          ],
        ));
  }
}
