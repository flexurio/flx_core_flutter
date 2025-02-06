import 'package:easy_localization/easy_localization.dart';

abstract class EntityY {
  const EntityY({
    required this.titleX,
    required this.subtitleX,
    required this.iconPath,
  });
  final String titleX;
  final String subtitleX;
  final String iconPath;

  String get title => titleX.tr();
  String get subtitle => 'entity_subtitle.$subtitleX'.tr();
  String get id => titleX.toLowerCase();
}

class Entity extends EntityY {
  const Entity({
    required super.titleX,
    required super.subtitleX,
    required super.iconPath,
  });

  static Entity get purchaseOrderDocument => const Entity(
        titleX: 'Purchase Order Document',
        subtitleX: '',
        iconPath: 'bill',
      );

  static Entity get balanceGroup => const Entity(
        titleX: 'balance_group',
        subtitleX: 'balance_group',
        iconPath: 'wallet',
      );

  static Entity get budgetType =>
      const Entity(titleX: 'Budget Type', subtitleX: '', iconPath: 'bill');
  static Entity get cashFlow =>
      const Entity(titleX: 'Cash Flow', subtitleX: '', iconPath: 'bill');
  static Entity get leadTime =>
      const Entity(titleX: 'LeadTime', subtitleX: '', iconPath: 'bill');
  static Entity get chartOfAccountGroup => const Entity(
        titleX: 'Chart of Account Group',
        subtitleX: '',
        iconPath: 'money',
      );
  static Entity get chartOfAccountNumber => const Entity(
        titleX: 'Chart of Account Number',
        subtitleX: '',
        iconPath: 'money',
      );
  static Entity get cogs => const Entity(
        titleX: 'Cost of Goods Sold',
        subtitleX: '',
        iconPath: 'bill',
      );
  static Entity get currency => const Entity(
        titleX: 'currency',
        subtitleX: 'currency',
        iconPath: 'money',
      );
  static Entity get customer => const Entity(
        titleX: 'customer',
        subtitleX: 'customer',
        iconPath: 'shopping-bag',
      );
  static Entity get customerDiscount => const Entity(
        titleX: 'customer_discount',
        subtitleX: 'customer_discount',
        iconPath: 'discount',
      );
  static Entity get department => const Entity(
        titleX: 'department',
        subtitleX: '',
        iconPath: 'department',
      );
  static Entity get departmentType =>
      const Entity(titleX: 'Department Group', subtitleX: '', iconPath: 'bill');
  static Entity get departmentGroup =>
      const Entity(titleX: 'Department Group', subtitleX: '', iconPath: 'bill');
  static Entity get invoiceReceive => const Entity(
        titleX: 'invoice_receive',
        subtitleX: 'invoice_receive',
        iconPath: 'bill',
      );
  static Entity get invoiceReceiveDetail => const Entity(
        titleX: 'Invoice Receive Detail',
        subtitleX: '',
        iconPath: 'bill',
      );
  static Entity get invoiceReceiveDocument => const Entity(
        titleX: 'invoice_receive_document',
        subtitleX: '',
        iconPath: 'bill',
      );
  static Entity get ebitda =>
      const Entity(titleX: 'Ebitda', subtitleX: '', iconPath: 'bill');
  static Entity get budgetRealization => const Entity(
        titleX: 'budget_realization',
        subtitleX: 'budget_realization',
        iconPath: 'accountant',
      );
  static Entity get formA1 => const Entity(
        titleX: 'form_a1',
        subtitleX: 'form_a1',
        iconPath: 'accountant',
      );
  static Entity get invoiceSummary => const Entity(
        titleX: 'invoice_summary',
        subtitleX: 'invoice_summary',
        iconPath: 'accountant',
      );
  static Entity get statusAccountPayable => const Entity(
        titleX: 'status_account_payable',
        subtitleX: 'status_account_payable',
        iconPath: 'accountant',
      );
  static Entity get accountsReceivableDetail => const Entity(
        titleX: 'accounts_receivable_detail',
        subtitleX: 'accounts_receivable_detail',
        iconPath: 'accountant',
      );
  static Entity get accountsReceivableGlobal => const Entity(
        titleX: 'accounts_receivable_global',
        subtitleX: 'accounts_receivable_global',
        iconPath: 'accountant',
      );
  static Entity get accountsReceivableGrup => const Entity(
        titleX: 'accounts_receivable_grup',
        subtitleX: 'accounts_receivable_grup',
        iconPath: 'accountant',
      );
  static Entity get accountsReceivableMutation => const Entity(
        titleX: 'accounts_receivable_mutation',
        subtitleX: 'accounts_receivable_mutation',
        iconPath: 'accountant',
      );
  static Entity get accountsReceivableCustomer => const Entity(
        titleX: 'accounts_receivable_customer',
        subtitleX: 'accounts_receivable_customer',
        iconPath: 'accountant',
      );
  static Entity get pettyCash => const Entity(
        titleX: 'petty_cash',
        subtitleX: 'petty_cash',
        iconPath: 'money',
      );
  static Entity get journalEstimation => const Entity(
        titleX: 'Journal Estimation Type',
        subtitleX: 'journal_estimation_type',
        iconPath: 'worksheet',
      );
  static Entity get material => const Entity(
        titleX: 'Material',
        subtitleX: 'material',
        iconPath: 'layers',
      );
  static Entity get materialApproveVendor => const Entity(
        titleX: 'Approve Supplier List',
        subtitleX: '',
        iconPath: 'bill',
      );
  static Entity get materialDesign => const Entity(
        titleX: 'Material Design',
        subtitleX: 'material_design',
        iconPath: 'design-code',
      );
  static Entity get materialGroup => const Entity(
        titleX: 'material_group',
        subtitleX: 'material_group',
        iconPath: 'material-group',
      );
  static Entity get purchaseRequest => const Entity(
        titleX: 'purchase_request',
        subtitleX: 'purchase_request',
        iconPath: 'add-basket',
      );
  static Entity get fuel => const Entity(
        titleX: 'Fuel',
        subtitleX: '',
        iconPath: 'shopping-list',
      );
  static Entity get fuelHistory => const Entity(
        titleX: 'History',
        subtitleX: '',
        iconPath: 'bill',
      );
  static Entity get vehicle => const Entity(
        titleX: 'Vehicle',
        subtitleX: '',
        iconPath: 'shopping-list',
      );
  static Entity get vehicleRent => const Entity(
        titleX: 'vehicle_rent',
        subtitleX: 'vehicle_rent',
        iconPath: 'shopping-list',
      );
  static Entity get vehicleRentDestination => const Entity(
        titleX: 'vehicle_rent_destination',
        subtitleX: '',
        iconPath: 'bill',
      );
  static Entity get requestForm => const Entity(
        titleX: 'Request Form',
        subtitleX:
            'A document utilized to formally request services, resources, or specific actions from a particular department within an organization',
        iconPath: 'contact-form',
      );
  static Entity get requestFormDetail => const Entity(
        titleX: 'Request Form Detail',
        subtitleX: '',
        iconPath: 'bill',
      );
  static Entity get none =>
      const Entity(titleX: '', subtitleX: '', iconPath: 'bill');
  static Entity get purchaseRequestDetail => const Entity(
        titleX: 'Material Request Detail',
        subtitleX: '',
        iconPath: 'bill',
      );
  static Entity get materialReturn => const Entity(
        titleX: 'material_return',
        subtitleX: '',
        iconPath: 'material-return',
      );
  static Entity get materialReturnExternal => const Entity(
        titleX: 'material_return_external',
        subtitleX: '',
        iconPath: 'material-return',
      );
  static Entity get materialReturnDetail => const Entity(
        titleX: 'material_return_detail',
        subtitleX: '',
        iconPath: 'bill',
      );
  static Entity get materialReturnDetailExternal => const Entity(
        titleX: 'material_return_detail_external',
        subtitleX: '',
        iconPath: 'bill',
      );
  static Entity get materialReturnNote => const Entity(
        titleX: 'Material Return Note',
        subtitleX: '',
        iconPath: 'shopping-list',
      );
  static Entity get materialReturnNoteDetail => const Entity(
        titleX: 'Material Return Note Detail',
        subtitleX: '',
        iconPath: 'shopping-list',
      );
  static Entity get materialType => const Entity(
        titleX: 'material_type',
        subtitleX: 'material_type',
        iconPath: 'material-type',
      );
  static Entity get materialUnit => const Entity(
        titleX: 'material_unit',
        subtitleX: 'material_unit',
        iconPath: 'bill',
      );
  static Entity get materialAnalysis => const Entity(
        titleX: 'Material Analysis',
        subtitleX: '',
        iconPath: 'bill',
      );
  static Entity get unitConvert =>
      const Entity(titleX: 'Unit Convert', subtitleX: '', iconPath: 'bill');
  static Entity get office =>
      const Entity(titleX: 'Office', subtitleX: '', iconPath: 'bill');
  static Entity get product => const Entity(
        titleX: 'product',
        subtitleX: 'Master menu containing a list of product',
        iconPath: 'medicine',
      );
  static Entity get billOfMaterial => const Entity(
        titleX: 'Bill of Material',
        subtitleX: 'bill_of_material',
        iconPath: 'formulations',
      );
  static Entity get productGroup => const Entity(
        titleX: 'Product Group',
        subtitleX:
            'Master menu that includes a list of product groups as the basis for classifying products',
        iconPath: 'product-group',
      );
  static Entity get productionFormulation => const Entity(
        titleX: 'Production Formulation',
        subtitleX: '',
        iconPath: 'bill',
      );
  static Entity get productionLine =>
      const Entity(titleX: 'Line', subtitleX: '', iconPath: 'bill');
  static Entity get productionMachine => const Entity(
        titleX: 'Production Machine',
        subtitleX: 'production_machine',
        iconPath: 'machines',
      );
  static Entity get productionOrder => const Entity(
        titleX: 'Production Order',
        subtitleX: '',
        iconPath: 'parcel-care',
      );
  static Entity get productionOrderDetail => const Entity(
        titleX: 'Production Order Detail',
        subtitleX: '',
        iconPath: 'bill',
      );
  static Entity get productionServiceOrder => const Entity(
        titleX: 'Production Service Order',
        subtitleX: '',
        iconPath: 'bill',
      );
  static Entity get productionStage => const Entity(
        titleX: 'Production Stage',
        subtitleX: 'production_stage',
        iconPath: 'production-stage',
      );
  static Entity get productionStageProcess => const Entity(
        titleX: 'Stage Process',
        subtitleX: 'stage_process',
        iconPath: 'stage-process',
      );
  static Entity get productionStageProcessDetail => const Entity(
        titleX: 'Stage Process Detail',
        subtitleX: '',
        iconPath: 'bill',
      );
  static Entity get productionSubStage => const Entity(
        titleX: 'Production Sub Stage',
        subtitleX: '',
        iconPath: 'bill',
      );
  static Entity get productIssue => const Entity(
        titleX: 'Product Issue',
        subtitleX:
            'The process of issuing inventory involves confirming the quantity and condition of goods issued to customers or sent to other departments',
        iconPath: 'unpacking',
      );
  static Entity get productNie =>
      const Entity(titleX: 'Product NIE', subtitleX: '', iconPath: 'bill');
  static Entity get productPrice =>
      const Entity(titleX: 'Product Price', subtitleX: '', iconPath: 'money');
  static Entity get productReceive => const Entity(
        titleX: 'product_receive',
        subtitleX: 'product_receive',
        iconPath: 'parcel-care',
      );
  static Entity get productRequest => const Entity(
        titleX: 'product_request',
        subtitleX: 'product_request',
        iconPath: 'product-request',
      );
  static Entity get productRequestDetail => const Entity(
        titleX: 'Product Request Detail',
        subtitleX: '',
        iconPath: 'bill',
      );
  static Entity get productReturn => const Entity(
        titleX: 'product_return',
        subtitleX: '',
        iconPath: 'shopping-list',
      );
  static Entity get productReturnCheck => const Entity(
        titleX: 'product_return_check',
        subtitleX: '',
        iconPath: 'shopping-list',
      );
  static Entity get productReturnDetail => const Entity(
        titleX: 'product_return_detail',
        subtitleX: '',
        iconPath: 'shopping-list',
      );
  static Entity get document =>
      const Entity(titleX: 'document', subtitleX: '', iconPath: 'bill');
  static Entity get purchaseOrder => const Entity(
        titleX: 'purchase_order',
        subtitleX: 'purchase_order',
        iconPath: 'shopping-list',
      );
  static Entity get purchaseOrderDownPayment => const Entity(
        titleX: 'purchase_order_down_payment',
        subtitleX: 'purchase_order_down_payment',
        iconPath: 'shopping-list',
      );
  static Entity get purchaseOrderDetail => const Entity(
        titleX: 'Purchase Order Detail',
        subtitleX: '',
        iconPath: 'bill',
      );
  static Entity get productReturnNote => const Entity(
        titleX: 'product_return_note',
        subtitleX: 'product_return_note',
        iconPath: 'package',
      );
  static Entity get productReturnNoteDetail => const Entity(
        titleX: 'Product Return Note Detail',
        subtitleX: '',
        iconPath: 'shopping-list',
      );
  static Entity get rate => const Entity(
        titleX: 'rate',
        subtitleX: 'Master menu for recording currency exchange rates',
        iconPath: 'stock-market',
      );
  static Entity get recapProductStock => const Entity(
        titleX: 'Recap Product Stock',
        subtitleX: '',
        iconPath: 'bill',
      );
  static Entity get role =>
      const Entity(titleX: 'role', subtitleX: 'role', iconPath: 'asset-type');
  static Entity get salesOrder => const Entity(
        titleX: 'sales_order',
        subtitleX: 'sales_order',
        iconPath: 'sales-order',
      );
  static Entity get productRequestOther => const Entity(
        titleX: 'product_request_other',
        subtitleX: 'product_request_other',
        iconPath: 'sales-order',
      );
  static Entity get salesOrderDocument => const Entity(
        titleX: 'sales_order_document',
        subtitleX: '',
        iconPath: 'bill',
      );
  static Entity get pendingRequestsRecap => const Entity(
        titleX: 'pending_requests_recap',
        subtitleX: 'pending_requests_recap',
        iconPath: 'bill',
      );
  static Entity get pendingRequestsRecapGlobal => const Entity(
        titleX: 'pending_requests_recap_global',
        subtitleX: 'pending_requests_recap_global',
        iconPath: 'bill',
      );
  static Entity get pendingRequestsUnserved => const Entity(
        titleX: 'pending_requests_unserved',
        subtitleX: 'pending_requests_unserved',
        iconPath: 'bill',
      );
  static Entity get pendingRequestsDetail => const Entity(
        titleX: 'pending_requests_detail',
        subtitleX: 'pending_requests_detail',
        iconPath: 'bill',
      );
  static Entity get schedule => const Entity(
        titleX: 'schedule',
        subtitleX: 'schedule',
        iconPath: 'schedule',
      );
  static Entity get scheduleActual =>
      const Entity(titleX: 'Schedule Actual', subtitleX: '', iconPath: 'bill');
  static Entity get scheduleDetail =>
      const Entity(titleX: 'Schedule Detail', subtitleX: '', iconPath: 'bill');
  static Entity get shift =>
      const Entity(titleX: 'Shift', subtitleX: '', iconPath: 'bill');
  static Entity get supplier => const Entity(
        titleX: 'Supplier',
        subtitleX:
            'Master menu containing a list of supplier that produce material',
        iconPath: 'supplier',
      );
  static Entity get tax =>
      const Entity(titleX: 'PPH', subtitleX: '', iconPath: 'bill');

