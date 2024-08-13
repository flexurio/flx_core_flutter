import 'package:easy_localization/easy_localization.dart';
import 'package:flexurio_erp_core/src/app/model/data_action.dart';

class Permission {
  static String accountingCogsReportViewMenu =
      'accounting_cogs_report_view_menu';
  static String accountingCogsReportExportExcel =
      'accounting_cogs_report_export_excel';
  static String accountingCogsReportExportPdf =
      'accounting_cogs_report_export_pdf';

  // Asset Type
  static String assetTypeViewMenu = 'asset_type_view_menu';
  static String assetTypeCreate = 'asset_type_create';
  static String assetTypeDelete = 'asset_type_delete';
  static String assetTypeEdit = 'asset_type_edit';

  // Asset Location
  static String assetLocationViewMenu = 'asset_location_view_menu';
  static String assetLocationCreate = 'asset_location_create';
  static String assetLocationDelete = 'asset_location_delete';

  // Asset Data
  static String assetDataViewMenu = 'asset_data_view_menu';
  static String assetDataCreate = 'asset_data_create';
  static String assetDataDelete = 'asset_data_delete';
  static String assetDataEdit = 'asset_data_edit';
  static String assetDataNonActive = 'asset_data_non_active';
  static String assetDataMoving = 'asset_data_moving';

  // Balance Group
  static String balanceGroupViewMenu = 'balance_group_view_menu';
  static String balanceGroupCreate = 'balance_group_create';
  static String balanceGroupDelete = 'balance_group_delete';

  // Budget Type
  static String budgetTypeViewMenu = 'budget_type_view_menu';
  static String budgetTypeCreate = 'budget_type_create';
  static String budgetTypeDelete = 'budget_type_delete';
  static String budgetTypeEdit = 'budget_type_edit';

  // --
  static String cashFlowViewMenu = 'cash_flow_view_menu';
  static String cashFlowApprove = 'cash_flow_approve';
  static String cashFlowCreate = 'cash_flow_create';
  static String cashFlowEdit = 'cash_flow_edit';

  // --
  static String chartOfAccountViewMenu = 'chart_of_account_view_menu';
  static String chartOfAccountCreate = 'chart_of_account_create';
  static String chartOfAccountDelete = 'chart_of_account_delete';
  static String chartOfAccountEdit = 'chart_of_account_number_edit';
  static String chartOfAccountExportExcel = 'chart_of_account_export_excel';

  // Chart Of Account Group
  static String chartOfAccountGroupViewMenu =
      'chart_of_account_group_view_menu';
  static String chartOfAccountGroupCreate = 'chart_of_account_group_create';
  static String chartOfAccountGroupDelete = 'chart_of_account_group_delete';
  static String chartOfAccountGroupEdit = 'chart_of_account_group_edit';
  static String chartOfAccountGroupExportPdf =
      'chart_of_account_group_export_pdf';

  // Currency
  static String currencyViewMenu = 'currency_view_menu';
  static String currencyCreate = 'currency_create';
  static String currencyDelete = 'currency_delete';

  // Customer
  static String customerViewMenu = 'customer_view_menu';
  static String customerCreate = 'customer_create';
  static String customerDelete = 'customer_delete';
  static String customerEdit = 'customer_edit';

  // Customer Discount
  static String customerDiscountViewMenu = 'customer_discount_view_menu';
  static String customerDiscountCreate = 'customer_discount_create';
  static String customerDiscountDelete = 'customer_discount_delete';

  // Department
  static String departmentViewMenu = 'department_view_menu';
  static String departmentCreate = 'department_create';
  static String departmentDelete = 'department_delete';
  static String departmentEdit = 'department_edit';
  static String departmentEmployeeEdit = 'department_employee_edit';

  // Ebitda
  static String ebitdaViewMenu = 'ebitda_view_menu';
  static String ebitdaPrint = 'ebitda_print';
  static String ebitdaUpload = 'ebitda_upload';

  // Budget Realization
  static String budgetRealizationViewMenu = 'budget_realization_view_menu';
  static String budgetRealizationExportExcel =
      'budget_realization_export_excel';

