import 'package:flutter/material.dart';
import '../screens/subjects_screen.dart';

class YearItem extends StatelessWidget {
  final String _id;
  final String _title;
  final Color _color;

  YearItem(this._id, this._title, this._color);

  void _selectYear(BuildContext context) {
    print("**********_ID************");
    print(_id);
    print("**********_ID************");
    Navigator.of(context)
        .pushNamed(SubjectsScreen.id, arguments: {'id': _id, 'title': _title});
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _selectYear(context),
      splashColor: Theme.of(context).primaryColor,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(15),
        alignment: Alignment.center,
        child: Text(
          _title,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline6.copyWith(fontSize: 40),
        ),
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [_color.withOpacity(0.7), _color],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight),
            borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}
