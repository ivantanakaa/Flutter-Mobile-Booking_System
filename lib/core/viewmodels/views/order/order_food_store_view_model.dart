import 'package:member_apps/core/models/order_store_product_model.dart';
import 'package:member_apps/core/services/order_service.dart';
import 'package:member_apps/core/services/product_service.dart';
import 'package:member_apps/core/services/store_service.dart';
import 'package:member_apps/core/viewmodels/base_view_model.dart';

class OrderFoodStoreViewModel extends BaseViewModel {
  StoreService _storeService;
  ProductService _productService;
  OrderService _orderService;

  OrderFoodStoreViewModel({StoreService storeService, ProductService productService, OrderService orderService}) {
    this._storeService = storeService;
    this._productService = productService;
    this._orderService = orderService;

    page = 0;
  }

  List<OrderStoreProductModel> orderStoreProducts = [];
  int page = 0;

  DateTime _orderDate;
  DateTime get orderDate => _orderDate;
  DateTime get minOrderDate => DateTime.now().add(Duration(minutes: 15));
  DateTime get maxOrderDate => DateTime.now().add(Duration(days: 7));

  set orderDate(DateTime dateTime) {
    _orderService.orderDate = dateTime;
    _orderDate = dateTime;
    notifyListeners();
  }

  Future getProducts() async {
    setBusy(true);
    page++;
    List<OrderStoreProductModel> tempModels = await _productService.getProductsByStoreId();
    orderStoreProducts.addAll(tempModels);
    setBusy(false);
  }
}
