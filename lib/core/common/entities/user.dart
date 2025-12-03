
import 'package:compair_hub/core/common/entities/address.dart';
import 'package:compair_hub/src/wishlist/domain/entities/wishlist_product.dart';
import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.isAdmin,
    required this.isBusiness,
    required this.wishlist,
    this.address,
    this.phone,
    this.profilePicture,
  });

  //To test it
  const User.empty()
      : id = "Test String",
        name = "Test String",
        email = "Test String",
        isAdmin = true,
        isBusiness = true,
        wishlist = const [],
        address = null,
        phone = null,
        profilePicture = "Test String";

  final String id;
  final String name;
  final String email;
  final bool isAdmin;
  final bool isBusiness;
  final List<WishlistProduct> wishlist;
  final Address? address;
  final String? phone;
  final String? profilePicture;

  @override
  List<Object?> get props => [id, name, email, isAdmin, isBusiness, wishlist.length, profilePicture];
}
