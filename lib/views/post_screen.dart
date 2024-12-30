import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/provider/posts_provider.dart';

class PostsScreen extends StatefulWidget {
  @override
  _PostsScreenState createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Fetch posts when screen initializes
    Future.microtask(
      () => context.read<PostsProvider>().fetchPosts(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              hintText: 'Filter by User ID',
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.search),
            ),
            keyboardType: TextInputType.number,
            onChanged: (value) => 
              context.read<PostsProvider>().filterPosts(value),
          ),
        ),
        Consumer<PostsProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            
            if (provider.error.isNotEmpty) {
              return Center(
                child: Text(
                  provider.error,
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            return Expanded(
              child: ListView.builder(
                itemCount: provider.filteredPosts.length,
                itemBuilder: (context, index) {
                  final post = provider.filteredPosts[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
                      title: Text(
                        post.title,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Text(post.body),
                          const SizedBox(height: 8),
                          Text(
                            'User ID: ${post.userId}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                      isThreeLine: true,
                    ),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
