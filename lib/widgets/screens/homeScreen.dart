import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:urban_hamony/models/design.dart';
import 'dart:math' as math;
import '../../models/auth_model.dart';
import '../../models/blog_model.dart';
import '../../providers/root.dart';
import '../../services/database_service.dart';
import '../../utils/userInfoUtil.dart';
import '../components/card/cardBlog.dart';
import '../components/card/cardProject.dart';
import 'drawScreen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  Future<UserModel?> _getCurrentUser() async {
    return await UserinfoUtil.getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
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
          html: c.html,
        );
      }).toList();
    }

    List<Design> _generateDesignList(List<Design> chats) {
      return chats.map((c) {
        return Design(
          id: c.id,
          name: c.name,
          image: c.image,
          description: c.description,
          width: c.width,
          height: c.height,
          roomType: c.roomType,
          draggableImages: c.draggableImages,
          status: c.status,
        );
      }).toList();
    }

    return FutureBuilder<UserModel?>(
      future: _getCurrentUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data == null) {
          return Center(child: Text('No user found'));
        } else {
          UserModel currentUser = snapshot.data!;
          return CustomScrollView(
            slivers: [
              SliverPersistentHeader(
                pinned: true,
                delegate: _MyProjectHeaderDelegate(),
              ),
              SliverList(
                delegate: SliverChildListDelegate([
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        StreamBuilder<List<Design>>(
                          stream: _databaseService.getDesignsByEmail(currentUser.email ?? ''),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              List<Design> data = snapshot.data!;
                              List<Design> designs = _generateDesignList(data);
                              return SizedBox(
                                height: 220,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: designs.length + 2,
                                  itemBuilder: (context, index) {
                                    if (index == 0) {
                                      return Padding(
                                        padding: const EdgeInsets.only(right: 10),
                                        child: _addCardProject(context),
                                      );
                                    } else if (index == designs.length + 1) {
                                      if (designs.isEmpty) {
                                        return const SizedBox();
                                      } else {
                                        return Padding(
                                          padding: const EdgeInsets.only(left: 10),
                                          child: _showMoreProject(context),
                                        );
                                      }
                                    } else {
                                      return Padding(
                                        padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => DrawScreen(design: designs[index - 1]),
                                              ),
                                            );
                                          },
                                          child: CardProject(
                                            title: designs[index - 1].name,
                                            description: designs[index - 1].description,
                                            imageUrl: designs[index - 1].image,
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                ),
                              );
                            } else if (snapshot.hasError) {
                              return Center(child: Text('Error: ${snapshot.error}'));
                            } else {
                              return Center(child: CircularProgressIndicator());
                            }
                          },
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Public',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 16),
                        StreamBuilder<List<Design>>(
                          stream: _databaseService.getAllDesignsWithStatus2(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              List<Design> data = snapshot.data!;
                              List<Design> designs = _generateDesignList(data);
                              return SizedBox(
                                height: 220,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: designs.length + 2,
                                  itemBuilder: (context, index) {
                                    if (index == 0) {
                                      return const SizedBox();
                                    } else if (index == designs.length + 1) {
                                      if (designs.isEmpty) {
                                        return const SizedBox();
                                      } else {
                                        return Padding(
                                          padding: const EdgeInsets.only(left: 10),
                                          child: _showMoreProject(context),
                                        );
                                      }
                                    } else {
                                      return Padding(
                                        padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => DrawScreen(design: designs[index - 1]),
                                              ),
                                            );
                                          },
                                          child: CardProject(
                                            title: designs[index - 1].name,
                                            description: designs[index - 1].description,
                                            imageUrl: designs[index - 1].image,
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                ),
                              );
                            } else if (snapshot.hasError) {
                              return Center(child: Text('Error: ${snapshot.error}'));
                            } else {
                              return Center(child: CircularProgressIndicator());
                            }
                          },
                        ),

                        const Text(
                          'Inspiration',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 16),
                        StreamBuilder(
                          stream: _databaseService.getBlogCollection(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              List<BlogModel> data = snapshot.data!;
                              List<BlogModel> blogs = _generateBlogsList(data);
                              return SizedBox(
                                height: 320,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: blogs.length + 1,
                                  itemBuilder: (context, index) {
                                    if (index == blogs.length) {
                                      return Padding(
                                        padding: const EdgeInsets.only(left: 8, right: 8),
                                        child: SizedBox(
                                          width: 280,
                                          child: _showMoreBlogs(),
                                        ),
                                      );
                                    } else {
                                      final blog = blogs[index];
                                      return Padding(
                                        padding: const EdgeInsets.only(left: 0, right: 8),
                                        child: SizedBox(
                                          width: 280,
                                          child: CardBlog(
                                            htmlContent: blog.html ?? "<h1>Content Null</h1>",
                                            imageUrl: blog.image ?? "",
                                            title: blog.title ?? "",
                                            description: blog.description ?? "",
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                ),
                              );
                            } else {
                              return const Center(child: CircularProgressIndicator());
                            }
                          },
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Tips',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 16),
                        StreamBuilder(
                          stream: _databaseService.getBlogCollection(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              List<BlogModel> data = snapshot.data!;
                              List<BlogModel> blogs = _generateBlogsList(data);
                              return SizedBox(
                                height: 320,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: blogs.length + 1,
                                  itemBuilder: (context, index) {
                                    if (index == blogs.length) {
                                      return Padding(
                                        padding: const EdgeInsets.only(left: 8, right: 8),
                                        child: SizedBox(
                                          width: 280,
                                          child: _showMoreBlogs(),
                                        ),
                                      );
                                    } else {
                                      final blog = blogs[index];
                                      return Padding(
                                        padding: const EdgeInsets.only(left: 0, right: 8),
                                        child: SizedBox(
                                          width: 280,
                                          child: CardBlog(
                                            htmlContent: blog.html ?? "<h1>Content Blog is Null</h1>",
                                            imageUrl: blog.image ?? "",
                                            title: blog.title ?? "",
                                            description: blog.description ?? "",
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                ),
                              );
                            } else {
                              return const Center(child: CircularProgressIndicator());
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ]),
              ),
            ],
          );
        }
      },
    );
  }

  Widget _addCardProject(BuildContext context) {
    return GestureDetector(
      onTap: () => {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DrawScreen()),
        )
      },
      child: Column(
        children: [
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              child: Container(
                width: 150,
                height: 150,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xfffbb448),
                        Color(0xffe46b10),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Stack(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "New Project",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Tap to get",
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal),
                            ),
                            Text(
                              "started",
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal),
                            )
                          ],
                        ),
                      ),
                      Positioned(
                        right: 10,
                        bottom: 10,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.add,
                            color: Color(0xffe46b10),
                            size: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _showMoreProject(BuildContext context) {
    return GestureDetector(
      onTap: () {
        var setIndex = context.read<RootProvider>().setPageIndex;
        setIndex(2);
      },
      child: Column(
        children: [
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Stack(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Show More",
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "View all",
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                                fontWeight: FontWeight.normal),
                          ),
                          Text(
                            "projects",
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                                fontWeight: FontWeight.normal),
                          )
                        ],
                      ),
                    ),
                    Positioned(
                      right: 10,
                      bottom: 10,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_forward,
                          color: Colors.black,
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _showMoreBlogs() {
    return GestureDetector(
      onTap: () {
        // Handle "Show More" action for blogs
        // For example: Navigator.push(context, MaterialPageRoute(builder: (context) => AllBlogsScreen()));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Container(
              width: 150,
              height: 312,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Stack(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Show More",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "View all blogs",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    right: 16,
                    bottom: 16,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: Colors.black12,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_forward,
                        color: Colors.black,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _MyProjectHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight = 1;
  final double maxHeight = 60.0;

  _MyProjectHeaderDelegate();

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final progress = shrinkOffset / (maxExtent - minExtent);
    final fontSize = (21 * (1 - progress)).clamp(20.0, 26.0);
    final opacity = (1 - progress).clamp(0.0, 1.0);
    return Container(
      height: math.max(minHeight, maxHeight - shrinkOffset),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          if (progress > 0)
            BoxShadow(
              color: Colors.black.withOpacity(0.3 * progress),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
        ],
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          AnimatedOpacity(
            opacity: opacity,
            duration: const Duration(milliseconds: 150),
            child: Container(
              color: Colors.white,
              child: const Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 16.0, bottom: 16.0),
                  child: Text(
                    "My Profile",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
