import 'package:flutter/material.dart';
import 'style/appColors.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  lanchurl(url) async {
    await launch(url);
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
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          brightness: Brightness.dark,
          centerTitle: true,
          title: GradientText(
            "About",
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
            onPressed: () => Navigator.pop(context, false),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SingleChildScrollView(child: AboutCards()),
      ),
    );
  }
}

class AboutCards extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Color(0xff263238),
      child: Column(
        children: <Widget>[
          Padding(
            padding:
                const EdgeInsets.only(top: 20, left: 8, right: 8, bottom: 6),
            child: Column(
              children: <Widget>[
                ListTile(
                  title: Image.network(
                    "https://telegra.ph/file/4798f3a9303b8300e4b5b.png",
                    height: 150,
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.all(13.0),
                    child: Center(
                      child: Text(
                        "Music Player | 2.1.0",
                        style: TextStyle(
                            color: accentLight,
                            fontSize: 24,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0, left: 10, right: 10),
            child: Divider(
              color: Color.fromARGB(58, 39, 129, 62),
              thickness: 0.8,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Card(
              color: Color(0xff263238),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              elevation: 2.3,
              child: ListTile(
                leading: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: NetworkImage("https://telegram.im/img/harshv23"),
                    ),
                  ),
                ),
                title: Text(
                  'Yuvaraja K',
                  style: TextStyle(color: accentLight),
                ),
                subtitle: Text(
                  'App Developer',
                  style: TextStyle(color: accentLight),
                ),
                trailing: Wrap(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        MdiIcons.linkedin,
                        color: accentLight,
                      ),
                      tooltip: 'Contact on Linkedin',
                      onPressed: () {
                        //launchUrl("http://linkedin.com/in/yuvaraja-kandasamy");
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
