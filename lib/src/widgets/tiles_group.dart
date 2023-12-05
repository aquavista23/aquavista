import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

// import 'tile.dart';
export 'tiles.dart';

Widget tilesGroup(List<StaggeredGridTile> tilesSize) {
  return StaggeredGrid.count(
    crossAxisCount: 2,
    crossAxisSpacing: 12.0,
    mainAxisSpacing: 12.0,
    axisDirection: AxisDirection.down,
    children: tilesSize,
    // padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    // staggeredTiles: tilesSize,
  );
}
