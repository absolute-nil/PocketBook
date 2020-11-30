import 'package:flutter/material.dart';
import 'package:pocketbook/data/subject_data.dart';
import 'package:pocketbook/model/subject.dart';
import 'package:pocketbook/widgets/app_drawer.dart';
import 'package:pocketbook/widgets/subject_item.dart';

class SubjectsScreen extends StatefulWidget {
  static const id = "/subjects-screen";

  @override
  _SubjectsScreenState createState() => _SubjectsScreenState();
}

class _SubjectsScreenState extends State<SubjectsScreen> {
  String yearTitle = "Year";
  List<Subject> subjects;
  var isLoaded = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (!isLoaded) {
      final routeArgs =
          ModalRoute.of(context).settings.arguments as Map<String, String>;
      final String yearId = routeArgs['id'];
      yearTitle = routeArgs['title'];
      print(yearTitle);
      subjects = SUBJECT_DATA.where((sub) {
        print("**********_ID************");
        print(yearId);
        print("**********_ID************");
        print("**********Sub.year************");
        print(sub.year);
        print("**********Sub.year************");
        return sub.year == yearId;
      }).toList();
      isLoaded = true;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(yearTitle),
      ),
      drawer: AppDrawer(),
      body: Center(
        child: ListView.builder(
          itemBuilder: (ctx, index) {
            return SubjectItem(
              id: subjects[index].id,
              title: subjects[index].title,
              key: ObjectKey(subjects[index].id),
            );
          },
          itemCount: subjects.length,
        ),
      ),
    );
  }
}
