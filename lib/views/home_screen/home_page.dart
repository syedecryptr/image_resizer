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
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:shared_preferences/shared_preferences.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    initTargets();
    showTutorial();
    super.initState();
  }
  // for tutorial screen.
  GlobalKey key1 = GlobalKey();
  GlobalKey key2 = GlobalKey();
  GlobalKey key3 = GlobalKey();

  List<TargetFocus> targets = <TargetFocus>[];


  void initTargets() {
    // for selection of images.
    targets.add(
      TargetFocus(
        enableOverlayTab: true,
        paddingFocus: 0.0,
        color: ThemeColors.white_dull,
        shape: ShapeLightFocus.Circle,
        identify: "Target 0",
        keyTarget: key1,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return Container(
                child: Padding(
                  padding: const EdgeInsets.only(top: 60.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "STEP 1 : ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 20.0),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Text(
                          "Select as many images you want to convert.",
                          style: TextStyle(
                              color: Colors.black, fontSize: 20.0),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
    // for changing the height and width of images
    targets.add(
      TargetFocus(
        enableOverlayTab: true,
        color: ThemeColors.white_dull,
          shape: ShapeLightFocus.RRect,
          identify: "Target 1",
          keyTarget: key2,
          contents: [
            TargetContent(
              align: ContentAlign.bottom,
              builder: (context, controller) {
                return Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "STEP 2 : ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 20.0),
                      ),
                      Text(
                        "Select desired image height(optional), width(optional), desired size(kb or mb) and desired format(jpg, png or pdf).",
                        style: TextStyle(
                            color: Colors.black, fontSize: 20.0),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
    );

    // for converting
    targets.add(
      TargetFocus(
        enableOverlayTab: true,
        color: ThemeColors.white_dull,
        // shape: ShapeLightFocus.RRect,
        identify: "Target 2",
        keyTarget: key3,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 50.0),
                        child: Text(
                          "STEP 3 : CONVERT",
                          style: TextStyle(
                              // fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 20.0),
                        ),
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.only(top: 10.0),
                    //   child: Text(
                    //     "Convert!!",
                    //     style: TextStyle(
                    //         color: Colors.black, fontSize: 20.0),
                    //   ),
                    // ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void showTutorial() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('tutorial_shown') == null) {
      await prefs.setBool('tutorial_shown', true);

      TutorialCoachMark tutorial = TutorialCoachMark(
        context,
        targets: targets, // List<TargetFocus>
        colorShadow: Colors.red, // DEFAULT Colors.black
        textStyleSkip: TextStyle(color: Colors.black),
        opacityShadow: 0.95
      )
        ..show();

    }
  }

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
              Center(child: Container(key: key1, child: ImagePickerSection())),
              SizedBox(height: SizeConfig.blockSizeVertical!*4,),
              Text("Edit your image", style: styles.primary_title,),
              SizedBox(height: SizeConfig.blockSizeVertical!*2,),
              Center(key: key2 ,child: ResizeBoxWidget()),
              SizedBox(height: SizeConfig.blockSizeVertical!*2,),
              ImageDisplay(),
              SizedBox(height: SizeConfig.blockSizeVertical!*3,),
            ],
          ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          if(context.watch<ImageProcessingProvider>().images.isNotEmpty && !context.watch<ImageProcessingProvider>().all_files_processed)Button(button_val: "Clear"),
          if(!context.watch<ImageProcessingProvider>().all_files_processed)Container(key: key3, child: Button(button_val: "Convert")),
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
      child: Text(button_val, style: styles.primary_title),
    );
  }
}