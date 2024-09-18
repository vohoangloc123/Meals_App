import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_app/providers/favorites_provider.dart';
import 'package:meals_app/providers/filters_provider.dart';
import 'package:meals_app/providers/meals_provider.dart';
import 'package:meals_app/screens/categories.dart';
import 'package:meals_app/screens/filters.dart';
import 'package:meals_app/screens/meals.dart';
import 'package:meals_app/widgets/main_drawer.dart';

const kInitialFilters = {
  Filter.glutenFree: false,
  Filter.lactoseFree: false,
  Filter.vegetarian: false,
  Filter.vegan: false,
};

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
    final meals = ref.watch(mealsProvider);
    final activeFilters = ref.watch(filtersProvider);
    final availableMeals = meals.where((meal) {
      print('Checking meal: ${meal.title}');

      if (activeFilters[Filter.glutenFree]!) {
        print('Gluten-free filter active: ${activeFilters[Filter.glutenFree]}');
        if (!meal.isGlutenFree) {
          print('${meal.title} is not gluten-free, excluding from results');
          return false;
        }
      }

      if (activeFilters[Filter.lactoseFree]!) {
        print(
            'Lactose-free filter active: ${activeFilters[Filter.lactoseFree]}');
        if (!meal.isLactoseFree) {
          print('${meal.title} is not lactose-free, excluding from results');
          return false;
        }
      }

      if (activeFilters[Filter.vegetarian]!) {
        print('Vegetarian filter active: ${activeFilters[Filter.vegetarian]}');
        if (!meal.isVegetarian) {
          print('${meal.title} is not vegetarian, excluding from results');
          return false;
        }
      }

      if (activeFilters[Filter.vegan]!) {
        print('Vegan filter active: ${activeFilters[Filter.vegan]}');
        if (!meal.isVegan) {
          print('${meal.title} is not vegan, excluding from results');
          return false;
        }
      }

      print('${meal.title} passes all filters, including in results');
      return true;
    }).toList();

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
