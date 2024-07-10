import 'package:altx2/providers/tweet_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateTweet extends ConsumerWidget {
  const CreateTweet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TextEditingController tweetController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Write a Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            TextField(
              controller: tweetController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)))),
              maxLength: 280,
              maxLines: 7,
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        backgroundColor:
                            Theme.of(context).colorScheme.secondary),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                          fontSize: 17,
                          color: Theme.of(context).colorScheme.primary),
                    )),
                const SizedBox(
                  width: 20,
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        backgroundColor:
                            Theme.of(context).colorScheme.inversePrimary),
                    onPressed: () {
                      ref.read(tweetProvider).postTweet(tweetController.text);
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Post',
                      style: TextStyle(
                          fontSize: 17,
                          color: Theme.of(context).colorScheme.primary),
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }
}
