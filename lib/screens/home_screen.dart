import 'package:flutter/material.dart';
import '../services/github_service.dart';
import '../models/repo.dart';
import '../widgets/repo_card.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

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
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Home",
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.w900,
              letterSpacing: 2.5),
            ),
            SizedBox(height: 8),
            Text(
              "Trending Repositories",
              style: TextStyle(fontSize: 16, color: Colors.grey[400]),
            ),
          ],
        ),
       
      ),
      body: FutureBuilder<List<Repo>>(
        future: _trendingRepos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: LoadingAnimationWidget.flickr(
                leftDotColor: const Color(0xFF1A1A3F),
                rightDotColor: const Color(0xFFEA3799),
                size: 60,
              ),
            );
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
