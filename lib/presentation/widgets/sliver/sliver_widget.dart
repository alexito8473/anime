import 'package:flutter/material.dart';

class SliverAppBarSearch extends StatelessWidget {
  final TextEditingController controller;
  final void Function()? onSubmit;
  final bool snapFloatingPinned;
  final bool isFlexibleSpaceBar;
  final bool canIcon;
  final Widget? action;

  const SliverAppBarSearch({
    super.key,
    required this.controller,
    this.onSubmit,
    this.snapFloatingPinned = true,
    this.isFlexibleSpaceBar = true,
    this.canIcon = true,
    this.action,
  });

  Widget textField(Size size) {
    return Container(
      margin: isFlexibleSpaceBar
          ? EdgeInsets.zero
          : EdgeInsets.symmetric(horizontal: size.width * 0.05),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[850],
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                controller: controller,
                onSubmitted: (_) => onSubmit?.call(),
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Buscar...',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  icon: canIcon
                      ? IconButton(
                          onPressed: onSubmit,
                          icon: const Icon(Icons.search, color: Colors.orange),
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: canIcon ? 0 : size.width * 0.05,
                  ),
                ),
              ),
            ),
          ),
          if (action != null) ...[SizedBox(width: 10), action!],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return SliverAppBar(
        floating: snapFloatingPinned,
        snap: snapFloatingPinned,
        pinned: snapFloatingPinned,
        automaticallyImplyLeading: false,
        expandedHeight: size.height * 0.02,
        backgroundColor: Colors.transparent,
        flexibleSpace: isFlexibleSpaceBar
            ? FlexibleSpaceBar(
                stretchModes: StretchMode.values,
                titlePadding:
                    EdgeInsets.symmetric(horizontal: size.width * 0.05),
                title: textField(size))
            : textField(size));
  }
}
