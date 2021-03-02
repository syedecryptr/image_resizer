// import 'dart:io';
// import 'dart:typed_data';
// import 'package:filesize/filesize.dart';
// import 'package:flutter/material.dart';
// // import 'package:flutter_image_compress/flutter_image_compress.dart';
// import 'package:downloads_path_provider/downloads_path_provider.dart';
// import 'package:path/path.dart' as path;
// import 'package:flutter_native_image/flutter_native_image.dart';
//
// var map_data = {};
//
// Future<void> compress(String filename, quality, extension) async {
//   final img = AssetImage(filename);
//   final config = new ImageConfiguration();
//   // CompressFormat extension_name = extension=="png"? CompressFormat.png : CompressFormat.jpeg;
//   AssetBundleImageKey key = await img.obtainKey(config);
//   final ByteData data = await key.bundle.load(key.name);
//
//   Directory downloadsDirectory = await DownloadsPathProvider.downloadsDirectory;
//   Directory source_dir = new Directory(path.join(downloadsDirectory.path, "input", filename.split("/").last.split(".")[1]));
//   Directory target_dir = new Directory(path.join(downloadsDirectory.path, "output", filename.split("/").last.split(".")[1]));
//
//   // create the directories
//   source_dir.createSync(recursive: true);
//   target_dir.createSync(recursive: true);
//
//   File source_file = new File(path.join(source_dir.path, filename.split("/").last));
//   await source_file.writeAsBytes(data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
//   String target_path = path.join(target_dir.path, "${quality.toString()+"_"+filename.split("/").last.split(".")[0]}.$extension");
//
//   // File out_file = await FlutterImageCompress.compressAndGetFile(
//   //     source_file.path,
//   //     target_path,
//   //     quality: quality,
//   //     autoCorrectionAngle: false,
//   //     format: extension_name
//   // );
//   File out_file = await FlutterNativeImage.compressImage(source_file.path,
//       quality: quality, percentage: quality);
//   final beforeCompress = source_file.lengthSync();
//   final after_compress = out_file.lengthSync();
//   out_file.delete();
//   print("${filename.split("/").last} $quality "
//       "${filesize(beforeCompress)} ${filesize(after_compress)} "
//       "${((beforeCompress.toInt()-after_compress.toInt())/beforeCompress.toInt()*100).toString()}%");
// }
//
// compression_loop()async{
//   var quality = 0;
//   var input_folder = "jpgs";
//   var output_extension = "png";
//   var jpg_files = ["1mb.jpg", "2mb.jpg", "10mb.jpg", "15mb.jpg", "20mb.jpg", "30mb.jpg"];
//   // var png_files = ["1mb.png", "3mb.png", "5mb.png", "10mb.png", "20mb.png", "30mb.png"];
//   var png_files = ["30mb.png"];
//
//   var file_iterator = input_folder == "pngs" ? png_files : jpg_files;
//   for(var file in file_iterator) {
//     var file_name = "assets/$input_folder/$file";
//     quality = 5;
//     while (quality < 101) {
//       await compress(file_name, quality, output_extension);
//       quality += 5;
//     }
//   }
// }
//
// // output size in bytes.
// get_desired_output_size(filename, output_dimensions, output_size, extension)async{
//   final img = AssetImage(filename);
//   final config = new ImageConfiguration();
//   AssetBundleImageKey key = await img.obtainKey(config);
//   final ByteData data = await key.bundle.load(key.name);
//
//   Directory downloadsDirectory = await DownloadsPathProvider.downloadsDirectory;
//   Directory source_dir = new Directory(path.join(downloadsDirectory.path, "input", filename.split("/").last.split(".")[1]));
//   Directory target_dir = new Directory(path.join(downloadsDirectory.path, "output", filename.split("/").last.split(".")[1]));
//   Directory cropped_target_dir = new Directory(path.join(downloadsDirectory.path, "cropped_output", filename.split("/").last.split(".")[1]));
//
//   // create the directories
//   source_dir.createSync(recursive: true);
//   target_dir.createSync(recursive: true);
//   cropped_target_dir.createSync(recursive: true);
//
//   File source_file = new File(path.join(source_dir.path, filename.split("/").last));
//   await source_file.writeAsBytes(data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
//   // var decodedImage = await decodeImageFromList(source_file.readAsBytesSync());
//   // var image_shape = {"height":decodedImage.height, "width": decodedImage.width};
//
//   String target_path = path.join(target_dir.path, "${filename.split("/").last.split(".")[0]}.$extension");
//   String cropped_target_path = path.join(cropped_target_dir.path, "${filename.split("/").last.split(".")[0]}.$extension");
//   print(await crop_scale(source_file, cropped_target_path, output_dimensions["height"], output_dimensions["width"]));
//   print(await binary_selection(source_file, target_path, output_size, extension));
// }
//
//
// Future<List<dynamic>>crop_scale(File source_file, target_file_path, output_height, output_width) async{
//   File out_file = await FlutterNativeImage.compressImage(source_file.path,
//       targetWidth: output_width, targetHeight: output_height);
//   out_file.copySync(target_file_path);
//   var out_file_size = source_file.lengthSync();
//   out_file.delete();
//   return [true, out_file_size ];
// }
//
// // returns the output list as [true, image path] else [false, max size possible.]
// // Note that outfile dimensions will be capped at 1920*1080
// // this logic is written keeping in mind to decrease the size of image.
// Future<List<dynamic>>binary_selection(File source_file, target_file_path, output_size, output_extension) async{
//   // this is the output file.
//   File out_file;
//
//   // CompressFormat extension_name = output_extension=="png"? CompressFormat.png : CompressFormat.jpeg;
//   // var input_extension = source_file.path.split("/").last.split(".")[0];
//   // // if input image is png first convert it in jpg then if required apply binary logic.
//   // if(input_extension == "png"){
//   //   source_file = await FlutterImageCompress.compressAndGetFile(
//   //     source_file.path,
//   //     target_file_path,
//   //     format: CompressFormat.jpeg,
//   //     quality: 100,
//   //     autoCorrectionAngle: false,
//   //   );
//   // }
//   // quality will vary from 10 to 95
//   var lower_limit_quality = 1;
//   var maximum_limit_quality = 100;
//
//   //there two will keep changing like rulers.
//   var min_desired_quality = lower_limit_quality;
//   var max_desired_quality = maximum_limit_quality;
//
//   var desired_quality = ((max_desired_quality + min_desired_quality) ~/ 2).floor();
//   var bytes_margin = 100*1000;
//   var current_size = source_file.lengthSync();
//   // if required output size is > input size will see later the expaning of the image.
//   if(current_size <= output_size){
//     out_file = source_file.copySync(target_file_path);
//     return [true, current_size];
//   }
//
//   // assuming the largest this variable could be when current size = 0
//   // smallest_curernt_size_dif_output_size = output_size - current_size
//   // making it largest so while iteration we can track the smallest value it reaches.
//   var smallest_curernt_size_closeto_output_size = output_size - 0;
//   var optimal_size ;
//   var optimal_desired_quality;
//   print("current file size: ${filesize(current_size)}");
//
//
//   while(desired_quality > min_desired_quality &&
//       desired_quality < max_desired_quality &&
//       min_desired_quality<max_desired_quality
//
//   ){
//     // out_file = await FlutterImageCompress.compressAndGetFile(
//     //   source_file.path,
//     //   target_file_path,
//     //   format: extension_name,
//     //   quality: desired_quality,
//     //   autoCorrectionAngle: false,
//     // );
//     out_file = await FlutterNativeImage.compressImage(source_file.path,
//         quality: desired_quality);
//     current_size = out_file.lengthSync();
//
//     // to empty a directory
//     // Directory out_file_directory = new Directory(path.dirname(out_file.path));
//     // out_file_directory.deleteSync(recursive: true);
//     // debugging where the library is storing the files.
//     // print(out_file.path);
//     // Directory out_file_directory = new Directory(path.dirname(out_file.path));
//     // List<FileSystemEntity> files_in_directory = out_file_directory.listSync();
//     // print(files_in_directory.length);
//
//
//     // this fix is because in the library many times quality decreasing not implies size decreasing.
//     if(smallest_curernt_size_closeto_output_size > output_size - current_size){
//       smallest_curernt_size_closeto_output_size =  output_size - current_size;
//       optimal_size = current_size;
//       optimal_desired_quality = desired_quality;
//     }
//     if(current_size > output_size) {
//       // source_file = out_file.copySync(source_file.path);
//       max_desired_quality = desired_quality;
//     }
//     else if(current_size < output_size){
//       if(output_size - current_size <= bytes_margin){
//         break;
//       }
//       else{
//         min_desired_quality = desired_quality;
//       }
//     }
//     desired_quality = ((max_desired_quality + min_desired_quality) ~/ 2).floor();
//
//     print("desired_quality = $desired_quality, min_desired_quality = $min_desired_quality max_desired_quality = $max_desired_quality current_size = ${(current_size)}, output_size = ${(output_size)}");
//   }
//
//   if(current_size > output_size){
//     if(optimal_size < output_size){
//       out_file = await FlutterNativeImage.compressImage(source_file.path,
//           quality: optimal_desired_quality);
//       out_file.copySync(target_file_path);
//       return [true, optimal_size];
//     }
//     return [false, "smallest size we can achieve is ${filesize(current_size)}"];
//   }
//   out_file.copySync(target_file_path);
//   // clean the cache
//   Directory cache_dir = new Directory(path.dirname(out_file.path));
//   cache_dir.delete(recursive: true);
//   return [true, current_size];
// }
//
//
// class debug extends StatefulWidget {
//
//   @override
//   _debugState createState() => _debugState();
// }
//
// class _debugState extends State<debug> {
//
//
//   @override
//   void initState() {
//     // compression_loop();
//     get_desired_output_size("assets/jpgs/1mb.jpg",{"height": 4000, "width": 4000}, 5*1000*1000, "jpg");
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // compression_loop();
//     return Container();
//   }
// }