  static Entity get sales => const Entity(
        titleX: 'Sales',
        subtitleX: 'sales',
        iconPath: 'credit-card',
      );

  static Entity get taxInvoiceNumber => const Entity(
        titleX: 'tax_invoice_number',
        subtitleX: '',
        iconPath: 'bill',
      );
  static Entity get ticket =>
      const Entity(titleX: 'Ticket', subtitleX: '', iconPath: 'bill');
  static Entity get ticketComment =>
      const Entity(titleX: 'Ticket Comment', subtitleX: '', iconPath: 'bill');
  static Entity get transactionNonOrder => const Entity(
        titleX: 'Transaction Non Order',
        subtitleX: '',
        iconPath: 'transaction-non-order',
      );
  static Entity get transactionRoutine => const Entity(
        titleX: 'Transaction Routine',
        subtitleX: '',
        iconPath: 'transaction-routine',
      );
  static Entity get transactionType => const Entity(
        titleX: 'transaction_type',
        subtitleX: 'Master menu for registering transaction type of company',
        iconPath: 'transaction',
      );
  static Entity get typeCost => const Entity(
        titleX: 'Type Cost',
        subtitleX: '',
        iconPath: 'transaction',
      );
  static Entity get transactionJournalAccounting => const Entity(
        titleX: 'general_journal',
        subtitleX: 'general_journal',
        iconPath: 'notebook',
      );
  static Entity get vendor => const Entity(
        titleX: 'Manufacturer',
        subtitleX:
            'Master menu containing a list of vendor that produce material',
        iconPath: 'manufacturer',
      );
  static Entity get workHour =>
      const Entity(titleX: 'Work Hour', subtitleX: '', iconPath: 'bill');
  static Entity get materialRetest => const Entity(
        titleX: 'material_retest',
        subtitleX: 'material_retest',
        iconPath: 'material-retest',
      );
  static Entity get salesOrderDetail => const Entity(
        titleX: 'Sales Order Detail',
        subtitleX: '',
        iconPath: 'bill',
      );
  static Entity get assetType => const Entity(
        titleX: 'Asset Type',
        subtitleX: '',
        iconPath: 'asset-type',
      );
  static Entity get assetLocation => const Entity(
        titleX: 'Asset Location',
        subtitleX: '',
        iconPath: 'asset-location',
      );

  static Entity get workHourShift =>
      const Entity(titleX: 'Work Hour Shift', subtitleX: '', iconPath: 'bill');
}
