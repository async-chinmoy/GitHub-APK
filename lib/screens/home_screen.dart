import 'package:flutter/material.dart';
import '../services/github_service.dart';
import '../models/repo.dart';
import '../widgets/repo_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GitHubService _service = GitHubService();
  late Future<List<Repo>> _trendingRepos;

  @override
  void initState() {
    super.initState();
    _trendingRepos = _service.getTrendingRepositories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Trending Repositories")),
      body: FutureBuilder<List<Repo>>(
        future: _trendingRepos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No trending repositories"));
          }
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return RepoCard(repo: snapshot.data![index]);
            },
          );
        },
      ),
    );
  }
}
