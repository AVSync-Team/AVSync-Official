import 'dart:io';
import 'dart:typed_data';

import 'package:VideoSync/controllers/roomLogic.dart';
// import 'package:VideoSync/views/YTPlayer.dart';
import 'package:VideoSync/views/video%20players/videoPlayer.dart';
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
        backgroundColor: Color.fromRGBO(51, 49, 49, 1),
        title: Text(
          "Mobile Storage",
          style: TextStyle(fontWeight: FontWeight.w100, fontSize: 20),
        ),
      ),
      body: Container(
        color: Color.fromRGBO(41, 39, 39, 1),
        height: size.height,
        width: size.width,
        child: Column(
          children: [
            SizedBox(
              height: 2.5,
            ),
            // Text("Tension"),
            // RaisedButton(onPressed: () async {
            //   List<AssetPathEntity> list =
            //       await PhotoManager.getAssetPathList(type: RequestType.video);
            //   list.forEach((element) {
            //     print(element);
            //   });
            // }),
            FutureBuilder<List<AssetPathEntity>>(
                future: PhotoManager.getAssetPathList(type: RequestType.video),
                builder: (BuildContext context,
                    AsyncSnapshot<List<AssetPathEntity>> snap) {
                  if (snap.hasData) {
                    return Expanded(
                        child: ListView.builder(
                      itemBuilder: (ctx, index) {
                        return Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 2.5, horizontal: 5),
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(121, 119, 119, 0.3),
                              border: Border.all(
                                  width: 0, color: Colors.transparent),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: ListTile(
                            title: Text(
                              '${snap.data[index].name}',
                              style: TextStyle(color: Colors.white),
                            ),
                            onTap: () {
                              // Get.to(() => SubDir(snap.data[index].assetList);
                              Get.to(SubDir(snap.data[index].assetList));
                            },
                            trailing: Text(
                              '${snap.data[index].assetCount} videos',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
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
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(51, 49, 49, 1),
        title: Text(
          "Sub Dir",
          style: TextStyle(fontWeight: FontWeight.w100, fontSize: 20),
        ),
      ),
      body: Container(
        color: Color.fromRGBO(41, 39, 39, 1),
        height: size.height,
        width: size.width,
        padding: EdgeInsets.only(top: 7),
        child: FutureBuilder<List<AssetEntity>>(
            future: widget.list,
            builder: (context, AsyncSnapshot<List<AssetEntity>> snapshot) {
              if (snapshot.hasData) {
                return ListView.separated(
                  itemBuilder: (ctx, index) {
                    return GestureDetector(
                      child: Card(
                        color: Color.fromRGBO(41, 39, 39, 1).withOpacity(0.5),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Container(
                                height: 100,
                                width: 100,
                                child: FutureBuilder<Uint8List>(
                                  future: snapshot.data[index].thumbData,
                                  builder: (context, thumbSnapshot) {
                                    if (thumbSnapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Center(
                                        child: Text(''),
                                      );
                                    }
                                    if (thumbSnapshot.hasData) {
                                      return Image.memory(
                                        thumbSnapshot.data,
                                        fit: BoxFit.fill,
                                      );
                                    }
                                    return SizedBox(
                                      width: 50,
                                      height: 50,
                                    );
                                  },
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Container(
                                      child: Text(
                                        "${snapshot.data[index].title}",
                                        style: TextStyle(
                                            fontFamily: 'Consolas',
                                            color: Colors.white60,
                                            fontSize: 15),
                                      ),
                                    ),
                                    // Text(
                                    //   '${snapshot.data[index].videoDuration} ',
                                    //   style: TextStyle(
                                    //       fontFamily: 'Consolas',
                                    //       color: Colors.white60,
                                    //       fontSize: 12),
                                    // )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      onTap: () async {
                        //set the local media url
                        final File res = await snapshot.data[index].originFile;
                        roomLogicController.localUrl.value = res.path;
                        Get.to(NiceVideoPlayer());
                      },
                    );
                  },
                  itemCount: snapshot.data.length,
                  separatorBuilder: (ctx, index) {
                    return SizedBox(height: 10);
                  },
                );
              }
              return Container();
            }),
      ),
    );
  }
}
