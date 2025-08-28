part of 'upload_adapter.dart';

sealed class UploadState extends Equatable {
  const UploadState();

  @override
  List<Object?> get props => [];
}

//THE INITIAL STATE
final class UploadInitial extends UploadState {
  const UploadInitial();
}

//THE LOADING STATES
final class UploadLoading extends UploadState {
  const UploadLoading();
}

//THE SUCCESS STATES
final class Uploaded extends UploadState {
  const Uploaded();
}

//THE ERROR STATE
class UploadError extends UploadState {
  const UploadError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}