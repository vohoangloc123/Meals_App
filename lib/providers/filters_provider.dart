import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_app/providers/meals_provider.dart';

// Định nghĩa một enum để xác định các loại filter (bộ lọc)
enum Filter {
  glutenFree, // Bộ lọc không chứa gluten
  lactoseFree, // Bộ lọc không chứa lactose
  vegetarian, // Bộ lọc ăn chay
  vegan, // Bộ lọc thuần chay
}

// Tạo class FiltersNotifier để quản lý trạng thái các bộ lọc
// Kế thừa từ StateNotifier và quản lý một Map chứa các filter và trạng thái của chúng (true/false)
class FiltersNotifier extends StateNotifier<Map<Filter, bool>> {
  // Constructor khởi tạo với trạng thái mặc định, tất cả các filter đều được đặt là false
  FiltersNotifier()
      : super({
          Filter.glutenFree: false,
          Filter.lactoseFree: false,
          Filter.vegetarian: false,
          Filter.vegan: false,
        });

  // Phương thức để cập nhật toàn bộ các bộ lọc cùng một lúc
  void setFilters(Map<Filter, bool> chosenFilters) {
    state = chosenFilters; // Cập nhật state bằng map bộ lọc mới
  }

  // Phương thức để cập nhật một filter duy nhất
  void setFilter(Filter filter, bool isActive) {
    // Cập nhật trạng thái của một bộ lọc cụ thể bằng cách sao chép state hiện tại và thay đổi giá trị
    state = {...state, filter: isActive};
  }
}

// Khởi tạo provider cho FiltersNotifier để quản lý và cung cấp state của các bộ lọc
final filtersProvider =
    StateNotifierProvider<FiltersNotifier, Map<Filter, bool>>(
        (ref) => FiltersNotifier());
// filtersProvider sẽ cung cấp bộ lọc dưới dạng một Map với trạng thái bool (true/false)
final filteredMealsProvider = Provider((ref) {
  final meals = ref.watch(mealsProvider);
  final activeFilters = ref.watch(filtersProvider);
  return meals.where((meal) {
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
      print('Lactose-free filter active: ${activeFilters[Filter.lactoseFree]}');

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
});
