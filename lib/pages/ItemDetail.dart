import 'package:ShoppingApp/controller/homePageController.dart';
import 'package:ShoppingApp/models/ItemModel.dart';
import 'package:ShoppingApp/utilities/stringValues.dart';
import 'package:ShoppingApp/widgets/CustomButton.dart';
import 'package:ShoppingApp/widgets/DotWidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class ItemDetailPage extends StatefulWidget {
  final int itemId;

  ItemDetailPage({required this.itemId});

  @override
  _ItemDetailPageState createState() => _ItemDetailPageState();
}

class _ItemDetailPageState extends State<ItemDetailPage> {
  late PageController pageController;
  int active = 0;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: 0);
  }

  Widget buildDot(int index, int num) {
    return Padding(
      padding: EdgeInsets.all(1.h),
      child: Container(
        height: 2.h,
        width: 2.h,
        decoration: BoxDecoration(
            color: (num == index) ? Colors.black38 : Colors.grey[200],
            shape: BoxShape.circle),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    HomePageController controller = Get.find<HomePageController>();
    ShopItemModel model = controller.getItem(widget.itemId);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Colors.grey.shade300,
              width: 1.0,
            ),
          ),
        ),
        child: ListView(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  height: 280.0,
                  padding: EdgeInsets.only(top: 2.h),
                  color: Colors.white,
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: 20.h,
                        child: PageView(
                          controller: pageController,
                          onPageChanged: (index) {
                            print(index);
                            setState(() {
                              active = index;
                            });
                          },
                          children: <Widget>[
                            Image.network(
                              model.image,
                              height: 15.h,
                            ),
                            Image.network(
                              model.image,
                              height: 15.h,
                            ),
                            Image.network(
                              model.image,
                              height: 15.h,
                            ),
                            Image.network(
                              model.image,
                              height: 15.h,
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          DotWidget(
                            activeIndex: active,
                            dotIndex: 0,
                          ),
                          DotWidget(
                            activeIndex: active,
                            dotIndex: 1,
                          ),
                          DotWidget(
                            activeIndex: active,
                            dotIndex: 2,
                          ),
                          DotWidget(
                            activeIndex: active,
                            dotIndex: 3,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                GetBuilder<HomePageController>(builder: (value) {
                  return Container(
                      height: 27.h,
                      alignment: Alignment(1.0, 1.0),
                      child: Padding(
                        padding: EdgeInsets.only(right: 15.0),
                        child: Column(
                          verticalDirection: VerticalDirection.down,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                controller.setToFav(model.id, !model.fav);
                                var msg = "";
                                if (model.fav) {
                                  msg = model.name + StringValues.notification_favourite_added;
                                } else {
                                  msg = model.name + StringValues.notification_favourite_removed;
                                }
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(content: Text(msg)));
                              },
                              child: model.fav
                                  ? Icon(
                                      Icons.favorite,
                                      size: 3.h,
                                      color: Colors.red,
                                    )
                                  : Icon(
                                      Icons.favorite_border,
                                      size: 3.h,
                                    ),
                            )
                          ],
                        ),
                      ));
                })
              ],
            ),
            Divider(
              color: Colors.grey[300],
              height: 1.0,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.h, vertical: 4.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    model.name,
                    style:
                        TextStyle(fontWeight: FontWeight.w500, fontSize: 19.0),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 2.h),
                    child: Text(
                        StringValues.item_dummy_description),
                  )
                ],
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: Container(
          margin: EdgeInsets.only(bottom: 3.h),
          height: 12.h,
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                  top: BorderSide(color: Colors.grey.shade300, width: 1.0))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 12.h,
                      child: Text(
                        StringValues.total_amount,
                        style: TextStyle(fontSize: 12.0, color: Colors.grey),
                      ),
                    ),
                    Text("\$${model.price.toString()}",
                        style: TextStyle(
                            fontSize: 25.0, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              GetBuilder<HomePageController>(builder: (_) {
                bool isAdded = controller.isAlreadyInCart(model.id);
                if (isAdded) {
                  return CustomButton(
                    name: StringValues.text_remove_cart,
                    onTap: () async {
                      try {
                        controller.removeFromCart(model.id);
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text(StringValues.notification_remove_success)));
                      } catch (e) {
                        print(e);
                      }
                    },
                  );
                }
                return CustomButton(
                  name: StringValues.text_add_to_cart,
                  onTap: controller.isLoading ? null : ()  async {
                    try {
                      var result = await controller.addToCart(model);
                      controller.getCardList();
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(StringValues.notification_added_success)));
                    } catch (e) {
                      print(e);
                    }
                  },
                );
              })
            ],
          )),
    );
  }
}
