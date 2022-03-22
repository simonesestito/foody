import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class AppFooter extends SliverFooter {
  const AppFooter({
    Key? key,
  }) : super(key: key, child: const _AppFooterContent());
}

class _AppFooterContent extends StatelessWidget {
  static const height = 50.0;

  const _AppFooterContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        color: Colors.grey[900],
        width: double.infinity,
        height: height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text('Copyright (C) 2022 Simone Sestito', textScaleFactor: 0.9),
          ],
        ),
      ),
    );
  }
}

///
/// SOURCE: https://stackoverflow.com/a/49621060/6418513
///
class SliverFooter extends SingleChildRenderObjectWidget {
  /// Creates a sliver that fills the remaining space in the viewport.
  const SliverFooter({
    Key? key,
    required Widget child,
  }) : super(key: key, child: child);

  @override
  RenderSliverFooter createRenderObject(BuildContext context) =>
      RenderSliverFooter();
}

class RenderSliverFooter extends RenderSliverSingleBoxAdapter {
  RenderSliverFooter({
    RenderBox? child,
  }) : super(child: child);

  @override
  void performLayout() {
    final extent =
        constraints.remainingPaintExtent - math.min(constraints.overlap, 0.0);
    var childGrowthSize = .0;
    if (child != null) {
      // changed maxExtent from 'extent' to double.infinity
      child!.layout(
          constraints.asBoxConstraints(
              minExtent: extent, maxExtent: double.infinity),
          parentUsesSize: true);
      childGrowthSize = constraints.axis == Axis.vertical
          ? child!.size.height
          : child!.size.width;
    }
    final paintedChildSize =
        calculatePaintOffset(constraints, from: 0.0, to: extent);
    assert(paintedChildSize.isFinite);
    assert(paintedChildSize >= 0.0);
    geometry = SliverGeometry(
      // used to be this : scrollExtent: constraints.viewportMainAxisExtent,
      scrollExtent: math.max(extent, childGrowthSize),
      paintExtent: paintedChildSize,
      maxPaintExtent: paintedChildSize,
      hasVisualOverflow: extent > constraints.remainingPaintExtent ||
          constraints.scrollOffset > 0.0,
    );
    if (child != null) {
      setChildParentData(child!, constraints, geometry!);
    }
  }
}
