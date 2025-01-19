import 'package:flutter/material.dart';

class SongListView extends StatelessWidget {
  final List<Map<String, String>> songs;
  final Function(String) onSongTap;

  const SongListView({
    super.key,
    required this.songs,
    required this.onSongTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: songs.length,
          itemBuilder: (context, index) {
            final song = songs[index];
            return _buildSongListTile(
              song['title']!,
              song['artist']!,
              song['duration']!,
              song['imagePath']!,
              onTap: () => onSongTap(song['title']!),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSongListTile(
    String title,
    String artist,
    String duration,
    String imagePath, {
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(
          width: 50,
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
          ),
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white, fontSize: 14),
      ),
      subtitle: Text(
        artist,
        style: const TextStyle(color: Colors.grey, fontSize: 12),
      ),
      trailing: Text(
        duration,
        style: const TextStyle(color: Colors.grey, fontSize: 12),
      ),
    );
  }
}
