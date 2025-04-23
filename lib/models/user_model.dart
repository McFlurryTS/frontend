class UserProfile {
  final String? id;
  final String name;
  final String? email;
  final String? photoUrl;
  final String? phoneNumber;
  final String? address;
  final bool hasNotificationsEnabled;

  UserProfile({
    this.id,
    required this.name,
    this.email,
    this.photoUrl,
    this.phoneNumber,
    this.address,
    this.hasNotificationsEnabled = true,
  });

  UserProfile copyWith({
    String? id,
    String? name,
    String? email,
    String? photoUrl,
    String? phoneNumber,
    String? address,
    bool? hasNotificationsEnabled,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      hasNotificationsEnabled:
          hasNotificationsEnabled ?? this.hasNotificationsEnabled,
    );
  }
}
