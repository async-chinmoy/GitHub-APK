import 'package:flutter/material.dart';
import '../models/user.dart';
import '../models/repo.dart';
import '../services/github_service.dart';
import '../widgets/repo_card.dart';

class UserDetailsScreen extends StatefulWidget {
  final GitHubUser user;

  const UserDetailsScreen({super.key, required this.user});

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  final GitHubService _service = GitHubService();
  late Future<List<Repo>> _repos;

  @override
  void initState() {
    super.initState();
    _repos = _service.userRepos(widget.user.username);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user.username),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(widget.user.avatarUrl),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.user.username,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.user.bio,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.people, size: 16, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text("${widget.user.followers} followers"),
                          const SizedBox(width: 10),
                          Text("•"),
                          const SizedBox(width: 10),
                          Text("${widget.user.following} following"),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),
            const Text(
              'Repositories',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            FutureBuilder<List<Repo>>(
              future: _repos,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: Padding(
                    padding: EdgeInsets.all(20),
                    child: CircularProgressIndicator(),
                  ));
                }
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                final repos = snapshot.data!;
                if (repos.isEmpty) {
                  return const Text('No repositories found.');
                }

                return Column(
                  children: repos.map((repo) => RepoCard(repo: repo)).toList(),
                );
              },
            ),

            const SizedBox(height: 30),
            
          ],
        ),
      ),
    );
  }
}
