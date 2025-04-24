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

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String?,
      name: json['name'] as String,
      email: json['email'] as String?,
      photoUrl: json['photo_url'] as String?,
      phoneNumber: json['phone_number'] as String?,
      address: json['address'] as String?,
      hasNotificationsEnabled: json['notifications_enabled'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'photo_url': photoUrl,
    'phone_number': phoneNumber,
    'address': address,
    'notifications_enabled': hasNotificationsEnabled,
  };
}
