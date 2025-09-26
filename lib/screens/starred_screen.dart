import 'package:flutter/material.dart';
import '../services/github_service.dart';
import '../models/repo.dart';
import '../widgets/repo_card.dart';

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

  void _fetchStarred() async {
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
      appBar: AppBar(title: const Text("Starred Repositories")),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: "Enter GitHub username",
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _fetchStarred,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
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
