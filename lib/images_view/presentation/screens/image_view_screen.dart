import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:path/path.dart' as p;
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
      child: GetMaterialApp(
          home: RawKeyboardListener(
        focusNode: FocusNode(),
        autofocus: true,
        onKey: (keyboard) {
          if (keyboard is RawKeyDownEvent) {
            if (keyboard.physicalKey == PhysicalKeyboardKey.escape) {
              context.go('/TodoEditorScreen');
            }
            if (keyboard.physicalKey == PhysicalKeyboardKey.arrowRight) {
              _openNextImage(state);
            }
            if (keyboard.physicalKey == PhysicalKeyboardKey.arrowLeft) {
              _openPrevImage(state);
            }
          }
        },
        child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                  onPressed: () {
                    context.go('/TodoEditorScreen');
                  },
                  icon: const Icon(Icons.arrow_back)),
              title: Text(p.basename(currentImage ?? '')),
            ),
            extendBodyBehindAppBar: true,
            body: _swipeHandler(
              screenWidth: MediaQuery.of(context).size.width,
              onSwipeLeft: () => _openNextImage(state),
              onSwipeRight: () => _openPrevImage(state),
              child: const NotesOnImageScreen(),
            )),
      )),
    );
  }

  _openPrevImage(ImagesViewNotifier state) =>
      state.openNextImage(increaseIndex: false);

  _openNextImage(ImagesViewNotifier state) =>
      state.openNextImage(increaseIndex: true);

  Widget _swipeHandler(
      {required Widget child,
      required double screenWidth,
      required onSwipeLeft,
      required onSwipeRight}) {
    return RawGestureDetector(gestures: {
      HorizontalSwipeGestureRecognizer: GestureRecognizerFactoryWithHandlers<
          HorizontalSwipeGestureRecognizer>(
        () => HorizontalSwipeGestureRecognizer(
          screenWidth: screenWidth,
          onSwipeLeft: onSwipeLeft,
          onSwipeRight: onSwipeRight,
        ),
        (HorizontalSwipeGestureRecognizer instance) {},
      )
    }, child: child);
  }
}