  // --
  static String financeReturnNoteViewMenu = 'finance_return_note_view_menu';
  static String financeReturnNoteExportExcel =
      'finance_return_note_export_excel';
  static String financeReturnNoteExportPdf = 'finance_return_note_export_pdf';

  // Invoice
  static String invoiceReceiveViewMenu = 'invoice_receive_view_menu';
  static String invoiceReceiveCreate = 'invoice_receive_create';
  static String invoiceReceiveEdit = 'invoice_receive_edit';
  static String invoiceReceiveDelete = 'invoice_receive_delete';
  static String invoiceReceiveConfirmFinance =
      'invoice_receive_confirm_finance';
  static String invoiceReceiveApproveHeadAccounting =
      'invoice_receive_approve_head_accounting';

  // Journal Estimation
  static String journalEstimationViewMenu = 'journal_estimation_view_menu';
  static String journalEstimationCreate = 'journal_estimation_create';
  static String journalEstimationDelete = 'journal_estimation_delete';

  // Material Approver Vendor List
  static String materialApproveVendorListViewMenu =
      'material_approve_vendor_list_view_menu';
  static String materialApproveVendorListCreate =
      'material_approve_vendor_list_create';
  static String materialApproveVendorListDelete =
      'material_approve_vendor_list_delete';
  static String materialApproveVendorListEdit =
      'material_approve_vendor_list_edit';
  static String materialApproveVendorListEditHalalCertificate =
      'material_approve_vendor_list_edit_halal_certificate';

  // --
  static String materialDesignViewMenu = 'material_design_view_menu';
  static String materialDesignCreate = 'material_design_create';
  static String materialDesignDelete = 'material_design_delete';
  static String materialDesignEdit = 'material_design_edit';

  // --
  static String materialGroupViewMenu = 'material_group_view_menu';
  static String materialGroupCreate = 'material_group_create';
  static String materialGroupDelete = 'material_group_delete';
  static String materialGroupEdit = 'material_group_edit';

  // --
  static String materialIssueViewMenu = 'material_issue_view_menu';
  static String materialIssueCreate = 'material_issue_create';
  static String materialIssueDelete = 'material_issue_delete';
  static String materialIssueEdit = 'material_issue_detail_edit';
  static String materialIssuePrint = 'material_issue_print';

  static String materialLeadTimeEdit = 'material_lead_time_edit';

  // Material Receive
  static String materialReceiveViewMenu = 'material_receive_view_menu';
  static String materialReceiveCreate = 'material_receive_create';
  static String materialReceiveExportPdf = 'material_receive_export_pdf';
  static String materialReceiveDelete = 'material_receive_delete';
  static String materialReceiveDetailDelete = 'material_receive_detail_delete';
  static String materialReceiveEdit = 'material_receive_edit';

  // Request Form
  static String requestFormViewMenu = 'request_form_view_menu';

  static String requestFormClose = 'request_form_close';
  static String requestFormCreate = 'request_form_create';
  static String requestFormEdit = 'request_form_edit';
  static String requestFormExportPdf = 'request_form_export_pdf';
  static String requestFormDetailConfirm = 'request_form_detail_confirm';
  static String requestFormDetailDelete = 'request_form_detail_delete';
  static String requestFormCreateMR = 'request_form_create_mr';
  static String requestFormReject = 'request_form_reject';

  // --
  static String purchaseRequestViewMenu = 'material_request_view_menu';
  static String purchaseRequestCreate = 'material_request_create';
  static String purchaseRequestDelete = 'material_request_delete';
  static String purchaseRequestEdit = 'material_request_edit';
  static String purchaseRequestExportPdf = 'material_request_export_pdf';
  static String purchaseRequestDetailConfirm =
      'material_request_detail_confirm';
  static String purchaseRequestExportExcel = 'material_request_export_excel';

  static String purchaseRequestDetailReject = 'material_request_detail_reject';

  static String purchaseRequestDetailRejectForManager =
      'material_request_detail_reject_for_manager';

  // Material Retest
  static String materialRetestViewMenu = 'material_retest_view_menu';
  static String materialRetestCreate = 'material_retest_create';
  static String materialRetestEdit = 'material_retest_edit';

  // --
  static String materialStockViewMenu = 'material_stock_view_menu';
  static String materialStockExportExcel = 'material_stock_export_excel';

