import 'package:equatable/equatable.dart';

/// Model user dengan dua field foto:
///
/// * [photourl]       → path **lokal** (persistent cache di device).
///                      Diisi setelah user pick image & file di-copy ke
///                      app-documents / cache dir. Tidak perlu panggil API
///                      setiap kali profile dicek.
///
/// * [photoRemoteUrl] → URL **CDN / remote** (Supabase Storage, Firebase, dll).
///                      Diisi setelah upload berhasil di repository/bloc.
///                      Disimpan juga di local storage agar bisa dipakai
///                      saat cache lokal dihapus.
class User extends Equatable {
  static const mFullName = 'FullName';
  static const mEmail = 'Email';
  static const mDateOfBirth = 'DateOfBirth';
  static const mGender = 'Gender';
  static const mPhotoUrl = 'PhotoUrl'; // path lokal
  static const mPhotoRemoteUrl = 'PhotoRemoteUrl'; // url CDN
  static const mNickname = 'Nickname';

  final String fullName;
  final String email;
  final DateTime dateOfBirth;
  final String gender;

  /// Path file lokal (persistent cache).
  /// Null jika belum pernah pilih foto atau cache dihapus.
  final String? photourl;

  /// URL remote (CDN / cloud storage).
  /// Null jika foto belum di-upload ke server.
  final String? photoRemoteUrl;

  final String? nickname;

  const User({
    required this.fullName,
    required this.email,
    required this.dateOfBirth,
    required this.gender,
    this.photourl,
    this.photoRemoteUrl,
    this.nickname,
  });

  // ── Equatable ──────────────────────────────────────────────────────

  @override
  List<Object?> get props => [
    fullName,
    email,
    dateOfBirth,
    gender,
    photourl,
    photoRemoteUrl,
    nickname,
  ];

  // ── CopyWith ───────────────────────────────────────────────────────

  User copyWith({
    String? fullName,
    String? email,
    DateTime? dateOfBirth,
    String? gender,
    String? photourl,
    String? photoRemoteUrl,
    String? nickname,
  }) {
    return User(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      photourl: photourl ?? this.photourl,
      photoRemoteUrl: photoRemoteUrl ?? this.photoRemoteUrl,
      nickname: nickname ?? this.nickname,
    );
  }

  // ── Serialization ──────────────────────────────────────────────────

  Map<String, dynamic> toMap() {
    return {
      mFullName: fullName,
      mEmail: email,
      mDateOfBirth: dateOfBirth.toIso8601String(),
      mGender: gender,
      mPhotoUrl: photourl,
      mPhotoRemoteUrl: photoRemoteUrl,
      mNickname: nickname,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      fullName: map[mFullName] ?? '',
      email: map[mEmail] ?? '',
      dateOfBirth: DateTime.parse(
        map[mDateOfBirth] ?? DateTime.now().toIso8601String(),
      ),
      gender: map[mGender] ?? '',
      photourl: map[mPhotoUrl],
      photoRemoteUrl: map[mPhotoRemoteUrl],
      nickname: map[mNickname],
    );
  }

  @override
  String toString() =>
      'User(fullName: $fullName, email: $email, '
      'gender: $gender, dob: $dateOfBirth, '
      'localPhoto: $photourl, remotePhoto: $photoRemoteUrl)';
}
