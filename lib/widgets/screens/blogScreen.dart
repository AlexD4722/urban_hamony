import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
class BlogScreen extends StatelessWidget {
  final String htmlContent;
  const BlogScreen({super.key, required this.htmlContent});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
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
                    HtmlWidget(htmlContent),
                  ],
                ),
              ),
            ]),
          ),
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
            child:   AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              title: const Text(
                'Back',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
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