  // Office
  static String officeViewMenu = 'office_view_menu';
  static String officeCreate = 'office_create';
  static String officeDelete = 'office_delete';
  static String officeEdit = 'office_edit';
  static String officeEmployeeCreate = 'office_employee_create';

  // Payment
  static String paymentViewMenu = 'payment_view_menu';
  static String paymentCreate = 'payment_create';
  static String paymentSalesCreate = 'payment_sales_create';
  static String paymentSalaryUpload = 'payment_salary_upload';

  // --
  static String presenceMonthlyReportViewMenu =
      'presence_monthly_report_view_menu';

  // --
  static String presenceMonthlyReportPerEmployeeViewMenu =
      'presence_monthly_report_per_employee_view_menu';
  static String presenceMonthlyReportPerEmployeeExportExcel =
      'presence_monthly_report_per_employee_export_excel';
  static String presenceMonthlyReportPerEmployeeExportPdf =
      'presence_monthly_report_per_employee_export_pdf';

  // --
  static String productFormulationViewMenu = 'product_formulation_view_menu';
  static String productFormulationCreate = 'product_formulation_create';
  static String productFormulationDelete = 'product_formulation_delete';
  static String productFormulationEdit = 'product_formulation_edit';
  static String productFormulationExportExcel =
      'product_formulation_export_excel';

  // --
  static String productGroupViewMenu = 'product_group_view_menu';
  static String productGroupCreate = 'product_group_create';
  static String productGroupDelete = 'product_group_delete';

  // --
  static String productIssueViewMenu = 'product_issue_view_menu';
  static String productIssueDeliveryCreate = 'product_issue_delivery_create';

  // --

  // --
  static String productReceiveViewMenu = 'product_receive_view_menu';
  static String productReceiveCreate = 'product_receive_create';
  static String productReceiveEdit = 'product_receive_edit';
  static String productReceiveRelease = 'product_receive_release';
  static String productReceiveExportPdf = 'product_receive_export_pdf';

  // --
  static String productRequestViewMenu = 'product_request_view_menu';
  static String productRequestCreate = 'product_request_create';
  static String productRequestDelete = 'product_request_delete';
  static String productRequestEdit = 'product_request_edit';

  // --
  static String purchaseOrderViewMenu = 'purchase_order_view_menu';
  static String purchaseOrderConfirm = 'purchase_order_confirm';
  static String purchaseOrderConfirmAccounting =
      'purchase_order_confirm_accounting';
  static String purchaseOrderCreate = 'purchase_order_create';
  static String purchaseOrderDelete = 'purchase_order_delete';
  static String purchaseOrderEdit = 'purchase_order_edit';
  static String purchaseOrderClose = 'purchase_order_close';
  static String purchaseOrderExportExcel = 'purchase_order_export_excel';

  // --
  static String rateViewMenu = 'rate_view_menu';
  static String rateCreate = 'rate_create';
  static String rateDelete = 'rate_delete';

  // --
  static String roleViewMenu = 'role_view_menu';
  static String roleCreate = 'role_create';
  static String roleDelete = 'role_delete';
  static String roleEdit = 'role_edit';
  static String rolePermissionEdit = 'permission_edit';

  // --

  // --
  static String salesOrderViewMenu = 'sales_order_view_menu';
  static String salesOrderConfirm = 'sales_order_confirm';
  static String salesOrderDelete = 'sales_order_delete';
  static String salesOrderDetailUploadDocument =
      'sales_order_detail_upload_document';
  static String salesOrderEdit = 'sales_order_edit';
  static String salesOrderExportDeliveryOrder =
      'sales_order_export_delivery_order';
  static String salesOrderPrintInvoice = 'sales_order_print_invoice';

  // --
  static String scheduleViewMenu = 'schedule_view_menu';
  static String scheduleCreate = 'schedule_create';
  static String scheduleDelete = 'schedule_delete';
  static String scheduleEdit = 'schedule_edit';
  static String scheduleClose = 'schedule_close';
  static String scheduleDetailCreate = 'schedule_detail_create';
  static String scheduleDetailEdit = 'schedule_detail_edit';
  static String scheduleDetailDelete = 'schedule_detail_delete';
  static String scheduleDetailValidate = 'schedule_detail_validate';

