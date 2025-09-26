import 'package:flutter/material.dart';
import '../models/repo.dart';
import '../screens/repo_details_screen.dart';

class RepoCard extends StatelessWidget {
  final Repo repo;

  const RepoCard({super.key, required this.repo});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => RepoDetailsScreen(repo: repo)),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                repo.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                repo.description,
                style: const TextStyle(color: Colors.grey, fontSize: 14),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Chip(
                    label: Text(repo.language),
                    backgroundColor: Colors.deepPurpleAccent.withOpacity(0.2),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 18),
                      const SizedBox(width: 4),
                      Text(repo.stars.toString()),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
