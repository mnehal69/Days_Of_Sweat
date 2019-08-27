import './../actions/main_actions.dart';
import './../store/main_store.dart';

PlayerState playerStateReducer(PlayerState prevState, dynamic action) {
  if (action is Player) {
    return action.intialized(
        prevState, action.isAlbum, action.index, action.duration);
  }
  if (action is VolumeControl) {
    return action.volumeControl(prevState, action.volumeBarShow, action.volume);
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
    return action.show(prevState, action.shown);
  }
  if (action is PlayerController) {
    return action.isLast(prevState, action.controller);
  }
  if (action is ChangeSong) {
    return action.pressed(prevState, action.btn);
  }
  return prevState;
}
