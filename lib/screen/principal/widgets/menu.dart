import 'package:essential_control_pc/style/styles/dark_ligth_theme.dart';
import 'package:flutter/material.dart';

class menuPop {
  void showCustomMenu(BuildContext context, Offset offset, String title,
      String icon, String openCommand) {
    final RenderObject overlay =
        Overlay.of(context).context.findRenderObject()!;

    showMenu(
        elevation: 0.7,
        color: darkLightTheme().greyContainer(),
        context: context,
        items: [
          itemMenu(context, 'Sincronizar', Icons.sync_outlined, openCommand),
          itemMenu(
              context, 'Crear Pad', Icons.videogame_asset_outlined, openCommand)
        ],
        position: RelativeRect.fromRect(
            Rect.fromLTWH(offset.dx, offset.dy, 30, 30),
            Rect.fromLTWH(0, 0, overlay.paintBounds.size.width,
                overlay.paintBounds.size.height)));
  }

  PopupMenuItem itemMenu(
      BuildContext context, String title, IconData icon, String openCommand) {
    return PopupMenuItem(
        child: Row(children: [
          Icon(
            icon,
            color: darkLightTheme().greyDetail(),
          ),
          const SizedBox(width: 16),
          Text(title, style: TextStyle(color: darkLightTheme().greyDetail()))
        ]),
        onTap: () {
          Navigator.of(context).pushNamed("controlcreate");
        });
  }
}
