// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shareindia/core/common/common_utils.dart';
import 'package:shareindia/core/constants/constants.dart';
import 'package:shareindia/core/extensions/build_context_extension.dart';
import 'package:shareindia/data/local/app_settings_db.dart';
import 'package:shareindia/data/local/user_data_db.dart';
import 'package:shareindia/domain/entities/user_credentials_entity.dart';
import 'package:shareindia/injection_container.dart';
import 'package:shareindia/presentation/bloc/user/user_bloc.dart';
import 'package:shareindia/presentation/common_widgets/alert_dialog_widget.dart';
import 'package:shareindia/presentation/common_widgets/base_screen_widget.dart';
import 'package:shareindia/presentation/common_widgets/msearch_user_app_bar.dart';
import 'package:shareindia/presentation/common_widgets/search_user_app_bar.dart';
import 'package:shareindia/presentation/common_widgets/side_bar.dart';
import 'package:shareindia/presentation/directory/directory_navigator_screen.dart';
import 'package:shareindia/presentation/home/user_home_navigator_screen.dart';
import 'package:shareindia/presentation/profile/profile_navigator_screen.dart';
import 'package:shareindia/presentation/reports/reports_navigator_screen.dart';
import 'package:shareindia/presentation/share_india/patient_form_a.dart';
import 'package:shareindia/presentation/share_india/patient_form_screen.dart';
import 'package:shareindia/presentation/share_india/report_screen.dart';
import 'package:shareindia/presentation/utils/NavbarNotifier.dart';
import 'package:shareindia/presentation/utils/dialogs.dart';
import 'package:shareindia/res/resources.dart';

import '../../core/enum/enum.dart';
import '../requests/create_new_request.dart';

class UserMainScreen extends StatefulWidget {
  static ValueNotifier onUnAuthorizedResponse = ValueNotifier<bool>(false);
  static ValueNotifier onNetworkConnectionError = ValueNotifier<int>(1);
  const UserMainScreen({super.key});
  @override
  State<StatefulWidget> createState() => _MainScreenState();
}

class _MainScreenState extends State<UserMainScreen> {
  final NavbarNotifier _navbarNotifier = NavbarNotifier();
  int backpressCount = 0;
  final ValueNotifier<int> _selectedIndex = ValueNotifier<int>(0);
  BaseScreenWidget? currentScreen;
  int activeTab = 0;
  double sideBarWidth = 200;
  final UserBloc _userBloc = sl<UserBloc>();
  late SideBar sideBar;

  Widget getUserAppBar(BuildContext context) {
    context.userDataDB.put(
        UserDataDB.userOnvaction,
        UserCredentialsEntity.details().userOnvaction ??
            context.userDataDB
                .get(UserDataDB.userOnvaction, defaultValue: false));
    return isDesktop(context)
        ? SearchUserAppBarWidget(
            userName: UserCredentialsEntity.details().name ?? "",
            onItemTap: (p0) {
              if (p0 == AppBarItem.user) {
                sideBar.selectItem(3);
              } else if (p0 == AppBarItem.vacation) {
                _userBloc.setVaction(requestParams: {
                  'vacation': context.userDataDB
                      .get(UserDataDB.userOnvaction, defaultValue: false)
                });
              }
            },
          )
        : MSearchUserAppBarWidget(
            userName: UserCredentialsEntity.details().name ?? "",
          );
  }

  void _onItemTapped(int index) {
    if (_selectedIndex.value == index) {
      _navbarNotifier.onBackButtonPressed(_selectedIndex.value);
    }
    _selectedIndex.value = index;
    context.appSettingsDB.put(AppSettingsDB.selectedSideBarIndex, index);
  }

  Widget getScreen(int index) {
    if (currentScreen != null) {
      currentScreen?.doDispose();
    }
    switch (index) {
      case 0:
        currentScreen = UserHomeNavigatorScreen();
      case 1:
        currentScreen = ProfileNavigatorScreen();
      case 2:
        currentScreen = ProfileNavigatorScreen();
      default:
        currentScreen =
            UserCredentialsEntity.details().userType == UserType.user
                ? CreateNewRequest()
                : UserHomeNavigatorScreen();
    }
    return currentScreen ??
        (UserCredentialsEntity.details().userType == UserType.user
            ? CreateNewRequest()
            : UserHomeNavigatorScreen());
  }

  @override
  void initState() {
    super.initState();
    _selectedIndex.value = context.appSettingsDB
        .get(AppSettingsDB.selectedSideBarIndex, defaultValue: 0);
    sideBar = SideBar(
      onItemSelected: (p0) {
        _onItemTapped(p0);
      },
      seletedItem: _selectedIndex.value,
    );
  }

  @override
  void dispose() {
    if (currentScreen != null) {
      currentScreen?.doDispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Resources resources = context.resources;
    // final isWebMobile = kIsWeb &&
    //     (defaultTargetPlatform == TargetPlatform.iOS ||
    //         defaultTargetPlatform == TargetPlatform.android);

    return BlocProvider(
      create: (context) => _userBloc,
      child: PopScope(
        canPop: false,
        onPopInvoked: (didPop) async {
          await _navbarNotifier.onBackButtonPressed(_selectedIndex.value);
        },
        child: BlocProvider(
          create: (context) => _userBloc,
          child: BlocListener<UserBloc, UserState>(
            listener: (context, state) {},
            child: Scaffold(
              backgroundColor: resources.color.colorWhite,
              resizeToAvoidBottomInset: false,
              drawer: SizedBox(
                width: 200,
                child: SideBar(
                  onItemSelected: (p0) {
                    _onItemTapped(p0);
                  },
                ),
              ),
              body: LayoutBuilder(builder: (context, size) {
                screenSize = size.biggest;
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isDesktop(context, size: size.biggest))
                      SizedBox(
                        width: 150,
                        child: sideBar,
                      ),
                    Expanded(
                      child: Column(
                        children: [
                          getUserAppBar(context),
                          ValueListenableBuilder(
                              valueListenable: _selectedIndex,
                              builder: (context, index, child) {
                                return Expanded(child: getScreen(index));
                              }),
                        ],
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
