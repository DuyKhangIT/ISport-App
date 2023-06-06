import 'package:flutter/material.dart';

class ButtonNext extends StatelessWidget {
  final GestureTapCallback onTap;
  final String? textInside;
  final Widget? icon;
  final Color? color;

  const ButtonNext({
    Key? key,
    required this.onTap,
    this.textInside,
    this.icon,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      decoration: BoxDecoration(
          color: color ?? Colors.blue,
          borderRadius: BorderRadius.circular(8)),
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: const Color(0xffFFFFFF).withOpacity(0.4),
        ),
        onPressed: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon != null ? icon! : const SizedBox(),
            icon != null ? const SizedBox(width: 8) : const SizedBox(),
            Text(
              "$textInside",
              style: const TextStyle(
                color: Colors.black,
                fontFamily: 'Nunito Sans',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
