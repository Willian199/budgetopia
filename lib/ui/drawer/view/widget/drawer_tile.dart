import 'package:budgetopia/common/constantes/double.dart';
import 'package:budgetopia/common/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ddi/flutter_ddi.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

class DrawerTile extends StatefulWidget {
  const DrawerTile(this.icon, this.text, this.page, {super.key});

  final IconData icon;
  final String text;
  final int page;

  @override
  State<DrawerTile> createState() => _DrawerTileState();
}

class _DrawerTileState extends ListenableState<DrawerTile, PageController> {
  int get _currentPage {
    if (!listenable.hasClients || listenable.page == null) {
      return listenable.initialPage;
    }

    return listenable.page!.round();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = context.colorScheme;

    final Color itemColor = _currentPage == widget.page ? scheme.primaryFixed : scheme.onPrimaryFixed;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        splashColor: Colors.transparent,
        onTap: () {
          ddi.get<ZoomDrawerController>().close?.call();

          if (listenable.hasClients) {
            listenable.jumpToPage(widget.page);
          }
        },
        child: Container(
          height: Double.SETENTA,
          padding: const EdgeInsets.only(left: Double.VINTE),
          child: Row(
            children: <Widget>[
              Icon(
                widget.icon,
                size: Double.QUARENTA,
                color: itemColor,
              ),
              const SizedBox(
                width: Double.TRINTA_DOIS,
              ),
              Text(
                widget.text,
                style: TextStyle(
                  fontSize: Double.VINTE,
                  color: itemColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
