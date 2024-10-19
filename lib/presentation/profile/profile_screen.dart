import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shareindia/core/extensions/build_context_extension.dart';
import 'package:shareindia/core/extensions/text_style_extension.dart';
import 'package:shareindia/domain/entities/user_credentials_entity.dart';
import 'package:shareindia/presentation/bloc/user/user_bloc.dart';
import 'package:shareindia/presentation/common_widgets/base_screen_widget.dart';

import '../../injection_container.dart';

class ProfileScreen extends BaseScreenWidget {
  ProfileScreen({super.key});
  final UserBloc _userBloc = sl<UserBloc>();
  @override
  Widget build(BuildContext context) {
    final resources = context.resources;

    return SelectionArea(
      child: Scaffold(
        backgroundColor: context.resources.color.appScaffoldBg,
        body: BlocProvider(
          create: (context) => _userBloc,
          child: Padding(
            padding: EdgeInsets.all(resources.dimen.dp20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    resources.string.userProfile,
                    style: context.textFontWeight700
                        .onFontSize(resources.fontSize.dp14),
                  ),
                  SizedBox(
                    height: resources.dimen.dp20,
                  ),
                  // FutureBuilder(
                  //     future: _userBloc.getUserData({
                  //       'userName': UserCredentialsEntity.details().username
                  //     }),
                  //     builder: (context, snapShot) {
                  //       final userEntity = snapShot.data;
                  //       return
                  Container(
                    padding: EdgeInsets.symmetric(
                        vertical: resources.dimen.dp15,
                        horizontal: resources.dimen.dp20),
                    color: resources.color.colorWhite,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IntrinsicHeight(
                          child: Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text.rich(
                                      TextSpan(
                                          text:
                                              '${resources.string.fullName}\n',
                                          style: context.textFontWeight400
                                              .onFontSize(
                                                  resources.fontSize.dp10),
                                          children: [
                                            TextSpan(
                                                text: '',
                                                style: context.textFontWeight600
                                                    .onFontSize(resources
                                                        .fontSize.dp12))
                                          ]),
                                    ),
                                    SizedBox(
                                      height: resources.dimen.dp15,
                                    ),
                                    Text.rich(
                                      TextSpan(
                                          text: '${resources.string.title}\n',
                                          style: context.textFontWeight400
                                              .onFontSize(
                                                  resources.fontSize.dp10),
                                          children: [
                                            TextSpan(
                                                text: '',
                                                style: context.textFontWeight600
                                                    .onFontSize(resources
                                                        .fontSize.dp12))
                                          ]),
                                    ),
                                  ],
                                ),
                              ),
                              // Expanded(
                              //     flex: 1,
                              //     child: Container(
                              //       margin:
                              //           EdgeInsets.all(resources.dimen.dp5),
                              //       decoration: BackgroundBoxDecoration(
                              //         boxColor: resources
                              //             .color.sideBarItemUnselected,
                              //       ).circularBox,
                              //     ))
                            ],
                          ),
                        ),
                        SizedBox(
                          height: resources.dimen.dp15,
                        ),
                        Text(
                          resources.string.managerName,
                          style: context.textFontWeight400
                              .onFontSize(resources.fontSize.dp10),
                        ),
                        Text('',
                            style: context.textFontWeight600
                                .onFontSize(resources.fontSize.dp12)),
                        SizedBox(
                          height: resources.dimen.dp15,
                        ),
                        // SizedBox(
                        //   height: resources.dimen.dp5,
                        // ),
                        // Row(
                        //   children: [
                        //     Expanded(
                        //       flex: 1,
                        //       child: Text(
                        //         resources.string.yearOfService,
                        //         style: context.textFontWeight400
                        //             .onFontSize(resources.fontSize.dp10),
                        //       ),
                        //     ),
                        //     Expanded(
                        //       flex: 3,
                        //       child: Text('8.0',
                        //           style: context.textFontWeight600
                        //               .onFontSize(resources.fontSize.dp12)),
                        //     )
                        //   ],
                        // ),
                        Text(
                          resources.string.emailID,
                          style: context.textFontWeight400
                              .onFontSize(resources.fontSize.dp10),
                        ),
                        Text('',
                            style: context.textFontWeight600
                                .onFontSize(resources.fontSize.dp12)),
                        SizedBox(
                          height: resources.dimen.dp15,
                        ),
                        Text(
                          resources.string.department,
                          style: context.textFontWeight400
                              .onFontSize(resources.fontSize.dp10),
                        ),
                        Text('',
                            style: context.textFontWeight600
                                .onFontSize(resources.fontSize.dp12)),
                        SizedBox(
                          height: resources.dimen.dp15,
                        ),
                        Text(
                          resources.string.telephoneExt,
                          style: context.textFontWeight400
                              .onFontSize(resources.fontSize.dp10),
                        ),
                        Text('',
                            style: context.textFontWeight600
                                .onFontSize(resources.fontSize.dp12)),
                      ],
                    ),
                  )
                  //})
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
