// dart format width=80
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_import, prefer_relative_imports, directives_ordering

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AppGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flx_core_flutter/src/app/util/toast.widgetbook.dart'
    as _flx_core_flutter_src_app_util_toast_widgetbook;
import 'package:flx_core_flutter/src/app/view/widget/f_drop_down/usecase/f_drop_down_small_usecase.dart'
    as _flx_core_flutter_src_app_view_widget_f_drop_down_usecase_f_drop_down_small_usecase;
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
                            _flx_core_flutter_src_app_view_widget_f_drop_down_usecase_f_drop_down_small_usecase
                                .dropDownSmallDefault,
                      ),
                      _widgetbook.WidgetbookUseCase(
                        name: 'With Clear Button',
                        builder:
                            _flx_core_flutter_src_app_view_widget_f_drop_down_usecase_f_drop_down_small_usecase
                                .dropDownSmallWithClearButton,
                      ),
                      _widgetbook.WidgetbookUseCase(
                        name: 'With Icon',
                        builder:
                            _flx_core_flutter_src_app_view_widget_f_drop_down_usecase_f_drop_down_small_usecase
                                .dropDownSmallWithIcon,
                      ),
                      _widgetbook.WidgetbookUseCase(
                        name: 'With Initial Value',
                        builder:
                            _flx_core_flutter_src_app_view_widget_f_drop_down_usecase_f_drop_down_small_usecase
                                .dropDownSmallWithInitialValue,
                      ),
                    ],
                  )
                ],
              )
            ],
          )
        ],
      ),
    ],
  )
];
