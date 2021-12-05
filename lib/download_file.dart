import 'package:flutter/material.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:persiting_image/components/bottom_button.dart';
import 'package:persiting_image/db/images_database.dart';
import 'package:persiting_image/model/image_model.dart';
import 'package:persiting_image/screen/images_grid_view.dart';

void main() {
  runApp(DownloadFile());
}

class DownloadFile extends StatefulWidget {
  final ImageModel? image;

  const DownloadFile({
    Key? key,
    this.image,
  }) : super(key: key);

  @override
  State createState() {
    return _DownloadFileState();
  }
}

class _DownloadFileState extends State {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool downloading = false;
  bool isSearchTapped = false;
  String downloadingStr = "No data";
  String savePath = "";

  ImagesDatabase? imagesDatabase;

  //count the number of images currently in the database
  Future<int> countImagesInDB() async {
    int count = await ImagesDatabase.instance.countImages();
    return count;
  }

  // validate the textfield
  void validate() {
    if (_formKey.currentState!.validate()) {}
  }

  // Getting the value of the TextFormField using TextEditingController
  TextEditingController imageUrlController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future<String> downloadFile() async {
    try {
      Dio dio = Dio();

      String fileName = imageUrlController.text
          .substring(imageUrlController.text.lastIndexOf("/") + 1);

      savePath = await getFilePath(fileName);
      await dio.download(imageUrlController.text, savePath,
          onReceiveProgress: (rec, total) {
        setState(() {
          downloading = true;
          // download = (rec / total) * 100;z
          downloadingStr = "Downloading Image : $rec";
        });
      });
      setState(() {
        downloading = false;
        downloadingStr = "Completed";
      });
      return savePath;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> getFilePath(uniqueFileName) async {
    String path = '';

    Directory dir = await getApplicationDocumentsDirectory();

    path = '${dir.path}/$uniqueFileName';

    return path;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Download File"),
        backgroundColor: Colors.pink,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              child: Form(
                key: _formKey,
                child: TextFormField(
                  controller: imageUrlController,
                  decoration: InputDecoration(
                      hintText: "Search",
                      suffixIcon: GestureDetector(
                        child: Icon(Icons.search),
                        onTap: () async {
                          //count the number of items in the db
                          final numOfImages = await countImagesInDB();

                          await downloadFile();

                          final imageToBeSaved = ImageModel(
                              urlString: savePath, imageNumber: numOfImages);
                          print(imageToBeSaved);
                          await ImagesDatabase.instance.insert(imageToBeSaved);
                          print(
                              'The number of images after: ${await countImagesInDB()}');
                          setState(() {
                            // downloading = true;
                            isSearchTapped = true;
                          });
                        },
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 1, color: Colors.black))),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Textfield is empty, please provide an image url";
                    }
                    return null;
                  },
                ),
              ),
            ),
            downloading
                ? Container(
                    height: 250,
                    width: 250,
                    child: Card(
                      color: Colors.pink,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            backgroundColor: Colors.white,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            downloadingStr,
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                    ),
                  )
                : Container(
                    height: 250,
                    width: 250,
                    child: Center(
                        child: isSearchTapped
                            ? Image.file(
                                File(savePath),
                                height: 200,
                              )
                            : Text("Nothing was pressed")),
                  ),
            SizedBox(
              height: 30,
            ),
            TextButton(
              onPressed: () async {
                await imagesDatabase?.readAllImages();
                // log(imagesDatabase?.readAllImages(););
                print("Fifth line");
              },
              child: Text(
                "Pressed",
                style: TextStyle(
                  color: Colors.purple,
                  fontSize: 30,
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            BottomButton(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => InstagramSearchGrid()));
                },
                buttonTitle: "View Gallery"),
          ],
        ),
      ),
    );
  }
}

class Hello extends StatelessWidget {
  const Hello({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
