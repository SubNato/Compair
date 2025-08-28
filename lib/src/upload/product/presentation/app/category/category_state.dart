part of 'category_adapter.dart';

sealed class CategoryState extends Equatable{
  const CategoryState();

  @override
  List<Object?> get props => [];
}

class CategoryInitial extends CategoryState {
  const CategoryInitial();
}

class CategoryLoading extends CategoryState {
  const CategoryLoading();
}

class CategoryLoaded extends CategoryState {
  const CategoryLoaded(this.categories);
  final List<ProductCategory> categories;

  @override
  List<Object> get props => categories;
}

class CategoryError extends CategoryState {
  const CategoryError(this.message);
  final String message;

  @override
  List<Object> get props => [message];
}