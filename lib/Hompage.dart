import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
//import 'package:musicplayer/download.dart';
import 'dbhandler.dart';
import 'api_services.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'style/appColors.dart';
import 'AboutPage.dart';
import 'Player.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:textfield_search/textfield_search.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List<ProductModel>? products;
  ProductModel? model;
  var fetch;
  ConnectionState connectivity = ConnectionState.none;
  TextEditingController myController = TextEditingController();
  final _testList = [
    'Test Item 1',
    'Test Item 2',
    'Test Item 3',
    'Test Item 4',
  ];

  @override
  void initState() {
    myController.addListener(fetchresultsongs);
    super.initState();
    // print(connectionchecker());
    connectionchecker();
    download();
    //getdata();
    //getsongs();
    fetch = APIService.getsongs();
    //print(connectivity);
  }

  fetchresultsongs() {
    setState(() {
      if (myController.text.isNotEmpty) {
        fetch = APIService.getresult(myController.text);
      } else {
        fetch = APIService.getsongs();
      }
    });

    // print("text field: ${myController.text}");
  }

  @override
  void dispose() {
    super.dispose();
  }

  //getsongs
  Future<dynamic>? getsongs() async {
    await download();
    //if (fileExists) fetch = await readsongdata();

    await connectionchecker();

    // if (connectivity == ConnectionState.active) {
    // fetch = APIService.getsongs();
    // // } else {
    //   //
    // }
    return result;
  }

  List result = <dynamic>[];
  getdata() async {
    print("getdetails");
    await Future.delayed(Duration(milliseconds: 1000));

    List<ProductModel>? model;

    model = await APIService.getdetails();
    setState(() {
      for (int i = 0; i < model!.length; i++) {
        result.add(model[i].song_name.toString());
        result.add(model[i].song_artist.toString());
        result.add(model[i].song_album.toString());
      }
      result.removeWhere((item) => item.isEmpty);

      //  print(result);

      result = result.toSet().toList();
    });

    //print(result);
    return result;
  }

  File? jsonFile;
  Directory? dir;
  String fileName = "songdata.json";
  bool fileExists = true;
  Map<String, dynamic>? fileContent;
  List<ProductModel>? songs = [];
  download() async {
    //print(productModel.song_name);
    getApplicationDocumentsDirectory().then((Directory directory) {
      dir = directory;
      jsonFile = File(dir!.path + "/" + fileName);
      //print(jsonFile);
      fileExists = jsonFile!.existsSync();
      //print('come');
      if (fileExists) {
        setState(() {
          fileExists = jsonFile!.existsSync();

          jsonFile = File(dir!.path + "/" + fileName);
          //readsongdata();

          dir = directory;
          //fileContent = json.decode(jsonFile!.readAsStringSync());
          // print("file1");
          // print(fileContent);
          //print(productModel.song_album);
          //await writesongdata(productModel);
        });
      } else {
        fileExists = jsonFile!.existsSync();

        jsonFile = new File(dir!.path + "/" + fileName);
        setState(() {
          jsonFile = File(dir!.path + "/" + fileName);

          dir = directory;
          // fileContent = json.decode(jsonFile!.readAsStringSync());

          // print("file2");

          // print(fileContent);
          //await writesongdata(productModel);
        });
      }
    });
  }

  Future<dynamic>? readsongdata() async {
    //await download();
    //print(jsonFile);

    jsonFile =
        File('/data/user/0/com.example.musicplayer/app_flutter/songdata.json');
    if (jsonFile!.existsSync()) {
      String contents = await jsonFile!.readAsString();
      var jsonresponse = jsonDecode(contents);
      // print(jsonresponse);
      //print(productsFromJson(jsonresponse));

      return productsFromJson(jsonresponse);
    } else {
      return null;
    }
    //if (jsonresponse != null)
    // for (var p in jsonresponse) {
    //   ProductModel oldsongs = ProductModel(p['song_id'], p['song_name'],
    //       p['song_album'], p['song_artist'], p['song_url'], p['url']);
    //   songs!.add(oldsongs);
    //   songs!.toSet().toList();
    //   print(json.encode(songs));
    // }
  }

  //download

  //connectionchecker

  connectionchecker() async {
    bool result = await InternetConnectionChecker().hasConnection;
    if (result == true) {
      if (mounted)
        setState(() {
          connectivity = ConnectionState.active;
          // print(connectivity);
        });
      // return true;
    } else {
      if (mounted)
        setState(() {
          connectivity = ConnectionState.none;
        });
      //return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xff384850),
            Color(0xff263238),
            Color(0xff263238),
          ],
        ),
      ),
      child: Scaffold(
          //resizeToAvoidBottomPadding: false,
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            padding: EdgeInsets.all(12.0),
            child: Column(
              children: <Widget>[
                Padding(padding: EdgeInsets.only(top: 30, bottom: 20.0)),
                Center(
                  child: Row(children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 42.0),
                        child: Center(
                          child: GradientText(
                            "Music Player.",
                            shaderRect: Rect.fromLTWH(13.0, 0.0, 100.0, 50.0),
                            gradient: LinearGradient(colors: [
                              Color(0xff4db6ac),
                              Color(0xff61e88a),
                            ]),
                            style: TextStyle(
                              fontSize: 35,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      child: IconButton(
                        iconSize: 26,
                        alignment: Alignment.center,
                        icon: Icon(MdiIcons.dotsVertical),
                        color: accent,
                        onPressed: () => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AboutPage(),
                            ),
                          ),
                        },
                      ),
                    )
                  ]),
                ),
                Padding(padding: EdgeInsets.only(top: 20)),
                // TextField(
                //   onSubmitted: (String value) {
                //     //search();
                //   },
                //   // controller: searchBar,
                //   style: TextStyle(
                //     fontSize: 16,
                //     color: accent,
                //   ),
                //   cursorColor: Colors.green[50],
                //   decoration: InputDecoration(
                //     fillColor: Color(0xff263238),
                //     filled: true,
                //     enabledBorder: const OutlineInputBorder(
                //       borderRadius: BorderRadius.all(
                //         Radius.circular(100),
                //       ),
                //       borderSide: BorderSide(
                //         color: Color(0xff263238),
                //       ),
                //     ),
                //     focusedBorder: OutlineInputBorder(
                //       borderRadius: BorderRadius.all(
                //         Radius.circular(100),
                //       ),
                //       borderSide: BorderSide(color: accent),
                //     ),
                //     suffixIcon: IconButton(
                //       icon: true
                //           ? SizedBox(
                //               height: 18,
                //               width: 18,
                //               child: Center(
                //                   // child: CircularProgressIndicator(
                //                   //   valueColor:
                //                   //       AlwaysStoppedAnimation<Color>(accent),
                //                   // ),
                //                   ),
                //             )
                //           : Icon(
                //               Icons.search,
                //               color: accent,
                //             ),
                //       color: accent,
                //       onPressed: () {
                //         // search();
                //       },
                //     ),
                //     border: InputBorder.none,
                //     hintText: "Search...",
                //     hintStyle: TextStyle(
                //       color: accent,
                //     ),
                //     contentPadding: const EdgeInsets.only(
                //       left: 18,
                //       right: 20,
                //       top: 14,
                //       bottom: 14,
                //     ),
                //   ),
                // ),
                TextFieldSearch(
                  //initialList: _testList,
                  label: 'search',
                  controller: myController,
                  future: () {
                    // print(getdata());
                    return getdata();
                  },
                  textStyle: TextStyle(
                    fontSize: 16,
                    color: accent,
                  ),
                  decoration: InputDecoration(
                    fillColor: Color(0xff263238),
                    filled: true,
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(100),
                      ),
                      borderSide: BorderSide(
                        color: Color(0xff263238),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(100),
                      ),
                      borderSide: BorderSide(color: accent),
                    ),
                    suffixIcon: myController.text.isEmpty
                        ? null
                        : IconButton(
                            color: accent,
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              if (myController.text.isEmpty) {
                                //close(context, null);
                              } else {
                                myController.text = '';
                              }
                            },
                          ),
                    border: InputBorder.none,
                    hintText: "Search...",
                    hintStyle: TextStyle(
                      color: accent,
                    ),
                    contentPadding: const EdgeInsets.only(
                      left: 18,
                      right: 20,
                      top: 14,
                      bottom: 14,
                    ),
                  ),

                  // getSelectedValue: (value) {
                  //   setState(() {
                  //     fetch = APIService.getresult(value);
                  //   });
                  // },
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  (connectivity == ConnectionState.active
                      ? "Online Songs.."
                      : "Your offline Songs.."),
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 16,
                    color: accent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                FutureBuilder(
                  future: connectivity == ConnectionState.active
                      ? fetch
                      : readsongdata(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      List<ProductModel> data = snapshot.data;
                      //print(data[0].song_artist);
                      return Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            ListView.builder(
                              shrinkWrap: true,
                              physics: ScrollPhysics(),
                              scrollDirection: Axis.vertical,

                              //padding: const EdgeInsets.all(10.0),
                              itemCount: data.length,
                              itemBuilder: (BuildContext context, int index) {
                                //const Text("Text");

                                return InkWell(
                                  onTap: () {
                                    // Musicplayer.stop();
                                    Navigator.of(context).pushNamed(
                                      '/player',
                                      arguments: {
                                        'data': data[index],
                                      },
                                    );
                                  },
                                  child: Row(
                                    children: [
                                      Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.11,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.25,
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          color: Colors.transparent,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              image: DecorationImage(
                                                fit: BoxFit.fill,
                                                image: AssetImage(
                                                    'assets/music.jpg'),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: 2,
                                          ),
                                          Text(
                                            data[index]
                                                .song_name
                                                .toString()
                                                .split("(")[0]
                                                .replaceAll("&amp;", "&")
                                                .replaceAll("&#039;", "'")
                                                .replaceAll("&quot;", "\""),
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              fontSize: 22,
                                              color: accent,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 2,
                                          ),
                                          Text(
                                            data[index].song_album.toString(),
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: accent,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            SizedBox(
                              height: 2,
                            ),
                          ],
                        ),
                      );
                    } else {
                      return Text("data");
                    }
                  },
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
              child: const Icon(Icons.music_note),
              backgroundColor: accent,
              onPressed: () {
                // Navigator.pushNamed(context, '/player');
              })),
    );
  }
}
