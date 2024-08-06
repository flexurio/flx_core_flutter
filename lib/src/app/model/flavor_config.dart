import 'dart:ui';

class FlavorConfig<T> {
  FlavorConfig({
    required this.companyId,
    required this.companyName,
    required this.apiUrl,
    required this.color,
    required this.backgroundLoginPage,
    required this.applicationConfig,
  });

  final String companyId;
  final String companyName;
  final String apiUrl;
  final String backgroundLoginPage;
  final Color color;
  final T applicationConfig;
}

late FlavorConfig<dynamic> flavorConfig;
