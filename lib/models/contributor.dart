class Contributor {
  final String username;
  final String avatarUrl;
  final int contributions;

  Contributor({
    required this.username,
    required this.avatarUrl,
    required this.contributions,
  });

  factory Contributor.fromJson(Map<String, dynamic> json) {
    return Contributor(
      username: json['login'] ?? '',
      avatarUrl: json['avatar_url'] ?? '',
      contributions: json['contributions'] ?? 0,
    );
  }
}
