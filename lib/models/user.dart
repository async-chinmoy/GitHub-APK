class GitHubUser {
  final String username;
  final String avatarUrl;
  final String bio;
  final int followers;
  final int following;

  GitHubUser({
    required this.username,
    required this.avatarUrl,
    required this.bio,
    required this.followers,
    required this.following,
  });

  factory GitHubUser.fromJson(Map<String, dynamic> json) {
    return GitHubUser(
      username: json['login'] ?? '',
      avatarUrl: json['avatar_url'] ?? '',
      bio: json['bio'] ?? '',
      followers: json['followers'] ?? 0,
      following: json['following'] ?? 0,
    );
  }
}
