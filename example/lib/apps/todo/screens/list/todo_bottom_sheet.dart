import 'package:flutter/material.dart';

class TodoBottomSheet extends StatelessWidget {
  const TodoBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textController = TextEditingController();
    return Align(
      alignment: Alignment.bottomCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: BottomSheet(
          onClosing: () {
            textController.dispose();
          },
          builder: (context) {
            final textTheme = Theme.of(context).textTheme;

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    "New Todo",
                    style: textTheme.headline3,
                  ),
                  const Divider(),
                  Expanded(
                    child: TextField(
                      autofocus: true,
                      controller: textController,
                      expands: true,
                      minLines: null,
                      maxLines: null,
                      textAlignVertical: TextAlignVertical.top,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  ButtonBar(
                    alignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context, textController.text);
                        },
                        child: const Text("Save"),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Cancel"),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
