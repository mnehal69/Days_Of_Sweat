import './../actions/main_actions.dart';
import './../store/main_store.dart';

PlayerState playerStateReducer(PlayerState prevState, dynamic action) {
  if (action is Player) {
    return action.intialized(
        prevState, action.isAlbum, action.index, action.duration, action.list);
  }
  if (action is VolumeControl) {
    return action.volumeControl(prevState, action.volumeBarShow, action.volume);
  }
  if (action is SongList) {
    return action.intialized(prevState, action.songlist, action.index);
  }
  if (action is Dispose) {
    return action.isDispose(prevState, action.dispose, action.counter);
  }
  if (action is AudioPlaying) {
    return action.audioPlaying(
        prevState, action.playing, action.currentduration);
  }
  if (action is Permission) {
    return action.isaccesed(prevState, action.storage);
  }

  if (action is ArtistAlbum) {
    return action.intialized(
        prevState, action.artistSongList, action.artistList, action.albumindex);
  }
  if (action is ScrollBar) {
    return action.show(prevState, action.shown, action.isAlbum);
  }
  if (action is PlayerController) {
    return action.isLast(prevState, action.controller);
  }
  if (action is ChangeSong) {
    return action.pressed(prevState, action.btn);
  }
  if (action is ScreenAction) {
    return action.screen(prevState, action.selected, action.subScreen);
  }
  if (action is PlayListSection) {
    return action.clicked(prevState, action.typeindex, action.type,
        action.playList, action.playModelList);
  }
  if (action is Like) {
    return action.isFavourite(prevState, action.like);
  }
  if (action is RefreshPlayList) {
    return action.resfresh(prevState, action.list);
  }
  return prevState;
}
