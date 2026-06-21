import 'package:flutter/material.dart';
import 'package:food_delivery_ui/services/notification_service.dart';
import 'package:food_delivery_ui/models/cart.dart';
import 'package:food_delivery_ui/orderscreen.dart';
import 'package:food_delivery_ui/services/cart_service.dart';
import 'package:food_delivery_ui/services/order_service.dart';
import 'package:food_delivery_ui/widgets/cart_item_card.dart';
import 'models/restaurant.dart';

final CartService cartService = CartService();
final OrderService orderService = OrderService();

class CartPage extends StatefulWidget{
  const CartPage({super.key, required this.restaurant});
  final Restaurant restaurant;

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<CartItem> cartItems = [];
  bool isLoading = true;
  String promoCode = "";
  double discount = 0;

  Future<void> loadCart() async {
    try {
      final data = await cartService.getCart();
      setState(() {
        cartItems = data;
        isLoading = false;
      });
    }
    catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    loadCart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart', style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: Colors.orange,
        ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.question_mark_rounded, color: Colors.orange,),
          ),
        ],
      ),
      body: Hero(
        tag: "cart",
        child: ListView(
          children: [
            SizedBox(height: 10,),
            CartHeader(
                resName: widget.restaurant.name,
                resRating: widget.restaurant.rating,
                resTime: widget.restaurant.deliveryTime,
                resImage: widget.restaurant.image,
            ),
            SizedBox(height: 30,),
            cartItems.isEmpty ? EmptyCart() : OrderCard(items: cartItems, refreshCart: loadCart,),
            if (cartItems.isNotEmpty) ...[
              SizedBox(height: 20),
              CouponCard(
                subtotal: calculateTotal(cartItems),
                onApply: (code, dis) {
                  setState(() {
                    promoCode = code;
                    discount = dis;
                  });
                },
              ),
              SizedBox(height: 20),
              DeliveryCard(),
              SizedBox(height: 20),
              BillingCard(items: cartItems, discount: discount),
            ],
          ],
        ),
      ),
        bottomNavigationBar: cartItems.isNotEmpty ? PlaceOrderButton(
            total: calculateTotal(cartItems, discount),
            cartItems: cartItems,
            refreshCart: loadCart,
            promoCode: promoCode,
        ) : null,
    );
  }
}

class CartHeader extends StatelessWidget{
  const CartHeader({super.key,
    required this.resName,
    required this.resRating,
    required this.resTime,
    required this.resImage
  });
  final String resName;
  final double resRating;
  final int resTime;
  final String resImage;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 15),
      color: Colors.white,
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25),),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Image.network(
                resImage,
                height: 80,
                width: 80,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 10,),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(resName, style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Text(resRating.toString(),style: TextStyle(color: Colors.grey),),
                      SizedBox(width: 5,),
                      Icon(Icons.star,size:10,color: Colors.grey,),
                      SizedBox(width: 5,),
                      Text("$resTime mins delivery",style: TextStyle(color: Colors.grey),),
                   ],
                  ),
                ]
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OrderCard extends StatelessWidget{
  const OrderCard({super.key, required this.items, required this.refreshCart,});
  final List<CartItem> items;
  final Future<void> Function() refreshCart;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Order Items", style: TextStyle(
                  color: Colors.black,fontSize: 25,fontWeight: FontWeight.bold),
              ),
            ),
            Divider(height: 1, thickness: 1),
            SizedBox(height: 5,),
            Column(
              children: items.map((item) {
                return CartItemCard(
                  item: item,
                  refreshCart: refreshCart,
                );
              }).toList(),
            ),
            SizedBox(
              height: 50,
              child: TextButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                child: Text("+ ADD MORE ITEMS",style: TextStyle(color: Colors.orange),)
              ),
            )
          ],
        ),
      ),
    );
  }

}

class CouponCard extends StatefulWidget{
  const CouponCard({super.key, required this.subtotal, required this.onApply});
  final double subtotal;
  final Function(String,double) onApply;

  @override
  State<CouponCard> createState() => _CouponCardState();
}

class _CouponCardState extends State<CouponCard> {
  final couponText=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Icon(Icons.local_offer_rounded,color: Colors.orange,),
                  SizedBox(width: 10,),
                  Text("Apply Coupon",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),)
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: couponText,
                      decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(11),
                              borderSide: BorderSide(
                                  color: Colors.black
                              )
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(11),
                              borderSide: BorderSide(
                                  color: Colors.grey
                              )
                          ),
                          hintText: "Enter promo code"
                      ),
                    ),
                  ),
                  SizedBox(width: 10,),
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        String code = couponText.text.trim().toUpperCase();
                        double discount = 0;
                        if(code=="WELCOME10"){
                          discount = widget.subtotal*0.10;
                        }
                        else if(code=="SAVE50"){
                          discount = 50;
                        }
                        if (discount == 0) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Invalid promo code"),
                            ),
                          );
                          return;
                        }
                        widget.onApply(code,discount);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("$code applied successfully")),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(12),
                        ),
                      ),
                      child: Text("Apply",style: TextStyle(fontWeight: FontWeight.bold),),
                    ),
                  ),
                ],
              ),
            ),
            // Container(
            //   height: 40,
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.only(
            //         bottomLeft: Radius.circular(15),
            //         bottomRight: Radius.circular(15)
            //     ),
            //     color: Colors.orange.shade100,
            //   ),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       SizedBox(width: 10,),
            //       Icon(Icons.verified_outlined,color: Colors.orange,size: 25,),
            //       SizedBox(width: 10,),
            //       Text("BIVAN11", style: TextStyle(fontWeight: FontWeight.bold,color: Colors.orange,fontSize: 15),),
            //       Text(" applied! You saved ₹100",style: TextStyle(color: Colors.orange,fontSize: 15),)
            //     ],
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}

