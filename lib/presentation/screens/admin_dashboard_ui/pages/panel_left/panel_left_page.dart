import 'package:flutter/material.dart';
import 'package:flutter_pdf_library/presentation/custom_widgets/responsive_widgets.dart';
import 'package:flutter_pdf_library/presentation/ui_component/app_colors.dart';

class Todo {
  String name;
  bool enable;

  Todo({this.enable = true, required this.name});
}

class PanelLeftPage extends StatefulWidget {
  @override
  _PanelLeftPageState createState() => _PanelLeftPageState();
}

class _PanelLeftPageState extends State<PanelLeftPage> {
  List<Todo> _todos = [
    Todo(name: "Purchase Paper", enable: true),
    Todo(name: "Refill the inventory of speakers", enable: true),
    Todo(name: "Hire someone", enable: true),
    Todo(name: "Maketing Strategy", enable: true),
    Todo(name: "Selling furniture", enable: true),
    Todo(name: "Finish the disclosure", enable: true),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          if (ResponsiveLayout.isComputer(context))
            Container(
              color: AppColors.purpleLight,
              width: 50,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.purpleDark,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                  ),
                ),
              ),
            ),
          SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: AppColors.kPadding / 2,
                      top: AppColors.kPadding / 2,
                      right: AppColors.kPadding / 2),
                  child: Card(
                    color: AppColors.purpleLight,
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Container(
                      width: double.infinity,
                      child: ListTile(
                        //leading: Icon(Icons.shopping_basket),
                        title: Text(
                          "Products Sold",
                          style: TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          "18% of Products Sold",
                          style: TextStyle(color: Colors.white),
                        ),
                        trailing: Chip(
                          label: Text(
                            "4,500",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // LineChartSample2(),
                // PieChartSample2(),
                Padding(
                  padding: const EdgeInsets.only(
                      right: AppColors.kPadding / 2,
                      bottom: AppColors.kPadding,
                      top: AppColors.kPadding,
                      left: AppColors.kPadding / 2),
                  child: Card(
                    color: AppColors.purpleLight,
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      children: List.generate(
                        _todos.length,
                        (index) => CheckboxListTile(
                          title: Text(
                            _todos[index].name,
                            style: TextStyle(color: Colors.white),
                          ),
                          value: _todos[index].enable,
                          onChanged: (newValue) {
                            setState(() {
                              _todos[index].enable = newValue ?? true;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
