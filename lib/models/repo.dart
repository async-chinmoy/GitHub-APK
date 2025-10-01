class Repo {
  final String name;
  final String owner;
  final String description;
  final int stars;
  final String language;
  final String url;
  final String ownerAvatarUrl;

  Repo({
    required this.name,
    required this.owner,
    required this.description,
    required this.stars,
    required this.language,
    required this.url,
    required this.ownerAvatarUrl,
  });

  factory Repo.fromJson(Map<String, dynamic> json) {
    return Repo(
      name: json['name'] ?? '',
      owner: json['owner']?['login'] ?? '',
      description: json['description'] ?? '',
      stars: json['stargazers_count'] ?? 0,
      language: json['language'] ?? 'Unknown',
      url: json['html_url'] ?? '',
      ownerAvatarUrl: json['owner']?['avatar_url'] ?? '',
    );
  }
}
