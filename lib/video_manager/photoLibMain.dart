import 'package:VideoSync/video_manager/photo_lib.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:typed_data';

import 'package:VideoSync/controllers/roomLogic.dart';
import 'package:VideoSync/views/video%20players/videoPlayer.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:get/get.dart';

class PhotoLibMain extends StatefulWidget {
  //const PhotoLibMain({ Key? key }) : super(key: key);

  @override
  _PhotoLibMainState createState() => _PhotoLibMainState();
}

class _PhotoLibMainState extends State<PhotoLibMain> {
  RoomLogicController roomLogicController = Get.find();

  @override
  Widget build(BuildContext context) {
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
        child: Column(
          children: <Widget>[
            Container(
              child: GestureDetector(
                child: ListTile(
                  leading: Container(
                    height: 37,
                    width: 37,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.redAccent,
                    ),
                    child: Center(
                      child: ClipOval(
                        child: Icon(
                          Icons.storage,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  title: Text(
                    'Internal Storage',
                    style: TextStyle(color: Colors.blueAccent),
                  ),
                  subtitle: Text(
                    'Browse your mobile for videos',
                    style: TextStyle(color: Colors.grey, fontSize: 10),
                  ),
                ),
                onTap: () {
                  Get.to(PhotoMypher());
                },
              ),
            ),
            Container(
              height: 16,
              width: MediaQuery.of(context).size.width,
              color: Color.fromRGBO(11, 9, 9, 1),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(top: 15, left: 15, bottom: 10),
              child: Text(
                'Recent files',
                style: TextStyle(color: Colors.purple),
              ),
            ),
            FutureBuilder<List<AssetPathEntity>>(
                future: PhotoManager.getAssetPathList(type: RequestType.video),
                builder: (BuildContext context,
                    AsyncSnapshot<List<AssetPathEntity>> snap) {
                  if (snap.hasData) {
                    return Expanded(
                        child: ListView.builder(
                      itemBuilder: (ctx, index) {
                        return SubDir(snap.data[index].assetList);
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
    return
        // Scaffold(
        //   appBar: AppBar(
        //     backgroundColor: Color.fromRGBO(51, 49, 49, 1),
        //     title: Text(
        //       "Sub Dir",
        //       style: TextStyle(fontWeight: FontWeight.w100, fontSize: 20),
        //     ),
        //   ),
        //body:
        Container(
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
                              height: MediaQuery.of(context).size.height * 0.11,
                              width: MediaQuery.of(context).size.width * 0.323,
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
    );
  }
}
