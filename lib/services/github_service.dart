import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/repo.dart';
import '../models/user.dart';
import '../models/contributor.dart';

class GitHubService {
  static const String baseUrl = "https://api.github.com";

  Future<List<Repo>> searchRepositories(String query) async {
    final response = await http.get(
      Uri.parse("$baseUrl/search/repositories?q=$query&sort=stars"),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['items'] as List).map((e) => Repo.fromJson(e)).toList();
    }
    throw Exception("Failed to fetch repositories");
  }

Future<List<Repo>> userRepos(String username) async {
  final response = await http.get(
    Uri.parse("$baseUrl/users/$username/repos"),
  );

  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body);
    return data.map((e) => Repo.fromJson(e)).toList();
  }

  throw Exception("Failed to fetch user's repos!");
}

  Future<List<Repo>> getTrendingRepositories() async {
    final response = await http.get(
      Uri.parse("$baseUrl/search/repositories?q=flutter&sort=stars&order=desc"),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['items'] as List).map((e) => Repo.fromJson(e)).toList();
    }
    throw Exception("Failed to fetch trending repos");
  }

  Future<GitHubUser> getUser(String username) async {
    final response = await http.get(Uri.parse("$baseUrl/users/$username"));
    if (response.statusCode == 200) {
      return GitHubUser.fromJson(json.decode(response.body));
    }
    throw Exception("User not found");
  }

  Future<List<Repo>> getStarredRepos(String username) async {
    final response = await http.get(
      Uri.parse("$baseUrl/users/$username/starred"),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data as List).map((e) => Repo.fromJson(e)).toList();
    }
    throw Exception("Failed to fetch starred repos");
  }

  Future<List<Contributor>> getContributors(String owner, String repo) async {
    final response = await http.get(
      Uri.parse("$baseUrl/repos/$owner/$repo/contributors"),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data as List).map((e) => Contributor.fromJson(e)).toList();
    }
    throw Exception("Failed to fetch contributors");
  }
}
