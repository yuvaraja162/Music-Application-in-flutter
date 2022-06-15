// import 'package:flutter/material.dart';

// import 'dart:html';

// import 'dart:html';
import 'dart:core';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:http/http.dart';
import 'package:musicplayer/Hompage.dart';
// import 'counterStorage.dart';
import 'dart:io';
import 'dart:typed_data';
//import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dbhandler.dart';
import 'style/appColors.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:path_provider/path_provider.dart';

class muplayer extends StatelessWidget {
  const muplayer({Key? key}) : super(key: key);

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
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          brightness: Brightness.dark,
          centerTitle: true,
          title: GradientText(
            "Player.",
            shaderRect: Rect.fromLTWH(13.0, 0.0, 100.0, 50.0),
            gradient: LinearGradient(colors: [
              Color(0xff4db6ac),
              Color(0xff61e88a),
            ]),
            style: TextStyle(
              color: accent,
              fontSize: 25,
              fontWeight: FontWeight.w700,
            ),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: accent,
            ),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/');
              //Navigator.pop(context, false);
            },
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SingleChildScrollView(child: Musicplayer()),
      ),
    );
  }
}

class Musicplayer extends StatefulWidget {
  const Musicplayer({Key? key}) : super(key: key);
  // final CounterStorage storage;

  @override
  State<Musicplayer> createState() => _MusicplayerState();
}

class _MusicplayerState extends State<Musicplayer> {
  AudioPlayer player = AudioPlayer();
  AudioPlayer player1 = AudioPlayer();

  AudioCache audioCache = AudioCache();
  // PlayerState audioPlayerState = PlayerState.PAUSED;

  PlayerState playerState = PlayerState.PAUSED;
  ProductModel? productModel;
  //CounterStorage storage = CounterStorage();
  String? url;
  late Duration position;
  // String url =
  //     "https://p.scdn.co/mp3-preview/a0735d900d3a23f7eae1006b65c758f5a3ec7e18?cid=a9ebb87ed6c542f784ce68964565d5e1";
  int timeProgress = 0;
  int audioDuration = 0;
  String? song_name, song_album, song_artist;
  Uint8List? bytes;

  //for downloading file installation
  File? jsonFile;
  Directory? dir;
  String fileName = "songdata.json";
  bool fileExists = true;
  Map<String, dynamic>? fileContent;
  List<ProductModel>? songs = [];
  @override
  void initState() {
    super.initState();

    //ConnectionUtil connectionStatus = ConnectionUtil.getInstance();
    // musicplayer();
    // musicplayerone();
    connectionchecker();
    download();
    //stop();
    setState(() {
      songs = [];
    });
    Future.delayed(Duration.zero, () {
      stop();
      if (ModalRoute.of(context)?.settings.arguments != null) {
        final Map arguments = ModalRoute.of(context)?.settings.arguments as Map;
        productModel = arguments['data'];
        //print(productModel!.product_name);
        setState(() {
          player.stop();
          stop();

          //var b = productModel!.url.toString();

          if (connectivity == ConnectionState.none)
            bytes = _getsongBinary(productModel!.url);

          ///print(bytes);
          //print(productModel!.url);
          url = (productModel?.song_url).toString();
          song_name = (productModel?.song_name).toString();
          song_album = (productModel?.song_album).toString();
          song_artist = (productModel?.song_artist).toString();

          PlayerState playerState = PlayerState.PLAYING;
        });
        //print(productModel!.song_album);
        play();
      } else {
        setState(() {
          stop();
          play();
        });

        // setState(() {});
      }
    });
  }

  Uint8List _getsongBinary(dynamicList) {
    List<int> intList =
        dynamicList.cast<int>().toList(); //This is the magical line.
    Uint8List data = Uint8List.fromList(intList);
    return data;
  }

