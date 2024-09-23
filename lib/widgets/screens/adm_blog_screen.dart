import 'package:flutter/material.dart';
import 'package:urban_hamony/models/blog_model.dart';
import 'package:urban_hamony/services/database_service.dart';
import 'package:urban_hamony/widgets/screens/add_blog_screen.dart';
import 'package:urban_hamony/widgets/screens/blog_detail_screen.dart';

class BlogListPage extends StatefulWidget {
  const BlogListPage({Key? key}) : super(key: key);

  @override
  _BlogListPageState createState() => _BlogListPageState();
}

class _BlogListPageState extends State<BlogListPage> {
  DatabaseService _databaseService = DatabaseService();

  List<BlogModel> _generateBlogsList(List<BlogModel> blog) {
    return blog.map((c) {
      return BlogModel(
        id: c.id,
        status: c.status,
        description: c.description,
        category: c.category,
        image: c.image,
        title: c.title,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
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
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<BlogModel> data = snapshot.data!;
            List<BlogModel> blogs = _generateBlogsList(data);
            return Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 500),
                child: ListView.builder(
                  itemCount: blogs.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      elevation: 5,
                      margin: const EdgeInsets.all(10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: InkWell(
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
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: ListTile(
                                  title: Text(
                                    'Title: ${blogs[index].title}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Description: ${blogs[index].description}'),
                                      Text('Category: ${blogs[index].category}'),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.pinkAccent,
              ),
            );
          }
        },
      ),
    );
  }
}