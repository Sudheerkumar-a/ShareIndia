// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shareindia/core/extensions/build_context_extension.dart';
import 'package:shareindia/core/extensions/text_style_extension.dart';
import 'package:shareindia/data/remote/api_urls.dart';
import 'package:shareindia/domain/entities/dashboard_entity.dart';
import 'package:shareindia/domain/entities/user_entity.dart';
import 'package:shareindia/presentation/bloc/master_data/master_data_bloc.dart';
import 'package:shareindia/presentation/common_widgets/action_button_widget.dart';
import 'package:shareindia/presentation/common_widgets/dropdown_widget.dart';

import '../../../injection_container.dart';

class TicketReturnWidget extends StatelessWidget {
  final TicketEntity ticketEntity;
  TicketReturnWidget({required this.ticketEntity, super.key});
  UserEntity? _selectedEmployee;
  final ValueNotifier _isForwordToEmployee = ValueNotifier(false);
  final _masterDataBloc = sl<MasterDataBloc>();

  @override
  Widget build(BuildContext context) {
    final resources = context.resources;
    return BlocProvider(
      create: (context) => _masterDataBloc,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            resources.string.returnText,
            style: context.textFontWeight600,
          ),
          SizedBox(
            height: resources.dimen.dp10,
          ),
          ValueListenableBuilder(
              valueListenable: _isForwordToEmployee,
              builder: (context, value, child) {
                return Column(
                  children: [
                    // Row(
                    //   children: [
                    //     Flexible(
                    //       child: RadioListTile(
                    //           contentPadding: const EdgeInsets.all(0),
                    //           title: Text(
                    //             'Previous Assignee',
                    //             style: context.textFontWeight400
                    //                 .onFontSize(resources.fontSize.dp12),
                    //           ),
                    //           groupValue: true,
                    //           visualDensity: const VisualDensity(
                    //               horizontal: -4, vertical: -4),
                    //           controlAffinity: ListTileControlAffinity.leading,
                    //           value: !_isForwordToEmployee.value,
                    //           onChanged: (isChecked) {
                    //             _isForwordToEmployee.value = false;
                    //           }),
                    //     ),
                    //     Flexible(
                    //       child: RadioListTile(
                    //           contentPadding: const EdgeInsets.all(0),
                    //           title: Text(
                    //             'Employee',
                    //             style: context.textFontWeight400
                    //                 .onFontSize(resources.fontSize.dp12),
                    //           ),
                    //           groupValue: true,
                    //           visualDensity: const VisualDensity(
                    //               horizontal: -4, vertical: -4),
                    //           controlAffinity: ListTileControlAffinity.leading,
                    //           value: _isForwordToEmployee.value,
                    //           onChanged: (isChecked) {
                    //             _isForwordToEmployee.value = true;
                    //           }),
                    //     ),
                    //   ],
                    // ),
                    FutureBuilder(
                        future: _masterDataBloc.getAssignedEmployees(
                            requestParams: value
                                ? {
                                    'subcategoryID': ticketEntity.subCategoryID,
                                    'categoryID': ticketEntity.categoryID,
                                  }
                                : {
                                    'ticketID': ticketEntity.id,
                                  },
                            apiUrl: value
                                ? assignedEmployeesApiUrl
                                : previousAssignedEmployeesApiUrl),
                        builder: (context, snapShot) {
                          final items = snapShot.data?.items ?? [];
                          items.removeWhere((item) =>
                              (item as UserEntity).id == ticketEntity.userID);
                          if (snapShot.data != null) {
                            final userEntity = UserEntity();
                            userEntity.id = ticketEntity.userID;
                            userEntity.name = 'Creator';
                            items.insert(0, userEntity);
                          }
                          if (items.length == 1) {
                            _selectedEmployee = items[0] as UserEntity;
                          }

                          return Padding(
                            padding: EdgeInsets.only(top: resources.dimen.dp10),
                            child: DropDownWidget(
                              isEnabled: true,
                              list: items,
                              labelText: resources.string.employee,
                              hintText: resources.string.selectEmployeeName,
                              fillColor: resources.color.colorWhite,
                              selectedValue: _selectedEmployee,
                              borderRadius: 0,
                              callback: (value) {
                                _selectedEmployee = value as UserEntity;
                              },
                            ),
                          );
                        }),
                  ],
                );
              }),
          SizedBox(
            height: resources.dimen.dp20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: ActionButtonWidget(
                  text: resources.string.clear,
                  color: resources.color.sideBarItemUnselected,
                  textStyle: context.textFontWeight400,
                  textColor: resources.color.textColor,
                  radious: resources.dimen.dp15,
                  padding: EdgeInsets.symmetric(
                      horizontal: context.resources.dimen.dp20,
                      vertical: context.resources.dimen.dp7),
                  textSize: resources.fontSize.dp12,
                ),
              ),
              SizedBox(
                width: resources.dimen.dp20,
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(context, {
                    'employeeId': _selectedEmployee?.id,
                    'employeeName': _selectedEmployee?.name,
                  });
                },
                child: ActionButtonWidget(
                  text: resources.string.submit,
                  radious: resources.dimen.dp15,
                  textStyle: context.textFontWeight400,
                  padding: EdgeInsets.symmetric(
                      horizontal: context.resources.dimen.dp20,
                      vertical: context.resources.dimen.dp7),
                  textSize: resources.fontSize.dp12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
