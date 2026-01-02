class ProfileResponse {
  final UserProfile user;
  final List<PostModel> posts;

  ProfileResponse({
    required this.user,
    required this.posts,
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'];

    return ProfileResponse(
      user: UserProfile.fromJson(data['user']),
      posts: (data['posts'] as List)
          .map((e) => PostModel.fromJson(e))
          .toList(),
    );
  }
}

class UserProfile {
  final String name;
  final String username;
  final String? bio;
  final String? profilePicture;

  UserProfile({
    required this.name,
    required this.username,
    this.bio,
    this.profilePicture,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      name: json['name'],
      username: json['username'],
      bio: json['bio'],
      profilePicture: json['profile_picture'],
    );
  }
}

class PostModel {
  final int id;
  final String caption;
  final String image;
  final String createdAt;

  PostModel({
    required this.id,
    required this.caption,
    required this.image,
    required this.createdAt,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id_post'],
      caption: json['caption'],
      image: json['image_post'],
      createdAt: json['created_at'],
    );
  }
}
