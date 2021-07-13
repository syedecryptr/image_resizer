import 'dart:io';
import 'package:filesize/filesize.dart';
import 'package:path/path.dart' as path;
import 'package:flutter_native_image/flutter_native_image.dart';

class Algorithms{
  static Future<List<dynamic>>rescale(File source_file, target_file_path, output_height, output_width) async{
    try {
      File out_file = await FlutterNativeImage.compressImage(source_file.path,
          targetWidth: output_width, targetHeight: output_height, percentage: 100, quality: 100);
      out_file.copySync(target_file_path);
      var out_file_size = out_file.lengthSync();
      out_file.delete();
      return [true, out_file_size];
    }
    catch(e){
      return [false, e.toString()];
    }
  }


  static Future<List<dynamic>>binary_selection(File source_file, target_file_path, output_size, output_extension) async{
    // this is the output file.
    late File out_file;

    var lower_limit_quality = 1;
    var maximum_limit_quality = 100;

    //there two will keep changing like rulers.
    var min_desired_quality = lower_limit_quality;
    var max_desired_quality = maximum_limit_quality;

    var desired_quality = ((max_desired_quality + min_desired_quality) ~/ 2).floor();
    // keeping the byte margin if image size is inside desired_size - bytes_range it will be accepted.
    var bytes_margin = 100*1000;
    var current_size = source_file.lengthSync();
    // if required output size is > input size will see later the expanding of the image.
    if(current_size <= output_size){
      out_file = source_file.copySync(target_file_path);
      return [true, current_size];
    }

    // assuming the largest this variable could be when current size = 0
    // smallest_curernt_size_dif_output_size = output_size - current_size
    // making it largest so while iteration we can track the smallest value it reaches.
    var smallest_current_size_closestto_output_size = output_size - 0;
    var optimal_size ;
    late var optimal_desired_quality;
    print("current file size: ${filesize(current_size)}");


    while(desired_quality > min_desired_quality &&
        desired_quality < max_desired_quality &&
        min_desired_quality<max_desired_quality

    ){
      out_file = await FlutterNativeImage.compressImage(source_file.path,
          quality: desired_quality);
      current_size = out_file.lengthSync();

      // this fix is because in the library many times quality decreasing not implies size decreasing.
      if(smallest_current_size_closestto_output_size > output_size - current_size && output_size > current_size){
        smallest_current_size_closestto_output_size =  output_size - current_size;
        optimal_size = current_size;
        optimal_desired_quality = desired_quality;
      }
      if(current_size > output_size) {
        // source_file = out_file.copySync(source_file.path);
        max_desired_quality = desired_quality;
      }
      else if(current_size < output_size){
        if(output_size - current_size <= bytes_margin){
          break;
        }
        else{
          min_desired_quality = desired_quality;
        }
      }
      desired_quality = ((max_desired_quality + min_desired_quality) ~/ 2).floor();

      print("desired_quality = $desired_quality, min_desired_quality = $min_desired_quality max_desired_quality = $max_desired_quality current_size = ${(current_size)}, output_size = ${(output_size)}");
    }
    print("current size $current_size output size $output_size optimal size $optimal_size");
    if(current_size > output_size){
      if(optimal_size < output_size){
        out_file = await FlutterNativeImage.compressImage(source_file.path,
            quality: optimal_desired_quality);
        out_file.copySync(target_file_path);
        return [true, optimal_size];
      }
      // even after this desired size is not reached force it three times on the output

      // return await binary_selection(out_file, target_file_path, output_size, output_extension);
      return [false, "smallest size we can achieve is ${filesize(current_size)}"];
    }
    out_file.copySync(target_file_path);
    // clean the cache
    Directory cache_dir = new Directory(path.dirname(out_file.path));
    cache_dir.delete(recursive: true);
    return [true, current_size];
  }

}