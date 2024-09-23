import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'dart:math' as math;
import '../../models/auth_model.dart';
import '../../models/design.dart';
import '../../services/database_service.dart';
import '../../utils/userInfoUtil.dart';
import '../components/card/cardProjectScreen.dart';
import 'drawScreen.dart';

class ProjectScreen extends StatelessWidget {
  const ProjectScreen({Key? key}) : super(key: key);

  Future<UserModel?> _getCurrentUser() async {
    return await UserinfoUtil.getCurrentUser();
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
        status: c.status, // Add status here
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
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
          return StreamBuilder<List<Design>>(
            stream: DatabaseService().getDesignsByEmail(currentUser.email ?? ''),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No designs found'));
              } else {
                List<Design> designs = _generateDesignList(snapshot.data!);
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
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(child: _addCardProject(context)),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: designs.isNotEmpty
                                          ? CardProjectScreen(design: designs[0],)
                                          : Container(),
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              final int startIndex = (index * 2) - 1;
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: CardProjectScreen(design: designs[0]),
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: startIndex + 1 < designs.length
                                          ? CardProjectScreen(design: designs[startIndex + 1],)
                                          : Container(),
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                          childCount: ((designs.length - 1) / 2).ceil() + 1,
                        ),
                      ),
                    ),
                  ],
                );
              }
            },
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
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
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
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
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