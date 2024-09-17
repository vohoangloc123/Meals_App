import 'package:flutter/material.dart';
import 'package:meals_app/models/meals.dart';
import 'package:meals_app/widgets/meal_details.dart';
import 'package:meals_app/widgets/meal_item.dart';

class MealsScreen extends StatelessWidget {
  const MealsScreen({
    super.key,
    this.title,
    required this.meals,
  });
  final String? title;
  final List<Meal> meals;
  // Hàm này sẽ được gọi khi người dùng chọn một món ăn. Nó sẽ điều hướng
  // người dùng đến màn hình chi tiết món ăn (MealDetails).
  void selectMeal(BuildContext context, Meal meal) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) =>
            MealDetails(meal: meal, onToggleFavorite: onToggleFavorite)));
    // Navigator.of(context).push() sẽ đẩy (push) màn hình MealDetails lên trên ngăn xếp (stack) màn hình hiện tại,
    // và hiển thị chi tiết món ăn mà người dùng chọn.
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Uh oh ... nothing here!',
            style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
          ),
          const SizedBox(
            height: 16,
          ),
          Text(
            'Try slecting a diffrent category!',
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
          )
        ],
      ),
    );

    if (meals.isNotEmpty) {
      content = ListView.builder(
        itemBuilder: (context, index) => MealItem(
            meal: meals[index],
            // Truyền hàm `onSelectMeal` cho mỗi `MealItem`. Hàm này sẽ gọi `selectMeal`
            // để điều hướng đến màn hình chi tiết món ăn khi người dùng nhấn vào món ăn.
            onSelectMeal: (meal) {
              selectMeal(context, meal);
            }),
        itemCount: meals.length,
      );
    }
    if (title == null) {
      return content;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(title!),
      ),
      body: content,
    );
  }
}
