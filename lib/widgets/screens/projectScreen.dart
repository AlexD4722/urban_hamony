import 'package:flutter/material.dart';
import 'dart:math' as math;

import '../components/card/cardBlog.dart';
import '../components/card/cardProject.dart';

class ProjectScreen extends StatelessWidget {
  const ProjectScreen({Key? key}) : super(key: key);

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
    return CustomScrollView(
      slivers: [
        SliverPersistentHeader(
          pinned: true,
          delegate: _MyProjectHeaderDelegate(),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(10),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                // Calculate the start index for each row
                final int startIndex = index * 2;
                // Check if we have reached the end of the list
                if (startIndex >= projects.length) {
                  return null;
                }
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: CardProject(
                          title: projects[startIndex]['title'] ?? '',
                          description: projects[startIndex]['description'] ?? '',
                          imageUrl: projects[startIndex]['imageUrl'] ?? '',
                        ),
                      ),
                      SizedBox(width: 10), // Space between cards
                      Expanded(
                        child: startIndex + 1 < projects.length
                            ? CardProject(
                          title: projects[startIndex + 1]['title'] ?? '',
                          description: projects[startIndex + 1]['description'] ?? '',
                          imageUrl: projects[startIndex + 1]['imageUrl'] ?? '',
                        )
                            : Container(), // Empty container if there's no second item
                      ),
                    ],
                  ),
                );
              },
              childCount: (projects.length / 2).ceil(),
            ),
          ),
        ),
      ],
    );;
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
