import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:plex/plex_assets.dart';

class PlexLoaderV2 extends StatelessWidget {
  const PlexLoaderV2({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 100,
      child: Lottie.asset(loadingV2),
    );
  }
}