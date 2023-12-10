import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../controllers/MenuAppController.dart';
import '../../responsive.dart';
import '../dashboard/dashboard_screenStudent.dart';
import '../main/components/side_menuStudent.dart';

class UploadTranscript extends StatefulWidget {
  @override
  _UploadTranscriptState createState() => _UploadTranscriptState();
}

class _UploadTranscriptState extends State<UploadTranscript> {
  final ImagePicker imagePicker = ImagePicker();
  List<XFile> imageFileList = [];

  void selectImages() async {
    final List<XFile>? selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages != null && selectedImages.isNotEmpty) {
      setState(() {
        imageFileList.addAll(selectedImages);
      });
    }
  }

  Widget _buildImageFromPath(String filePath) {
    if (kIsWeb) {
      return Image.network(filePath);
    } else {
      return Image.file(
        File(filePath),
        fit: BoxFit.cover,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: context.read<MenuAppController>().scaffoldKey,
      drawer: SideMenuStudent(),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (Responsive.isDesktop(context))
              Expanded(
                child: SideMenuStudent(),
              ),
            Expanded(
              flex: 5,
              child: Column(
                children: [
                  DashboardScreenStudent(parameter: "UploadTranscirpt"),
                  SizedBox(height: 20),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GridView.builder(
                        itemCount: imageFileList.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 8.0,
                          mainAxisSpacing: 8.0,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          return _buildImageFromPath(imageFileList[index].path);
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  MaterialButton(
                    color: Colors.blue,
                    child: Text(
                      'Pick Your Transcript',
                      style: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: selectImages,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}