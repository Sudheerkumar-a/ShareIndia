import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shareindia/core/common/common_utils.dart';
import 'package:shareindia/core/enum/enum.dart';
import 'package:shareindia/core/extensions/build_context_extension.dart';
import 'package:shareindia/core/extensions/string_extension.dart';
import 'package:shareindia/core/extensions/text_style_extension.dart';
import 'package:shareindia/presentation/bloc/services/services_bloc.dart';
import 'package:shareindia/presentation/common_widgets/action_button_widget.dart';
import 'package:shareindia/presentation/common_widgets/base_screen_widget.dart';
import 'package:shareindia/presentation/common_widgets/dropdown_widget.dart';
import 'package:shareindia/presentation/common_widgets/report_list_widget.dart';

import '../../domain/entities/user_credentials_entity.dart';
import '../../injection_container.dart';
import '../requests/view_request.dart';

// ignore: must_be_immutable
class ReportsScreen extends BaseScreenWidget {
  ReportsScreen({super.key});
  final ServicesBloc _servicesBloc = sl<ServicesBloc>();
  // final _masterDataBloc = sl<MasterDataBloc>();
  List<dynamic>? tickets;
  final ValueNotifier<int?> _selectedCategory = ValueNotifier(null);
  // final ValueNotifier<UserEntity?> _selectedEmployee = ValueNotifier(null);
  String? selectedStatus;
  List<String>? ticketsHeaderData;

