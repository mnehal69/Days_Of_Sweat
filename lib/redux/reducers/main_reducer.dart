import './../actions/main_actions.dart';
import './../store/main_store.dart';

PlayerState playerStateReducer(PlayerState prevState, dynamic action) {
  if (action is Player) {
    return action.isPlaying(prevState, action.play);
  }
  if (action is VolumeC) {
    return action.volumeControl(prevState, action.volumeBar, action.volume);
  }
  if (action is SongChooser) {
    return action.songNextPrev(
        prevState, action.nextbuttonPress, action.prevbuttonPress);
  }
  if (action is Expanding) {
    return action.expanding(prevState, action.expanded,action.dragging);
  }
  if (action is Audioplayer) {
    return action.durationInPlay(
        prevState, action.isLocal, action.current, action.duration);
  }
  if (action is Permission) {
    return action.isaccesed(prevState, action.storage);
  }
  if (action is Music) {
    return action.list(
        prevState, action.songlist, action.index, action.playing);
  }
  return prevState;
}
