import 'dart:io';
import 'dart:typed_data';
import 'package:random_string/random_string.dart';
import 'package:string_validator/string_validator.dart';

import 'image_algos.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class ImageProcessingProvider extends ChangeNotifier{


  List<Asset> images = List<Asset>();
  String output_image_width = "1200";
  String output_image_height = "800";
  String output_image_size = "1024";
  String output_image_type = "kb";
  String extension = "png";
  // list containing overlay for individual image;
  List<String> overlay;
  // results : corresponding list of images containing status of processing.
  // these are the valid status
  // not_processed (initialised);
  // processing
  // failed
  // success;
  List<String> images_status;
  String error = 'No Error Detected';
  bool all_files_processed = false;
  Directory source_dir;
  Directory target_dir;

  Future<Directory> get_temp_dir() async{
    return await getTemporaryDirectory();
  }

  Future<void>clean_directory(directory) async{
    directory.list(recursive: true, followLinks: false)
        .listen((FileSystemEntity entity) {
      new File(entity.path).deleteSync();
    });
  }
  
  // size should be in bytes.
  Future<List<dynamic>>process_image(source_file, target_path, height, width, size, extension) async{
    // if(index < images.length) 

      var returned_size_after_rescaling = await Algorithms.rescale(source_file, target_path, height, width);
      if(returned_size_after_rescaling[0]) {
        if (returned_size_after_rescaling[1] < size){
          return [true, returned_size_after_rescaling[1]];
        }
        else{
          File source_file_rescaled = File(target_path);
          var returned_size_after_binary = await Algorithms.binary_selection(source_file_rescaled, target_path, size, extension);
          if(returned_size_after_binary[0]){
            return [true, returned_size_after_binary[1]];
          }
          else{
            return [false, returned_size_after_binary[1]];
          }
        }
      }
      else{
        return [false, returned_size_after_rescaling[1]];
      }
    }


  Future<void>loop_files_processing(height, width, size, extension) async{
    Directory temp_dir = await get_temp_dir();
    source_dir = new Directory(path.join(temp_dir.path, "input"));
    target_dir = new Directory(path.join(temp_dir.path, "output"));
    // Recreate them if exists.
    if(source_dir.existsSync()){
      source_dir.deleteSync(recursive: true);
    }
    if(target_dir.existsSync()){
      target_dir.deleteSync(recursive: true);
    }

    // create the directories
    source_dir.createSync(recursive: true);
    target_dir.createSync(recursive: true);


    for (var index = 0; index < images.length; index++){
      images_status[index] = "processing";
      overlay[index] = "processing";
      notifyListeners();
      final ByteData data = await images[index].getByteData();
      File source_file = new File(path.join(source_dir.path, images[index].name));
      await source_file.writeAsBytes(data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
      //have to recheck the logic here.
      var file_name = images[index].name.split(".")[0] + "_" + randomNumeric(4).toString();
      String target_path = path.join(target_dir.path, "$file_name.$extension");
      var processing_result = await process_image(source_file, target_path, height, width, size, extension);
      print(processing_result);
      if(processing_result[0]){
        overlay[index] = "download";
        images_status[index] = "success'";
      }
      else{
        overlay[index] = "error";
        images_status[index] = "failed";
      }
      notifyListeners();
    }
  }

  Future<List<dynamic>>validate_and_process()async{
    // if elements are empty dont throw error use default values.
    // if(output_image_height.isEmpty || output_image_width.isEmpty || output_image_type.isEmpty || output_image_size.isEmpty){
    //   return [false, "Please fill the form"];
    // }
    // check validation for fields.
    if(images.isEmpty){
      return [false, "Upload the image(s) first."];
    }
    if(!isInt(output_image_width) || int.parse(output_image_width) > 3840 || int.parse(output_image_height) < 0){
      return [false, "Height should be a number in between 0 and 3840"];
    }
    if(!isInt(output_image_height) || int.parse(output_image_height) > 2160 || int.parse(output_image_height) < 0){
      return [false, "Height should be a number in between 0 and 2160"];
    }
    if(output_image_type != "kb" && output_image_type !="mb"){
      return [false, "Image type should be kb or mb."];
    }
    int output_size;
    if(output_image_type == "kb"){
      output_size = int.parse(output_image_size) * 1000;
    }
    else if(output_image_type == "mb"){
      output_size = int.parse(output_image_size) * 1000 * 1000;
    }
    await loop_files_processing(int.parse(output_image_height), int.parse(output_image_width), output_size, extension );
    all_files_processed = true;
    notifyListeners();
    return [true, "Processing completed"];
  }

  Future<void> loadAssets() async {

    try {
      images = await MultiImagePicker.pickImages(
        maxImages: 50,
        enableCamera: true,
        selectedAssets: images,
        materialOptions: MaterialOptions(
          actionBarColor: "#3b4954",
          actionBarTitle: "Image Resizer",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
      //initialise everything.
      images_status = List.filled(images.length, "not_processed");
      overlay = List.filled(images.length, "not_processed");
      all_files_processed = false;
      print(images);
    } on Exception catch (e) {
      error = e.toString();
      print(error);
    }
    notifyListeners();

  }

}