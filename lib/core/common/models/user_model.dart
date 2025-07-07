import 'dart:convert';

import 'package:compair_hub/core/common/entities/address.dart';
import 'package:compair_hub/core/common/entities/user.dart';
import 'package:compair_hub/core/common/models/address_model.dart';
import 'package:compair_hub/core/utils/typedefs.dart';
import 'package:compair_hub/src/wishlist/data/models/wishlist_product_model.dart';
import 'package:compair_hub/src/wishlist/domain/entities/wishlist_product.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.isAdmin,
    required super.isBusiness,
    required super.wishlist,
    super.address,
    super.phone,
  });

  const UserModel.empty()
      : this(
    id: "Test String",
    name: "Test String",
    email: "Test String",
    isAdmin: true,
    isBusiness: true,
    wishlist: const [],
    address: null,
    phone: null,
  );

  User copyWith({
    String? id,
    String? name,
    String? email,
    bool? isAdmin,
    bool? isBusiness,
    List<WishlistProduct>? wishlist,
    Address? address,
    String? phone,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      isAdmin: isAdmin ?? this.isAdmin,
      isBusiness: isBusiness ?? this.isBusiness,
      wishlist: wishlist ?? this.wishlist,
      address: address ?? this.address,
      phone: phone ?? this.phone,
    );
  }

  DataMap toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'isAdmin': isAdmin,
      'isBusiness': isBusiness,
      'wishlist': wishlist
          .map((product) => (product as WishlistProductModel).toMap())
          .toList(),
      if (address != null) 'address': (address as AddressModel).toMap(),
      if (phone != null) 'phone': phone,
    };
  }

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(jsonDecode(source) as DataMap);

  factory UserModel.fromMap(DataMap map) {
    final address = AddressModel.fromMap({
      if (map case {'street': String street}) 'street': street,
      if (map case {'apartment': String apartment}) 'apartment': apartment,
      if (map case {'city': String city}) 'city': city,
      if (map case {'parish': String parish}) 'parish' : parish,
      if (map case {'postalCode': String postalCode}) 'postalCode': postalCode,
      if (map case {'country': String country}) 'country': country,
    });
    return UserModel(
      id: map['id'] as String? ?? map['_id'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      isAdmin: map['isAdmin'] as bool,
      isBusiness: map['isBusiness'] as bool,
      wishlist: List<DataMap>.from(map['wishList'] as List)
          .map(WishlistProductModel.fromMap)
          .toList(),
      address: address.isEmpty ? null : address,
      phone: map['phone'] as String?,
    );
  }

  String toJson() => jsonEncode(toMap());
}
