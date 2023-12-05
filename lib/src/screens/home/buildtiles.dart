import 'package:aquavista/src/util/constantes.dart';
import 'package:aquavista/src/util/style.dart';
import 'package:aquavista/src/widgets/tiles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

List<StaggeredGridTile> buildTiles() {
  final List<StaggeredGridTile> tilesSize = [];

  tilesSize.add(StaggeredGridTile.extent(
    crossAxisCellCount: 1,
    mainAxisExtent: 150,
    child: Tile(
        icon: Icons.stacked_line_chart,
        heading: 'Estadisticas',
        color: logoImageColor, //0xff3399fe,
        backColor: mainColor,
        route: ESTADISTICAS,
        params: const [
          ESTADISTICAS,
        ]),
  ));

  tilesSize.add(StaggeredGridTile.extent(
    crossAxisCellCount: 1,
    mainAxisExtent: 150,
    child: Tile(
        icon: Icons.sync,
        heading: 'Sincronizar',
        color: logoImageColor,
        backColor: mainColor,
        route: SINCRONIZAR,
        params: const [
          SINCRONIZAR,
        ]),
  ));

  tilesSize.add(StaggeredGridTile.extent(
    crossAxisCellCount: 1,
    mainAxisExtent: 150,
    child: Tile(
        icon: Icons.settings,
        heading: 'Ajustes',
        color: logoImageColor, //0xff3399fe,
        backColor: mainColor,
        route: AJUSTES,
        params: const [
          AJUSTES,
        ]),
  ));

  return tilesSize;
}
