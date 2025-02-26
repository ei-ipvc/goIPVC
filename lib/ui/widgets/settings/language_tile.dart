import 'package:flutter/material.dart';
import 'package:goipvc/generated/l10n.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goipvc/providers/data_providers.dart';
import 'package:goipvc/ui/widgets/dropdown.dart';

class LanguageTile extends ConsumerWidget {
  const LanguageTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final languageState = ref.watch(languageProvider);
    final languageNotifier = ref.read(languageProvider.notifier);

    return ListTile(
      leading: Icon(Icons.language),
      title: Text(S.of(context).language),
      trailing: Dropdown<String>(
        value: languageState.languageCode,
        items: [
          DropdownMenuItem<String>(
            value: "pt",
            child: Text("Português"),
          ),
          DropdownMenuItem<String>(
            value: "en",
            child: Text("English"),
          ),
        ],
        onChanged: (String? value) {
          if (value != null) {
            languageNotifier.changeLanguage(value);
          }
        },
      ),
    );
  }
}