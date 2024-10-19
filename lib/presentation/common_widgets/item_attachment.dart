import 'package:flutter/material.dart';
import 'package:shareindia/core/constants/constants.dart';
import 'package:shareindia/core/extensions/build_context_extension.dart';
import 'package:shareindia/core/extensions/text_style_extension.dart';
import 'package:shareindia/presentation/common_widgets/image_widget.dart';
import 'package:shareindia/res/drawables/background_box_decoration.dart';
import 'package:shareindia/res/drawables/drawable_assets.dart';

class ItemAttachment extends StatelessWidget {
  final String name;
  final int id;
  final bool wrapContent;
  final Function(int)? callBack;

  const ItemAttachment(
      {this.id = 0,
      required this.name,
      this.wrapContent = false,
      this.callBack,
      super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BackgroundBoxDecoration(
              boarderColor: context.resources.color.bottomSheetIconUnSelected)
          .roundedCornerBox,
      child: Row(
        mainAxisSize: wrapContent ? MainAxisSize.min : MainAxisSize.max,
        children: [
          SizedBox(
            width: context.resources.dimen.dp5,
          ),
          wrapContent
              ? Flexible(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 3.0),
                    child: Text(
                      name,
                      style: context.textFontWeight400
                          .onFontSize(context.resources.fontSize.dp12)
                          .onFontFamily(fontFamily: fontFamilyEN)
                          .copyWith(height: 1),
                    ),
                  ),
                )
              : Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 3.0),
                    child: Text(
                      name,
                      style: context.textFontWeight400
                          .onFontSize(context.resources.fontSize.dp12)
                          .onFontFamily(fontFamily: fontFamilyEN)
                          .copyWith(height: 1),
                    ),
                  ),
                ),
          SizedBox(
            width: context.resources.dimen.dp10,
          ),
          InkWell(
            onTap: () {
              callBack!(id);
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ImageWidget(
                      width: 13, height: 13, path: DrawableAssets.icCloseCircle)
                  .loadImage,
            ),
          ),
        ],
      ),
    );
  }
}
