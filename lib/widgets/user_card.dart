import 'package:flutter/material.dart';
import '../models/contributor.dart';

class UserCard extends StatelessWidget {
  final Contributor contributor;

  const UserCard({super.key, required this.contributor});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(contributor.avatarUrl),
      ),
      title: Text(contributor.username),
      subtitle: Text("Contributions: ${contributor.contributions}"),
    );
  }
}
