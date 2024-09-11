import 'package:flutter/material.dart';
import 'package:meals_app/models/meals.dart';
import 'package:meals_app/screens/categories.dart';
import 'package:meals_app/screens/meals.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

/*Hàm _toggleFavoriteStatus(Meal meal) được 
  thiết kế để thay đổi trạng thái yêu thích của
  món ăn bằng cách thêm hoặc xóa nó từ danh sách
  yêu thích. Nếu món ăn đã tồn tại trong danh sách,
  nó sẽ bị xóa; nếu không, nó sẽ được thêm vào danh 
  sách. Đây là một cách hiệu quả để quản lý trạng 
  thái yêu thích của các món ăn trong ứng dụng.*/
final List<Meal> _favoriteMeals = [];
void _toggleFavoriteStatus(Meal meal) {
  final isExisting = _favoriteMeals.contains(meal);
  if (isExisting) {
    _favoriteMeals.remove(meal);
  } else {
    _favoriteMeals.add(meal);
  }
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedTabIndex = 0;
  void _selectPage(int index) {
    setState(() {
      _selectedTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget activePage = CategoriesScreen(
      onToggleFavorite: _toggleFavoriteStatus,
    );
    var activePageTitle = 'Categories';
    if (_selectedTabIndex == 1) {
      activePage = const MealsScreen(
        meals: [],
        onToggleFavorite: _toggleFavoriteStatus,
      );
      activePageTitle = 'Your Favorites';
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle),
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
