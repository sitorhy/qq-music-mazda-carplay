extension DurationExtension on Duration {
  toSongDurationFormat() {
    int minus = (inSeconds / 60).floor();
    int secs = inSeconds % 60;
    return "${minus.toString().padLeft(2, "0")}:${secs.toString().padLeft(2, "0")}";
  }
}