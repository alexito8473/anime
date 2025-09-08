import 'package:flutter/material.dart';

class ButtonSelectorIconTextWidget extends StatelessWidget {
  final String title;
  final int current;
  final IconData icon;
  final Function(int index) changeIndex;
  const ButtonSelectorIconTextWidget(
      {super.key,
      required this.title,
      required this.current,
      required this.icon, required this.changeIndex});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return Padding(
        padding: EdgeInsets.only(left: size.width * 0.01),
        child: ElevatedButton(
            onPressed: () => changeIndex(current),
            style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.withAlpha(50),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    elevation: 10,
                    // Sombra elevada
                    shadowColor: Colors.transparent)
                .copyWith(
                    overlayColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.pressed)) {
                return Colors.blueGrey.shade900; // Efecto al presionar
              }
              return null;
            })),
            child: Row(
              spacing: 10,
              children: [
                Icon(
                  icon,
                  color: Colors.white,
                ),
                Text(title, style: Theme.of(context).textTheme.titleMedium)
              ],
            )));
  }
}
