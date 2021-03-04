import 'package:flutter/material.dart';
import 'package:image_resizer/providers/image_process/image_processor.dart';
import 'package:image_resizer/views/theme/text_format.dart';
import 'package:image_resizer/views/theme/colors.dart';
import 'package:provider/provider.dart';
class ImagePickerSection extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Button(button_val: "Select Image(s)"),
    );
  }
}

class Button extends StatelessWidget {
  var button_val;

  Button({this.button_val});

  @override
  Widget build(BuildContext context) {
    var im_provider = context.read<ImageProcessingProvider>();
    return MaterialButton(
      shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(5.0),
          side: BorderSide(color: ThemeColors.white_dull)),
      onPressed: im_provider.loadAssets,
      child: Text(button_val, style: styles.primary_title),
    );
  }

}
