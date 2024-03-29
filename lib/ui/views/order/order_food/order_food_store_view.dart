import 'package:extended_text/extended_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:member_apps/base_widget.dart';
import 'package:member_apps/core/models/order_store_product_model.dart';
import 'package:member_apps/core/viewmodels/views/order/order_food_store_view_model.dart';
import 'package:member_apps/router.dart';
import 'package:member_apps/service_locator.dart';
import 'package:member_apps/ui/shared_colors.dart';
import 'package:member_apps/ui/widgets/shared_button.dart';

class OrderFoodStoreView extends StatefulWidget {
  final String storeId;

  OrderFoodStoreView({this.storeId});

  @override
  _OrderFoodStoreViewState createState() => _OrderFoodStoreViewState();
}

class _OrderFoodStoreViewState extends State<OrderFoodStoreView> {
  ScrollController _scrollController = new ScrollController();
  OrderFoodStoreViewModel _viewModel = locator<OrderFoodStoreViewModel>();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() async {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        await _viewModel.getProducts(storeId: widget.storeId);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget<OrderFoodStoreViewModel>(
      model: _viewModel,
      onModelReady: (OrderFoodStoreViewModel viewModel) async {
        await viewModel.loadStore(storeId: widget.storeId);
        await viewModel.getProducts(storeId: widget.storeId);
      },
      builder: (BuildContext context, OrderFoodStoreViewModel viewModel,
          Widget child) {
        return WillPopScope(
          onWillPop: () {
            viewModel.carts.clear();
            viewModel.cartsProducts.clear();
            return Future.value(true);
          },
          child: Scaffold(
            appBar: AppBar(
                elevation: 1,
                backgroundColor: SharedColors.scaffoldColor,
                title: Text(viewModel.branchModel != null
                    ? viewModel.branchModel.franchiseName
                    : "")),
            bottomSheet: Container(
              height: viewModel.carts.length > 0 ? 70 : 0,
              child: SharedButton(
                onTap: () {
                  viewModel.continueOrder();
                  Navigator.pushNamed(context, RoutePaths.OrderFoodConfirmation,
                      arguments: widget.storeId);
                },
                txtFontSize: 20,
                text: "${viewModel.carts.length ?? 0} items on cart - Continue",
              ),
            ),
            body: _buildBody(viewModel),
          ),
        );
      },
    );
  }

  Widget _buildBody(OrderFoodStoreViewModel viewModel) {
    return Container(
      child: Column(
        children: <Widget>[
          Expanded(child: _buildStoreProduct(viewModel)),
        ],
      ),
    );
  }

  Widget _buildStoreProduct(OrderFoodStoreViewModel viewModel) {
    return Container(
      child: ListView.separated(
          controller: _scrollController,
          itemCount: viewModel.orderStoreProducts.length + 1,
          separatorBuilder: (BuildContext context, int index) {
            return Divider();
          },
          itemBuilder: (BuildContext context, int index) {
            return (index == viewModel.orderStoreProducts.length
                ? Container(
                    height: 100,
                  )
                : _buildStoreProductItem(
                    viewModel, viewModel.orderStoreProducts[index]));
          }),
    );
  }

  Widget _buildStoreProductItem(
      OrderFoodStoreViewModel viewModel, OrderStoreProductModel model) {
    return Container(
      height: 120,
      margin: EdgeInsets.symmetric(horizontal: 5),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: model.imagePath != null
                ? Image.network(
                    model.imagePath,
                  )
                : Image.asset("assets/images/empty_image.png"),
          ),
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      flex: 4,
                      child: Container(
                        padding: EdgeInsets.only(left: 10),
                        child: Text(
                          model.productName,
                          style: Theme.of(context)
                              .textTheme
                              .body1
                              .merge(TextStyle(fontSize: 18)),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(right: 15),
                            alignment: Alignment.centerRight,
                            child: Text(
                              "${model.formattedPrice}",
                              style: Theme.of(context)
                                  .textTheme
                                  .body2
                                  .merge(TextStyle(fontSize: 20)),
                            ),
                          ),
//                          Container(
//                            padding: EdgeInsets.only(right: 10),
//                            alignment: Alignment.centerRight,
//                            child: Text(
//                              "${model.discountPrice}",
//                              style: Theme.of(context)
//                                  .textTheme
//                                  .body1
//                                  .merge(TextStyle(
//                                  fontWeight: FontWeight.w300,
//                                  decoration:
//                                  TextDecoration.lineThrough)),
//                            ),
//                          ),
                        ],
                      ),
                    )
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 5,
                        child: ExtendedText(
                          model.description,
                          style: Theme.of(context).textTheme.caption,
                          maxLines: 3,
                          overflowWidget: TextOverflowWidget(
                            child: Text(
                              " ...",
                              style: TextStyle(color: Colors.black45),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Container(
                          child: Center(
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                RawMaterialButton(
                                  onPressed: () {
                                    model.minusQty();
                                    viewModel.refreshCarts(model);
                                  },
                                  child: new Icon(
                                    FontAwesomeIcons.minus,
                                    color: SharedColors.primaryColor,
                                    size: 14.0,
                                  ),
                                  shape: new CircleBorder(),
                                  constraints: BoxConstraints(
                                      minHeight: 30, minWidth: 30),
                                  elevation: 4,
                                  fillColor: Colors.white,
                                ),
                                new Text("${model.qty}",
                                    style: new TextStyle(fontSize: 16.0)),
                                RawMaterialButton(
                                  onPressed: () {
                                    model.addQty();
                                    viewModel.refreshCarts(model);
                                  },
                                  child: new Icon(
                                    FontAwesomeIcons.plus,
                                    color: SharedColors.primaryColor,
                                    size: 14.0,
                                  ),
                                  shape: new CircleBorder(),
                                  constraints: BoxConstraints(
                                      minHeight: 30, minWidth: 30),
                                  elevation: 4,
                                  fillColor: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
