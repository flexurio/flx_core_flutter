import 'dart:ui';

class FlavorConfig<T> {
  FlavorConfig({
    required this.companyId,
    required this.companyName,
    required this.companyPhone,
    required this.companyWebsite,
    required this.companyAddress,
    required this.apiUrl,
    required this.color,
    required this.colorSoft,
    required this.backgroundLoginPage,
    required this.applicationConfig,
    this.authUrl,
    this.idleLogoutDuration,
  });

  final String companyId;
  final String companyName;
  final String companyPhone;
  final String companyWebsite;
  final String companyAddress;
  final String apiUrl;
  final String? authUrl;
  final String backgroundLoginPage;
  final Color color;
  final Color colorSoft;
  final T applicationConfig;
  final Duration? idleLogoutDuration;
}

late FlavorConfig<dynamic> flavorConfig;
