import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:lashamezz/models/project_model.dart';
import 'package:shimmer/shimmer.dart';

import '../constants/zoogies.dart';
import 'home_screen.dart';

class ProjectDetailScreen extends StatelessWidget {
  const ProjectDetailScreen({super.key, required this.projectModel});

  final ProjectModel projectModel;
  @override
  Widget build(BuildContext context) {
    final GlobalKey _backgroundImageKey = GlobalKey();

    var mdof = MediaQuery.of(context);

    return Scaffold(
        backgroundColor: Colors.black,
        body: Align(
          alignment: Alignment.topCenter,
          child: Container(
            constraints: BoxConstraints(
                maxWidth: min(1000, MediaQuery.of(context).size.width * 0.8)),
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              slivers: [
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 400,
                    child: Stack(children: [
                      Center(
                        child: Hero(
                          createRectTween: (begin, end) {
                            return MaterialRectCenterArcTween(
                                begin: begin, end: end);
                          },
                          tag: '${projectModel.backgroundColor}Text',
                          child: DefaultTextStyle(
                            style: const TextStyle(
                              fontFamily: 'Greybeard',
                              fontSize: 40,
                              color: Colors.white,
                            ),
                            child: Text(
                              projectModel.title,
                            ),
                          ),
                        ),
                      ),
                    ]),
                  ),
                ),
                AnimationLimiter(
                  child: SliverGrid.builder(
                      itemCount: ZOOGIES_LIST.length,
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 200,
                        mainAxisSpacing: 0,
                        crossAxisSpacing: 30,
                        childAspectRatio: 0.7,
                      ),
                      itemBuilder: (context, index) {
                        return AnimationConfiguration.staggeredGrid(
                            position: index,
                            duration: const Duration(milliseconds: 375),
                            columnCount: ZOOGIES_LIST.length,
                            child: ZoogiePreviewGridTile(
                              image: ZOOGIES_LIST.values.elementAt(index),
                              title: ZOOGIES_LIST.keys.elementAt(index),
                            ));
                      }),
                ),
              ],
            ),
          ),
        ));
  }
}

class ZoogiePreviewGridTile extends StatelessWidget {
  const ZoogiePreviewGridTile({
    super.key,
    required this.image,
    required this.title,
  });

  final String image;
  final String title;

  @override
  Widget build(BuildContext context) {
    return FadeInAnimation(
      child: SlideAnimation(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () {
                context.pushTransparentRoute(InspectZoogie(image: image));
              },
              splashFactory: NoSplash.splashFactory,
              child: Hero(
                tag: image,
                createRectTween: (begin, end) {
                  return MaterialRectCenterArcTween(begin: begin, end: end);
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.asset(
                    image,
                    frameBuilder:
                        (context, child, frame, wasSynchronouslyLoaded) {
                      //circular progress indicator
                      if (wasSynchronouslyLoaded) {
                        return child;
                      }
                      return AnimatedOpacity(
                        opacity: frame == null ? 0 : 1,
                        duration: const Duration(seconds: 1),
                        curve: Curves.easeOut,
                        child: child,
                      );
                    },
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            AutoSizeText(
              title,
              maxLines: 1,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'Greybeard',
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InspectZoogie extends StatelessWidget {
  const InspectZoogie({
    super.key,
    required this.image,
  });

  final String image;

  @override
  Widget build(BuildContext context) {
    return DismissiblePage(
      backgroundColor: Colors.black,
      startingOpacity: 0.4,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 400,
              margin: const EdgeInsets.all(20),
              child: Hero(
                createRectTween: (begin, end) {
                  return MaterialRectCenterArcTween(begin: begin, end: end);
                },
                tag: image,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.asset(
                    image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const DefaultTextStyle(
              style: TextStyle(
                fontFamily: 'Greybeard',
                fontSize: 20,
                color: Colors.white,
              ),
              child: Text(
                'Current Owner: 0xf',
              ),
            ),
          ],
        ),
      ),
      onDismissed: () {
        Navigator.of(context).pop();
      },
    );
  }
}
