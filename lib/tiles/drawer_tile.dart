import 'package:flutter/material.dart';

class DrawerTileCustom extends StatelessWidget {
  // properties
  final IconData icon;
  final String text;

  // cosntructor
  DrawerTileCustom(this.icon, this.text);

  @override
  Widget build(BuildContext context) {
    // retorna material para dar efeito visual ao selecionar item no menu
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        child: Container(
          height: 50.0,
          child: Row(
            children: [
              Icon(
                icon,
                size: 32,
                color: Colors.black,
              ),
              const SizedBox(
                width: 20.0,
              ),
              Text(
                text,
                style: const TextStyle(fontSize: 16.0, color: Colors.black),
              )
            ],
          ),
        ),
      ),
    );
  }
}
