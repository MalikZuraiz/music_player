import 'package:get/get.dart';

class HomeScreenController extends GetxController {
  //TODO: Implement HomeScreenController

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }
  
void onSearchChanged(String value) {

  // Your code here

}
  void onPlaylistTap(String playlistId) {

Get.toNamed('/playlist-screen');
    print('Playlist tapped: $playlistId');

  }
   void onSongTap(String songId) {

Get.toNamed('/player-screen');
    print('Song tapped: $songId');

  }
   void onCategoryTap(String songId) {

    // Implement your logic here

    print('Song tapped: $songId');

  }
  
  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
