import 'package:flutter/material.dart';
import '../services/github_service.dart';
import '../models/repo.dart';
import '../widgets/repo_card.dart';
import '../widgets/search_bar.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final GitHubService _service = GitHubService();
  final TextEditingController _controller = TextEditingController();
  List<Repo> _results = [];
  bool _loading = false;

  void _searchRepos(String query) async {
    if (query.isEmpty) {
      setState(() => _results = []);
      return;
    }
    setState(() => _loading = true);
    try {
      final repos = await _service.searchRepositories(query);
      setState(() => _results = repos);
    } catch (_) {
      setState(() => _results = []);
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const Text(
              "Explore",
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w800,
                letterSpacing: 2.5,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Search GitHub Repositories",
              style: TextStyle(fontSize: 16, color: Colors.grey[400]),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            SearchBarWidget(controller: _controller, onSearch: _searchRepos),
            const SizedBox(height: 12),
            Expanded(
              child: _loading
                  ? Center(
              child: LoadingAnimationWidget.flickr(
                leftDotColor: const Color(0xFF1A1A3F),
                rightDotColor: const Color(0xFFEA3799),
                size: 60,
              ),
            )
                  : _results.isEmpty
                  ? const Center(child: Text("Start typing to search"))
                  : ListView.builder(
                      itemCount: _results.length,
                      itemBuilder: (context, index) {
                        return RepoCard(repo: _results[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
