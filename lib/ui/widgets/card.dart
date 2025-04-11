import 'package:flutter/material.dart';

class FilledCard extends StatelessWidget {
  final Widget? iconWidget;
  final IconData? icon;
  final String? title;
  final Widget? titleWidget;
  final Widget? footer;
  final Widget? trailing;
  final Color? backgroundColor;
  final double? paddingVertical;
  final double? paddingHorizontal;
  final double? marginVertical;
  final double? marginHorizontal;
  final List<Widget> children;
  final Function()? onTap;
  final Function()? onLongPress;

  const FilledCard({
    super.key,
    required this.children,
    this.icon,
    this.iconWidget,
    this.title,
    this.titleWidget,
    this.footer,
    this.trailing,
    this.backgroundColor,
    this.paddingVertical,
    this.paddingHorizontal,
    this.marginVertical,
    this.marginHorizontal,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final hasHeader = titleWidget != null || (title != null && title!.isNotEmpty);
    final currentIcon = iconWidget ?? (icon != null
        ? Icon(
      icon,
      size: 16,
      color: Theme.of(context).colorScheme.primary,
    )
        : null);

    return Card.filled(
      color: backgroundColor ?? Theme.of(context).colorScheme.surfaceContainer,
      margin: EdgeInsets.symmetric(
        vertical: marginVertical ?? 6,
        horizontal: marginHorizontal ?? 0,
      ),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (hasHeader)
              Padding(
                padding: const EdgeInsets.only(
                  left: 10,
                  right: 10,
                  top: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (currentIcon != null)
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: currentIcon,
                      ),
                    Expanded(
                      child: titleWidget ?? Text(
                        title!,
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (trailing != null) trailing!,
                  ],
                ),
              ),

            // Content section
            Padding(
              padding: EdgeInsets.only(
                left: paddingHorizontal ?? 10,
                right: paddingHorizontal ?? 10,
                top: hasHeader ? 0 : 10,
                bottom: footer != null ? 0 : 10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: children,
              ),
            ),

            // Footer section
            if (footer != null)
              Padding(
                padding: const EdgeInsets.only(
                  left: 10,
                  right: 10,
                  bottom: 10,
                ),
                child: footer!
              ),
          ],
        ),
      ),
    );
  }
}


class ExpandableCard extends StatelessWidget {
  final String title;
  final List<Widget> body;
  final Color? backgroundColor;

  const ExpandableCard({
    super.key,
    required this.title,
    required this.body,
    this.backgroundColor
  });

  @override
  Widget build(BuildContext context) {
    return Card.filled(
      color: backgroundColor ?? Theme.of(context).colorScheme.surfaceContainer,
      margin: EdgeInsets.symmetric(vertical: 6),
      clipBehavior: Clip.hardEdge,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
              child: Align(
                alignment: Alignment.topLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: body,
                ),
              ),
            )
          ],
        ),
      )
    );
  }
}