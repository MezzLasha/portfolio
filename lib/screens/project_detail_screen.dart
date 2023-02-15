import 'package:flutter/material.dart';
import 'package:lashamezz/models/project_model.dart';

import 'home_screen.dart';

class ProjectDetailScreen extends StatelessWidget {
  const ProjectDetailScreen({super.key, required this.projectModel});

  final ProjectModel projectModel;
  @override
  Widget build(BuildContext context) {
    final GlobalKey _backgroundImageKey = GlobalKey();
    return Scaffold(
      body: ListView(
        shrinkWrap: true,
        children: [
          Stack(
            children: [
              Center(
                child: Hero(
                    createRectTween: (begin, end) {
                      return MaterialRectCenterArcTween(begin: begin, end: end);
                    },
                    tag: projectModel.titleImage,
                    child: SizedBox(
                      height: 400,
                      width: 400,
                      child: Image.network(
                        projectModel.titleImage,
                        fit: BoxFit.cover,
                      ),
                    )),
              ),
              Hero(
                  createRectTween: (begin, end) {
                    return MaterialRectCenterArcTween(begin: begin, end: end);
                  },
                  tag: '${projectModel.titleImage}Text',
                  child: Center(
                    child: Text(projectModel.title,
                        style: const TextStyle(
                            fontFamily: 'Lovelace', fontSize: 40)),
                  )),
            ],
          ),
          const SizedBox(
            height: 1000,
          )
        ],
      ),
    );
  }

  Widget _buildParallaxBackground(BuildContext context,
      GlobalKey<State<StatefulWidget>> backgroundImageKey) {
    return ParallaxBackground(
        backgroundImageKey: backgroundImageKey, projectModel: projectModel);
  }
}
