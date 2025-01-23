import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player/Widgets/song_listview.dart';
import 'package:music_player/app/service/song_data_controller.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../controllers/playlist_screen_controller.dart';

class PlaylistScreenView extends GetView<PlaylistScreenController> {
  PlaylistScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Black background
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                // Background Image
                Container(
                  margin: const EdgeInsets.all(5),
                  height: MediaQuery.of(context).size.height *
                      0.35, // 30% of screen height
                  width: MediaQuery.of(context).size.width,
                  child: QueryArtworkWidget(
                    artworkBorder: const BorderRadius.only(
                      bottomLeft: Radius.circular(25),
                      bottomRight: Radius.circular(25),
                    ),
                    id: controller.songs.isNotEmpty
                        ? controller.songs.first.id
                        : 0,
                    type: ArtworkType.AUDIO,
                    nullArtworkWidget: Container(
                      color: Colors.grey, // Fallback background color
                      child: const Icon(
                        Icons.playlist_play,
                        color: Colors.white,
                        size: 48,
                      ),
                    ),
                  ),
                ),
                // Semi-transparent overlay for text visibility
                Container(
                  margin: const EdgeInsets.all(5),
                  height: MediaQuery.of(context).size.height * 0.35,
                  decoration: BoxDecoration(
                    color: Colors.black
                        .withOpacity(0.6), // Semi-transparent overlay
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(25),
                      bottomRight: Radius.circular(25),
                    ),
                  ),
                ),
                // Stack for content (text and icons)
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 30),
                  child: Column(
                    children: [
                      // Back Button and Three Dot Icon (Top Right and Left)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back,
                                color: Colors.white),
                            onPressed: () => Get.back(),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline,
                                color: Colors.white),
                            onPressed: () {
                              SongDataController()
                                  .deletePlaylist(controller.playlist.id);
                              Get.back();
                            },
                          ),
                        ],
                      ),
                      // Playlist Name and Subtitle
                      const SizedBox(height: 100),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                controller.playlist
                                    .name, // Replace with dynamic playlist name
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              // const SizedBox(height: 8),
                              Text(
                                '${controller.songs.length} Songs', // Replace with dynamic subtitle
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 20),
                          // Play Icon with Gradient Background
                          Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.purple, Colors.pink],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.play_arrow),
                              color: Colors.white,
                              onPressed: () {
                                // Handle play action
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 60),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.songs.length,
                        itemBuilder: (context, index) {
                          final song = controller.songs[index];
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: QueryArtworkWidget(
                              id: song.id,
                              type: ArtworkType.AUDIO,
                              nullArtworkWidget: Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Colors.grey[900],
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Icon(Icons.music_note,
                                    color: Colors.white54),
                              ),
                              artworkWidth: 60,
                              artworkHeight: 60,
                              artworkFit: BoxFit.cover,
                              artworkBorder: BorderRadius.circular(4),
                            ),
                            title: Text(
                              song.title,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 14),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Text(
                              song.artist ?? 'Unknown Artist',
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 12),
                            ),
                            trailing: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  controller.formatDuration(song.duration ?? 0),
                                  style: const TextStyle(
                                      color: Colors.grey, fontSize: 6),
                                ),
                              ],
                            ),
                            onTap: () => controller.onSongTap(index),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
