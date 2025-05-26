import 'package:flutter/material.dart';

class CustomActivityIndicator extends StatelessWidget {
  CustomActivityIndicator();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.1),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            CircularProgressIndicator(
              color: Colors.black,
            ),
            SizedBox(
              height: 16.0,
            ),
            Text(
              "Carregando...",
              style: TextStyle(color: Colors.black),
            )
          ],
        ),
      ),
    );
  }
}
