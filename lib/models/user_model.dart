class UserModel {
  final String uid;
  final String email;
  final String displayName;
  final String? photoUrl;
  final String role; // Add role field (e.g., 'player' or 'admin')

  UserModel({
    required this.uid,
    required this.email,
    required this.displayName,
    this.photoUrl,
    this.role = 'player', // Default to 'player'
  });

  factory UserModel.fromMap(Map<String, dynamic> data, String uid) {
    return UserModel(
      uid: uid,
      email: data['email'] ?? '',
      displayName: data['displayName'] ?? '',
      photoUrl: data['photoUrl'],
      role: data['role'] ?? 'player',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'role': role,
    };
  }
}