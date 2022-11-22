import 'package:ShoppingApp/controller/homePageController.dart';
import 'package:ShoppingApp/models/ItemModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../utilities/stringValues.dart';

class CartPage extends StatelessWidget {
  Widget generateCart(BuildContext context, ShopItemModel d) {
    return Padding(
      padding: EdgeInsets.all(1.h),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white12,
            border: Border(
              bottom: BorderSide(color: Colors.grey.shade100, width: 1.0),
              top: BorderSide(color: Colors.grey.shade100, width: 1.0),
            )),
        height: 15.h,
        child: Row(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(1.h),
              child: Container(
                alignment: Alignment.topLeft,
                height: 15.h,
                width: 15.h,
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 1.h)
                    ],
                    borderRadius: BorderRadius.circular(2.h),
                    image: DecorationImage(
                        image: NetworkImage(d.image), fit: BoxFit.fitHeight)),
              ),
            ),
            Expanded(
                child: Padding(
              padding: EdgeInsets.only(top: 2.h, left: 3.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          d.name,
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 15.0),
                        ),
                      ),
                      Container(
                        alignment: Alignment.bottomRight,
                        child: InkResponse(
                          onTap: () {
                            Get.find<HomePageController>()
                                .removeFromCart(d.shopId ?? 0);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                                    StringValues.notification_item_remove)));
                          },
                          child: Padding(
                            padding: EdgeInsets.only(right: 2.h),
                            child: Icon(
                              Icons.remove_circle,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  Text(StringValues.item_price + d.price.toString()),
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }


  getItemTotal(List<ShopItemModel> items) {
    double sum = 0.0;
    items.forEach((e){sum += e.price;});
    return "\$$sum";
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomePageController>();
    return Scaffold(
      appBar: AppBar(
        title: Text(StringValues.title_cart_list),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: GetBuilder<HomePageController>(
                builder: (_) {
                  if (controller.cartItems.length == 0) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 30.h),
                        child: Text(StringValues.text_no_item_found),
                      ),
                    );
                  }
                  return ListView(
                    shrinkWrap: true,
                    children: controller.cartItems
                        .map((d) => generateCart(context, d))
                        .toList(),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                child: GetBuilder<HomePageController>(
                  builder: (_) {
                    return RichText(
                      text: TextSpan(
                          text: StringValues.text_no_item_found,
                          style: TextStyle(color: Colors.black, fontSize: 18),
                          children: <TextSpan>[
                            TextSpan(
                                text: getItemTotal(controller.cartItems).toString(),
                                style: TextStyle(fontWeight: FontWeight.bold)
                            )
                          ]
                      ),
                    );
                  },
                )
              ),
              Container(
                alignment: Alignment.centerLeft,
                height: 50,
                color: Colors.white,
                child: ElevatedButton(
                  onPressed: () {},
                  child: Container(
                    alignment: Alignment.center,
                    height: 40,
                    width: 100,
                    child: Text(StringValues.text_checkout, style: TextStyle(fontSize: 18),),
                  )
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
