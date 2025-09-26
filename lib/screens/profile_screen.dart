import 'package:flutter/material.dart';
import '../services/github_service.dart';
import '../models/user.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GitHubService _service = GitHubService();
  final TextEditingController _controller = TextEditingController();

  GitHubUser? _user;
  bool _loading = false;

  void _fetchUser() async {
    if (_controller.text.isEmpty) return;
    setState(() => _loading = true);
    try {
      final user = await _service.getUser(_controller.text.trim());
      setState(() => _user = user);
    } catch (e) {
      debugPrint("Error: $e");
      setState(() => _user = null);
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("GitHub Profile")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: "Enter GitHub username",
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _fetchUser,
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (_loading) const CircularProgressIndicator(),
            if (_user != null)
              Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(_user!.avatarUrl),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _user!.username,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(_user!.bio),
                  const SizedBox(height: 10),
                  Text("Followers: ${_user!.followers}"),
                  Text("Following: ${_user!.following}"),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
