import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

Future<Widget> loadSvgWithColorReplacement({
  required String assetPath,
  required String newColor,
  required double size
}) async {
  String rawSvg = await rootBundle.loadString(assetPath);

  final replacedSvg = rawSvg.replaceAll(
    '#E6E6E6',
    newColor
  );

  return SvgPicture.string(
    replacedSvg,
    fit: BoxFit.contain,
    width: size,
  );
}

class Logo extends StatelessWidget {
  final double size;
  final String? text;

  const Logo({super.key, this.size = 52, this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        FutureBuilder<Widget>(
          future: loadSvgWithColorReplacement(
            assetPath: 'assets/logo.svg',
            newColor: Theme.of(context).brightness == Brightness.light
                ? "#1A1A1A"
                : "#E6E6E6",
            size: size
          ),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
              return snapshot.data!;
            } else {
              return const CircularProgressIndicator();
           }
          },
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 6),
          child: Text(
            text ?? "goIPVC não é um projeto oficial do IPVC",
            style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: size / 16),
          ),
        )
      ],
    );
  }
}
