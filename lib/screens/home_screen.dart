import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
                      title: 'Vacancies',
                      titleImage:
                          'https://cdn.pixabay.com/photo/2012/08/27/14/19/mountains-55067__340.png',
                    ),
                  ),
                  ProjectPreviewColumn(
                    ProjectModel(
                        title: 'Aggregate',
                        titleImage:
                            'https://images.unsplash.com/photo-1562043236-559c3b65a6e2?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8bGFuZHNjYXBlc3xlbnwwfHwwfHw%3D&w=1000&q=80'),
                  ),
                  ProjectPreviewColumn(
                    ProjectModel(
                        title: 'Modules',
                        titleImage:
                            'https://images.unsplash.com/photo-1500964757637-c85e8a162699?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTF8fHZpZXd8ZW58MHx8MHx8&w=1000&q=80'),
                  ),
                  ProjectPreviewColumn(
                    ProjectModel(
                        title: 'Other',
                        titleImage:
                            'https://static.wixstatic.com/media/bb1bd6_cb14f2fa77da4667a8289261989062e4~mv2.png/v1/fill/w_640,h_366,al_c,q_85,usm_0.66_1.00_0.01,enc_auto/bb1bd6_cb14f2fa77da4667a8289261989062e4~mv2.png'),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}

// class ProjectPreviewColumn extends StatefulWidget {
//   const ProjectPreviewColumn(
//     this.project, {
//     super.key,
//   });

//   final ProjectModel project;

//   @override
//   State<ProjectPreviewColumn> createState() => _ProjectPreviewColumnState();
// }

// class _ProjectPreviewColumnState extends State<ProjectPreviewColumn>
//     with SingleTickerProviderStateMixin {
//   late AnimationController animationController;
//   late Animation<double> animation;
//   @override
//   void initState() {
//     animationController = AnimationController(
//         vsync: this, duration: const Duration(milliseconds: 500));
//     animation =
//         Tween<double>(begin: 0.1, end: 1.0).animate(animationController);
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final mdof = MediaQuery.of(context);
//     double columnWidth = (2000 - kNavBarWidth) / 4;
//     return MouseRegion(
//       onEnter: (event) {
//         animationController.forward();
//       },
//       onExit: (event) {
//         animationController.reverse();
//       },
//       child: InkWell(
//         splashFactory: InkSparkle.splashFactory,
//         hoverColor: Colors.transparent,
//         focusColor: Colors.black12,
//         onTap: () {},
//         child: SizedBox(
//           height: double.infinity,
//           width: columnWidth,
//           child: Stack(
//             children: [
//               Positioned.fill(
//                 left: widget.offset.dx * 50,
//                 child: Container(
//                   child: Image.asset(
//                     widget.project.titleImage,
//                     fit: BoxFit.none,
//                   ),
//                 ),
//               ),
//               Positioned.fill(
//                 child: Center(
//                   child: Text(
//                     widget.project.title,
//                     style: GoogleFonts.prata(fontSize: 30),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

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
    double columnWidth = (mdof.size.width - kNavBarWidth) / 4;
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
              // _buildGradient(),
              _buildTitle(),
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
      tag: widget.projectModel.titleImage,
      child: ParallaxBackground(
          backgroundImageKey: _backgroundImageKey,
          projectModel: widget.projectModel),
    );
  }

  Widget _buildTitle() {
    return Hero(
      createRectTween: (begin, end) {
        return MaterialRectCenterArcTween(begin: begin, end: end);
      },
      tag: '${widget.projectModel.titleImage}Text',
      child: Center(
        child: Text(widget.projectModel.title,
            style: const TextStyle(fontFamily: 'Lovelace', fontSize: 40)),
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
          widget.projectModel.titleImage,
          key: widget._backgroundImageKey,
          fit: BoxFit.cover,
        ),
      ],
    );
  }
}
