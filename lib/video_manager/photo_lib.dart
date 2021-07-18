import 'dart:io';
import 'dart:typed_data';

import 'package:VideoSync/controllers/roomLogic.dart';
// import 'package:VideoSync/views/YTPlayer.dart';
import 'package:VideoSync/views/videoPlayer.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:get/get.dart';

class PhotoMypher extends StatefulWidget {
  @override
  _PhotoMypherState createState() => _PhotoMypherState();
}

class _PhotoMypherState extends State<PhotoMypher> {
  RoomLogicController roomLogicController = Get.find();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Sample"),
      ),
      body: Container(
        height: size.height,
        width: size.width,
        child: Column(
          children: [
            Text("Tension"),
            RaisedButton(onPressed: () async {
              List<AssetPathEntity> list =
                  await PhotoManager.getAssetPathList(type: RequestType.video);
              list.forEach((element) {
                print(element);
              });
            }),
            FutureBuilder<List<AssetPathEntity>>(
                future: PhotoManager.getAssetPathList(type: RequestType.video),
                builder: (BuildContext context,
                    AsyncSnapshot<List<AssetPathEntity>> snap) {
                  if (snap.hasData) {
                    return Expanded(
                        child: ListView.builder(
                      itemBuilder: (ctx, index) {
                        return ListTile(
                          title: Text('${snap.data[index].name}'),
                          onTap: () {
                            // Get.to(() => SubDir(snap.data[index].assetList);
                            Get.to(SubDir(snap.data[index].assetList));
                          },
                        );
                      },
                      itemCount: snap.data.length,
                    ));
                  }
                  return Container();
                })
          ],
        ),
      ),
    );
  }
}

class SubDir extends StatefulWidget {
  final Future<List<AssetEntity>> list;

  SubDir(this.list);

  @override
  _SubDirState createState() => _SubDirState();
}

class _SubDirState extends State<SubDir> {
  @override
  Widget build(BuildContext context) {
    // final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Sub Dir"),
      ),
      body: Container(
        height: 400,
        width: 200,
        child: FutureBuilder<List<AssetEntity>>(
            future: widget.list,
            builder: (context, AsyncSnapshot<List<AssetEntity>> snapshot) {
              if (snapshot.hasData) {
                return Expanded(
                  child: ListView.builder(
                    itemBuilder: (ctx, index) {
                      return ListTile(
                        title: Text("${snapshot.data[index].title}"),
                        leading: SizedBox(
                          height: 100,
                          width: 100,
                          child: FutureBuilder<Uint8List>(
                              future: snapshot.data[index].thumbData,
                              builder: (context, thumbSnapshot) {
                                if (thumbSnapshot.hasData) {
                                  return Image.memory(thumbSnapshot.data);
                                }
                                return SizedBox(
                                  width: 50,
                                  height: 50,
                                );
                              }),
                        ),
                        onTap: () async {
                          // snapshot.data[index]
                          //     .getMediaUrl()
                          //     .then((value) => print("pyar $value"));
                          //set the url
                          // await snapshot.data[index]
                          //     .getMediaUrl()
                          //     .then((value) {
                          //   print("val $value");
                          //   roomLogicController.localUrl.value = value;
                          // });

                          //set the local media url
                          final File res =
                              await snapshot.data[index].originFile;
                          roomLogicController.localUrl.value = res.path;
                          Get.to(NiceVideoPlayer());
                        },
                      );
                    },
                    itemCount: snapshot.data.length,
                  ),
                );
              }
              return Container();
            }),
      ),
    );
  }
}