  download() async {
    //print(productModel.song_name);
    getApplicationDocumentsDirectory().then((Directory directory) {
      dir = directory;
      jsonFile = File(dir!.path + "/" + fileName);
      fileExists = jsonFile!.existsSync();
      //print('come');
      if (fileExists) {
        setState(() {
          jsonFile = File(dir!.path + "/" + fileName);
          //readsongdata();

          dir = directory;
          //fileContent = json.decode(jsonFile!.readAsStringSync());
          // //print("file1");
          // print(fileContent);
          //print(productModel.song_album);
          //await writesongdata(productModel);
        });
      } else {
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

  void createFile(List<ProductModel> content, Directory dir, String fileName) {
    //print("Creating file!");
    File file = new File(dir.path + "/" + fileName);
    file.createSync();
    fileExists = true;
    file.writeAsStringSync(json.encode(content));
    // print(json.encode(content));
  }

  readsongdata() async {
    String contents = await jsonFile!.readAsString();
    var jsonresponse = jsonDecode(contents);
    if (jsonresponse != null)
      for (var p in jsonresponse) {
        ProductModel oldsongs = ProductModel(p['song_id'], p['song_name'],
            p['song_album'], p['song_artist'], p['song_url'], p['url']);
        songs!.add(oldsongs);

        //print(json.encode(songs));
      }
  }

  b(String? u) async {
    Response response = await Client().get(Uri.parse(u!));
    // var s = response.body;
    // print(s);
    Uint8List bytes = response.bodyBytes;
    return bytes;
  }

  writesongdata(ProductModel productModel) async {
    ///
    ///
    ///

    ///
    ///
    ///
    await download();

    Uint8List url = await b(productModel.song_url);
    //print(url);

    //print(fileExists);
    if (fileExists) {
      await readsongdata();
      ProductModel newsong = new ProductModel(
          productModel.song_id,
          productModel.song_name,
          productModel.song_album,
          productModel.song_artist,
          "",
          url);
      // //print(newsong.song_name);
      songs!.add(newsong);
      // print(songs![3].song_name);
      //print(songs);
      //print(songs!.length);
      songs!.toSet().toList();
      //print(songs!.length);
      songs!.map((ProductModel) => ProductModel.toJson()).toList();

      //print(json.encode(songs!));
      // fileContent = json.decode(jsonFile!.readAsStringSync());
      // print("write1");
      // print(productsFromJson(data).length);
      // fileContent = productsFromJson(data) as Map<String, dynamic>;
      // fileContent!.addAll(songs as Map<String, dynamic>);
      // print(fileContent);
      // //print(json.encode(songs));
      //print("last");
      //print(songs!.length);

      jsonFile!.writeAsString(json.encode(songs));
      Text(json.encode(songs));

      ///
      ///
      ///
    } else {
      ProductModel newsong = new ProductModel(
          productModel.song_id,
          productModel.song_name,
          productModel.song_album,
          productModel.song_artist,
          "",
          url);
      songs!.add(newsong);
      //print(songs!.length);
      songs!.map((ProductModel) => ProductModel.toJson()).toList();
      // dir = Directory directory;
      createFile(songs!, dir!, fileName);
    }

    //print(productModel.song_album);
    // songs.add(productModel.song_id.toString());
    // songs.add(productModel.song_name.toString());
    // songs.add(productModel.song_album.toString());
    // songs.add(productModel.song_artist.toString());
    // songs.add(productModel.song_url.toString());
    //print(songs!.length);
  }

  @override
  void dispose() {
    stop();
    super.dispose();
  }

  //this is slider
  Widget slider() {
    return Container(
      //color: accent,
      width: 300.0,
      child: Slider.adaptive(
        thumbColor: accent,
        activeColor: accent,
        inactiveColor: accentLight,
        value: timeProgress.toDouble(),
        max: audioDuration.toDouble(),
        onChanged: (value) {
          seekTOSec(value.toInt());
        },
      ),
    );
  }

  seekTOSec(int sec) async {
    Duration newpos = Duration(seconds: sec);
    await connectionchecker();
    if (connectivity == ConnectionState.active) {
      player.seek(newpos);
    } else {
      player1.seek(newpos);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.only(top: 50.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.28,
                width: MediaQuery.of(context).size.width * 0.6,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  color: Colors.transparent,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage('assets/music.jpg'),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                song_name
                    .toString()
                    .split("(")[0]
                    .replaceAll("&amp;", "&")
                    .replaceAll("&#039;", "'")
                    .replaceAll("&quot;", "\""),
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 26,
                  color: accent,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                song_album
                        .toString()
                        .split("(")[0]
                        .replaceAll("&amp;", "&")
                        .replaceAll("&#039;", "'")
                        .replaceAll("&quot;", "\"") +
                    " || " +
                    song_artist
                        .toString()
                        .split("(")[0]
                        .replaceAll("&amp;", "&")
                        .replaceAll("&#039;", "'")
                        .replaceAll("&quot;", "\""),
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 15,
                  color: accent,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              // IconButton(
              //     onPressed: () {
              //       playerState == PlayerState.PLAYING ? pause() : play();
              //     },
              //     icon: Icon(playerState == PlayerState.PLAYING
              //         ? Icons.pause_rounded
              //         : Icons.play_arrow_rounded)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    getTimeString(timeProgress),
                    style: TextStyle(
                      fontSize: 16,
                      color: accent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 20),
                  Container(width: 200, child: slider()),
                  SizedBox(width: 20),
                  Text(
                    getTimeString(audioDuration),
                    style: TextStyle(
                      fontSize: 16,
                      color: accent,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                // crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FloatingActionButton(
                      backgroundColor: accent,
                      child: Icon(playerState == PlayerState.PLAYING
                          ? Icons.pause_rounded
                          : Icons.play_arrow_rounded),
                      heroTag: "play",
                      onPressed: () {
                        playerState == PlayerState.PLAYING ? pause() : Resume();
                      }),
                  FloatingActionButton(
                      child: Icon(connectivity == ConnectionState.active
                          ? Icons.download
                          : Icons.file_download_off),
                      heroTag: "download",
                      onPressed: () async {
                        await connectionchecker();
                        connectivity == ConnectionState.active
                            ? writesongdata(productModel!)
                            : toast();
                      }),
                ],
              ),

              // IconButton(
              //     onPressed: () async {
              //       //print(connectivity == ConnectionState.active);
              //       // widget.storage.writeCounter()
              //       await connectionchecker();
              //       connectivity == ConnectionState.active
              //           ? download()
              //           : toast();
              //     },
              //     icon: Icon(connectivity == ConnectionState.active
              //         ? Icons.download
              //         : Icons.file_download_off))
            ]),
      ),
    );
  }

  toast() {
    return Fluttertoast.showToast(
        msg: 'Download is not Available While offline.',
        toastLength: Toast.LENGTH_SHORT);
  }

  ConnectionState connectivity = ConnectionState.active;
  connectionchecker() async {
    bool result = await InternetConnectionChecker().hasConnection;
    if (result == true) {
      if (mounted)
        setState(() {
          connectivity = ConnectionState.active;
        });
    } else {
      if (mounted)
        setState(() {
          connectivity = ConnectionState.none;
        });
    }
  }

  String getTimeString(int seconds) {
    String minuteString =
        '${(seconds / 60).floor() < 10 ? 0 : ''}${(seconds / 60).floor()}';
    String secondString = '${seconds % 60 < 10 ? 0 : ''}${seconds % 60}';
    return '$minuteString:$secondString'; // Returns a string with the format mm:ss
  }

  musicplayerone() {
    player1.onPlayerStateChanged.listen((PlayerState state) {
      if (mounted)
        setState(() {
          playerState = state;
        });
    });

    // player.setUrl(url);
    player1.onDurationChanged.listen((Duration d) {
      if (mounted)
        setState(() {
          audioDuration = d.inSeconds;
        });
    });

    player1.onAudioPositionChanged.listen((Duration d) {
      if (mounted)
        setState(() {
          timeProgress = d.inSeconds;
        });
    });
  }

  musicplayer() {
    player.onPlayerStateChanged.listen((PlayerState state) {
      if (mounted)
        setState(() {
          // player.stop();
          playerState = state;
        });
    });

    player.setUrl(url!);
    player.onDurationChanged.listen((Duration d) {
      if (mounted)
        setState(() {
          audioDuration = d.inSeconds;
        });
    });

    player.onAudioPositionChanged.listen((Duration d) {
      if (mounted)
        setState(() {
          timeProgress = d.inSeconds;
        });
    });
  }

  play() async {
    await stop();
    await connectionchecker();
    //print(result);

    //  if () {
    if (connectivity == ConnectionState.active) {
      print('one');
      musicplayer();
      await player.stop();
      await player.play(url!);
    } else {
      print('two');
      //print(await storage.readCounter());
      musicplayerone();
      player1.stop();
      await player1.playBytes(bytes!);
    }
    //  }
  }

  pause() async {
    if (connectivity == ConnectionState.active) {
      await player.pause();
    } else {
      await player1.pause();
    }
  }

  Resume() async {
    if (connectivity == ConnectionState.active) {
      await player.resume();
    } else {
      await player1.resume();
    }
  }

  stop() async {
    await player.stop();
    if (mounted)
      setState(() {
        //print("stop");
        playerState = PlayerState.STOPPED;
        position = Duration();
      });

    // play();
  }

  playLocal() async {
    print("come");
    // Uint8List s = Uint8List.fromList(byteData);
    // print(s); // Load audio as a byte array here.
  }

  // downloa() async {
  //   if (connectivity == ConnectionState.active) {
  //     await download();
  //   } else {
  //     await toast();
  //   }
  // }

  // Future<Uint8List> download() async {
  //   Fluttertoast.showToast(
  //       msg: 'Downloading...', toastLength: Toast.LENGTH_SHORT);
  //   return await storage.writeCounter(url);
  // }
}
