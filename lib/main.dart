import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player/app/routes/app_pages.dart';
import 'package:music_player/app/service/song_data_controller.dart';

void main() {
  Get.put(SongDataController());
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Music Player',
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      // theme: AppTheme.darkTheme,
    );
  }
}
