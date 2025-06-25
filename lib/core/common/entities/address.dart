import 'package:equatable/equatable.dart';

class Address extends Equatable {
  const Address({
    this.street,
    this.apartment,
    this.city,
    this.parish,
    this.postalCode,
    this.country,
  });

  const Address.empty()
      : street = "Test String",
        apartment = "Test String",
        city = "Test String",
        parish = "Test String",
        postalCode = "Test String",
        country = "Test String";

  final String? street;
  final String? apartment;
  final String? city;
  final String? parish;
  final String? postalCode;
  final String? country;

  bool get isEmpty =>
      street == null &&
          apartment == null &&
          city == null &&
          parish == null &&
          postalCode == null &&
          country == null;

  bool get isNotEmpty => !isEmpty;

  @override
  List<dynamic> get props => [
    street,
    apartment,
    city,
    parish,
    postalCode,
    country,
  ];
}
