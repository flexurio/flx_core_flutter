// dart format width=80
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_import, prefer_relative_imports, directives_ordering

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AppGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flx_core_flutter/features/data_table_set_backend/presentation/data_table_set_backend.widgetbook.dart'
    as _flx_core_flutter_features_data_table_set_backend_presentation_data_table_set_backend_widgetbook;
import 'package:flx_core_flutter/features/menu/presentation/menu_page.widgetbook.dart'
    as _flx_core_flutter_features_menu_presentation_menu_page_widgetbook;
import 'package:flx_core_flutter/features/sidebar/presentation/menu_side_nav.widgetbook.dart'
    as _flx_core_flutter_features_sidebar_presentation_menu_side_nav_widgetbook;
import 'package:flx_core_flutter/features/top_bar/presentation/top_bar.widgetbook.dart'
    as _flx_core_flutter_features_top_bar_presentation_top_bar_widgetbook;
import 'package:flx_core_flutter/features/yuhu_table/presentation/yuhu_table.widgetbook.dart'
    as _flx_core_flutter_features_yuhu_table_presentation_yuhu_table_widgetbook;
import 'package:flx_core_flutter/features/yuhu_table/presentation/yuhu_table_sales_order_detail.widgetbook.dart'
    as _flx_core_flutter_features_yuhu_table_presentation_yuhu_table_sales_order_detail_widgetbook;
import 'package:flx_core_flutter/src/app/util/toast.widgetbook.dart'
    as _flx_core_flutter_src_app_util_toast_widgetbook;
import 'package:flx_core_flutter/src/app/view/widget/f_drop_down/f_drop_down_search_small.widgetbook.dart'
    as _flx_core_flutter_src_app_view_widget_f_drop_down_f_drop_down_search_small_widgetbook;
import 'package:flx_core_flutter/src/app/view/widget/f_drop_down/f_drop_down_small.widgetbook.dart'
    as _flx_core_flutter_src_app_view_widget_f_drop_down_f_drop_down_small_widgetbook;
import 'package:widgetbook/widgetbook.dart' as _widgetbook;

