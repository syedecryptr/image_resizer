import 'package:flutter/material.dart';
import 'package:image_resizer/views/theme/text_format.dart';
import 'package:image_resizer/views/theme/colors.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class ImageUploader extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Button(button_val: "Upload Image/ Batch Images"),
    );
  }
}


class Button extends StatelessWidget {
  var button_val;

  Button({this.button_val});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(5.0),
          side: BorderSide(color: ThemeColors.white_dull)),
      onPressed: (){},
      child: Text(button_val, style: styles.secondary_title),
    );
  }
}
