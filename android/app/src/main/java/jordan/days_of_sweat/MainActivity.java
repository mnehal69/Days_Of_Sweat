package jordan.days_of_sweat;

import android.content.ContentResolver;
import android.database.Cursor;
import android.net.Uri;
import android.os.Bundle;
import android.provider.MediaStore;
import io.flutter.app.FlutterActivity;


import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import io.flutter.app.FlutterFragmentActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
  ContentResolver musicResolver;

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);
    musicResolver = getContentResolver();
    new MethodChannel(getFlutterView(), "MusicList").setMethodCallHandler(
            new MethodChannel.MethodCallHandler() {
              @Override
              public void onMethodCall(MethodCall call, MethodChannel.Result result) {
                if (call.method.equals("getMusicList")) {
                  List<Song> musicList = getMusicList();
                  ArrayList<HashMap> songMap = new ArrayList<>();
                  for (Song s : musicList) {
                    songMap.add(s.toMap());
                  }
                  result.success(songMap);
                  //System.out.println("COOL THING"+);
                } else {
                  result.notImplemented();
                }
              }
            });
  }
  List<Song> getMusicList() {
    List<Song> music=new ArrayList<>();
    Uri uri = android.provider.MediaStore.Audio.Media.EXTERNAL_CONTENT_URI;
    Cursor cur = musicResolver.query(uri, null,
            MediaStore.Audio.Media.IS_MUSIC + " = 1", null, null);

    if (cur != null) {
      if (cur.moveToFirst()) {

        int artistColumn = cur.getColumnIndex(MediaStore.Audio.Media.ARTIST);
        int titleColumn = cur.getColumnIndex(MediaStore.Audio.Media.TITLE);
        int albumColumn = cur.getColumnIndex(MediaStore.Audio.Media.ALBUM);
        int albumArtColumn = cur.getColumnIndex(MediaStore.Audio.Media.ALBUM_ID);
        int durationColumn = cur.getColumnIndex(MediaStore.Audio.Media.DURATION);
        int idColumn = cur.getColumnIndex(MediaStore.Audio.Media._ID);

        do {
          music.add(new Song(
                  cur.getLong(idColumn),
                  cur.getString(artistColumn),
                  cur.getString(titleColumn),
                  cur.getString(albumColumn),
                  cur.getLong(durationColumn),
                  cur.getLong(albumArtColumn)));
        } while (cur.moveToNext());
      }
      cur.close();
      //System.out.println("cool");
    }
    return music;
  }
public class Song {
  long id;
  String artist;
  String title;
  String album;
  long albumId;
  long duration;
  String uri;
  String albumArt;



  public Song(long id, String artist, String title, String album, long duration, long albumId) {
    this.id = id;
    this.artist = artist;
    this.title = title;
    this.album = album;
    this.duration = duration;
    this.albumId = albumId;
    this.uri = getURI();
    this.albumArt = getAlbumArt();

  }

  public long getId() {
    return id;
  }

  public String getArtist() {
    return artist;
  }

  public String getTitle() {
    return title;
  }

  public String getAlbum() {
    return album;
  }

  public long getDuration() {
    return duration;
  }

  public long getAlbumId() {
    return albumId;
  }

  public String getURI() {

    Uri mediaContentUri = MediaStore.Audio.Media.EXTERNAL_CONTENT_URI;
    String[] projection = new String[] { MediaStore.Audio.Media._ID, MediaStore.Audio.Media.ARTIST, MediaStore.Audio.Media.TITLE, MediaStore.Audio.Media.ALBUM,
            MediaStore.Audio.Media.DURATION, MediaStore.Audio.Media.DATA, MediaStore.Audio.Media.ALBUM_ID};
    String selection = MediaStore.Audio.Media._ID + "=?";
    String[] selectionArgs = new String[] {"" + id}; //This is the id you are looking for

    Cursor mediaCursor = getContentResolver().query(mediaContentUri, projection, selection, selectionArgs, null);

    if(mediaCursor.getCount() >= 0) {
      mediaCursor.moveToPosition(0);
//                String title = mediaCursor.getString(mediaCursor.getColumnIndex(MediaStore.Audio.Media.TITLE));
//                String album = mediaCursor.getString(mediaCursor.getColumnIndex(MediaStore.Audio.Media.ALBUM));
//                String artist = mediaCursor.getString(mediaCursor.getColumnIndex(MediaStore.Audio.Media.ARTIST));
//                long duration = mediaCursor.getLong(mediaCursor.getColumnIndex(MediaStore.Audio.Media.DURATION));
      uri = mediaCursor.getString(mediaCursor.getColumnIndex(MediaStore.Audio.Media.DATA));
      //Do something with the data
    }
    mediaCursor.close();
    return uri;

  }

  public String getAlbumArt() {
    String path = "";
//            try {
//                Uri genericArtUri = Uri.parse("content://media/external/audio/albumart");
//                Uri actualArtUri = ContentUris.withAppendedId(genericArtUri, albumId);
//                return actualArtUri.toString();
//            } catch(Exception e) {
//                return null;
//            }
    Cursor cursor = getContentResolver().query(MediaStore.Audio.Albums.EXTERNAL_CONTENT_URI,
            new String[] {MediaStore.Audio.Albums._ID, MediaStore.Audio.Albums.ALBUM_ART},
            MediaStore.Audio.Albums._ID+ "=?",
            new String[] {String.valueOf(albumId)},
            null);

    if (cursor.moveToFirst()) {
      path = cursor.getString(cursor.getColumnIndex(MediaStore.Audio.Albums.ALBUM_ART));
      // do whatever you need to do

    }
    cursor.close();
    return path;
  }
  HashMap<String,Object> toMap(){
    HashMap<String,Object> songsMap = new HashMap<>();
    songsMap.put("id", id);
    songsMap.put("artist",artist);
    songsMap.put("title",title);
    songsMap.put("album",album);
    songsMap.put("albumId",albumId);
    songsMap.put("duration", duration);
    songsMap.put("uri",uri);
    songsMap.put("albumArt",albumArt);


    return songsMap;
  }
}
}
