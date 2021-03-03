import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_resizer/providers/image_process/image_processor.dart';
import 'package:image_resizer/views/home_screen/image_uploader.dart';
import 'package:image_resizer/views/home_screen/images_thumnails.dart';
import 'package:image_resizer/views/home_screen/resize_box_widget.dart';
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
      resizeToAvoidBottomInset: false,
      backgroundColor: ThemeColors.grey_main,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: ImagePickerSection()),
              SizedBox(height: SizeConfig.blockSizeVertical*4,),
              Text("Edit your image", style: styles.secondary_title,),
              SizedBox(height: SizeConfig.blockSizeVertical*2,),
              Center(child: ResizeBoxWidget()),
              SizedBox(height: SizeConfig.blockSizeVertical*2,),
              ImageDisplay(),
              SizedBox(height: SizeConfig.blockSizeVertical*3,),
            ],
          ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          if(context.watch<ImageProcessingProvider>().images.isNotEmpty && !context.watch<ImageProcessingProvider>().all_files_processed)Button(button_val: "Clear"),
          if(!context.watch<ImageProcessingProvider>().all_files_processed)Button(button_val: "Convert"),
          if(context.watch<ImageProcessingProvider>().all_files_processed)Button(button_val: "Clear"),
          if(context.watch<ImageProcessingProvider>().all_files_processed) Button(button_val: "Download All"),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class Button extends StatelessWidget {
  var button_val;

  Button({this.button_val});

  @override
  Widget build(BuildContext context) {
    ImageProcessingProvider im_provider = context.read<ImageProcessingProvider>();
    return MaterialButton(
      shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(5.0),
          side: BorderSide(color: ThemeColors.white_dull)),
      // onPressed: im_provider.loop_files_processing(height, width, size, extension),
      onPressed: () async{
        if(button_val == "Convert") {
          var result = await im_provider.validate_and_process();
          final snackBar = SnackBar(
              content: Text(result[1], style: styles.input_value, textAlign: TextAlign.center,),
              backgroundColor: ThemeColors.grey_main,
              behavior: SnackBarBehavior.floating,
              elevation: 0,
          );
          Scaffold.of(context).showSnackBar(snackBar);
          print(result);
        }
        else if(button_val == "Clear"){
          await im_provider.reset();
        }
        else if(button_val == "Download All"){
          await im_provider.share_zip();
        }
      },
      child: Text(button_val, style: styles.secondary_title),
    );
  }
}