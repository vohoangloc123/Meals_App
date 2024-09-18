import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_app/providers/favorites_provider.dart';
import 'package:meals_app/providers/filters_provider.dart';
import 'package:meals_app/providers/meals_provider.dart';
import 'package:meals_app/screens/categories.dart';
import 'package:meals_app/screens/filters.dart';
import 'package:meals_app/screens/meals.dart';
import 'package:meals_app/widgets/main_drawer.dart';

class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});

  @override
  ConsumerState<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends ConsumerState<TabsScreen> {
  int _selectedTabIndex = 0;
  void _selectPage(int index) {
    setState(() {
      _selectedTabIndex = index;
    });
  }

  void _setScreen(String identifier) async {
    Navigator.of(context).pop();
    if (identifier == 'filters') {
      final result = await Navigator.of(context).push<Map<Filter, bool>>(
        MaterialPageRoute(
          builder: (context) => const FiltersScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Lấy danh sách tất cả các món ăn từ mealsProvider
    final meals = ref.watch(mealsProvider);

// Lấy danh sách các bộ lọc đang hoạt động từ filtersProvider
    final activeFilters = ref.watch(filtersProvider);

// Lọc danh sách các món ăn dựa trên các bộ lọc đang hoạt động
    final availableMeals = meals.where((meal) {
      // In ra thông tin của món ăn hiện tại đang được kiểm tra
      print('Checking meal: ${meal.title}');

      // Kiểm tra nếu bộ lọc 'Gluten-free' đang được kích hoạt
      if (activeFilters[Filter.glutenFree]!) {
        // In ra trạng thái của bộ lọc 'Gluten-free'
        print('Gluten-free filter active: ${activeFilters[Filter.glutenFree]}');

        // Nếu món ăn không phải là 'Gluten-free', loại bỏ món ăn này
        if (!meal.isGlutenFree) {
          print('${meal.title} is not gluten-free, excluding from results');
          return false; // Loại món ăn này khỏi kết quả
        }
      }

      // Kiểm tra nếu bộ lọc 'Lactose-free' đang được kích hoạt
      if (activeFilters[Filter.lactoseFree]!) {
        // In ra trạng thái của bộ lọc 'Lactose-free'
        print(
            'Lactose-free filter active: ${activeFilters[Filter.lactoseFree]}');

        // Nếu món ăn không phải là 'Lactose-free', loại bỏ món ăn này
        if (!meal.isLactoseFree) {
          print('${meal.title} is not lactose-free, excluding from results');
          return false; // Loại món ăn này khỏi kết quả
        }
      }

      // Kiểm tra nếu bộ lọc 'Vegetarian' đang được kích hoạt
      if (activeFilters[Filter.vegetarian]!) {
        // In ra trạng thái của bộ lọc 'Vegetarian'
        print('Vegetarian filter active: ${activeFilters[Filter.vegetarian]}');

        // Nếu món ăn không phải là 'Vegetarian', loại bỏ món ăn này
        if (!meal.isVegetarian) {
          print('${meal.title} is not vegetarian, excluding from results');
          return false; // Loại món ăn này khỏi kết quả
        }
      }

      // Kiểm tra nếu bộ lọc 'Vegan' đang được kích hoạt
      if (activeFilters[Filter.vegan]!) {
        // In ra trạng thái của bộ lọc 'Vegan'
        print('Vegan filter active: ${activeFilters[Filter.vegan]}');

        // Nếu món ăn không phải là 'Vegan', loại bỏ món ăn này
        if (!meal.isVegan) {
          print('${meal.title} is not vegan, excluding from results');
          return false; // Loại món ăn này khỏi kết quả
        }
      }

      // Nếu món ăn vượt qua tất cả các bộ lọc, giữ lại món ăn này
      print('${meal.title} passes all filters, including in results');
      return true; // Giữ món ăn trong danh sách kết quả
    }).toList(); // Chuyển kết quả lọc thành danh sách (List)

    Widget activePage = CategoriesScreen(
      availableMeals: availableMeals,
    );
    var activePageTitle = 'Categories';
    if (_selectedTabIndex == 1) {
      final favoriteMeals = ref.watch(favoriteMealsProvier);
      activePage = MealsScreen(
        meals: favoriteMeals,
      );
      activePageTitle = 'Your Favorites';
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle),
      ),
      drawer: MainDrawer(
        onSelectedScreen: _setScreen,
      ),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        currentIndex: _selectedTabIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.set_meal),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Favorites',
          ),
        ],
      ),
    );
  }
}
