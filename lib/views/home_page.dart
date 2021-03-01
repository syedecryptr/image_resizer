import 'package:flutter/material.dart';
import 'package:image_resizer/views/image_uploader.dart';
import 'package:image_resizer/views/resizer_screen/resize_box_widget.dart';
import 'package:image_resizer/views/theme/colors.dart';
import 'package:image_resizer/views/theme/text_format.dart';

import 'package:image_resizer/views/theme/size_config.dart';


class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // initialise the size_config for responsive.
    SizeConfig().init(context);

    var padding = SizeConfig.blockSizeHorizontal * 5;
    return Scaffold(
      backgroundColor: ThemeColors.grey_main,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: ImageUploader()),
              SizedBox(height: SizeConfig.blockSizeVertical*4,),
              Text("Edit your image", style: styles.secondary_title,),
              SizedBox(height: SizeConfig.blockSizeVertical*2,),
              Center(child: ResizeBoxWidget())
            ],
          ),
        ),
      ),
    );
  }
}
