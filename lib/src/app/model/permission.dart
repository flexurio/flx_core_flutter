import 'package:easy_localization/easy_localization.dart';
import 'package:flx_core_flutter/src/app/model/data_action.dart';

class Permission {
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

  // --
  static String cashFlowViewMenu = 'cash_flow_view_menu';
  static String cashFlowApprove = 'cash_flow_approve';
  static String cashFlowCreate = 'cash_flow_create';
  static String cashFlowEdit = 'cash_flow_edit';

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
  static String materialGroupViewMenu = 'material_group_view_menu';
  static String materialGroupCreate = 'material_group_create';
  static String materialGroupDelete = 'material_group_delete';
  static String materialGroupEdit = 'material_group_edit';

  static String materialLeadTimeEdit = 'material_lead_time_edit';

  static String materialAnalysisEdit = 'material_analysis_edit';

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
  static String requestFormExportExcel = 'request_form_export_excel';
  static String requestFormAllDepartmentExportExcel =
      'request_form_all_department_export_excel';

  // --
  static String purchaseRequestViewMenu = 'material_request_view_menu';
  static String purchaseRequestCreate = 'material_request_create';
  static String purchaseRequestDelete = 'material_request_delete';
  static String purchaseRequestEdit = 'material_request_edit';
  static String purchaseRequestExportPdf = 'material_request_export_pdf';
  static String purchaseRequestDetailConfirm =
      'material_request_detail_confirm';
  static String purchaseRequestDetailUndoConfirm =
      'purchase_request_detail_confirm_undo';
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
  static String paymentExportPdf = 'payment_export_pdf';
  static String paymentBankReceiptPdf = 'payment_bank_receipt_export_pdf';
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
  static String productIssueViewMenu = 'product_issue_view_menu';
  static String productIssueDeliveryCreate = 'product_issue_delivery_create';
  static String productIssueGlobalExportPdf = 'product_issue_global_export_pdf';
  static String productIssueLeadTimeDeliveryOrderExportPdf =
      'product_issue_{lead_time}_{delivery_order}_export_pdf';
  static String productIssueReportDeliveryExportPdf =
      'product_issue_report_delivery_export_pdf';

  // --
  static String productRequestViewMenu({required bool isExternal}) => isExternal
      ? 'product_request_external_view_menu'
      : 'product_request_view_menu';
  static String productRequestCreate({required bool isExternal}) =>
      isExternal ? 'product_request_external_create' : 'product_request_create';
  static String productRequestDelete({required bool isExternal}) =>
      isExternal ? 'product_request_external_delete' : 'product_request_delete';
  static String productRequestEdit({required bool isExternal}) =>
      isExternal ? 'product_request_external_edit' : 'product_request_edit';

  // --
  static String roleViewMenu = 'role_view_menu';
  static String roleCreate = 'role_create';
  static String roleDelete = 'role_delete';
  static String roleEdit = 'role_edit';
  static String roleExportExcel = 'role_export_excel';
  static String rolePermissionEdit = 'permission_edit';

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
  static String vehicleActive = 'vehicle_activate';

  // Business Trip
  static String vehicleRentViewMenu = 'vehicle_rent_view_menu';
  static String vehicleRentCreate = 'vehicle_rent_create';
  static String vehicleRentDelete = 'vehicle_rent_delete';
  static String vehicleRentApproveManager = 'vehicle_rent_approve_manager';
  static String vehicleRentRejectManager = 'vehicle_rent_reject_manager';
  static String vehicleRentApproveCs = 'vehicle_rent_approve_cs';
  static String vehicleRentRejectCs = 'vehicle_rent_reject_cs';
  static String vehicleRentEdit = 'vehicle_rent_edit';
  static String vehicleRentActualStartDate = 'vehicle_rent_actual_start_date';
  static String vehicleRentActualEndDate = 'vehicle_rent_actual_end_date';
  static String vehicleRentExportExcel = 'vehicle_rent_export_excel';
  static String vehicleRentExportPdf = 'vehicle_rent_export_pdf';

  static List<String> toListString(List<String> permissions) {
    return permissions.map((e) => e).toList();
  }

  static List<String> events = [
    // 3 words
    'confirm_document_ppic',
    'actual_end_date',
    'actual_start_date',
    'quality_control_check',
    // 2 words
    'open_close',
    'reject_cs',
    'reject_manager',
    'actual_date',
    'approve_cs',
    'approve_reject',
    'approve_manager',
    'confirm_accounting',
    'export_excel',
    'export_pdf',
    'confirm_finance',
    'confirm_marketing',
    'confirm_ppic',
    'print_document',
    'print_voucher',
    'print_invoice',
    'print_report',
    'non_active',
    'view_menu',
    // 1 word
    'activate',
    'approve',
    'close',
    'confirm',
    'create',
    'deactivate',
    'delete',
    'edit',
    'execute',
    'export',
    'moving',
    'print',
    'read',
    'realization',
    'reject',
    'release',
    'reprocess',
    'rework',
    'upload',
    'validate',
    'write',
  ];

  static String label(String permission) {
    for (final event in events) {
      if (permission.contains(event)) {
        var entity = permission.replaceAll('_$event', '');
        String? subWord;

        final regex = RegExp(r'\{(.*?)\}');
        final matches = regex.allMatches(entity);
        for (final match in matches) {
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

class PermissionVendor {
  // Vendor
  static String vendorViewMenu = 'vendor_view_menu';
  static String vendorCreate = 'vendor_create';
  static String vendorDelete = 'vendor_delete';
  static String vendorEdit = 'vendor_edit';
}
