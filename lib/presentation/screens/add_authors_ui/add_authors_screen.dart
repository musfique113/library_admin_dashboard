import 'package:flutter/material.dart';

class AddAuthorsScreen extends StatefulWidget {
  const AddAuthorsScreen({super.key});

  @override
  State<AddAuthorsScreen> createState() => _AddAuthorsScreenState();
}

class _AddAuthorsScreenState extends State<AddAuthorsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("Authors",style: TextStyle(fontSize: 45),)),
    );
  }
}
