import 'package:flutter/material.dart';
import 'package:flutter_pdf_library/presentation/screens/add_authors_ui/add_authors_screen.dart';
import 'package:flutter_pdf_library/presentation/screens/add_books_ui/add_book_screen.dart';
import 'package:flutter_pdf_library/presentation/screens/add_categories_ui/add_categories_screen.dart';
import 'package:flutter_pdf_library/presentation/screens/add_publishers_ui/add_publishers_screen.dart';
import 'package:flutter_pdf_library/presentation/screens/display_books_ui/display_books_screen.dart';

class BottomNavbarScreen extends StatefulWidget {
  const BottomNavbarScreen({Key? key}) : super(key: key);

  @override
  State<BottomNavbarScreen> createState() => _BottomNavbarScreenState();
}

class _BottomNavbarScreenState extends State<BottomNavbarScreen> {
  int _selectedScreenIndex = 0;
  final List<Widget> _screens =  [
    AddBooksScreen(),
    const DisplayBooksScreen(),
    const AddPublishersScreen(),
    const AddCategoriesScreen(),
    const AddAuthorsScreen()
  ];

  @override
  Widget build(BuildContext context) {
    print(_selectedScreenIndex);
    return Scaffold(
      body: _screens[_selectedScreenIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedScreenIndex,
        unselectedItemColor: Colors.grey,
        unselectedLabelStyle: const TextStyle(
            color: Colors.grey
        ),
        showUnselectedLabels: true,
        selectedItemColor: Colors.green,
        onTap: (int index) {
          _selectedScreenIndex = index;
          print(_selectedScreenIndex);
          if (mounted) {
            setState(() {});
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'Add Books'),
          BottomNavigationBarItem(icon: Icon(Icons.access_time_rounded), label: 'Display'),
          BottomNavigationBarItem(icon: Icon(Icons.cancel_outlined), label: 'Publishers'),
          BottomNavigationBarItem(icon: Icon(Icons.check_circle_outline), label: 'Categories'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Authors'),
        ],
      ),
    );
  }
}

