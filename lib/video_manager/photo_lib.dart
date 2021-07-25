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
        backgroundColor: Color.fromRGBO(31, 29, 29, 1),
        title: Text(
          "Select File",
          style: TextStyle(fontWeight: FontWeight.w100, fontSize: 20),
        ),
      ),
      body: Container(
        color: Color.fromRGBO(31, 29, 29, 1),
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
                        if (snap.data[index].name != 'Recent') {
                          return Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 2.5, horizontal: 5),
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(31, 29, 29, 1),
                                border: Border.all(
                                    width: 0, color: Colors.transparent),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: ListTile(
                              leading: Container(
                                height: 37,
                                width: 37,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.lightBlue,
                                ),
                                child: Center(
                                  child: ClipOval(
                                    child: Icon(
                                      Icons.folder,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              title: Text(
                                '${snap.data[index].name}',
                                style: TextStyle(
                                  color: Color.fromRGBO(100, 0, 220, 1),
                                ),
                              ),
                              onTap: () {
                                // Get.to(() => SubDir(snap.data[index].assetList);
                                Get.to(SubDir(
                                    list: snap.data[index].assetList,
                                    name: snap.data[index].name));
                                print(snap.data[index].assetList);
                              },
                              subtitle: Text(
                                '${snap.data[index].assetCount} videos',
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 13),
                              ),
                            ),
                          );
                        }
                        return Container();
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
  final String name;

  SubDir({this.list, this.name});

  @override
  _SubDirState createState() => _SubDirState();
}

class _SubDirState extends State<SubDir> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(31, 29, 29, 1),
        title: Text(
          '${widget.name}',
          style: TextStyle(fontWeight: FontWeight.w100, fontSize: 20),
        ),
      ),
      body: Container(
        color: Color.fromRGBO(31, 29, 29, 1),
        height: size.height,
        width: size.width,
        padding: EdgeInsets.only(top: 7),
        child: FutureBuilder<List<AssetEntity>>(
            future: widget.list,
            builder: (context, AsyncSnapshot<List<AssetEntity>> snapshot) {
              if (snapshot.hasData) {
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 3 / 2,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                  ),
                  itemBuilder: (ctx, index) {
                    return GestureDetector(
                      child: GridTile(
                        //color: Color.fromRGBO(41, 39, 39, 1).withOpacity(0.5),
                        child: Padding(
                          padding: const EdgeInsets.all(0),
                          child: Row(
                            children: [
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.11,
                                width:
                                    MediaQuery.of(context).size.width * 0.323,
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
                                        fit: BoxFit.cover,
                                      );
                                    }
                                    return SizedBox(
                                      width: 50,
                                      height: 50,
                                    );
                                  },
                                ),
                              ),
                              //SizedBox(width: 10),
                              // Expanded(
                              //   child: Column(
                              //     crossAxisAlignment: CrossAxisAlignment.start,
                              //     mainAxisAlignment:
                              //         MainAxisAlignment.spaceAround,
                              //     children: [
                              //       Container(
                              //         child: Text(
                              //           "${snapshot.data[index].title}",
                              //           style: TextStyle(
                              //               fontFamily: 'Consolas',
                              //               color: Colors.white60,
                              //               fontSize: 15),
                              //         ),
                              //       ),
                              //       // Text(
                              //       //   '${snapshot.data[index].videoDuration} ',
                              //       //   style: TextStyle(
                              //       //       fontFamily: 'Consolas',
                              //       //       color: Colors.white60,
                              //       //       fontSize: 12),
                              //       // )
                              //     ],
                              //   ),
                              // ),
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
                );
              }
              return Container();
            }),
        //),
      ),
    );
  }
}
