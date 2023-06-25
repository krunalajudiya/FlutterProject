import 'package:emgage_flutter/src/features/separation/view/widgets/filter_dialog_box.dart';
import 'package:flutter/material.dart';

class SeparationView extends StatelessWidget {
  const SeparationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () async {
                var data = await showFilterDialogBox(context, []);
                if (data != null) {}
              },
              icon: const Icon(Icons.filter_alt))
        ],
      ),
      body: Container(),
    );
  }
}
