part of 'category_upload_adapter.dart';

sealed class CategoryUploadState extends Equatable {
  const CategoryUploadState();

  @override
  List<Object?> get props => [];
}

//THE INITIAL STATE
final class CategoryUploadInitial extends CategoryUploadState {
  const CategoryUploadInitial();
}

//THE LOADING STATES
final class CategoryUploadLoading extends CategoryUploadState {
  const CategoryUploadLoading();
}

//THE SUCCESS STATES
final class CategoryUploaded extends CategoryUploadState {
  const CategoryUploaded();
}

//THE ERROR STATE
class CategoryUploadError extends CategoryUploadState {
  const CategoryUploadError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}