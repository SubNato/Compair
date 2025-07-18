import 'package:compair_hub/core/services/injection_container.dart';
import 'package:compair_hub/src/wishlist/domain/entities/wishlist_product.dart';
import 'package:compair_hub/src/wishlist/domain/usecases/add_to_wishlist.dart';
import 'package:compair_hub/src/wishlist/domain/usecases/get_wishlist.dart';
import 'package:compair_hub/src/wishlist/domain/usecases/remove_from_wishlist.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'wishlist_provider.g.dart';
part 'wishlist_state.dart';

@riverpod
class UserWishlist extends _$UserWishlist {
  @override
  WishlistState build([GlobalKey? familyKey]) {
    _getWishlist = sl<GetWishlist>();
    _addToWishlist = sl<AddToWishlist>();
    _removeFromWishlist = sl<RemoveFromWishlist>();
    return const WishlistInitial();
  }

  late GetWishlist _getWishlist;
  late AddToWishlist _addToWishlist;
  late RemoveFromWishlist _removeFromWishlist;

  Future<void> getWishlist(String userId) async {
    state = const GettingUserWishlist();
    final result = await _getWishlist(userId);
    result.fold(
      (failure) => state = WishlistError(failure.errorMessage),
      (wishlist) => state = FetchedUserWishlist(wishlist),
    );
  }

  Future<void> addToWishlist({
    required String userId,
    required String productId,
  }) async {
    state = const AddingToWishlist();
    final result = await _addToWishlist(
      AddToWishlistParams(userId: userId, productId: productId),
    );
    result.fold(
      (failure) => state = WishlistError(failure.errorMessage),
      (_) => state = const AddedToWishlist(),
    );
  }

  Future<void> removeFromWishlist({
    required String userId,
    required String productId,
  }) async {
    state = const RemovingFromWishlist();
    final result = await _removeFromWishlist(
      RemoveFromWishlistParams(userId: userId, productId: productId),
    );
    result.fold(
      (failure) => state = WishlistError(failure.errorMessage),
      (_) => state = const RemovedFromWishlist(),
    );
  }
}
