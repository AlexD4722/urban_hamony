import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:urban_hamony/models/blog_model.dart';
import 'package:urban_hamony/models/product_model.dart';

class BlogDetailPage extends StatefulWidget {
  final int heroTag;
  final BlogModel blog;
  const BlogDetailPage({Key? key,
    required this.heroTag,
    required this.blog,
  }) : super(key: key);
  @override
  _BlogDetailPageState createState() => _BlogDetailPageState();
}
class _BlogDetailPageState extends State<BlogDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.blog.title}')),
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
                      '${widget.blog.image}',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListTile(// Icon đại diện cho sản phẩm
              title: Text('Name: ${widget.blog.title}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10,),
                  Text('Code: \$${widget.blog.category}'),
                  SizedBox(height: 10,),
                  Text('Price: \$${widget.blog.id}'),
                  SizedBox(height: 10,),
                  Text('Quantity: ${widget.blog.status}'),
                  SizedBox(height: 10,),
                  Text('Description: ${widget.blog.description}'),
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