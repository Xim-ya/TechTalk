class VersionEntity {
  final String versionCode;
  final String notification;
  final bool isSystemAvailable;

  const VersionEntity({
    required this.versionCode,
    required this.notification,
    required this.isSystemAvailable,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VersionEntity &&
          runtimeType == other.runtimeType &&
          versionCode == other.versionCode &&
          isSystemAvailable == other.isSystemAvailable);

  @override
  int get hashCode => versionCode.hashCode ^ isSystemAvailable.hashCode;

  @override
  String toString() {
    return 'VersionEntity{' +
        ' versionCode: $versionCode,' +
        ' isSystemAvailable: $isSystemAvailable,' +
        '}';
  }

  VersionEntity copyWith(
      {String? versionCode, bool? isSystemAvailable, String? notification}) {
    return VersionEntity(
      versionCode: versionCode ?? this.versionCode,
      isSystemAvailable: isSystemAvailable ?? this.isSystemAvailable,
      notification: notification ?? this.notification,
    );
  }
}
