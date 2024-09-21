import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../components/card/cardBlog.dart';
import '../components/card/cardProject.dart';
import 'drawScreen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> projects = [
      {
        'title': 'Project 1',
        'description': 'Description 1',
        'imageUrl': 'demo.jpg'
      },
      {
        'title': 'Project 2',
        'description': 'Description 2',
        'imageUrl': 'demo.jpg'
      },
      {
        'title': 'Project 3',
        'description': 'Description 3',
        'imageUrl': 'demo.jpg'
      },
      {
        'title': 'Project 3',
        'description': 'Description 3',
        'imageUrl': 'demo.jpg'
      },
      {
        'title': 'Project 3',
        'description': 'Description 3',
        'imageUrl': 'demo.jpg'
      },
      {
        'title': 'Project 3',
        'description': 'Description 3',
        'imageUrl': 'demo.jpg'
      },
      {
        'title': 'Project 3',
        'description': 'Description 3',
        'imageUrl': 'demo.jpg'
      },
    ];
    final List<Map<String, String>> blogs = [
      {
        'imageUrl': 'blogDemo.jpg',
        'title': 'Flutter Tips and Tricks',
        'description':
            'Learn some advanced Flutter techniques to improve your app development skills.',
      },
      {
        'imageUrl': 'blogDemo.jpg',
        'title': 'Dart 3.0: What\'s New',
        'description':
            'Explore the latest features and improvements in Dart 3.0.',
      },
      {
        'imageUrl': 'blogDemo.jpg',
        'title': 'Dart 3.0: What\'s New',
        'description':
            'Explore the latest features and improvements in Dart 3.0.',
      },
      {
        'imageUrl': 'blogDemo.jpg',
        'title': 'Dart 3.0: What\'s New',
        'description':
            'Explore the latest features and improvements in Dart 3.0.',
      },
      {
        'imageUrl': 'blogDemo.jpg',
        'title': 'Dart 3.0: What\'s New',
        'description':
            'Explore the latest features and improvements in Dart 3.0.',
      },
      {
        'imageUrl': 'blogDemo.jpg',
        'title': 'Dart 3.0: What\'s New',
        'description':
            'Explore the latest features and improvements in Dart 3.0.',
      },
      // Add more blog entries as needed
    ];
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
                  SizedBox(
                    height: 220,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: projects.length + 2,

                      itemBuilder: (context, index) {
                        if (index == 0) {

                          return Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: _addCardProject(context),
                          );
                        } else if (index == projects.length + 1) {
                          // "Show More" widget at the end of the list
                          return Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: _showMoreProject(),
                          );
                        } else {
                          // CardProject items
                          return Padding(
                            padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                            child: CardProject(
                              title: projects[index - 1]['title']!,
                              description: projects[index - 1]['description']!,
                              imageUrl: projects[index - 1]['imageUrl']!,
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Inspiration',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 320, // Adjust this height as needed
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: blogs.length + 1, // Increase itemCount by 1
                      itemBuilder: (context, index) {
                        if (index == blogs.length) {
                          // "Show More" widget at the end of the list
                          return Padding(
                            padding: const EdgeInsets.only(left: 8, right: 8),
                            child: SizedBox(
                              width: 280, // Same width as blog cards
                              child: _showMoreBlogs(),
                            ),
                          );
                        } else {
                          final blog = blogs[index];
                          return Padding(
                            padding: const EdgeInsets.only(left: 0, right: 8),
                            child: SizedBox(
                              width: 280, // Adjust this width as needed
                              child: CardBlog(
                                imageUrl: blog['imageUrl']!,
                                title: blog['title']!,
                                description: blog['description']!,
                              ),
                            ),
                          );
                        }
                      },
                    ),
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
                  SizedBox(
                    height: 320, // Adjust this height as needed
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: blogs.length + 1, // Increase itemCount by 1
                      itemBuilder: (context, index) {
                        if (index == blogs.length) {
                          // "Show More" widget at the end of the list
                          return Padding(
                            padding: const EdgeInsets.only(left: 8, right: 8),
                            child: SizedBox(
                              width: 280, // Same width as blog cards
                              child: _showMoreBlogs(),
                            ),
                          );
                        } else {
                          final blog = blogs[index];
                          return Padding(
                            padding: const EdgeInsets.only(left: 0, right: 8),
                            child: SizedBox(
                              width: 280, // Adjust this width as needed
                              child: CardBlog(
                                imageUrl: blog['imageUrl']!,
                                title: blog['title']!,
                                description: blog['description']!,
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ),
      ],
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
                        Color(0xfffbb448), // Light green
                        Color(0xffe46b10), // Dark green
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

  Widget _showMoreProject() {
    return GestureDetector(
      onTap: () {
        // Handle "Show More" action
        // For example: Navigator.push(context, MaterialPageRoute(builder: (context) => AllProjectsScreen()));
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
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
