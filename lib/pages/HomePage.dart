import 'package:ShoppingApp/controller/homePageController.dart';
import 'package:ShoppingApp/models/ItemModel.dart';
import 'package:ShoppingApp/pages/CartPage.dart';
import 'package:ShoppingApp/pages/ItemDetail.dart';
import 'package:ShoppingApp/services/itemService.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ItemServices itemServices = ItemServices();
  List<ShopItemModel> items = [];
  final HomePageController controller = Get.put(HomePageController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Home"),
          elevation: 0.0,
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.h),
              child: InkResponse(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => CartPage()));
                  },
                  child: Stack(
                    children: [
                      GetBuilder<HomePageController>(builder: (_) => Align(
                        child: Text(controller.cartItems.length > 0 ? controller.cartItems.length.toString() : ''),
                        alignment: Alignment.topLeft,
                      )),
                      Align(
                        child: Icon(Icons.shopping_cart),
                        alignment: Alignment.center,
                      ),
                    ],
                  )),
            )
          ],
        ),
        body: Container(
          child: GetBuilder<HomePageController>(
            init: controller,
            builder: (_) => controller.isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : ShopItemListing(
                    items: controller.items,
                  ),
          ),
        ));
  }
}

class ShopItemListing extends StatelessWidget {
  final List<ShopItemModel> items;

  ShopItemListing({required this.items});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(2.h),
      child: GridView.builder(
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, childAspectRatio: 0.8),
        itemBuilder: (BuildContext context, int index) {
          return ItemView(
            item: items[index],
          );
        },
        itemCount: items.length,
      ),
    );
  }
}

class ItemView extends StatelessWidget {
  final ShopItemModel item;

  ItemView({required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(1.h),
      child: InkResponse(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ItemDetailPage(itemId: item.id)));
          },
          child: Material(
            child: Container(
                height: 380.0,
                padding: EdgeInsets.all(1.h),
                decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 1.h)
                    ]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: 15.h,
                      child: Padding(
                        padding: EdgeInsets.all(1.h),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                child: Image.network(
                                  item.image,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            Container(
                              child: item.fav
                                  ? Icon(
                                      Icons.favorite,
                                      size: 2.h,
                                      color: Colors.red,
                                    )
                                  : Icon(
                                      Icons.favorite_border,
                                      size: 2.h,
                                    ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 2.h),
                      child: Text(
                        "${item.name}",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15.0,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 2.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(right: 2.h),
                            child: Text(
                              "\$${item.price.toString()}",
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                )),
          )),
    );
  }
}