  // --
  static String supplierViewMenu = 'supplier_view_menu';
  static String supplierCreate = 'supplier_create';
  static String supplierDelete = 'supplier_delete';
  static String supplierEdit = 'supplier_edit';
  static String supplierExportExcel = 'supplier_export_excel';

  // --
  static String taxInvoiceNumberViewMenu = 'tax_invoice_number_view_menu';
  static String taxInvoiceNumberCreate = 'tax_invoice_number_create';
  static String taxInvoiceNumberDelete = 'tax_invoice_number_delete';

  // --
  static String ticketViewMenu = 'ticket_view_menu';
  static String ticketCommentDelete = 'ticket_comment_delete';
  static String ticketCreate = 'ticket_create';
  static String ticketDelete = 'ticket_delete';

  // --
  static String transactionNonOrderViewMenu = 'transaction_non_order_view_menu';
  static String transactionNonOrderCreate = 'transaction_non_order_create';
  static String transactionNonOrderDelete = 'transaction_non_order_delete';

  // --
  static String transactionRoutineViewMenu = 'transaction_routine_view_menu';
  static String transactionRoutineCreate = 'transaction_routine_create';
  static String transactionRoutineDelete = 'transaction_routine_delete';
  static String transactionRoutineEdit = 'transaction_routine_edit';

  // --
  static String transactionTypeViewMenu = 'transaction_type_view_menu';
  static String transactionTypeCreate = 'transaction_type_create';
  static String transactionTypeDelete = 'transaction_type_delete';
  static String transactionTypeEdit = 'transaction_type_edit';

  // Transaction Journal Accounting
  static String transactionJournalAccountingViewMenu =
      'transaction_journal_accounting_view_menu';
  static String transactionJournalAccountingCreate =
      'transaction_journal_accounting_create';
  static String transactionJournalAccountingDelete =
      'transaction_journal_accounting_delete';

  // --
  static String typeCostViewMenu = 'type_cost_view_menu';
  static String typeCostCreate = 'type_cost_create';
  static String typeCostDelete = 'type_cost_delete';

  // Unit Convert
  static String unitConvertViewMenu = 'unit_convert_view_menu';
  static String unitConvertCreate = 'unit_convert_create';
  static String unitConvertEdit = 'unit_convert_edit';
  static String unitConvertDelete = 'unit_convert_delete';

  // Work Hour
  static String workHourShiftViewMenu = 'work_hour_shift_view_menu';
  static String workHourShiftCreate = 'work_hour_shift_create';
  static String workHourShiftDelete = 'work_hour_shift_delete';
  static String workHourShiftEdit = 'work_hour_shift_edit';

  // Fuel
  // --
  static String fuelViewMenu = 'fuel_view_menu';
  static String fuelCreate = 'fuel_create';
  static String fuelDelete = 'fuel_delete';
  static String fuelEdit = 'fuel_edit';

  // Vehicle
  // --
  static String vehicleViewMenu = 'vehicle_view_menu';
  static String vehicleCreate = 'vehicle_create';
  static String vehicleDelete = 'vehicle_delete';
  static String vehicleEdit = 'vehicle_edit';

  // Business Trip
  static String businessTripViewMenu = 'business_trip_view_menu';
  static String businessTripCreate = 'business_trip_create';
  static String businessTripDelete = 'business_trip_delete';
  static String businessTripApproveManager = 'business_trip_approve_manager';
  static String businessTripRejectManager = 'business_trip_reject_manager';
  static String businessTripApproveCs = 'business_trip_approve_cs';
  static String businessTripRejectCs = 'business_trip_reject_cs';
  static String businessTripEdit = 'business_trip_edit';
  static String businessTripActualDate = 'business_trip_actual_date';

  static List<String> toListString(List<String> permissions) {
    return permissions.map((e) => e).toList();
  }

