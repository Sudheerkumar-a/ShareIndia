import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shareindia/core/config/app_routes.dart';
import 'package:shareindia/data/local/user_data_db.dart';
import 'package:shareindia/injection_container.dart';
import 'package:shareindia/presentation/bloc/user/user_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shareindia/core/constants/constants.dart';
import 'package:shareindia/core/extensions/build_context_extension.dart';
import 'package:shareindia/res/resources.dart';

import '../common_widgets/dropdown_widget.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});
  final UserBloc _userBloc = sl<UserBloc>();

  @override
  Widget build(BuildContext context) {
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      appVersion = "${packageInfo.version} (${packageInfo.buildNumber})";
    });
    Resources resources = context.resources;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: resources.color.colorWhite,
        statusBarIconBrightness: Brightness.dark));
    Future.delayed(const Duration(seconds: 0), () async {
      // final user = await _userBloc.validateUser({"username": username});
      // if (context.mounted) {
      //   userToken = user.token ?? '';
      //   context.userDataDB.put(UserDataDB.userToken, userToken);
      //   Navigator.of(context).pushAndRemoveUntil(
      //       MaterialPageRoute(builder: (context) => const UserMainScreen()),
      //       (_) => false);
      // }
    });

    return BlocProvider(
      create: (context) => _userBloc,
      child: Scaffold(
        backgroundColor: const Color(0xFFFFFFFF),
        body: Center(
          child: Container(
              padding: const EdgeInsets.all(50),
              width: 400,
              child: DropDownWidget<String>(
                list: const [
                  'sudheer.akula',
                  'mooza.binyeem',
                  'asma.alraee',
                  'akbar.shaik',
                  'sahil.ahmed',
                  'prathap.rajendiran',
                  'syed.ibrahim',
                  'noora.bolasly',
                  'noushad.kolliyath',
                  'shaikha.almuheiri',
                  'shaikha.bintook',
                  'Ijaz.Kasim',
                  'ujjwal.jha',
                  'ibrahim.othman',
                  'essa.saif',
                  'eman.essa',
                  'alyaa.alshehi',
                ],
                callback: (p0) async {
                  userToken = '';
                  final user = await _userBloc.validateUser({"username": p0});
                  if (context.mounted) {
                    userToken = user.token ?? '';
                    context.userDataDB.put(UserDataDB.userToken, userToken);
                    Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRoutes.userMainRoute,
                        (Route route) => route.settings.name == 'homePage');
                  }
                },
              )),
        ),
      ),
    );
  }
}
