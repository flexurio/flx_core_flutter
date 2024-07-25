import 'dart:ui';

class FlavorConfig {
  FlavorConfig({
    required this.companyId,
    required this.companyName,
    required this.apiUrl,
    required this.color,
    required this.backgroundLoginPage,
  });

  final String companyId;
  final String companyName;
  final String apiUrl;
  final String backgroundLoginPage;
  final Color color;

  static FlavorConfig get chironDemo => FlavorConfig(
        companyId: '03',
        companyName: 'PT. Chiron',
        apiUrl: 'https://dev.erp.api.farmasys.com',
        color: const Color(0XFF436EC1),
        backgroundLoginPage: 'asset/image/background-3.jpg',
      );

  static FlavorConfig get metiskaFarmaProduction => FlavorConfig(
        companyId: '01',
        companyName: 'PT. Metiska Farma',
        apiUrl: 'https://erp-metiska-farma-api.flexurio.com',
        color: const Color(0XFF1D71B8),
        backgroundLoginPage: 'asset/image/background-3.jpg',
      );

  static FlavorConfig get metiskaFarmaDevelopment => FlavorConfig(
        companyId: '01',
        companyName: 'PT. Metiska Farma',
        apiUrl: 'https://dev.erp.api.farmasys.com',
        color: const Color(0XFF1D71B8),
        backgroundLoginPage: 'asset/image/background-3.jpg',
      );

  static FlavorConfig get teguhsindoDevelopment => FlavorConfig(
        apiUrl: 'https://tl.api.dev.farmasys.com',
        companyId: '02',
        companyName: 'PT. Teguhsindo Lestaritama',
        color: const Color(0XFF00A1E1),
        backgroundLoginPage: 'asset/image/background-6.jpg',
      );

  static FlavorConfig get teguhsindoProduction => FlavorConfig(
        apiUrl: 'https://erp-teguhsindo-api.flexurio.com',
        companyId: '02',
        companyName: 'PT. Teguhsindo Lestaritama',
        color: const Color(0XFF00A1E1),
        backgroundLoginPage: 'asset/image/background-3.jpg',
      );
}

late FlavorConfig flavorConfig;
