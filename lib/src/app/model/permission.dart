import 'package:easy_localization/easy_localization.dart';
import 'package:flexurio_erp_core/src/app/model/data_action.dart';

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
  static String materialDesignViewMenu = 'material_design_view_menu';
  static String materialDesignCreate = 'material_design_create';
  static String materialDesignDelete = 'material_design_delete';
  static String materialDesignEdit = 'material_design_edit';

  // --
  static String materialGroupViewMenu = 'material_group_view_menu';
  static String materialGroupCreate = 'material_group_create';
  static String materialGroupDelete = 'material_group_delete';
  static String materialGroupEdit = 'material_group_edit';

  static String materialLeadTimeEdit = 'material_lead_time_edit';

  // Material Receive
  static String materialReceiveViewMenu = 'material_receive_view_menu';
  static String materialReceiveCreate = 'material_receive_create';
  static String materialReceiveRelease = 'material_receive_release';
  static String materialReceiveReject = 'material_receive_reject';
  static String materialReceiveExportPdf = 'material_receive_export_pdf';
  static String materialReturnReceiptExportPdf =
      'material_return_receipt_export_pdf';
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
  static String roleViewMenu = 'role_view_menu';
  static String roleCreate = 'role_create';
  static String roleDelete = 'role_delete';
  static String roleEdit = 'role_edit';
  static String rolePermissionEdit = 'permission_edit';

  // --

  // --
  static String salesOrderViewMenu = 'sales_order_view_menu';
  static String salesOrderConfirm = 'sales_order_confirm';
  static String salesOrderCreate = 'sales_order_create';
  static String salesOrderDelete = 'sales_order_delete';
  static String salesOrderDetailUploadDocument =
      'sales_order_detail_upload_document';
  static String salesOrderEdit = 'sales_order_edit';
  static String salesOrderExportDeliveryOrder =
      'sales_order_export_delivery_order';
  static String salesOrderPrintInvoice = 'sales_order_print_invoice';
  static String salesOrderSummaryExportPdf = 'sales_order_summary_export_pdf';
  static String salesOrderMalkSummaryExportPdf =
      'sales_order_malk_summary_export_pdf';
  static String salesOrderLoanRequestsSummaryExportPdf =
      'sales_order_loan_requests_summary_export_pdf';
  static String pendingRequestsRecapViewMenu =
      'pending_requests_recap_view_menu';
  static String pendingRequestsRecapExportPdf =
      'pending_requests_recap_export_pdf';
  static String pendingRequestsUnservedExportPdf =
      'pending_requests_unserved_export_pdf';
  static String pendingRequestsDetailExportPdf =
      'pending_requests_detail_export_pdf';

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
  static String scheduleExportExcel = 'schedule_export_excel';

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
