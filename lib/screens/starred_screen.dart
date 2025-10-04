import 'package:flutter/material.dart';
import 'package:github/widgets/search_bar.dart';
import '../services/github_service.dart';
import '../models/repo.dart';
import '../widgets/repo_card.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../widgets/search_bar.dart';

class StarredScreen extends StatefulWidget {
  const StarredScreen({super.key});

  @override
  State<StarredScreen> createState() => _StarredScreenState();
}

class _StarredScreenState extends State<StarredScreen> {
  final GitHubService _service = GitHubService();
  final TextEditingController _controller = TextEditingController();
  List<Repo> _repos = [];
  bool _loading = false;

  void _fetchStarred(String query) async {
    if (_controller.text.isEmpty) return;
    setState(() => _loading = true);
    try {
      final repos = await _service.getStarredRepos(_controller.text.trim());
      setState(() => _repos = repos);
    } catch (_) {
      setState(() => _repos = []);
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
              "Starred repos",
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold, fontFamily: 'Nunito',
                letterSpacing: 2.5,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Search starred repositories by username",
              style: TextStyle(fontSize: 16, color: Colors.grey[400]),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            SearchBarWidget(controller: _controller, onSearch: _fetchStarred),
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
                  : _repos.isEmpty
                  ? const Center(child: Text("No starred repos found"))
                  : ListView.builder(
                      itemCount: _repos.length,
                      itemBuilder: (context, index) {
                        return RepoCard(repo: _repos[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
