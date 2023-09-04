import 'package:flutter/material.dart';

class HomePageTest extends StatefulWidget {
  const HomePageTest({super.key});

  @override
  State<HomePageTest> createState() => _HomePageTestState();
}

class _HomePageTestState extends State<HomePageTest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:  Colors.red,
        automaticallyImplyLeading: false,
        ),
      body: SafeArea(

        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              width: 93.0,
              height: 60.0,
              child: Center(child: Text("Email")),
              decoration: BoxDecoration(
                color: Colors.green,
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
                child: TextFormField(
                  autofocus: true,
                  obscureText: false,
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.yellowAccent,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),

                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
