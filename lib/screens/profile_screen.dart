import 'package:flutter/material.dart';
import '../services/github_service.dart';
import '../models/user.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../widgets/search_bar.dart';
import './user_profile.dart';
import 'package:animations/animations.dart';

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

  void _fetchUser(String query) async {
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
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Profile",
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold, fontFamily: 'Nunito',
                letterSpacing: 2.5,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Search GitHub Users",
              style: TextStyle(fontSize: 16, color: Colors.grey[400]),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: OpenContainer(
          closedElevation: 2,
          openElevation: 4,
          closedShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          transitionDuration: const Duration(milliseconds: 500),
          transitionType: ContainerTransitionType.fadeThrough,
          closedColor: Theme.of(context).scaffoldBackgroundColor,
          openColor: Theme.of(context).scaffoldBackgroundColor,

          openBuilder: (context, _) => UserDetailsScreen(user: _user!),
          closedBuilder: (context, openContainer) =>Column(
            children: [
              SearchBarWidget(controller: _controller, onSearch: _fetchUser),
              const SizedBox(height: 20),
              if (_loading)
                LoadingAnimationWidget.flickr(
                  leftDotColor: const Color(0xFF1A1A3F),
                  rightDotColor: const Color(0xFFEA3799),
                  size: 60,
                ),
              if (_user != null)
                GestureDetector(
                  onTap: (){
                    openContainer();
                  },
                  child: Card(
                    margin: const EdgeInsets.only(top: 24),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundImage: NetworkImage(_user!.avatarUrl),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            _user!.username,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            _user!.bio,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    _user!.followers.toString(),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  const Text(
                                    'Followers',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    _user!.following.toString(),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  const Text(
                                    'Following',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
