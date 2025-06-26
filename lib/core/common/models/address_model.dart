import 'dart:convert';

import 'package:compair_hub/core/common/entities/address.dart';
import 'package:compair_hub/core/utils/typedefs.dart';

class AddressModel extends Address {
  const AddressModel({
    super.street,
    super.apartment,
    super.city,
    super.parish,
    super.postalCode,
    super.country,
  });

  const AddressModel.empty()
      : this(
    street: "Test String",
    apartment: "Test String",
    city: "Test String",
    parish: "Test String",
    postalCode: "Test String",
    country: "Test String",
  );

  factory AddressModel.fromJson(String source) =>
      AddressModel.fromMap(jsonDecode(source) as DataMap);

  AddressModel.fromMap(DataMap map)
      : this(
    street: map['street'] as String?,
    apartment: map['apartment'] as String?,
    city: map['city'] as String?,
    parish: map['parish'] as String?,
    postalCode: map['postalCode'] as String?,
    country: map['country'] as String?,
  );

  AddressModel copyWith({
    String? street,
    String? apartment,
    String? city,
    String? parish,
    String? postalCode,
    String? country,
  }) {
    return AddressModel(
      street: street ?? this.street,
      apartment: apartment ?? this.apartment,
      city: city ?? this.city,
      parish: parish ?? this.parish,
      postalCode: postalCode ?? this.postalCode,
      country: country ?? this.country,
    );
  }

  DataMap toMap() {
    return <String, dynamic>{
      'street': street,
      'apartment': apartment,
      'city': city,
      'parish': parish,
      'postalCode': postalCode,
      'country': country,
    };
  }

  String toJson() => jsonEncode(toMap());
}
