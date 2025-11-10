import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:compair_hub/core/utils/enums/product_type.dart';

part 'product_type_notifier.g.dart';

//This provider manages the currently selected product type.
//Allows it to be shared/used throughout the entire app. Best practice.
@riverpod
class ProductTypeNotifier extends _$ProductTypeNotifier {
  @override
  ProductType build() {
    //Default Product Type Selection.
    return ProductType.autoPart;
  }

  void setType(ProductType type) {
    state = type;
  }

  //toggle method to change between product types.
  void toggleType() {
    state = state == ProductType.autoPart
        ? ProductType.furnitureAppliance
        : ProductType.autoPart;
  }

  //Getting the current type's query parameter for API calls
  String get queryParam => state.queryParam;

  //Getting the Current type's display title
  String get title => state.title;

}