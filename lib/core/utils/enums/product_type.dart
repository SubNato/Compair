enum ProductType{
  autoPart('Auto Parts', 'autoPart'),
  furnitureAppliance('Furniture and Appliances', 'furnitureAppliance');

  const ProductType(this.title, this.queryParam);
  final String title;
  final String queryParam;
}


extension ProductTypeExtension on ProductType {
  String get apiValue {
    switch (this) {
      case ProductType.autoPart:
        return "autoPart";
      case ProductType.furnitureAppliance:
        return "furnitureAppliance";
    }
  }

  String get Label {
    switch (this) {
      case ProductType.autoPart:
        return "Auto Part";
      case ProductType.furnitureAppliance:
        return "Furniture & Appliance";
    }
  }

  static ProductType fromApi(String value) {
    switch (value) {
      case "autoPart":
        return ProductType.autoPart;
      case "furnitureAppliance":
        return ProductType.furnitureAppliance;
      default:
        throw Exception("Unknown category: $value");
    }
  }
}



//Working
/*enum ProductType{
  autoPart,
  furnitureAppliance,
}

extension ProductTypeExtension on ProductType {
  String get apiValue {
    switch (this) {
      case ProductType.autoPart:
        return "autoPart";
      case ProductType.furnitureAppliance:
        return "furnitureAppliance";
    }
  }

  String get Label {
    switch (this) {
      case ProductType.autoPart:
        return "Auto Part";
      case ProductType.furnitureAppliance:
        return "Furniture & Appliance";
    }
  }

  static ProductType fromApi(String value) {
    switch (value) {
      case "autoPart":
        return ProductType.autoPart;
      case "furnitureAppliance":
        return ProductType.furnitureAppliance;
      default:
        throw Exception("Unknown category: $value");
    }
  }
}*/