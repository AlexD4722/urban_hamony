import 'package:flutter/material.dart';
import 'package:urban_hamony/models/blog_model.dart';
import 'package:urban_hamony/models/product_model.dart';
import 'package:urban_hamony/services/database_service.dart';
import 'package:urban_hamony/widgets/screens/add_product_screen.dart';
import 'package:urban_hamony/widgets/screens/blog_detail_screen.dart';
import 'package:urban_hamony/widgets/screens/product_detail_screen.dart';

import 'add_blog_screen.dart';

class BlogListPage extends StatefulWidget {
  const BlogListPage({Key? key}) : super(key: key);



  @override
  _BlogListPageState createState() => _BlogListPageState();
}

class _BlogListPageState extends State<BlogListPage> {
  DatabaseService _databaseService = DatabaseService();
  List<BlogModel> _generateBlogsList(List<BlogModel> blog){
    List<BlogModel> blogs = blog.map((c) {
      return BlogModel(
        id: c.id,
        status: c.status,
        description: c.description,
        category: c.category,
        image: c.image,
        title: c.title,
      );
    }).toList();
    return blogs;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(
        "Blog List",
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.add,
              color: Colors.deepOrangeAccent,
            ),
            splashColor: Colors.deepOrangeAccent,
            focusColor: Colors.deepOrangeAccent,
            iconSize: 40,
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => AddBlogPage()));
            },
          ),
        ],
      ),
      body: StreamBuilder(
          stream: _databaseService.getBlogCollection(),
          builder: (context, snapshot){
            if(snapshot.hasData){
              List<BlogModel> data = snapshot.data!;
              List<BlogModel> blogs = _generateBlogsList(
                  data
              );
              return Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: ListView.builder(
                    itemCount: blogs.length,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => BlogDetailPage(
                                heroTag: index,
                                blog: blogs[index],
                              )));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Hero(
                                tag: index,
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Container(
                                      width: 150,
                                      height: 100,
                                      child: Image.network(
                                        fit: BoxFit.cover,
                                        blogs[index].image!,
                                      ),
                                    )
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: ListTile(// Icon đại diện cho sản phẩm
                                  title: Text('Title: ${blogs[index].title}'),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('description: \$${blogs[index].description}'),
                                      Text('Category: ${blogs[index].category}'),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );

            }else {
              return Center(
                child: CircularProgressIndicator(color: Colors.pinkAccent,),
              );
            }
          }
      ),
    );
  }


}


final List<String> _images = [
  'https://images.pexels.com/photos/167699/pexels-photo-167699.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260',
  'https://images.pexels.com/photos/2662116/pexels-photo-2662116.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
  'https://images.pexels.com/photos/273935/pexels-photo-273935.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
  'https://images.pexels.com/photos/1591373/pexels-photo-1591373.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
  'https://images.pexels.com/photos/462024/pexels-photo-462024.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
  'https://images.pexels.com/photos/325185/pexels-photo-325185.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500'
];