import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as p;
import 'package:notes_on_image/ui/screens/draw_on_image_screen.dart';
import 'package:tagged_todos_organizer/images_view/domain/images_view_provider.dart';
import 'package:tagged_todos_organizer/images_view/presentation/screens/custom_gesture_recognizer.dart';
import 'package:tagged_todos_organizer/todos/presentation/widgets/attachment_action_buttons.dart';

class ImagesViewScreen extends ConsumerWidget {
  const ImagesViewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentImage = ref.watch(imagesViewProvider);
    final state = ref.read(imagesViewProvider.notifier);
    state.context = context;
    if (currentImage == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return PopScope(
      canPop: false, onPopInvokedWithResult: (fl,__){
        if(fl) return;
        _back(context, state);
    },
      child: GetMaterialApp(
          home: KeyboardListener(
        focusNode: FocusNode(),
        autofocus: true,
        onKeyEvent: (keyboard) async {
          if (keyboard is KeyDownEvent) {
            if (keyboard.physicalKey == PhysicalKeyboardKey.escape) {
              _back(context, state);
            }
            if (keyboard.physicalKey == PhysicalKeyboardKey.arrowRight) {
              _openNextImage(state);
            }
            if (keyboard.physicalKey == PhysicalKeyboardKey.arrowLeft) {
              _openPrevImage(state);
            }
          }
        },
        child: PopScope(
          canPop: false,
          child: Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  onPressed: () async => _back(context, state),
                  icon: Icon(Icons.arrow_back),
                ),
                title: Text(p.basename(currentImage)),
                actions: [
                  RenameAttachmentButton(e: currentImage),
                  DeleteAttachmentButton(e: currentImage),
                ],
              ),
              extendBodyBehindAppBar: true,
              body: _swipeHandler(
                screenWidth: MediaQuery.of(context).size.width,
                onSwipeLeft: () => _openNextImage(state),
                onSwipeRight: () => _openPrevImage(state),
                child: const NotesOnImageScreen(),
              )),
        ),
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

  _back(BuildContext context, ImagesViewNotifier state) async {
    final fl = await state.saveImageRequest();
    if (fl && context.mounted) state.close();
  }
}
