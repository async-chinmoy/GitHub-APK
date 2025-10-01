import 'package:flutter/material.dart';
import '../models/repo.dart';
import '../services/github_service.dart';
import '../models/contributor.dart';
import '../widgets/user_card.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class RepoDetailsScreen extends StatefulWidget {
  final Repo repo;

  const RepoDetailsScreen({super.key, required this.repo});

  @override
  State<RepoDetailsScreen> createState() => _RepoDetailsScreenState();
}

class _RepoDetailsScreenState extends State<RepoDetailsScreen> {
  final GitHubService _service = GitHubService();
  late Future<List<Contributor>> _contributors;

  @override
  void initState() {
    super.initState();
    _contributors = _service.getContributors(
      widget.repo.owner,
      widget.repo.name,
    );
  }

  Widget _buildRepoInfo() {
    return ListTile(
      title: Text(
        widget.repo.name,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(widget.repo.description),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star, color: Colors.amber),
          Text(widget.repo.stars.toString()),
        ],
      ),
    );
  }

  Widget _buildLanguageInfo() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text("Language: ${widget.repo.language}"),
    );
  }

  Widget _buildContributorsSection() {
    return FutureBuilder<List<Contributor>>(
      future: _contributors,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return  Center(
              child: LoadingAnimationWidget.flickr(
                leftDotColor: const Color(0xFF1A1A3F),
                rightDotColor: const Color(0xFFEA3799),
                size: 60,
              ),
            );;
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No contributors found"));
        }
        final contributors = snapshot.data!;
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: contributors.length,
          itemBuilder: (context, index) {
            return UserCard(contributor: contributors[index]);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.repo.name,
          style: const TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRepoInfo(),
            _buildLanguageInfo(),
            const Divider(),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Contributors",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            _buildContributorsSection(),
          ],
        ),
      ),
    );
  }
}
