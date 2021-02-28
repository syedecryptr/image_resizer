import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_resizer/views/theme/colors.dart';
import 'package:image_resizer/views/theme/size_config.dart';
import 'package:image_resizer/views/theme/text_format.dart';

class ResizeBoxWidget extends StatelessWidget {
  var width = SizeConfig.blockSizeHorizontal * 90;
  var height = SizeConfig.blockSizeVertical * 35;
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
            border: Border.all(color: ThemeColors.white_main),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal:padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text("RESIZE", style: styles.style_1),
              //resize options width and height
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Width", style: styles.style_1),
                      InputField(default_val: "1200",height: shape_box_height, width: shape_box_width)
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Height", style: styles.style_1),
                      InputField(default_val: "800", height: shape_box_height, width: shape_box_width)
                    ],
                  )
                ],
              ),
              // output size column
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text("Output size", style: styles.style_1),
                  // output size options size and kb/mb
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InputField(default_val: "1200", height: size_number_height, width: size_number_width)
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InputField(default_val: "kb", height: size_type_heigth, width: size_type_width)
                        ],
                      )
                    ],
                  ),
                ],
              ),
              // output type column
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Output type", style: styles.style_1),
                  // output size options size and kb/mb
                  DefaultTabController(
                      length: 2, // length of tabs
                      initialIndex: 0,
                      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: <Widget>[
                      Container(
                        child: TabBar(
                          indicatorSize: TabBarIndicatorSize.label,
                          indicatorColor: ThemeColors.green_main,
                          // indicator:BoxDecoration(color: ThemeColors.dark_grey),
                          tabs: [
                            Tab(child: Text('PNG', style: styles.style_1,)),
                            Tab(child: Text('JPEG', style: styles.style_1,)),

                          ],
                        ),
                        height: shape_box_height,
                    )

                  ],
            ),
                  ),
                ],
              ),
              MaterialButton(
                // TODO change it to dull white
                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(5.0), side: BorderSide(color:ThemeColors.white_main) ),
                onPressed: () {},
                child: Text('Convert', style: styles.style_1),
              ),
          ]
          ),
        )
      );
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
              borderRadius: BorderRadius.only(topLeft: Radius.circular(border_radius), bottomLeft: Radius.circular(border_radius)),
          ),
          height: height,
          width: width,
          child: TextField(
            cursorColor: ThemeColors.green_main,
            style: styles.style_1,
            keyboardType: TextInputType.number,

            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(5, 0, 0, 7),
              border: InputBorder.none,
              hintText: default_val,
              hintStyle: styles.style_1,

            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: ThemeColors.dark_grey,
            border: Border.all(color: Colors.transparent),
            borderRadius: BorderRadius.only(topRight: Radius.circular(border_radius), bottomRight: Radius.circular(border_radius)),
          ),
          height: height,
          child: Stack(
            children: [
              Align(alignment:Alignment.topCenter, child: Icon(Icons.arrow_drop_up_sharp, size: 18,)),
              Align(alignment:Alignment.bottomCenter, child: Icon(Icons.arrow_drop_down_sharp, size: 18,)),
            ],
          ),
        )
      ],
    );
  }
}
