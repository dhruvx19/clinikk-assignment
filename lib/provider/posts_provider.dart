import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todo_app/models/posts_model.dart';

class PostsProvider with ChangeNotifier {
  List<Post> _posts = [];
  List<Post> _filteredPosts = [];
  bool _isLoading = false;
  String _error = '';

  List<Post> get posts => _posts;
  List<Post> get filteredPosts => _filteredPosts;
  bool get isLoading => _isLoading;
  String get error => _error;

  Future<void> fetchPosts() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('https://jsonplaceholder.typicode.com/posts'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        _posts = jsonData.map((post) => Post.fromJson(post)).toList();
        _filteredPosts = _posts;
      } else {
        throw Exception('Failed to load posts');
      }
    } catch (e) {
      _error = 'Error fetching posts: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void filterPosts(String userId) {
    if (userId.isEmpty) {
      _filteredPosts = _posts;
      notifyListeners();
      return;
    }

    try {
      final id = int.parse(userId);
      _filteredPosts = _posts.where((post) => post.userId == id).toList();
    } catch (e) {
      // Invalid input - show all posts
      _filteredPosts = _posts;
    }
    notifyListeners();
  }
}