  Widget _getFilters(BuildContext context) {
    final resources = context.resources;
    final categories = [
      resources.string.all,
      resources.string.assignedTickets,
      resources.string.myTickets,
      resources.string.employeeTickets,
    ];
    return Wrap(
      alignment: WrapAlignment.end,
      runSpacing: resources.dimen.dp10,
      runAlignment: WrapAlignment.start,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        SizedBox(
          width: 200,
          child: Row(
            children: [
              Text(
                resources.string.category,
                style: context.textFontWeight600
                    .onFontSize(resources.fontSize.dp10),
              ),
              SizedBox(
                width: resources.dimen.dp5,
              ),
              Expanded(
                child: DropDownWidget<String>(
                  height: 32,
                  list: categories,
                  selectedValue: categories[_selectedCategory.value ?? 0],
                  iconSize: 20,
                  fontStyle: context.textFontWeight400
                      .onFontSize(resources.fontSize.dp12),
                  callback: (p0) {
                    _selectedCategory.value = categories.indexOf(p0 ?? 'All');
                  },
                ),
              ),
            ],
          ),
        ),
        // ValueListenableBuilder(
        //     valueListenable: _selectedCategory,
        //     builder: (context, category, child) {
        //       return (category == 0 || category == 3)
        //           ? SizedBox(
        //               width: 250,
        //               child: Row(
        //                 children: [
        //                   SizedBox(
        //                     width: resources.dimen.dp20,
        //                   ),
        //                   Text(
        //                     resources.string.employee,
        //                     style: context.textFontWeight600
        //                         .onFontSize(resources.fontSize.dp10),
        //                   ),
        //                   SizedBox(
        //                     width: resources.dimen.dp5,
        //                   ),
        //                   Expanded(
        //                     child: FutureBuilder(
        //                         future: _masterDataBloc.getAssignedEmployees(
        //                             requestParams: {},
        //                             apiUrl: assignedEmployeesByUserApiUrl),
        //                         builder: (context, snapShot) {
        //                           final items = snapShot.data?.items ?? [];
        //                           if (items.isNotEmpty) {
        //                             final employee = UserEntity();
        //                             employee.id = 0;
        //                             employee.name = resources.string.all;
        //                             _selectedEmployee.value = employee;
        //                             items.insert(0, employee);
        //                           }
        //                           return DropDownWidget(
        //                             isEnabled: true,
        //                             height: 32,
        //                             iconSize: 20,
        //                             selectedValue: _selectedEmployee.value,
        //                             fontStyle: context.textFontWeight400
        //                                 .onFontSize(resources.fontSize.dp12),
        //                             list: items,
        //                             callback: (value) {
        //                               _selectedEmployee.value = value;
        //                             },
        //                           );
        //                         }),
        //                   ),
        //                 ],
        //               ),
        //             )
        //           : const SizedBox();
        //     }),
        // SizedBox(
        //   width: resources.dimen.dp10,
        // ),
        // SizedBox(
        //   width: 200,
        //   child: Row(
        //     children: [
        //       Text(
        //         resources.string.status,
        //         style: context.textFontWeight600
        //             .onFontSize(resources.fontSize.dp10),
        //       ),
        //       SizedBox(
        //         width: resources.dimen.dp10,
        //       ),
        //       Expanded(
        //         child: DropDownWidget(
        //           height: 32,
        //           list: statusTypes,
        //           iconSize: 20,
        //           selectedValue: selectedStatus ?? statusTypes[0],
        //           fontStyle: context.textFontWeight400
        //               .onFontSize(resources.fontSize.dp12),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        // SizedBox(
        //   width: resources.dimen.dp10,
        // ),
        // SizedBox(
        //   width: 120,
        //   child: Row(
        //     children: [
        //       Text(
        //         resources.string.export,
        //         style: context.textFontWeight600
        //             .onFontSize(resources.fontSize.dp10),
        //       ),
        //       SizedBox(
        //         width: resources.dimen.dp5,
        //       ),
        //       Expanded(
        //         child: DropDownWidget(
        //           height: 28,
        //           list: const [
        //             'exl',
        //             'pdf',
        //           ],
        //           iconSize: 20,
        //           fontStyle: context.textFontWeight400
        //               .onFontSize(resources.fontSize.dp10),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        SizedBox(
          width: resources.dimen.dp10,
        ),
        InkWell(
          onTap: () {
            var excel = Excel.createExcel();
            var sheetObject = excel[excel.getDefaultSheet() ?? 'SheetName'];

            tickets?.forEach((item) {
              List<CellValue> headerlist = List.empty(growable: true);
              List<CellValue> list = List.empty(growable: true);

              item.toExcel().forEach((k, v) {
                if (sheetObject.rows.isEmpty) {
                  final cellValue = TextCellValue("$k".capitalize());
                  headerlist.add(cellValue);
                }
                final cellValue = TextCellValue("$v");
                list.add(cellValue);
              });
              if (sheetObject.rows.isEmpty) {
                sheetObject.appendRow(headerlist);
              }
              sheetObject.appendRow(list);
            });
            excel.save(fileName: 'Tickets.xlsx');
          },
          child: ActionButtonWidget(
              text: resources.string.download,
              radious: resources.dimen.dp15,
              textSize: resources.fontSize.dp10,
              padding: EdgeInsets.symmetric(
                  vertical: resources.dimen.dp5,
                  horizontal: resources.dimen.dp15),
              color: resources.color.sideBarItemSelected),
        ),
        SizedBox(
          width: resources.dimen.dp10,
        ),
        InkWell(
          onTap: () {
            _printData(ticketsHeaderData ?? []);
          },
          child: ActionButtonWidget(
            text: resources.string.print,
            padding: EdgeInsets.symmetric(
                vertical: resources.dimen.dp5,
                horizontal: resources.dimen.dp15),
            radious: resources.dimen.dp15,
            textSize: resources.fontSize.dp10,
            color: resources.color.sideBarItemSelected,
          ),
        ),
      ],
    );
  }

  Future<void> _printData(List<String> headers) async {
    String tableHeader = '<tr>';
    for (var item in headers) {
      tableHeader = '$tableHeader\n <td>$item</td>';
    }
    tableHeader = '$tableHeader\n</tr>';
    String tableBody = '';
    tickets?.forEach((item) {
      tableBody = '$tableBody\n<tr>';
      item.toJson().forEach((k, v) {
        tableBody = '$tableBody\n <td>$v</td>';
      });
      tableBody = '$tableBody\n</tr>';
    });
    printData(title: "Tickets", headerData: tableHeader, bodyData: tableBody);
  }

  List<Widget> _getFilterBar(BuildContext context) {
    final resources = context.resources;
    return [
      Text(
        resources.string.report,
        style: context.textFontWeight600,
      ),
      if (UserCredentialsEntity.details().userType != UserType.user) ...[
        SizedBox(
          width: resources.dimen.dp20,
          height: resources.dimen.dp10,
        ),
        isDesktop(context)
            ? Expanded(
                child: _getFilters(context),
              )
            : _getFilters(context)
      ],
    ];
  }

  @override
  Widget build(BuildContext context) {
    final resources = context.resources;
    return SelectionArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: context.resources.color.appScaffoldBg,
        body: BlocProvider(
          create: (context) => _servicesBloc,
          child: Padding(
            padding: EdgeInsets.all(resources.dimen.dp20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  isDesktop(context)
                      ? Row(
                          children: _getFilterBar(context),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: _getFilterBar(context),
                        ),
                  SizedBox(
                    height: resources.dimen.dp20,
                  ),
                  ValueListenableBuilder(
                    valueListenable: _selectedCategory,
                    builder: (context, value, child) {
                      return FutureBuilder(
                          future:
                              _servicesBloc.getTticketsByUser(requestParams: {
                            'ticketType': (value ?? 0) + 1,
                          }),
                          builder: (context, snapsShot) {
                            tickets = snapsShot.data?.entity?.items;
                            return snapsShot.data == null
                                ? const Center(
                                    child: CircularProgressIndicator())
                                : ReportListWidget(
                                    ticketsData: tickets ?? [],
                                    showActionButtons: true,
                                    onTicketSelected: (ticket) {
                                      ViewRequest.start(context, ticket);
                                    },
                                  );
                          });
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
