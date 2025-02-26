import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goipvc/providers/data_providers.dart';
import '../containers.dart';

class ServerTile extends ConsumerWidget {
  const ServerTile({super.key});

  void showServerSettingsDialog(BuildContext context, WidgetRef ref) {
    final serverNotifier = ref.read(serverUrlProvider.notifier);
    final serverState = ref.read(serverUrlProvider);
    final TextEditingController controller = TextEditingController(
        text: serverState.url);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      labelText: "Server:",
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: serverNotifier
                            .getStatusColor()),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: serverNotifier
                            .getStatusColor()),
                      ),
                    ),
                    autocorrect: false,
                  ),
                ],
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () async {
                        await serverNotifier.pingServer(controller.text);
                        setState(() {}); // Update dialog UI
                      },
                      child: const Text("Test"),
                    ),
                    TextButton(
                      onPressed: () {
                        serverNotifier.saveServerUrl(controller.text);
                        Navigator.pop(context);
                      },
                      child: const Text("Save"),
                    ),
                  ],
                )
              ],
            );
          }
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final serverState = ref.watch(serverUrlProvider);

    return ListTile(
      leading: const Icon(Icons.dns),
      title: const Text("Server"),
      trailing: TextContainer(text: serverState.url),
      onTap: () {
        showServerSettingsDialog(context, ref);
      },
    );
  }
}