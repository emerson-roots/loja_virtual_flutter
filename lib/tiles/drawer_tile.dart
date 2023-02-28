import 'package:flutter/material.dart';

class DrawerTileCustom extends StatelessWidget {
  // properties
  final IconData icon;
  final String text;
  final PageController pageController;
  final int page;

  // constructor
  DrawerTileCustom(this.icon, this.text, this.pageController, this.page);

  @override
  Widget build(BuildContext context) {
    // retorna material para dar efeito visual ao selecionar item no menu
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          pageController.jumpToPage(page);
          // fecha o menu hamburguer
          Navigator.of(context).pop();
        },
        child: Container(
          height: 50.0,
          child: Row(
            children: [
              Icon(
                icon,
                size: 32,
                color: pageController.page!.round() == page
                    ? Theme.of(context).primaryColor
                    : Colors.grey[700],
              ),
              const SizedBox(
                width: 20.0,
              ),
              Text(
                text,
                style: TextStyle(
                  fontSize: 16.0,
                  color: pageController.page!.round() == page
                      ? Theme.of(context).primaryColor
                      : Colors.grey[700],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
