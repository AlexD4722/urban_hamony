import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../components/card/cardProject.dart';
import '../components/card/cardProjectScreen.dart';

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
                if (index == 0) {
                  // First row: Add Project widget and first project
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _addCardProject()),
                        SizedBox(width: 10),
                        Expanded(
                          child: projects.isNotEmpty
                              ? CardProjectScreen(
                                  title: projects[0]['title'] ?? '',
                                  description: projects[0]['description'] ?? '',
                                  imageUrl: projects[0]['imageUrl'] ?? '',
                                )
                              : Container(),
                        ),
                      ],
                    ),
                  );
                } else {
                  // Subsequent rows: Two projects per row
                  final int startIndex = (index * 2) - 1;
                  if (startIndex >= projects.length) {
                    return null;
                  }
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: CardProjectScreen(
                            title: projects[startIndex]['title'] ?? '',
                            description:
                                projects[startIndex]['description'] ?? '',
                            imageUrl: projects[startIndex]['imageUrl'] ?? '',
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: startIndex + 1 < projects.length
                              ? CardProjectScreen(
                                  title:
                                      projects[startIndex + 1]['title'] ?? '',
                                  description: projects[startIndex + 1]
                                          ['description'] ??
                                      '',
                                  imageUrl: projects[startIndex + 1]
                                          ['imageUrl'] ??
                                      '',
                                )
                              : Container(),
                        ),
                      ],
                    ),
                  );
                }
              },
              childCount: ((projects.length - 1) / 2).ceil() + 1,
            ),
          ),
        ),
      ],
    );
    ;
  }

  Widget _addCardProject() {
    return GestureDetector(
      onTap: () => {},
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: AspectRatio(
              aspectRatio: 1,
              child:Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
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
