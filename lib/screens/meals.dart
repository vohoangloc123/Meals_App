import 'package:flutter/material.dart';
import 'package:meals_app/models/meals.dart';

class MealsScreen extends StatelessWidget {
  const MealsScreen({super.key, required this.title, required this.meals});
  final String title;
  final List<Meal> meals;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return Text(meals[index].title);
        },
        itemCount: meals.length,
      ),
    );
  }
}
