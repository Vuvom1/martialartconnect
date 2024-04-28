import 'dart:io';

import 'package:flutter/material.dart';
import 'package:martialartconnect/pages/addposttext_page.dart';
import 'package:photo_manager/photo_manager.dart';

class AddPostPage extends StatefulWidget {
  const AddPostPage({super.key});

  @override
  State<StatefulWidget> createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  final List<Widget> _mediaList = [];
  final List<File> path = [];

  File? _file;
  int currentPage = 0;
  int? lastPage;

  @override
  _fetchNewMedia() async {
    lastPage = currentPage;
    final PermissionState ps = await PhotoManager.requestPermissionExtend();
    if (ps.isAuth) {
      List<AssetPathEntity> album =
          await PhotoManager.getAssetPathList(onlyAll: true);
      List<AssetEntity> media =
          await album[0].getAssetListPaged(page: currentPage, size: 60);

      for (var asset in media) {
        if (asset.type == AssetType.image) {
          final file = await asset.file;
          if (file != null) {
            path.add(File(file.path));
            _file = path[0];
          }
        }
      }

      List<Widget> temp = [];

      for (var asset in media) {
        if (asset.type == AssetType.image) {
          temp.add(FutureBuilder(
            future: asset.thumbnailDataWithSize(ThumbnailSize(200, 200)),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Container(
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Image.memory(
                          snapshot.data!,
                          fit: BoxFit.cover,
                        ),
                      )
                    ],
                  ),
                );
              }
              return Container();
            }));
        }
        
      }

      if (mounted) {
        setState(() {
        _mediaList.addAll(temp);
        currentPage++;
      });
      }
      
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchNewMedia();
  }

  int imageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'New Posts',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: false,
        actions: [
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AddPostTextPage(_file!)
                  ));
                },
                child:
                  Text(
                    'Next',
                    style: TextStyle(fontSize: 15, color: Colors.blue),
                  ),
              ),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 375,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    mainAxisSpacing: 1,
                    crossAxisSpacing: 1,
                  ),
                  itemBuilder: (context, index) {
                    if (_mediaList.isNotEmpty) {
                      return _mediaList[imageIndex];
                    } else {
                      // Show a loading indicator or empty message while data loads
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
              Container(
                width: double.infinity,
                height: 40,
                color: Colors.white,
                child: const Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Recent',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                ),
              ),
              
              
              GridView.builder(
                shrinkWrap: true,
                itemCount: _mediaList.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 1,
                  crossAxisSpacing: 2,
                ),
                itemBuilder: (context, index) {
                  return GestureDetector(
                      onTap: () {
                        setState(() {
                          imageIndex = index;
                          _file = path[index];
                        });
                      },
                      child: _mediaList[index]);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}