import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:todo_app/models/posts_model.dart';

class PostsScreen extends StatefulWidget {
  @override
  _PostsScreenState createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  List<Post> posts = [];
  List<Post> filteredPosts = [];
  bool isLoading = false;
  String error = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchPosts();
  }

  Future<void> _fetchPosts() async {
    setState(() {
      isLoading = true;
      error = '';
    });

    try {
      final response = await http.get(
        Uri.parse('https://jsonplaceholder.typicode.com/posts'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        setState(() {
          posts = jsonData.map((post) => Post.fromJson(post)).toList();
          filteredPosts = posts;
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load posts');
      }
    } catch (e) {
      setState(() {
        error = 'Error fetching posts: $e';
        isLoading = false;
      });
    }
  }

  void _filterPosts(String userId) {
    if (userId.isEmpty) {
      setState(() {
        filteredPosts = posts;
      });
      return;
    }

    try {
      final id = int.parse(userId);
      setState(() {
        filteredPosts = posts.where((post) => post.userId == id).toList();
      });
    } catch (e) {
      // Invalid input - show all posts
      setState(() {
        filteredPosts = posts;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Filter by User ID',
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.search),
            ),
            keyboardType: TextInputType.number,
            onChanged: _filterPosts,
          ),
        ),
        if (isLoading)
          Center(child: CircularProgressIndicator())
        else if (error.isNotEmpty)
          Center(child: Text(error, style: TextStyle(color: Colors.red)))
        else
          Expanded(
            child: ListView.builder(
              itemCount: filteredPosts.length,
              itemBuilder: (context, index) {
                final post = filteredPosts[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(
                      post.title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 8),
                        Text(post.body),
                        SizedBox(height: 8),
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
          ),
      ],
    );
  }
}