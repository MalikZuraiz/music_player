import 'package:on_audio_query/on_audio_query.dart';

class SongDetails {
  final int id;
  final String title;
  final String artist;
  final String album;
  final String filePath;
  final int duration;
  final int size;

  SongDetails({
    required this.id,
    required this.title,
    required this.artist,
    required this.album,
    required this.filePath,
    required this.duration,
    required this.size,
  });

  factory SongDetails.fromSongModel(SongModel songModel) {
    return SongDetails(
      id: songModel.id,
      title: songModel.title ?? "Unknown Title",
      artist: songModel.artist ?? "Unknown Artist",
      album: songModel.album ?? "Unknown Album",
      filePath: songModel.uri ?? "Unknown Path",
      duration: songModel.duration ?? 0,
      size: songModel.size ?? 0,
    );
  }
}
