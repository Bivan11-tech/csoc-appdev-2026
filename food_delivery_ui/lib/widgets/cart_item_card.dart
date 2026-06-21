import 'package:flutter/material.dart';
import 'package:food_delivery_ui/cartscreen.dart';
import 'package:food_delivery_ui/models/cart.dart';


class CartItemCard extends StatefulWidget{
  const CartItemCard({super.key, required this.item, required this.refreshCart});
  final CartItem item;
  final VoidCallback refreshCart;

  @override
  State<CartItemCard> createState() => _CartItemCardState();
}

class _CartItemCardState extends State<CartItemCard> {
  late int count;

  @override
  void initState() {
    super.initState();
    count = widget.item.quantity;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25),),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Image.network(
                widget.item.image,
                height: 80,
                width: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(Icons.fastfood, size: 80);
                },
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(widget.item.name,
                        style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),
                        maxLines: 2,
                      ),
                      Text("₹ ${widget.item.price}", style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold,fontSize: 20),),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(widget.item.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.grey, fontSize: 12,),
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 6),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  try {
                                    if (count > 1) {
                                      await cartService.updateCartItem(widget.item.menuItemId, count - 1,);
                                      setState(() {
                                        count--;
                                      });
                                      widget.refreshCart();
                                    }
                                    else {
                                      await cartService.removeCartItem(widget.item.menuItemId,);
                                      setState(() {
                                        count = 0;
                                      });
                                      widget.refreshCart();
                                    }
                                  }
                                  catch (e) {
                                    print(e);
                                  }
                                },
                                child: Icon(Icons.remove,color: Colors.red),
                              ),
                              SizedBox(width: 5,),
                              Text("$count", style: TextStyle(fontWeight: FontWeight.bold)),
                              SizedBox(width: 5,),
                              GestureDetector(
                                onTap: () async {
                                  try {
                                    await cartService.addToCart(widget.item.menuItemId, 1);
                                    setState(() {
                                      count++;
                                    });
                                    widget.refreshCart();
                                  }
                                  catch (e) {
                                    print(e);
                                  }
                                },
                                child: Icon(Icons.add,color: Colors.green,),
                              ),
                            ],
                          )
                        ),
                      ),
                      TextButton(
                          onPressed: () async {
                            try {
                              await cartService.removeCartItem(widget.item.menuItemId,);
                              widget.refreshCart();
                            } catch (e) {
                              print(e);
                            }
                          },
                          child: Text("Remove", style: TextStyle(color: Colors.red),)
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}