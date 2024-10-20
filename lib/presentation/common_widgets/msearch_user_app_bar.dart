import 'package:flutter/material.dart';
import 'package:shareindia/core/extensions/build_context_extension.dart';
import 'package:shareindia/presentation/common_widgets/image_widget.dart';
import 'package:shareindia/presentation/common_widgets/search_textfield_widget.dart';
import 'package:shareindia/res/drawables/drawable_assets.dart';

import '../../core/constants/constants.dart';

class MSearchUserAppBarWidget extends StatelessWidget
    implements PreferredSizeWidget {
  final String userName;
  final EdgeInsets? padding;
  static final _formKey = GlobalKey<FormState>();
  MSearchUserAppBarWidget({required this.userName, this.padding, super.key});
  final ValueNotifier _isAvailable = ValueNotifier<bool>(true);

  @override
  Widget build(BuildContext context) {
    final resources = context.resources;
    return Container(
      padding: padding ?? const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
              SizedBox(
                width: resources.dimen.dp10,
              ),
              Expanded(
                child: Form(
                  key: _formKey,
                  child: SearchDropDownWidget(
                    prefixIconPath: DrawableAssets.icSearch,
                  ),
                ),
              ),
              SizedBox(
                width: resources.dimen.dp10,
              ),
              ValueListenableBuilder(
                  valueListenable: _isAvailable,
                  builder: (context, value, child) {
                    return Tooltip(
                      message: resources.string.vacation,
                      child: Switch(
                          activeColor: resources.color.viewBgColor,
                          value: value,
                          onChanged: (value) {
                            _isAvailable.value = value;
                          }),
                    );
                  }),

              InkWell(
                onTap: () {
                  resources.setLocal(language: isSelectedLocalEn ? 'ar' : 'en');
                },
                child: Tooltip(
                  message: resources.string.language,
                  child: ImageWidget(
                          path: isSelectedLocalEn
                              ? DrawableAssets.icLangAr
                              : DrawableAssets.icLangEn,
                          width: 20,
                          height: 20,
                          padding: EdgeInsets.all(resources.dimen.dp10))
                      .loadImageWithMoreTapArea,
                ),
              ),
              Tooltip(
                message: resources.string.userProfile,
                child: ImageWidget(
                        path: DrawableAssets.icUserCircle,
                        width: 20,
                        height: 20,
                        backgroundTint: resources.color.textColorLight,
                        padding: EdgeInsets.all(resources.dimen.dp10))
                    .loadImageWithMoreTapArea,
              ),
              // Text(userName,
              //     style: context.textFontWeight600
              //         .onFontSize(resources.fontSize.dp12)
              //         .onColor(resources.color.textColorLight))
            ],
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50);
}
