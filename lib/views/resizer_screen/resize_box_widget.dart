import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:image_resizer/views/theme/colors.dart';
import 'package:image_resizer/views/theme/size_config.dart';
import 'package:image_resizer/views/theme/text_format.dart';

class ResizeBoxWidget extends StatelessWidget {
  var width = SizeConfig.blockSizeHorizontal * 90;
  var height = SizeConfig.blockSizeVertical * 40;
  var padding = SizeConfig.blockSizeHorizontal * 5;
  var shape_box_width = SizeConfig.blockSizeHorizontal * 30;
  var shape_box_height = SizeConfig.blockSizeVertical * 4;
  var size_number_width = SizeConfig.blockSizeHorizontal * 30;
  var size_number_height = SizeConfig.blockSizeVertical * 4;
  var size_type_width = SizeConfig.blockSizeHorizontal * 15;
  var size_type_heigth = SizeConfig.blockSizeVertical * 4;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Container(
        // padding: EdgeInsets.all(padding),
        width: width,
        height: height,
        decoration: BoxDecoration(
          // TODO: create new color dull white.
          color: ThemeColors.grey_main,
          border: Border.all(color: ThemeColors.white_dull),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: padding),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("RESIZE", style: styles.secondary_title),
                //resize options width and height
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: padding),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Width", style: styles.parameters_headings),
                          SizedBox(height: SizeConfig.blockSizeVertical),
                          InputField(
                              default_val: "1200",
                              height: shape_box_height,
                              width: shape_box_width)
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Height", style: styles.parameters_headings),
                          SizedBox(height: SizeConfig.blockSizeVertical),
                          InputField(
                              default_val: "800",
                              height: shape_box_height,
                              width: shape_box_width)
                        ],
                      )
                    ],
                  ),
                ),
                // output size column
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: padding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Output size", style: styles.parameters_headings),
                      SizedBox(height: SizeConfig.blockSizeVertical),
                      // output size options size and kb/mb
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InputField(
                                  default_val: "1200",
                                  height: size_number_height,
                                  width: size_number_width)
                            ],
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InputField(
                                  default_val: "kb",
                                  height: size_type_heigth,
                                  width: size_type_width)
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                // output type column
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: padding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Output type", style: styles.parameters_headings),
                      // output size options size and kb/mb
                      DefaultTabController(
                        length: 3, // length of tabs
                        initialIndex: 0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Container(
                              child: TabBar(
                                indicatorSize: TabBarIndicatorSize.label,
                                indicatorColor: ThemeColors.green_main,
                                // indicator:BoxDecoration(color: ThemeColors.dark_grey),
                                tabs: [
                                  Tab(
                                      child: Text(
                                    'PNG',
                                    style: styles.place_holder,
                                  )),
                                  Tab(
                                      child: Text(
                                    'JPEG',
                                    style: styles.place_holder,
                                  )),
                                  Tab(
                                      child: Text(
                                    'PDF',
                                    style: styles.place_holder,
                                  )),
                                ],
                              ),
                              height: shape_box_height,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
        ));
  }
}

class InputField extends StatelessWidget {
  InputField({this.default_val, this.height, this.width});
  final default_val;
  final height;
  final width;
  @override
  Widget build(BuildContext context) {
    var border_radius = 7.0;
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: ThemeColors.dark_grey,
            border: Border.all(color: Colors.transparent),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(border_radius),
                bottomLeft: Radius.circular(border_radius)),
          ),
          height: height,
          width: width * 0.7,
          child: TextField(
            cursorColor: ThemeColors.green_main,
            style: styles.place_holder,
            decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                hintText: default_val,
                hintStyle: styles.place_holder,
                contentPadding: EdgeInsets.fromLTRB(10, 5, 0, 0)),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: ThemeColors.dark_grey,
            border: Border.all(color: Colors.transparent),
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(border_radius),
                bottomRight: Radius.circular(border_radius)),
          ),
          height: height,
          width: width * 0.3,
          child: Stack(
            children: [
              Align(
                  alignment: Alignment.topCenter,
                  child: Icon(
                    Icons.arrow_drop_up_sharp,
                    size: 18,
                    color: Colors.white12,
                  )),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Icon(
                    Icons.arrow_drop_down_sharp,
                    size: 18,
                    color: Colors.white12,
                  )),
            ],
          ),
        ),
      ],
    );
  }
}

class Button extends StatelessWidget {
  var button_val;
  Button({this.button_val});
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(5.0), side: BorderSide(color:ThemeColors.white_dull) ),
      onPressed: () {},
      child: Text(button_val, style: styles.secondary_title),
    );
  }
}
