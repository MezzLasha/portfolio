import 'dart:math';

import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/material.dart';
import 'package:lashamezz/models/project_model.dart';
import 'package:lashamezz/screens/project_detail_screen.dart';
import 'package:lashamezz/ui/parallax.dart';

const kNavBarWidth = 50.0;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Row(
          children: [
            SizedBox(
              height: double.infinity,
              width: kNavBarWidth,
              child: Material(
                color: Colors.black,
                child: Center(
                    child: IconButton(
                        onPressed: () {}, icon: const Icon(Icons.menu))),
              ),
            ),
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                children: [
                  ProjectPreviewColumn(
                    ProjectModel(
                        title: 'Zoogies',
                        backgroundColor: 'assets/images/1.png',
                        hoverColor: Colors.white),
                  ),
                  ProjectPreviewColumn(
                    ProjectModel(
                        title: 'Roadmap',
                        backgroundColor: 'assets/images/2.png',
                        hoverColor: Colors.white),
                  ),
                  ProjectPreviewColumn(
                    ProjectModel(
                        title: 'About',
                        backgroundColor: 'assets/images/3.png',
                        hoverColor: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}

class ProjectPreviewColumn extends StatefulWidget {
  const ProjectPreviewColumn(
    this.projectModel, {
    super.key,
  });

  final ProjectModel projectModel;

  @override
  State<ProjectPreviewColumn> createState() => _ProjectPreviewColumnState();
}

class _ProjectPreviewColumnState extends State<ProjectPreviewColumn>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));

    _animation = Tween<double>(begin: 0.0, end: 1).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeIn));
    super.initState();
  }

  final GlobalKey _backgroundImageKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final mdof = MediaQuery.of(context);
    double columnWidth = max(((mdof.size.width - kNavBarWidth) / 3), 300);
    return SizedBox(
      width: columnWidth,
      height: double.infinity,
      child: MouseRegion(
        onEnter: (event) => _animationController.forward(),
        onExit: (event) => _animationController.reverse(),
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () => context.pushTransparentRoute(
              ProjectDetailScreen(projectModel: widget.projectModel)),
          child: Stack(
            fit: StackFit.expand,
            children: [
              AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _animation.value,
                      child: child,
                    );
                  },
                  child: _buildParallaxBackground(context)),
              AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return _buildTitle(Color.lerp(Colors.white,
                            widget.projectModel.hoverColor, _animation.value) ??
                        Colors.white);
                  }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildParallaxBackground(BuildContext context) {
    return Hero(
      createRectTween: (begin, end) {
        return MaterialRectCenterArcTween(begin: begin, end: end);
      },
      tag: widget.projectModel.backgroundColor,
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Image.asset(
          widget.projectModel.backgroundColor,
          fit: BoxFit.fitHeight,
          key: _backgroundImageKey,
        ),
      ),
    );
  }

  Widget _buildTitle(Color color) {
    return Center(
      child: Hero(
        createRectTween: (begin, end) {
          return MaterialRectCenterArcTween(begin: begin, end: end);
        },
        tag: '${widget.projectModel.backgroundColor}Text',
        child: DefaultTextStyle(
          style: TextStyle(
            fontFamily: 'Greybeard',
            fontSize: 40,
            color: color,
          ),
          child: Text(widget.projectModel.title),
        ),
      ),
    );
  }
}

class ParallaxBackground extends StatefulWidget {
  const ParallaxBackground({
    super.key,
    required GlobalKey<State<StatefulWidget>> backgroundImageKey,
    required this.projectModel,
  }) : _backgroundImageKey = backgroundImageKey;

  final GlobalKey<State<StatefulWidget>> _backgroundImageKey;
  final ProjectModel projectModel;

  @override
  State<ParallaxBackground> createState() => _ParallaxBackgroundState();
}

class _ParallaxBackgroundState extends State<ParallaxBackground> {
  @override
  Widget build(BuildContext context) {
    return Flow(
      delegate: ParallaxFlowDelegate(
        scrollable: Scrollable.of(context),
        listItemContext: context,
        backgroundImageKey: widget._backgroundImageKey,
      ),
      children: [
        Image.network(
          widget.projectModel.backgroundColor,
          key: widget._backgroundImageKey,
          fit: BoxFit.cover,
        ),
      ],
    );
  }
}
