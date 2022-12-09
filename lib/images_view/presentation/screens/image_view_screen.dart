import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:notes_on_image/ui/screens/draw_on_image_screen.dart';
import 'package:tagged_todos_organizer/images_view/domain/images_view_provider.dart';
import 'package:tagged_todos_organizer/images_view/presentation/screens/custom_gesture_recognizer.dart';

class ImagesViewScreen extends ConsumerWidget {
  const ImagesViewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentImage = ref.watch(imagesViewProvider);
    final state = ref.read(imagesViewProvider.notifier);
    return WillPopScope(
      onWillPop: () async {
        return await state.saveImageRequest();
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text(currentImage ?? ''),
          ),
          body: RawGestureDetector(gestures: {
            HorizontalSwipeGestureRecognizer:
                GestureRecognizerFactoryWithHandlers<
                    HorizontalSwipeGestureRecognizer>(
              () => HorizontalSwipeGestureRecognizer(
                screenWidth: MediaQuery.of(context).size.width,
                onSwipeLeft: () => state.openNextImage(increaseIndex: true),
                onSwipeRight: () => state.openNextImage(increaseIndex: false),
              ),
              (HorizontalSwipeGestureRecognizer instance) {},
            )
          }, child: const GetMaterialApp(home: NotesOnImageScreen()))),
    );
  }
}
