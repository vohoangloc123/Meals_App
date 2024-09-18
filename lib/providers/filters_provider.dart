import 'package:flutter_riverpod/flutter_riverpod.dart';

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
