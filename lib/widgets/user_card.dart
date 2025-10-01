import 'package:flutter/material.dart';
import '../models/contributor.dart';

class UserCard extends StatelessWidget {
  final Contributor contributor;

  const UserCard({super.key, required this.contributor});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 12),
      decoration: BoxDecoration(
        color: const Color.fromARGB(129, 106, 110, 131),
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        
        leading: CircleAvatar(
          backgroundImage: NetworkImage(contributor.avatarUrl),
        ),
        title: Text(contributor.username),
        subtitle: Text("Contributions: ${contributor.contributions}"),
      ),
    );
  }
}
