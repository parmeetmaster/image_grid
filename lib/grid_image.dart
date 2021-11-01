import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_support/file_support.dart';
import 'package:flutter/material.dart';
import 'package:image_grid/extension.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'logs.dart';

class GridImage extends StatefulWidget {
  final BuildContext context;
  final Function(List<File> files) onchange;

  final String? title;

  bool compressImage;

  String? placeholderImage;
  List<File>? images;

  String? bottomsheetTitle;

  bool onlyCamera;

  GridImage(
      {Key? key,
      required this.context,
      required this.onchange,
      this.onlyCamera = false,
      this.title,
      this.bottomsheetTitle = "",
      this.compressImage = false,
      this.images,
      this.placeholderImage = ""})
      : super(key: key);

  @override
  _GridImageState createState() => _GridImageState();
}

class _GridImageState extends State<GridImage> {
  List<File> images = [];

  @override
  void initState() {
    super.initState();
    if (widget.images != null) {
      images.clear();
      images.addAll(widget.images!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final imageGrabber = GestureDetector(
      onTap: () {
        pickImage(widget.context);
      },
      child: Container(
        width: 200,
        height: 200,
        //color: Colors.red,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: widget.placeholderImage!.isEmpty
                  ? CachedNetworkImage(
                      imageUrl:
                          "https://raw.githubusercontent.com/parmeetmaster/image_grid/master/assets/camera_group.png",
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      widget.placeholderImage!,
                      fit: BoxFit.cover,
                    ),
            )
          ],
        ),
      ),
    );

    return Container(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        widget.title != null
            ? Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "${widget.title}",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ))
            : const SizedBox(),
        GridView(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
          children: [
            ...images.mapIndexed(
              (file, i) => _getImageContiner(i, file),
            ),
            imageGrabber
          ],
        ),
      ],
    ));
  }

  _getImageContiner(index, File file) {
    return Container(
      width: 200,
      height: 200,
      //color: Colors.red,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: FileImage(
                        file,
                      )),
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
              )),
          Positioned(
              top: 0,
              right: 0,
              child: GestureDetector(
                  onTap: () {
                    setState(() {
                      images.removeAt(index);
                      widget.onchange(images);
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 2.0, right: 4),
                    child: CachedNetworkImage(
                      imageUrl:
                          "https://raw.githubusercontent.com/parmeetmaster/image_grid/master/assets/remove.png",
                      height: 20,
                    ),
                  )))
        ],
      ),
    );
  }

  void pickImage(
    context,
  ) async {
    PickedFile? res;
    Dialogs.bottomMaterialDialog(
        title: widget.bottomsheetTitle == null
            ? 'Choose Camera or gallery'
            : widget.bottomsheetTitle,
        context: context,
        actions: widget.onlyCamera == false
            ? [
                IconsButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    res = (await ImagePicker.platform
                        .pickImage(source: ImageSource.camera))!;
                    updateImages(res);
                  },
                  text: 'Camera',
                  iconData: Icons.camera_alt,
                  color: Colors.green,
                  textStyle: TextStyle(color: Colors.white),
                  iconColor: Colors.white,
                ),
                IconsButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    res = (await ImagePicker.platform
                        .pickImage(source: ImageSource.gallery))!;
                    updateImages(res);
                  },
                  text: 'Gallery',
                  iconData: Icons.camera,
                  color: Colors.red,
                  textStyle: TextStyle(color: Colors.white),
                  iconColor: Colors.white,
                ),
              ]
            : [
                IconsButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    res = (await ImagePicker.platform
                        .pickImage(source: ImageSource.camera))!;
                    updateImages(res);
                  },
                  text: 'Camera',
                  iconData: Icons.camera_alt,
                  color: Colors.green,
                  textStyle: TextStyle(color: Colors.white),
                  iconColor: Colors.white,
                ),
              ]);
  }

  void updateImages(PickedFile? res) {
    if (res == null) {
      "Response is null".printinfo;
    } else {
      res.path.printwtf;
      setState(() {
        images.add(File(res.path));
        if (widget.compressImage == true) {
          compressImage(images);
        } else {
          widget.onchange(images);
        }
      });
    }
  }

  void compressImage(List<File> files) async {
    try {
      List<File>? tempimages = [];
      await Future.forEach(files, (e) async {
        print(e);
        File? file = await FileSupport().compressImage(e as File);
        tempimages.add(file!);
      });
      this.images.clear();
      "${tempimages.length} are compress".toString().printwtf;
      this.images.addAll(tempimages);
      widget.onchange(images);
    } catch (e) {}
  }
}
