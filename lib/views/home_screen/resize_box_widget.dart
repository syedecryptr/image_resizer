import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:provider/provider.dart';
import 'package:image_resizer/providers/image_process/image_processor.dart';
import 'package:image_resizer/views/theme/colors.dart';
import 'package:image_resizer/views/theme/size_config.dart';
import 'package:image_resizer/views/theme/text_format.dart';

class ResizeBoxWidget extends StatefulWidget {
  @override
  _ResizeBoxWidgetState createState() => _ResizeBoxWidgetState();
}

class _ResizeBoxWidgetState extends State<ResizeBoxWidget> {
  late ImageProcessingProvider im_provider;

  var width_controller = TextEditingController();
  var height_controller = TextEditingController();
  var output_size_controller = TextEditingController();
  var output_size_type_controller = TextEditingController();

  var height = SizeConfig.blockSizeVertical! * 40;
  var width = SizeConfig.blockSizeHorizontal * 90;
  var padding = SizeConfig.blockSizeHorizontal * 5;
  var shape_box_width = SizeConfig.blockSizeHorizontal * 30;
  var shape_box_height = SizeConfig.blockSizeVertical! * 4;
  var size_number_width = SizeConfig.blockSizeHorizontal * 30;
  var size_number_height = SizeConfig.blockSizeVertical! * 4;
  var size_type_width = SizeConfig.blockSizeHorizontal * 15;
  var size_type_heigth = SizeConfig.blockSizeVertical! * 4;
  String? output_size_type;
  @override
  void initState() {
    im_provider = context.read<ImageProcessingProvider>();
    output_size_type = "kb";

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    output_size_type = context.watch<ImageProcessingProvider>().output_image_type;
    width_controller.text = context.watch<ImageProcessingProvider>().output_image_width;
    height_controller.text = context.watch<ImageProcessingProvider>().output_image_height;
    output_size_controller.text = context.watch<ImageProcessingProvider>().output_image_size;
    // output_size_type_controller.text = context.watch<ImageProcessingProvider>().output_image_type;
    width_controller.selection = TextSelection.fromPosition(TextPosition(offset: width_controller.text.length));
    height_controller.selection = TextSelection.fromPosition(TextPosition(offset: height_controller.text.length));
    output_size_controller.selection = TextSelection.fromPosition(TextPosition(offset: output_size_controller.text.length));
    output_size_type_controller.selection = TextSelection.fromPosition(TextPosition(offset: output_size_type_controller.text.length));
    return Container(
        // padding: EdgeInsets.all(padding),
        width: width,
        height: height,
        decoration: BoxDecoration(
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
                              width: shape_box_width,
                              controller: width_controller,
                          )
                        ],
                      ),
                      // Container(
                      //   padding: EdgeInsets.fromLTRB(0, SizeConfig.blockSizeVertical*4, 0, 0),
                      //   child: Icon(Icons.aspect_ratio_sharp),
                      // ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("", style: styles.parameters_headings),
                          SizedBox(height: SizeConfig.blockSizeVertical),
                          if(context.watch<ImageProcessingProvider>().fix_aspect_ratio)GestureDetector(
                              onTap: (){
                                im_provider.handle_aspect_ratio();
                              },
                              child: Icon(
                                Icons.aspect_ratio_sharp,
                                color: ThemeColors.green_main
                            ),
                          ),
                          if(!context.watch<ImageProcessingProvider>().fix_aspect_ratio)GestureDetector(
                              onTap: (){
                                im_provider.handle_aspect_ratio();
                              },
                              child: Icon(
                                Icons.aspect_ratio_sharp,
                                color: ThemeColors.white_dull.withOpacity(0.4),)
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Height", style: styles.parameters_headings),
                          SizedBox(height: SizeConfig.blockSizeVertical),
                          InputField(
                              default_val: "800",
                              width: shape_box_width,
                              controller: height_controller,
                          )
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Output size", style: styles.parameters_headings),
                          SizedBox(height: 5),
                          Text("(Output Image will be less than this.)", style: styles.small_information),
                        ],
                      ),
                      SizedBox(height: SizeConfig.blockSizeVertical),
                      // output size options size and kb/mb
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InputField(
                                  default_val: "1024",
                                  width: size_number_width,
                                  controller: output_size_controller,
                              )
                            ],
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              new DropdownButton<String>(
                                hint: Text("kb", style: styles.place_holder,),
                                underline: Container(
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: ThemeColors.grey_main,
                                      ),
                                    ),
                                  ),
                                ),
                                value: output_size_type,
                                elevation: 8,
                                dropdownColor: ThemeColors.grey_main,
                                items: <String>['kb', 'mb'].map((String value) {
                                  return new DropdownMenuItem<String>(
                                    value: value,
                                    child: new Text(value, style: styles.place_holder,),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    output_size_type = newValue;
                                    im_provider.output_image_type = newValue;
                                  });
                                },
                              ),
                              // InputField(
                              //     default_val: "kb",
                              //     height: size_type_heigth,
                              //     width: size_type_width,
                              //     controller: output_size_type_controller,
                              // )
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
                                onTap: (index){
                                  print(index);
                                  if (index == 0) im_provider.set_extension("png");
                                  if (index == 1) im_provider.set_extension("jpg");
                                  if (index == 2) im_provider.set_extension("pdf");
                                },
                                indicatorSize: TabBarIndicatorSize.label,
                                indicatorColor: ThemeColors.green_main,
                                // indicator:BoxDecoration(color: ThemeColors.dark_grey),
                                tabs: [
                                  Tab(
                                      child: Text(
                                    'PNG',
                                    style: styles.input_value,
                                  )),
                                  Tab(
                                      child: Text(
                                    'JPEG',
                                    style: styles.input_value,
                                  )),
                                  Tab(
                                      child: Text(
                                    'PDF',
                                    style: styles.input_value,
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
  InputField({this.default_val, this.width, this.controller});
  final default_val;
  final width;
  final TextEditingController? controller;

  late ImageProcessingProvider im_provider;

  @override
  Widget build(BuildContext context) {
    var border_radius = 7.0;
    im_provider = context.read<ImageProcessingProvider>();

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
          height: 35,
          width: width * 0.7,
          child: TextField(
            controller: controller,
            onChanged: (value){onChange(value);},
            cursorColor: ThemeColors.green_main,
            style: styles.input_value,
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
          height: 35,
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

  void onChange(value){

    switch(default_val) {
      case '1200': im_provider.set_input_fields("width", value); return;
      case '800': im_provider.set_input_fields("height", value); return;
      case '1024': im_provider.output_image_size = value; return;
      case 'kb': im_provider.output_image_type = value; return;
    }
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