  static List<String> events = [
    'actual_date',
    'approve',
    'approve_cs',
    'approve_manager',
    'close',
    'confirm',
    'confirm_accounting',
    'confirm_finance',
    'confirm_marketing',
    'confirm_ppic',
    'create',
    'delete',
    'edit',
    'export_excel',
    'export_pdf',
    'moving',
    'non_active',
    'print',
    'print_document',
    'print_invoice',
    'print_report',
    'realization',
    'reject',
    'reject_cs',
    'reject_manager',
    'release',
    'rework',
    'upload',
    'validate',
    'view_menu',
    'activate',
    'deactivate',
  ];

  static String label(String permission) {
    for (final event in events) {
      if (permission.contains(event)) {
        var entity = permission.replaceAll('_$event', '');
        String? subWord;

        final regex = RegExp(r'\{(.*?)\}');
        final Match? match = regex.firstMatch(entity);
        if (match != null) {
          subWord = match.group(1);
          entity = entity.replaceAll('_{$subWord}', '');
        }

        entity = entity.tr();
        if (subWord != null) {
          entity += ' ${subWord.tr()}';
        }
        return 'permission_title.$event'.tr(namedArgs: {'entity': entity.tr()});
      }
    }
    return 'Unknown permission: $permission';
  }

  static DataAction action(String permission) {
    if (permission.contains(DataAction.view.id)) {
      return DataAction.view;
    } else if (permission.contains(DataAction.create.id)) {
      return DataAction.create;
    } else if (permission.contains(DataAction.delete.id)) {
      return DataAction.delete;
    } else if (permission.contains(DataAction.edit.id)) {
      return DataAction.edit;
    } else if (permission.contains(DataAction.approve.id)) {
      return DataAction.approve;
    } else if (permission.contains(DataAction.exportExcel.id)) {
      return DataAction.exportExcel;
    } else if (permission.contains(DataAction.exportPdf.id)) {
      return DataAction.exportPdf;
    } else if (permission.contains(DataAction.upload.id)) {
      return DataAction.upload;
    } else if (permission.contains(DataAction.activate.id)) {
      return DataAction.activate;
    } else if (permission.contains(DataAction.deactivate.id)) {
      return DataAction.deactivate;
    } else {
      return DataAction.create;
    }
  }
}

class PermissionMaterial {
  // Material
  static String materialViewMenu = 'material_view_menu';
  static String materialCreate = 'material_create';
  static String materialDelete = 'material_delete';
  static String materialEdit = 'material_edit';
  static String materialExportPdf = 'material_export_pdf';
  static String materialExportExcel = 'material_export_excel';
  static String materialActivateStock = 'material_activate_stock';
  static String materialActivateOrder = 'material_activate_order';

  // Material Type
  static String materialTypeViewMenu = 'material_type_view_menu';
  static String materialTypeCreate = 'material_type_create';
  static String materialTypeDelete = 'material_type_delete';

  // Material Unit
  static String materialUnitViewMenu = 'material_unit_view_menu';
  static String materialUnitCreate = 'material_unit_create';
  static String materialUnitDelete = 'material_unit_delete';
  static String materialUnitEdit = 'material_unit_edit';
}

class PermissionProduction {
  // --
  static String productionLineViewMenu = 'production_line_view_menu';
  static String productionLineCreate = 'production_line_create';
  static String productionLineDelete = 'production_line_delete';
  static String productionLineEdit = 'production_line_edit';

  // --
  static String productionMachineViewMenu = 'production_machine_view_menu';
  static String productionMachineCreate = 'production_machine_create';
  static String productionMachineDelete = 'production_machine_delete';
  static String productionMachineEdit = 'production_machine_edit';

  // --
  static String productionOrderViewMenu = 'production_order_view_menu';
  static String productionOrderCreate = 'production_order_create';
  static String productionOrderDelete = 'production_order_delete';
  static String productionOrderEdit = 'production_order_edit';
  static String productionOrderRework = 'production_order_rework';

  // --
  static String productionServiceOrderViewMenu =
      'production_service_order_view_menu';
  static String productionServiceOrderCreate =
      'production_service_order_create';
  static String productionServiceOrderDelete =
      'production_service_order_delete';
  static String productionServiceOrderEdit = 'production_service_order_edit';
  static String productionServiceOrderRework =
      'production_service_order_rework';

