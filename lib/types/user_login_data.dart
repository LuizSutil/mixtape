class UserProfile {
  final String profileImage;
  final String displayName;
  final String email;

  UserProfile(
      {required this.profileImage,
      required this.displayName,
      required this.email});

  factory UserProfile.fromJson(dynamic json) {
    return UserProfile(
        profileImage: json['profile_image'],
        displayName: json['display_name'],
        email: json['email']);
  }
}
