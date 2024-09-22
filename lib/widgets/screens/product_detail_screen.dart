import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:urban_hamony/models/product_model.dart';

class SecondPage extends StatefulWidget {
  final int heroTag;
  final ProductModel product;
  const SecondPage({Key? key,
    required this.heroTag,
    required this.product,
  }) : super(key: key);
  @override
  _SecondPageState createState() => _SecondPageState();
}
class _SecondPageState extends State<SecondPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.product.name}')),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Hero(
                tag: widget.heroTag,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    height: 300,
                    width: 350,
                    child: Image.network(
                    '${widget.product.urlImages[0]}',
                    fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListTile(// Icon đại diện cho sản phẩm
              title: Text('Name: ${widget.product.name}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10,),
                  Text('Code: \$${widget.product.code}'),
                  SizedBox(height: 10,),
                  Text('Price: \$${widget.product.price}'),
                  SizedBox(height: 10,),
                  Text('Quantity: ${widget.product.quantity}'),
                  SizedBox(height: 10,),
                  Text('Description: ${widget.product.description}'),
                  SizedBox(height: 10,),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}