  // --
  static String productionStageViewMenu = 'production_stage_view_menu';
  static String productionStageCreate = 'production_stage_create';
  static String productionStageDelete = 'production_stage_delete';
  static String productionStageEdit = 'production_stage_edit';
  static String productionSubStageCreate = 'production_sub_stage_create';
  static String productionSubStageDelete = 'production_sub_stage_delete';
  static String productionSubStageEdit = 'production_sub_stage_edit';
  static String productionSubStageActivate = 'production_sub_stage_activate';
  static String productionSubStageDeactivate =
      'production_sub_stage_deactivate';

  // --
  static String productionStageProcessViewMenu =
      'production_stage_process_view_menu';
  static String productionStageProcessCreate =
      'production_stage_process_create';
  static String productionStageProcessDelete =
      'production_stage_process_delete';
  static String productionStageProcessEdit = 'production_stage_process_edit';
}

class PermissionProductStock {
  static String productReturnViewMenu = 'product_return_view_menu';
  static String productReturnApprove = 'product_return_approve';
  static String productReturnConfirmMarketing =
      'product_return_confirm_marketing';
  static String productReturnConfirmPpic = 'product_return_confirm_ppic';
  static String productReturnCreate = 'product_return_create';
  static String productReturnDelete = 'product_return_delete';
  static String productReturnDetailCreate = 'product_return_detail_create';
  static String productReturnDetailDelete = 'product_return_detail_delete';
  static String productReturnEdit = 'product_return_edit';
  static String productReturnCheckViewMenu = 'product_return_check_view_menu';
  static String productReturnCheckCreate = 'product_return_check_create';
  static String productReturnCheckDelete = 'product_return_check_delete';
  static String productReturnLeadTimeExportExcel =
      'product_return_{lead_time}_export_excel';
  static String productReturnRecapDispositionExportExcel =
      'product_return_{recap_disposition}_export_excel';

  // --
  static String productStockViewMenu = 'product_stock_view_menu';
  static String productStockPrint = 'product_stock_print';
  static String productStockRecapViewMenu = 'product_stock_recap_view_menu';
  static String productStockRecapExportExcel =
      'recap_product_stock_export_excel';

  static String productReturnNoteViewMenu = 'product_return_note_view_menu';
  static String productReturnNoteConfirmMarketing =
      'product_return_note_confirm_marketing';
  static String productReturnNoteCreate = 'product_return_note_create';
  static String productReturnNoteDelete = 'product_return_note_delete';
  static String productReturnNoteEdit = 'product_return_note_edit';
}

class PermissionMaterialStock {
  static String materialReturnViewMenu = 'material_return_view_menu';
  static String materialReturnCreate = 'material_return_create';
  static String materialReturnDelete = 'material_return_delete';
  static String materialReturnDetailCreate = 'material_return_detail_create';
  static String materialReturnDetailDelete = 'material_return_detail_delete';
  static String materialReturnDetailEdit = 'material_return_detail_edit';
}

class PermissionAccounting {
  static String journalTransactionViewMenu = 'journal_transaction_view_menu';
  static String journalTransactionExportExcel =
      'journal_transaction_export_excel';
  static String invoiceDiscountViewMenu = 'invoice_discount_view_menu';
  static String invoiceDiscountExportPdf = 'invoice_discount_export_pdf';
}

class PermissionVendor {
  // Vendor
  static String vendorViewMenu = 'vendor_view_menu';
  static String vendorCreate = 'vendor_create';
  static String vendorDelete = 'vendor_delete';
  static String vendorEdit = 'vendor_edit';
}

class PermissionProduct {
  static String productViewMenu = 'product_view_menu';
  static String productCreate = 'product_create';
  static String productDelete = 'product_delete';
  static String productEdit = 'product_edit';
  static String productPrint = 'product_print';
  static String productPrintReport = 'product_print_report';
  static String productPrintDocumentExternal = 'product_print_document';

  // Product NIE
  static String productNieViewMenu = 'product_nie_view_menu';
  static String productNieCreate = 'product_nie_create';
  static String productNieDelete = 'product_nie_delete';

  // Product Price
  static String productPriceCreate = 'product_price_create';
  static String productPriceDelete = 'product_price_delete';
  static String productPriceViewMenu = 'product_price_view_menu';
}
