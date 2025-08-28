enum CategoryType{
  autoPart,
furnitureAppliance,
}

extension CategoryTypeExtension on CategoryType {
  String get apiValue {
    switch (this) {
      case CategoryType.autoPart:
        return "autoPart";
      case CategoryType.furnitureAppliance:
        return "furniture-appliance";
    }
  }

  String get Label {
    switch (this) {
      case CategoryType.autoPart:
        return "Auto Part";
      case CategoryType.furnitureAppliance:
        return "Furniture & Appliance";
    }
  }

  static CategoryType fromApi(String value) {
    switch (value) {
      case "autoPart":
        return CategoryType.autoPart;
      case "furniture-application":
        return CategoryType.furnitureAppliance;
      default:
        throw Exception("Unknown category: $value");
    }
  }
}