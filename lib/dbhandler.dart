import 'dart:typed_data';

List<ProductModel> productsFromJson(dynamic str) =>
    List<ProductModel>.from((str).map((x) => ProductModel.formJson(x)));

class ProductModel {
  int? song_id;
  String? song_name;
  String? song_album;
  String? song_artist;
  String? song_url;
  var url;

  ProductModel(this.song_id, this.song_name, this.song_album, this.song_artist,
      this.song_url, this.url);

  ProductModel.formJson(Map<String, dynamic> json) {
    song_id = json['song_id'];
    song_name = json['song_name'];
    song_album = json['song_album'];
    song_artist = json['song_artist'];
    song_url = json['song_url'];
    url = json['url'];

    //print(song_id);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};

    data['song_id'] = song_id;
    data['song_name'] = song_name;
    data['song_album'] = song_album;
    data['song_artist'] = song_artist;
    data['song_url'] = song_url;
    data['url'] = url;

    return data;
  }
}
