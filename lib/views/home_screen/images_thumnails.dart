import 'package:flutter/material.dart';
import 'package:image_resizer/providers/image_process/image_processor.dart';
import 'package:image_resizer/views/theme/colors.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:provider/provider.dart';



class ImageDisplay extends StatefulWidget {
  @override
  _ImageDisplayState createState() => _ImageDisplayState();
}

class _ImageDisplayState extends State<ImageDisplay> {
  List<Asset> images;
  Widget buildGridView(images) {
    return GridView.count(
      crossAxisCount: 5,
      children: List.generate(images.length, (index) {
        Asset asset = images[index];
        return Padding(
          padding: const EdgeInsets.all(1.0),
          child: thumbnail(thumbnail_val: asset),
        );
      }),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    images = context.watch<ImageProcessingProvider>().images;
    if(images.length > 0) {
      return Expanded(child: buildGridView(images));
    }
    else{
      return Container();
    }
  }
}


class thumbnail extends StatelessWidget {
  thumbnail({this.thumbnail_val});
  Asset thumbnail_val;
  @override
  Widget build(BuildContext context) {
    return AssetThumb(
      asset: thumbnail_val,
      width: 50,
      height: 50,
      quality: 10,
      spinner: const Center(
        child: SizedBox(
          width: 50,
          height: 50,
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(ThemeColors.green_main),
          ),
        ),
      ),
    );
  }
}