final directories = <_widgetbook.WidgetbookNode>[
  _widgetbook.WidgetbookFolder(
    name: 'app',
    children: [
      _widgetbook.WidgetbookFolder(
        name: 'util',
        children: [
          _widgetbook.WidgetbookComponent(
            name: 'Toast',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'All Toasts',
                builder: _flx_core_flutter_src_app_util_toast_widgetbook
                    .toastUseCase,
              )
            ],
          )
        ],
      ),
      _widgetbook.WidgetbookFolder(
        name: 'view',
        children: [
          _widgetbook.WidgetbookFolder(
            name: 'widget',
            children: [
              _widgetbook.WidgetbookFolder(
                name: 'f_drop_down',
                children: [
                  _widgetbook.WidgetbookComponent(
                    name: 'DropDownSmall',
                    useCases: [
                      _widgetbook.WidgetbookUseCase(
                        name: 'Default',
                        builder:
                            _flx_core_flutter_src_app_view_widget_f_drop_down_f_drop_down_small_widgetbook
                                .dropDownSmallDefault,
                      ),
                      _widgetbook.WidgetbookUseCase(
                        name: 'With Clear Button',
                        builder:
                            _flx_core_flutter_src_app_view_widget_f_drop_down_f_drop_down_small_widgetbook
                                .dropDownSmallWithClearButton,
                      ),
                      _widgetbook.WidgetbookUseCase(
                        name: 'With Icon',
                        builder:
                            _flx_core_flutter_src_app_view_widget_f_drop_down_f_drop_down_small_widgetbook
                                .dropDownSmallWithIcon,
                      ),
                      _widgetbook.WidgetbookUseCase(
                        name: 'With Initial Value',
                        builder:
                            _flx_core_flutter_src_app_view_widget_f_drop_down_f_drop_down_small_widgetbook
                                .dropDownSmallWithInitialValue,
                      ),
                    ],
                  ),
                  _widgetbook.WidgetbookComponent(
                    name: 'FDropDownSearchSmall',
                    useCases: [
                      _widgetbook.WidgetbookUseCase(
                        name: 'Default',
                        builder:
                            _flx_core_flutter_src_app_view_widget_f_drop_down_f_drop_down_search_small_widgetbook
                                .fDropDownSearchSmallDefault,
                      ),
                      _widgetbook.WidgetbookUseCase(
                        name: 'Disabled',
                        builder:
                            _flx_core_flutter_src_app_view_widget_f_drop_down_f_drop_down_search_small_widgetbook
                                .fDropDownSearchSmallDisabled,
                      ),
                      _widgetbook.WidgetbookUseCase(
                        name: 'With Clear Button',
                        builder:
                            _flx_core_flutter_src_app_view_widget_f_drop_down_f_drop_down_search_small_widgetbook
                                .fDropDownSearchSmallWithClearButton,
                      ),
                      _widgetbook.WidgetbookUseCase(
                        name: 'With Initial Value',
                        builder:
                            _flx_core_flutter_src_app_view_widget_f_drop_down_f_drop_down_search_small_widgetbook
                                .fDropDownSearchSmallWithInitialValue,
                      ),
                    ],
                  ),
                ],
              )
            ],
          )
        ],
      ),
    ],
  ),
  _widgetbook.WidgetbookFolder(
    name: 'features',
    children: [
      _widgetbook.WidgetbookFolder(
        name: 'data_table_set_backend',
        children: [
          _widgetbook.WidgetbookFolder(
            name: 'presentation',
            children: [
              _widgetbook.WidgetbookComponent(
                name: 'DataTableBackend',
                useCases: [
                  _widgetbook.WidgetbookUseCase(
                    name: 'Default',
                    builder:
                        _flx_core_flutter_features_data_table_set_backend_presentation_data_table_set_backend_widgetbook
                            .dataTableBackendDefault,
                  ),
                  _widgetbook.WidgetbookUseCase(
                    name: 'Product Return Check',
                    builder:
                        _flx_core_flutter_features_data_table_set_backend_presentation_data_table_set_backend_widgetbook
                            .dataTableBackendProductReturnCheck,
                  ),
                  _widgetbook.WidgetbookUseCase(
                    name: 'Voucher Payment List',
                    builder:
                        _flx_core_flutter_features_data_table_set_backend_presentation_data_table_set_backend_widgetbook
                            .dataTableBackendVoucherPayment,
                  ),
                  _widgetbook.WidgetbookUseCase(
                    name: 'With Action Multiple',
                    builder:
                        _flx_core_flutter_features_data_table_set_backend_presentation_data_table_set_backend_widgetbook
                            .dataTableBackendWithActionMultiple,
                  ),
                  _widgetbook.WidgetbookUseCase(
                    name: 'With Pinned Columns',
                    builder:
                        _flx_core_flutter_features_data_table_set_backend_presentation_data_table_set_backend_widgetbook
                            .dataTableBackendWithPinnedColumns,
                  ),
                ],
              )
            ],
          )
        ],
      ),
      _widgetbook.WidgetbookFolder(
        name: 'menu',
        children: [
          _widgetbook.WidgetbookFolder(
            name: 'presentation',
            children: [
              _widgetbook.WidgetbookComponent(
                name: 'MenuPage',
                useCases: [
                  _widgetbook.WidgetbookUseCase(
                    name: 'Default Menu Page',
                    builder:
                        _flx_core_flutter_features_menu_presentation_menu_page_widgetbook
                            .menuPageUseCase,
                  )
                ],
              )
            ],
          )
        ],
      ),
      _widgetbook.WidgetbookFolder(
        name: 'sidebar',
        children: [
          _widgetbook.WidgetbookFolder(
            name: 'presentation',
            children: [
              _widgetbook.WidgetbookComponent(
                name: 'MenuSideNav',
                useCases: [
                  _widgetbook.WidgetbookUseCase(
                    name: 'Default Side Nav',
                    builder:
                        _flx_core_flutter_features_sidebar_presentation_menu_side_nav_widgetbook
                            .menuSideNavUseCase,
                  )
                ],
              )
            ],
          )
        ],
      ),
      _widgetbook.WidgetbookFolder(
        name: 'top_bar',
        children: [
          _widgetbook.WidgetbookFolder(
            name: 'presentation',
            children: [
              _widgetbook.WidgetbookComponent(
                name: 'TopBar',
                useCases: [
                  _widgetbook.WidgetbookUseCase(
                    name: 'Default Top Bar',
                    builder:
                        _flx_core_flutter_features_top_bar_presentation_top_bar_widgetbook
                            .topBarUseCase,
                  )
                ],
              )
            ],
          )
        ],
      ),
      _widgetbook.WidgetbookFolder(
        name: 'yuhu_table',
        children: [
          _widgetbook.WidgetbookFolder(
            name: 'presentation',
            children: [
              _widgetbook.WidgetbookComponent(
                name: 'YuhuTable',
                useCases: [
                  _widgetbook.WidgetbookUseCase(
                    name: 'Default',
                    builder:
                        _flx_core_flutter_features_yuhu_table_presentation_yuhu_table_widgetbook
                            .yuhuTableUseCase,
                  ),
                  _widgetbook.WidgetbookUseCase(
                    name: 'Interactivity Options',
                    builder:
                        _flx_core_flutter_features_yuhu_table_presentation_yuhu_table_widgetbook
                            .yuhuTableInteractivityOptionsUseCase,
                  ),
                  _widgetbook.WidgetbookUseCase(
                    name: 'Many Columns',
                    builder:
                        _flx_core_flutter_features_yuhu_table_presentation_yuhu_table_widgetbook
                            .yuhuTableManyColumnsUseCase,
                  ),
                  _widgetbook.WidgetbookUseCase(
                    name: 'Purchase Request',
                    builder:
                        _flx_core_flutter_features_yuhu_table_presentation_yuhu_table_widgetbook
                            .yuhuTablePurchaseRequestUseCase,
                  ),
                  _widgetbook.WidgetbookUseCase(
                    name: 'Sales Order Detail',
                    builder:
                        _flx_core_flutter_features_yuhu_table_presentation_yuhu_table_sales_order_detail_widgetbook
                            .yuhuTableSalesOrderDetailUseCase,
                  ),
                ],
              )
            ],
          )
        ],
      ),
    ],
  ),
];
