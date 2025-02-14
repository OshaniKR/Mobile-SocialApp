import 'package:flutter/material.dart';

class DeleteButton extends StatelessWidget {
  final void Function()? onTap;

  const DeleteButton(
      {super.key, this.onTap}); // Added this.onTap to the constructor

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: const Icon(
        Icons.cancel,
        color: Colors.grey,
      ),
    );
  }
}
