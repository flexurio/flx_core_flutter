class AppConfig {
  AppConfig({
    required this.purchaseRequestCreateFilterMaterialGroup,
    required this.purchaseRequestCanCreatePurchaseOrder,
    required this.companyId,
    required this.companyExternals,
  });

  final String companyId;
  final List<String> companyExternals;

  final dynamic Function({
    required dynamic materialGroups,
    required dynamic department,
  }) purchaseRequestCreateFilterMaterialGroup;

  final bool Function({
    required dynamic purchaseRequestDetail,
  }) purchaseRequestCanCreatePurchaseOrder;
}
