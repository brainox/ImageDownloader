import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:persiting_image/db/images_database.dart';
import 'package:persiting_image/model/image_model.dart';

class InstagramSearchGrid extends StatefulWidget {
  const InstagramSearchGrid({Key? key}) : super(key: key);

  @override
  State<InstagramSearchGrid> createState() => _InstagramSearchGridState();
}

class _InstagramSearchGridState extends State<InstagramSearchGrid> {
  List<ImageModel>? images;

  @override
  void initState() {
    super.initState();
    refereshImages();
  }

  @override
  void dispose() {
    ImagesDatabase.instance.close();
    super.dispose();
  }

  Future<void> refereshImages() async {
    var imagesInDb = await ImagesDatabase.instance.readAllImages();
    setState(() {
      images = imagesInDb;
    });
    print(images);
    await ImagesDatabase.instance.countImages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: StaggeredGridView.countBuilder(
          crossAxisCount: 3,
          itemCount: images?.length ?? 0,
          itemBuilder: (context, index) => ImageCard(
            imageData: images?[index],
          ),
          staggeredTileBuilder: (index) => StaggeredTile.count(
              (index % 7 == 0) ? 2 : 1, (index % 7 == 0) ? 2 : 1),
          mainAxisSpacing: 8.0,
          crossAxisSpacing: 8.0,
        ),
      ),
    );
  }
}

class ImageCard extends StatelessWidget {
  const ImageCard({this.imageData});

  final ImageModel? imageData;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.0),
      child: Image.file(
        File(imageData!.urlString),
        fit: BoxFit.cover,
      ),
    );
  }
}
