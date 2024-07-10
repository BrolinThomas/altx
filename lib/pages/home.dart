import 'package:altx/models/tweet.dart';
import 'package:altx/pages/create.dart';
import 'package:altx/pages/loginpage.dart';
import 'package:altx/pages/settings.dart';
import 'package:altx/providers/tweet_provider.dart';
import 'package:altx/providers/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Home extends ConsumerWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    LocalUser currentUser = ref.watch(userProvider);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: Builder(builder: (context) {
          return GestureDetector(
            onTap: () => Scaffold.of(context).openDrawer(),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: CircleAvatar(
                backgroundImage: NetworkImage(
                  currentUser.user.profilePic,
                ),
              ),
            ),
          );
        }),
        title: const Text('Home'),
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(4.0),
            child: Container(
              height: 1,
              color: Theme.of(context).colorScheme.primary,
            )),
        actions: [
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                ref.read(userProvider.notifier).logout();
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: ref.watch(feedProvider).when(
            data: (List<Tweet> tweets) {
              return ListView.separated(
                separatorBuilder: (context, index) => Divider(
                  indent: 15,
                  endIndent: 15,
                  thickness: 0.2,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
                itemCount: tweets.length,
                itemBuilder: (context, count) {
                  return ListTile(
                    leading: CircleAvatar(
                      foregroundImage: NetworkImage(tweets[count].profilePic),
                    ),
                    title: Text(
                      tweets[count].name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    subtitle: Text(
                      tweets[count].tweet,
                      style: const TextStyle(fontSize: 16),
                    ),
                  );
                },
              );
            },
            error: (error, stackTrace) => const Center(
              child: Text('Error'),
            ),
            loading: () => Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
          ),
      drawer: Drawer(
        shape: const BeveledRectangleBorder(),
        child: Column(
          children: [
            Image(
              image: NetworkImage(currentUser.user.profilePic),
              fit: BoxFit.fill,
              height: 300,
            ),
            ListTile(
              title: Text(
                "Hello, ${currentUser.user.name}",
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            ListTile(
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SettingsPage(),
                    ));
              },
            ),
            ListTile(
              title: const Text('Sign Out'),
              onTap: () {
                FirebaseAuth.instance.signOut();
                ref.read(userProvider.notifier).logout();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginPage(),
                    ));
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CreateTweet(),
              ));
        },
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        child: const Icon(
          Icons.add,
          size: 30,
        ),
      ),
    );
  }
}
