import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_app/models/meals.dart';

class FavoriteMealsNotifier extends StateNotifier<List<String>> {
  FavoriteMealsNotifier() : super([]);
  void toggleFavorite(Meal meal) {
    // Kiểm tra xem món ăn đã được yêu thích hay chưa
    final mealIsFavorite = state.contains(meal.id);

    if (mealIsFavorite) {
      // Nếu món ăn đã yêu thích, loại bỏ nó khỏi danh sách yêu thích
      state = state.where((id) => id != meal.id).toList();
    } else {
      // Nếu món ăn chưa yêu thích, thêm nó vào danh sách yêu thích
      state = [...state, meal.id];
    }
  }
}

final favoriteMealsProvier =
    StateNotifierProvider<FavoriteMealsNotifier, List<Meal>>(
  (ref) => FavoriteMealsNotifier(),}
);
