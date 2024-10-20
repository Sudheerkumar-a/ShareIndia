// ignore_for_file: must_be_immutable
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shareindia/core/common/common_utils.dart';
import 'package:shareindia/core/common/log.dart';
import 'package:shareindia/core/constants/constants.dart';
import 'package:shareindia/core/enum/enum.dart';
import 'package:shareindia/core/extensions/build_context_extension.dart';
import 'package:shareindia/core/extensions/text_style_extension.dart';
import 'package:shareindia/domain/entities/api_entity.dart';
import 'package:shareindia/domain/entities/dashboard_entity.dart';
import 'package:shareindia/domain/entities/master_data_entities.dart';
import 'package:shareindia/domain/entities/user_credentials_entity.dart';
import 'package:shareindia/injection_container.dart';
import 'package:shareindia/presentation/bloc/services/services_bloc.dart';
import 'package:shareindia/presentation/common_widgets/action_button_widget.dart';
import 'package:shareindia/presentation/common_widgets/alert_dialog_widget.dart';
import 'package:shareindia/presentation/common_widgets/base_screen_widget.dart';
import 'package:shareindia/presentation/common_widgets/dropdown_widget.dart';
import 'package:shareindia/presentation/common_widgets/image_widget.dart';
import 'package:shareindia/presentation/common_widgets/report_list_widget.dart';
import 'package:shareindia/presentation/requests/create_new_request.dart';
import 'package:shareindia/presentation/requests/view_request.dart';
import 'package:shareindia/presentation/share_india/patient_form_screen.dart';
import 'package:shareindia/presentation/utils/dialogs.dart';
import 'package:shareindia/res/drawables/background_box_decoration.dart';
import 'package:shareindia/res/drawables/drawable_assets.dart';

class UserHomeScreen extends BaseScreenWidget {
  UserHomeScreen({super.key});
  late FocusNode requestStatusFocusNode;
  final ServicesBloc _servicesBloc = sl<ServicesBloc>();

  DashboardEntity? _dashboardEntity;
  final ValueNotifier<bool> _onDataChange = ValueNotifier(false);
  List<Map<String, Object>> _requestTypes = [];
  List<TicketEntity> ticketsData = [];
  int selectTicketCategory = 1;
  final ValueNotifier<int> _selectedYear = ValueNotifier(2024);
  final ValueNotifier<List<String>> _filteredDates = ValueNotifier([]);
  StatusType filteredStatus = StatusType.all;

  Future<ApiEntity<ListEntity>> _getDashboradTickets() {
    final tickets = ApiEntity<ListEntity>();
    final listEntity = ListEntity();
    listEntity.items = ticketsData;
    tickets.entity = listEntity;
    return Future.value(tickets);
  }

