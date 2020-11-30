import 'package:flutter/material.dart';
import 'package:pocketbook/data/year_data.dart';
import 'package:pocketbook/widgets/app_drawer.dart';
import 'package:pocketbook/widgets/year_item.dart';

class HomeScreen extends StatelessWidget {
  static const id = '/home-screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Year"),
      ),
      drawer: AppDrawer(),
      body: GridView(
        padding: EdgeInsets.all(20),
        children: YEAR_DATA
            .map((yearData) =>
                YearItem(yearData.id, yearData.title, yearData.color))
            .toList(),
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            childAspectRatio: 1 / 1.5,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20),
      ),
    );
  }
}
