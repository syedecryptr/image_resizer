import 'package:flutter/material.dart';
import 'package:image_resizer/views/resizer_screen/resize_box_widget.dart';
import 'package:image_resizer/views/theme/colors.dart';
import 'package:image_resizer/views/theme/text_format.dart';
import 'package:image_resizer/views/theme/size_config.dart';


class ResizerView extends StatefulWidget {
  @override
  _ResizerViewState createState() => _ResizerViewState();
}

class _ResizerViewState extends State<ResizerView> {
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
              Text("Edit your image", style: styles.style_1,),
              SizedBox(height: SizeConfig.blockSizeVertical*4,),
              Center(child: ResizeBoxWidget())
            ],
          ),
        ),
      ),
    );
  }
}
