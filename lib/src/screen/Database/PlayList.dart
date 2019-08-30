import 'dart:convert';

PlayListModel clientFromJson(String str) {
  final jsonData = json.decode(str);
  return PlayListModel.fromMap(jsonData);
}

String clientToJson(PlayListModel data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class PlayListModel {
  final int id;
  final String type;
  final int songID;

  PlayListModel({this.id, this.type, this.songID});

  Map<String, dynamic> toMap() => {
        'id': id,
        'type': type,
        'songID': songID,
      };

  toString() {
    return "{ID:$id  TYPE:$type  SONGID:$songID}";
  }

  factory PlayListModel.fromMap(Map<String, dynamic> json) => new PlayListModel(
        id: json["id"],
        type: json["type"],
        songID: json["songID"],
      );
}
