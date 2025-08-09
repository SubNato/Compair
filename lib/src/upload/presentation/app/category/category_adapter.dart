import 'package:compair_hub/core/services/injection_container.dart';
import 'package:compair_hub/src/product/domain/entities/category.dart';
import 'package:compair_hub/src/product/domain/usecases/get_categories.dart';
import 'package:equatable/equatable.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'category_adapter.g.dart';

part 'category_state.dart';

@riverpod
class CategoryAdapter extends _$CategoryAdapter {
  late final GetCategories _getCategories;

  @override
  CategoryState build() {
    _getCategories = sl<GetCategories>();
    return const CategoryInitial();
  }

  Future<void> fetchCategories() async {
    state = const CategoryLoading();
    final result = await _getCategories();
    result.fold(
      (failure) => state = CategoryError(failure.errorMessage),
      (categories) => state = CategoryLoaded(categories),
    );
  }
}