  Widget getLineChart(
      BuildContext context, List<TicketsByMonthEntity> ticketsByMonthEntity) {
    final resources = context.resources;
    final years = [
      _selectedYear.value,
      _selectedYear.value - 1,
      _selectedYear.value - 2
    ];
    final lineChartData = List<FlSpot>.empty(growable: true);
    final tilesData = List<Widget>.empty(growable: true);
    for (var i = 0; i < 12; i++) {
      final currentMonth = DateTime.now().month;
      final startMonth = ((currentMonth + i) % 12) + 1;
      final monthData = ticketsByMonthEntity
          .where((month) => month.month == startMonth)
          .firstOrNull;
      // if (monthData != null) {
      //   lineChartData
      //       .add(FlSpot(double.parse('${i + 1}'), Random().nextInt(100).toDouble()));
      //   tilesData.add(Expanded(
      //     child: Text(textAlign: TextAlign.right, '${monthData.month}'),
      //   ));
      // } else {
      //   lineChartData.add(FlSpot(double.parse('${i + 1}'), 0));
      //   tilesData.add(Expanded(
      //     child: Text(textAlign: TextAlign.right, '$startMonth'),
      //   ));
      // }
      lineChartData.add(
          FlSpot(double.parse('${i + 1}'), Random().nextInt(100).toDouble()));
      tilesData.add(Expanded(
        child: Text(textAlign: TextAlign.right, '$startMonth'),
      ));
    }
    return Container(
      height: 450,
      color: resources.color.colorWhite,
      padding: EdgeInsets.all(resources.dimen.dp15),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  'Patient Entiries By Month',
                  style: context.textFontWeight600
                      .onFontSize(resources.fontSize.dp12),
                ),
              ),
            ],
          ),
          SizedBox(
            height: resources.dimen.dp40,
          ),
          Expanded(
            child: LineChart(
              LineChartData(
                backgroundColor: resources.color.colorWhite,
                titlesData: FlTitlesData(
                    topTitles: const AxisTitles(),
                    rightTitles: const AxisTitles(),
                    bottomTitles: AxisTitles(
                      axisNameWidget: Row(
                        children: tilesData,
                      ),
                    )),
                borderData: FlBorderData(
                    show: true,
                    border: Border(
                        left: BorderSide(
                            color: resources.color.sideBarItemUnselected),
                        bottom: BorderSide(
                            color: resources.color.sideBarItemUnselected))),
                lineBarsData: [
                  LineChartBarData(
                      show: true,
                      spots: lineChartData,
                      preventCurveOvershootingThreshold: 12,
                      isCurved: true,
                      preventCurveOverShooting: true,
                      barWidth: 2),
                ],
              ), // Optional
            ),
          ),
        ],
      ),
    );
  }

  Widget getPieChart(BuildContext context,
      List<TicketsByCategoryEntity> ticketsByCategoryEntity) {
    final resources = context.resources;
    final categoryData = List.empty(growable: true);
    var totalCount = 0;
    for (var i = 1; i < 4; i++) {
      switch (i) {
        case 1:
          {
            var item = {'name': 'Male', 'count': 40, 'color': Colors.orange};
            categoryData.add(item);
            // totalCount = (ticketsByCategoryEntity[i].count ?? 0) + totalCount;
          }
        case 2:
          {
            var item = {'name': 'Female', 'count': 30, 'color': Colors.green};
            categoryData.add(item);
            // totalCount = (ticketsByCategoryEntity[i].count ?? 0) + totalCount;
          }
        case 3:
          {
            var item = {'name': 'TG', 'count': 10, 'color': Colors.blue};
            categoryData.add(item);
            // totalCount = (ticketsByCategoryEntity[i].count ?? 0) + totalCount;
          }
      }
    }

    totalCount = 80;
    return Container(
      height: 450,
      width: double.infinity,
      color: resources.color.colorWhite,
      padding: EdgeInsets.all(resources.dimen.dp15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Patient Entiries By Gender',
            style:
                context.textFontWeight600.onFontSize(resources.fontSize.dp12),
          ),
          SizedBox(
            height: resources.dimen.dp20,
          ),
          Expanded(
            child: PieChart(
              PieChartData(
                borderData: FlBorderData(
                    show: true,
                    border: Border(
                        left: BorderSide(
                            color: resources.color.sideBarItemUnselected),
                        bottom: BorderSide(
                            color: resources.color.sideBarItemUnselected))),
                sections: List.generate(
                    categoryData.length,
                    (index) => PieChartSectionData(
                        value: (categoryData[index]['count'] ?? 0) as double,
                        color: (categoryData[index]['color'] ?? Colors.yellow)
                            as Color,
                        title: '')),
              ), // Optional
            ),
          ),
          SizedBox(
            height: resources.dimen.dp20,
          ),
          Row(
            children: List.generate(
                categoryData.length,
                (index) => Expanded(
                      child: Align(
                        alignment: Alignment.center,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Text.rich(
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  TextSpan(
                                      text: ''.toString(),
                                      style: context.textFontWeight700
                                          .onFontSize(resources.fontSize.dp12),
                                      children: [
                                        WidgetSpan(
                                          alignment:
                                              PlaceholderAlignment.middle,
                                          child: Container(
                                            margin: EdgeInsets.only(
                                                right: resources.dimen.dp5),
                                            height: 15,
                                            width: 15,
                                            color: categoryData[index]
                                                    ['color'] ??
                                                Colors.yellow,
                                          ),
                                        ),
                                        TextSpan(
                                          text:
                                              '${((categoryData[index]['count'] / totalCount) * 100).toStringAsFixed(0)}%\n'
                                                  .toString(),
                                          style: context.textFontWeight700
                                              .onFontSize(
                                                  resources.fontSize.dp12),
                                        ),
                                        WidgetSpan(
                                          alignment:
                                              PlaceholderAlignment.middle,
                                          child: Container(
                                            margin: EdgeInsets.only(
                                                right: resources.dimen.dp5),
                                            height: 15,
                                            width: 15,
                                          ),
                                        ),
                                        TextSpan(
                                            text: categoryData[index]['name']
                                                .toString(),
                                            style: context.textFontWeight400
                                                .onFontSize(
                                                    resources.fontSize.dp10))
                                      ])),
                            ),
                          ],
                        ),
                      ),
                    )),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final resources = context.resources;
    Future.delayed(Duration.zero, () {
      _servicesBloc.getDashboardData(
          requestParams: {"userId": UserCredentialsEntity.details().id});
    });
    _selectedYear.value = DateTime.now().year;
    final requestTypesRows = isDesktop(context) ? 1 : 2;
    final requestTypesColumns = isDesktop(context) ? 4 : 2;
    _requestTypes = [
      {
        'name': resources.string.notAssignedRequests,
        'icon_path': DrawableAssets.icNotAssignedRequests,
        'count': 0
      },
      {
        'name': resources.string.openRequests,
        'icon_path': DrawableAssets.icOpenRequests,
        'count': 0
      },
      {
        'name': resources.string.closedRequests,
        'icon_path': DrawableAssets.icClosedRequests,
        'count': 0
      },
      {
        'name': resources.string.noOfRequests,
        'icon_path': DrawableAssets.icNoOfRequests,
        'count': 0
      },
    ];
    return SelectionArea(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: context.resources.color.appScaffoldBg,
      body: BlocProvider(
        create: (context) => _servicesBloc,
        child: BlocListener<ServicesBloc, ServicesState>(
          listener: (context, state) {
            if (state is OnDashboardSuccess) {
              _dashboardEntity = state.dashboardEntity.entity;
              _requestTypes[0]['count'] =
                  _dashboardEntity?.notAssignedRequests ?? 0;
              _requestTypes[1]['count'] = _dashboardEntity?.openRequests ?? 0;
              _requestTypes[2]['count'] = _dashboardEntity?.closedRequests ?? 0;
              _requestTypes[3]['count'] = _dashboardEntity?.totalRequests ?? 0;
              ticketsData = _dashboardEntity?.assignedTickets ?? [];
              _onDataChange.value = !(_onDataChange.value);
            }
          },
          child: Padding(
            padding: EdgeInsets.all(resources.dimen.dp20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        flex: 2,
                        child: Text(
                          'Dashboard',
                          style: context.textFontWeight600,
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: LayoutBuilder(builder: (context, size) {
                          printLog(size.maxWidth);
                          return InkWell(
                            onTap: () {
                              PatientFormScreen.start(context);
                            },
                            child: ActionButtonWidget(
                              width: size.maxWidth < 210 ? 100 : null,
                              text: 'Add New Patient',
                              padding: EdgeInsets.symmetric(
                                  horizontal: size.maxWidth > 210
                                      ? context.resources.dimen.dp30
                                      : context.resources.dimen.dp10,
                                  vertical: context.resources.dimen.dp7),
                            ),
                          );
                        }),
                      )
                    ],
                  ),
                  SizedBox(
                    height: resources.dimen.dp40,
                  ),
                  ValueListenableBuilder(
                      valueListenable: _onDataChange,
                      builder: (context, onDataChange, child) {
                        return isDesktop(context)
                            ? Row(
                                children: [
                                  Flexible(
                                      flex: 4,
                                      child: getLineChart(
                                          context,
                                          _dashboardEntity?.ticketsByMonth ??
                                              [])),
                                  SizedBox(
                                    width: resources.dimen.dp20,
                                  ),
                                  Flexible(
                                      flex: 2,
                                      child: getPieChart(
                                          context,
                                          _dashboardEntity?.ticketsByCategory ??
                                              []))
                                ],
                              )
                            : Column(
                                children: [
                                  getLineChart(context,
                                      _dashboardEntity?.ticketsByMonth ?? []),
                                  SizedBox(
                                    height: resources.dimen.dp20,
                                  ),
                                  getPieChart(context,
                                      _dashboardEntity?.ticketsByCategory ?? [])
                                ],
                              );
                      }),
                ],
              ),
            ),
          ),
        ),
      ),
    ));
  }

  @override
  doDispose() {}
}
