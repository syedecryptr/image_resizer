import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_archive/flutter_archive.dart';
import 'package:random_string/random_string.dart';
import 'package:string_validator/string_validator.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:pdf/widgets.dart' as pw;
import 'image_algos.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class ImageProcessingProvider extends ChangeNotifier{


  List<Asset> images = List<Asset>();
  String output_image_width = "";
  String output_image_height = "";
  String output_image_size = "";
  String output_image_type = "";
  String extension = "png";
  bool fix_aspect_ratio = true;
  double aspect_ratio = 1200/800;
  pw.Document final_pdf;
  // list containing overlay for individual image;
  List<String> overlay;
  // results : corresponding list of images containing status of processing.
  // these are the valid status
  // not_processed (initialised);
  // processing
  // failed
  // success;
  List<String> images_status;
  // list containing the path of output images;
  List<String> target_paths;
  String error = 'No Error Detected';
  bool all_files_processed = false;
  Directory source_dir;
  Directory target_dir;

  Future<Directory> get_temp_dir() async{
    return await getTemporaryDirectory();
  }

  Future<List<dynamic>> save_to_pdf(File image_file, String target_path)async{
    try {
      final pdf_image = pw.Document();
      final image = pw.MemoryImage(
        image_file.readAsBytesSync(),
      );
      final image2 = pw.MemoryImage(
        image_file.readAsBytesSync(),
      );
      final_pdf.addPage(pw.Page(build: (pw.Context context) {
        return pw.Center(
          child: pw.Image(image2),
        ); // Center
      })); // Page
      pdf_image.addPage(pw.Page(build: (pw.Context context) {
        return pw.Center(
          child: pw.Image(image),
        ); // Center
      })); // Page

      final file = File(target_path);
      await file.writeAsBytes(await pdf_image.save());
      return [true, file.lengthSync()];
    }
    catch(e){
      return [false, e.toString()];
    }
  }

  void set_input_fields(field, value){
    if(field == "width"){
      if(fix_aspect_ratio) {
          output_image_width = value;
          output_image_height =(int.parse(output_image_width) / aspect_ratio).ceil().toString();
        }
      else{
        output_image_width = value;
      }
    }

    if(field == "height"){
      if(fix_aspect_ratio) {
        output_image_height = value;
        output_image_width = (int.parse(output_image_height)*aspect_ratio).ceil().toString();
      }
      else{
        output_image_height = value;
      }
    }
    if(field == "image_size"){
      output_image_size = value;
    }
    if(field == "image_size_type"){
      output_image_type = value;
    }
    notifyListeners();

  }

  Future<void>clean_directory(Directory directory) async{
    directory.list(recursive: false, followLinks: false)
        .listen((FileSystemEntity entity) {
          try {
            entity.deleteSync(recursive: true);
          }
          catch(e){
            print(e);
          }
    });
  }

  handle_aspect_ratio(){
    fix_aspect_ratio = !fix_aspect_ratio;
    notifyListeners();
  }

  set_extension(value){
    extension = value;
  }

  Future<void> share_image(index) async{
    if(images_status[index] == "success") {
      try {
        await FlutterShare.shareFile(
          title: target_paths[index]
              .split("/")
              .last,
          filePath: target_paths[index],
        );
      }
      catch(e){
        print(e);
      }
    }
  }

  Future<void> share_zip() async{
    if(all_files_processed){
      try {
        Directory temp_directory = await get_temp_dir();

        if(extension == "pdf"){
          var pdf_combined = File(path.join(temp_directory.path, "output.pdf"));
          await pdf_combined.writeAsBytes(await final_pdf.save());

          await FlutterShare.shareFile(
            title: "output.pdf",
            filePath: pdf_combined.path,
          );
        }
        else {
          var zip_file = File(path.join(temp_directory.path, "output.zip"));
          await ZipFile.createFromDirectory(
              sourceDir: target_dir, zipFile: zip_file, recurseSubDirs: true);
          await FlutterShare.shareFile(
            title: "output.zip",
            filePath: zip_file.path,
          );
        }
      } catch (e) {
        print(e);
      }
    }
  }
  // reset everything
  Future<void> reset()async{
    images.clear();
    images_status.clear();
    target_paths.clear();
    overlay.clear();
    extension = "png";
    all_files_processed = false;
    error = 'No Error Detected';
    output_image_width = "";
    output_image_height = "";
    output_image_size = "";
    output_image_type = "";
    await clean_directory(await get_temp_dir());
    notifyListeners();

  }

  // size should be in bytes.
  Future<List<dynamic>>process_image(source_file, target_path, height, width, size, extension) async{
    // if(index < images.length) 
      print("desired size = $size");
      var returned_size_after_rescaling = await Algorithms.rescale(source_file, target_path, height, width);
      print("returned after rescaling = $returned_size_after_rescaling");
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
    List<dynamic> processing_result;
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
    if(extension == "pdf"){
      final_pdf = pw.Document();
    }
    for (var index = 0; index < images.length; index++){
      images_status[index] = "processing";
      overlay[index] = "processing";
      notifyListeners();
      final ByteData data = await images[index].getByteData();

      File source_file = new File(
          path.join(source_dir.path, images[index].name));
      await source_file.writeAsBytes(
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));

      var file_name = images[index].name.split(".")[0] + "_" + randomNumeric(4).toString();
      String target_path = path.join(target_dir.path, "$file_name.$extension");
      target_paths[index] = target_path;

      // if extension is pdf
      if(extension == "pdf") {
        processing_result = await save_to_pdf(
            source_file, target_path);
      }
      else {
        processing_result = await process_image(
            source_file, target_path, height, width, size, extension);
        print(processing_result);
      }
      if(processing_result[0]){
        overlay[index] = "download";
        images_status[index] = "success";
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
      return [false, "Select the image(s) first."];
    }
    if(!isInt(output_image_width) || int.parse(output_image_width) > 8000 || int.parse(output_image_height) < 0){
      return [false, "Width should be a number in between 0 and 8000"];
    }
    if(!isInt(output_image_height) || int.parse(output_image_height) > 4000 || int.parse(output_image_height) < 0){
      return [false, "Height should be a number in between 0 and 4000"];
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
      images_status =List<String>.generate(images.length, (int index) => "not_processed");
      overlay = List<String>.generate(images.length, (int index) => "not_processed");
      target_paths = List<String>.generate(images.length, (int index) => "");
      all_files_processed = false;
      output_image_width = images[0].originalWidth.toString();
      output_image_height = images[0].originalHeight.toString();
      output_image_type = "kb";
      output_image_size = "1024";
      aspect_ratio = images[0].originalWidth / images[0].originalHeight;
      print("aspect ratio $aspect_ratio");
      print(images);
    } on Exception catch (e) {
      error = e.toString();
      print(error);
    }
    notifyListeners();

  }

}