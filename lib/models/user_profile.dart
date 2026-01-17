class UserProfile {
  final String? fullName;
  final String? email;
  final String? avatarUrl;
  final int points;
  final double co2Saved;

  UserProfile({
    this.fullName,
    this.email,
    this.avatarUrl,
    this.points = 0,
    this.co2Saved = 0.0,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      fullName: json['full_name'] ?? 'Ayansh Paliwal',
      email: json['email'] ?? 'payansh@tisb.ac.in',
      avatarUrl: json['avatar_url'],
      points: json['points'] ?? 0,
      co2Saved: (json['co2_saved'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'full_name': fullName,
      'email': email,
      'avatar_url': avatarUrl,
      'points': points,
      'co2_saved': co2Saved,
    };
  }
}
