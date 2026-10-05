import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:notes_on_image/domain/states/designation_on_image_state.dart';
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
      child: KeyboardListener(
        focusNode: FocusNode(),
        autofocus: true,
        onKeyEvent: (keyboard) async {
          if (keyboard is KeyDownEvent) {
            if (keyboard.physicalKey == PhysicalKeyboardKey.escape) {
              _back(context, state);
            }
            if (keyboard.physicalKey == PhysicalKeyboardKey.arrowRight) {
              _openNextImage(context, state);
            }
            if (keyboard.physicalKey == PhysicalKeyboardKey.arrowLeft) {
              _openPrevImage(context, state);
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
                onSwipeLeft: () => _openNextImage(context, state),
                onSwipeRight: () => _openPrevImage(context, state),
                child: DesignationOnImageScope(
                  notifier: state.editor,
                  child: const NotesOnImageScreen(),
                ),
              )),
        ),
      ),
    );
  }

  Future<bool> saveImageRequest(
      BuildContext context, ImagesViewNotifier state) async {
    bool result = false;
    await state.editor.hasToSaveDialog(
      context,
      onConfirmCallback: () async {
        await state.editor.saveZip();
        result = true;
      },
      onNoCallback: () {
        result = true;
      },
    );
    return result;
  }

  Future<void> _openPrevImage(
      BuildContext context, ImagesViewNotifier state) async {
    final canGoNext = await saveImageRequest(context, state);
    if (canGoNext) {
      state.openNextImage(increaseIndex: false);
    }
  }

  Future<void> _openNextImage(
      BuildContext context, ImagesViewNotifier state) async {
    final canGoNext = await saveImageRequest(context, state);
    if (canGoNext) {
      state.openNextImage(increaseIndex: true);
    }
  }

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

  Future<void> _back(BuildContext context, ImagesViewNotifier state) async {
    final fl = await saveImageRequest(context, state);
    if (fl && context.mounted) state.close();
  }
}
