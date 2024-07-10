import 'dart:io';

import 'package:altx/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  final TextEditingController _nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    LocalUser currentUser = ref.watch(userProvider);
    _nameController.text = currentUser.user.name;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            GestureDetector(
              onTap: () async {
                final ImagePicker picker = ImagePicker();
                final XFile? pickedImage = await picker.pickImage(
                    source: ImageSource.gallery, requestFullMetadata: false);
                if (pickedImage != null) {
                  ref
                      .read(userProvider.notifier)
                      .updatePicture(File(pickedImage.path));
                }
              },
              child: CircleAvatar(
                radius: 100,
                backgroundImage: NetworkImage(currentUser.user.profilePic),
                child: const Opacity(
                  opacity: 0.1,
                  child: Icon(
                    Icons.upload_outlined,
                    size: 170,
                    shadows: [
                      BoxShadow(
                          blurRadius: 0.4,
                          color: Colors.grey,
                          offset: Offset(2, 4))
                    ],
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Center(
              child: Text("Tap Image to change"),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                  labelText: "Name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    borderSide: BorderSide(color: Color(0xFF317773)),
                  )),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    backgroundColor: Theme.of(context).colorScheme.secondary),
                onPressed: () {
                  ref
                      .read(userProvider.notifier)
                      .updateName(_nameController.text);
                },
                child: Text(
                  'Update',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary),
                ))
          ],
        ),
      ),
    );
  }
}