class DeliveryCard extends StatelessWidget{
  const DeliveryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.location_on_rounded,color: Colors.orange,size: 25,),
                  SizedBox(width: 10,),
                  Text("Delivery to",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                  Spacer(),
                  TextButton(
                    onPressed: () {},
                    child: Text("Change", style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold,),
                    ),
                  ),
                ],
              ),
              Text("Flat 302, Sai Residency",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
              Text("KIIT Road, Patia, Bhubaneswar 751024", style: TextStyle(color: Colors.grey, fontSize: 14,),),
              SizedBox(height: 10,),
              SizedBox(
                width: double.infinity,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  color: Colors.blueGrey.shade300,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15,vertical: 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("INSTRUCTIONS:",style: TextStyle(fontSize: 16)),
                        Text("Leave at the front Door, ask for Rupesh",style: TextStyle(fontSize: 14),),
                      ],
                    ),
                  ),
                ),
              )
            ]
          ),
        ),
      ),
    );
  }
}

class PlaceOrderButton extends StatelessWidget{
  const PlaceOrderButton({
    super.key,
    required this.total,
    required this.cartItems,
    required this.refreshCart,
    required this.promoCode,
  });

  final double total;
  final List<CartItem> cartItems;
  final Future<void> Function() refreshCart;
  final String promoCode;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: SizedBox(
        height: 50,
        child: ElevatedButton(
          onPressed: () async {
            try {
              final order = await orderService.createOrder(cartItems, promoCode);
              await NotificationService.showOrderPlaced(
                orderId: order.id.substring(order.id.length - 5),
              );
              await cartService.clearCart();
              await refreshCart();
              // ScaffoldMessenger.of(context).showSnackBar(
              //   SnackBar(content: Text("Order #ORD-${order.id.substring(order.id.length - 5)} placed")),
              // );
              Navigator.push(context, MaterialPageRoute(builder: (_) => const OrderScreen()),
              );
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Failed: $e"),
                ),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          child: Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("PAY TOTAL", style: TextStyle(fontSize: 10, color: Colors.white,)),
                  Text("₹${total.toStringAsFixed(2)}", style: TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white,),
                  ),
                ],
              ),
              Spacer(),
              Text("Place Order", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.white),),
              SizedBox(width: 10),
              Icon(Icons.arrow_forward_ios_rounded, size: 20,color: Colors.white,),
            ],
          ),
        ),
      ),
    );
  }
}

class BillingCard extends StatelessWidget{
  const BillingCard({super.key, required this.items, required this.discount});
  final List<CartItem> items;
  final double discount;

  @override
  Widget build(BuildContext context) {
    double itemTotal = items.fold(0, (sum, item) =>
      sum + item.price * item.quantity,
    );
    double delFee=40.0;
    double tax=itemTotal*0.05;
    double total = itemTotal + delFee + tax - discount;
    if (total < 0) {
      total = 0;
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Billing Details",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
              SizedBox(height: 10,),
              BillRow(s: "Item Total", price: itemTotal, isBold: false),
              BillRow(s: "Delivery Fee", price: delFee, isBold: false),
              // BillRow(s: "Platform Fee", price: platFee, isBold: false),
              if(discount > 0)
                BillRow(s: "Discount", price: -discount, isBold: false, clr: Colors.green,),
              BillRow(s: "Tax (5%)", price: tax, isBold: false,),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Divider(),
              ),
              BillRow(s: "To Pay", price: total , isBold: true)
            ],
          ),
        ),
      ),
    );
  }
}

class BillRow extends StatelessWidget{
  final String s;
  final double price;
  final Color? clr;
  final bool isBold;

  const BillRow({super.key, required this.s, required this.price, this.clr, required this.isBold});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(s,style: TextStyle(color: clr,fontSize: 15,
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,),
        ),
        Spacer(),
        Text("₹${price.toStringAsFixed(2)}",style: TextStyle(color: clr,fontSize: 15,
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,),
        ),
      ],
    );
  }
}

double calculateTotal(List<CartItem> items, [double discount = 0]) {
  double itemTotal = items.fold(0, (sum, item) => sum + item.price * item.quantity,);
  double delFee = 40;
  double tax = itemTotal * 0.05;
  double total = itemTotal + delFee + tax - discount;
  if (total < 0) {
    total = 0;
  }
  return total;
}

class EmptyCart extends StatelessWidget {
  const EmptyCart({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey,),
          SizedBox(height: 16),
          Text("Your cart is empty", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text("Add some delicious food", style: TextStyle(fontSize: 15, color: Colors.grey)),
        ],
      ),
    );
  }
}