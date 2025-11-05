import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:tagged_todos_organizer/images_view/presentation/screens/custom_gesture_recognizer.dart';
import 'package:tagged_todos_organizer/notifications/domain/notifications_provider.dart';
import 'package:tagged_todos_organizer/notifications/presentation/widget/active_notifications_dialog.dart';
import 'package:tagged_todos_organizer/one_day_view/domain/one_day_view_provider.dart';
import 'package:tagged_todos_organizer/one_day_view/domain/tmp_todo_provider.dart';
import 'package:tagged_todos_organizer/todos/presentation/widgets/menu_widget.dart';
import 'package:tagged_todos_organizer/utils/snackbar_provider.dart';

class OneDayViewScreen extends ConsumerWidget {
  const OneDayViewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<SnackbarNotifier>(snackbarProvider, (p, val) {
      if (val.msg != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(val.msg ?? ''),
            duration: const Duration(milliseconds: 3000)));
      }
    });

    final importantUrgent = ref.watch(oneDayViewImportantUrgentProvider);
    final importantNotUrgent = ref.watch(oneDayViewImportantNotUrgentProvider);
    final notImportantUrgent = ref.watch(oneDayViewNotImportantUrgentProvider);
    final notImportantNotUrgent =
        ref.watch(oneDayViewNotImportantNotUrgentProvider);

    final itemContainerSize = Size(
        MediaQuery.of(context).size.width * 0.5,
        (MediaQuery.of(context).size.height -
                kToolbarHeight -
                MediaQuery.of(context).viewPadding.top) *
            0.5);

    return _swipeHandler(
      screenWidth: MediaQuery.of(context).size.width,
      onSwipeLeft: () {
        context.go("/TodosScreen");
      },
      onSwipeRight: () {},
      child: Scaffold(
          drawer: const MenuWidget(),
          appBar: AppBar(
            title: Text(DateFormat('EE, MMM dd, yyyy').format(DateTime.now())),
            actions: [
              IconButton(
                tooltip: "Get active reminders",
                icon: Icon(Icons.list_alt),
                onPressed: () {
                  ref.read(notificationsProvider.notifier).getNotifications();
                  showActiveNotificationsDialog(context);
                },
              ),
              IconButton(
                  tooltip: "Add tmp todo",
                  onPressed: () =>
                      ref.read(tmpTodoProvider.notifier).addTmpTodo(),
                  icon: const Icon(Icons.add)),
              IconButton(
                  tooltip: "Todos Screen",
                  onPressed: () => context.go('/TodosScreen'),
                  icon: const Icon(Icons.segment_sharp))
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Row(children: [
                  _itemsContainer(
                    label: "Urgent & Important",
                    color: Colors.red[50],
                    size: itemContainerSize,
                    children: importantUrgent,
                  ),
                  _itemsContainer(
                    label: "Important & Not Urgent",
                    color: Colors.orange[50],
                    size: itemContainerSize,
                    children: importantNotUrgent,
                  ),
                ]),
                Row(children: [
                  _itemsContainer(
                    size: itemContainerSize,
                    color: Colors.green[50],
                    label: "Urgent & Not Important",
                    children: notImportantUrgent,
                  ),
                  _itemsContainer(
                    size: itemContainerSize,
                    color: Colors.grey[50],
                    label: "Not Urgent & Not Important",
                    children: notImportantNotUrgent,
                  ),
                ]),
              ],
            ),
          )),
    );
  }

  Widget _itemsContainer({
    required String label,
    required Color? color,
    required Size size,
    required List<Widget> children,
  }) {
    final headerStyle = TextStyle(
        fontSize: 12, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic);

    return Container(
      width: size.width,
      height: size.height,
      color: color,
      child: ListView(
        children: [Center(child: Text(label, style: headerStyle)), ...children],
      ),
    );
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
}
