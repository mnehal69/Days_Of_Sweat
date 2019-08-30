class Song {
  int id;
  String artist;
  String title;
  String album;
  int albumId;
  int duration;
  String uri;
  String albumArt;
  bool favourite = false;
  Song(this.id, this.artist, this.title, this.album, this.albumId,
      this.duration, this.uri, this.albumArt);
  Song.fromMap(Map m) {
    id = m["id"];
    artist = m["artist"];
    title = m["title"];
    album = m["album"];
    albumId = m["albumId"];
    duration = m["duration"];
    uri = m["uri"];
    albumArt = m["albumArt"];
  }
  void setFavourite(bool isFavourite) {
    this.favourite = isFavourite;
  }

  String toString() {
    return "{id:$id, artist:$artist, title:$title, album:$album, albumId:$albumId, duration:$duration, uri:$uri, albumArt:$albumArt,favourite:favourite:$favourite}";
  }
}
