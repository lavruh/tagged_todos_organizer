import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:camerawesome/pigeon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:tagged_todos_organizer/todos/domain/attachments_provider.dart';
import 'package:tagged_todos_organizer/utils/snackbar_provider.dart';

class ImageAddScreen extends ConsumerWidget {
  const ImageAddScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final outputPath = ref.read(attachmentsProvider.notifier).path;
    if (outputPath == null) return Center(child: CircularProgressIndicator());

    return Scaffold(
      body: Container(
        color: Colors.white,
        child: CameraAwesomeBuilder.awesome(
          previewFit: CameraPreviewFit.fitHeight,
          onMediaCaptureEvent: (e) => _showMessage(e, ref),
          saveConfig: SaveConfig.photoAndVideo(
            initialCaptureMode: CaptureMode.photo,
            photoPathBuilder: (sensors) async {
              final String filePath = p.join(
                outputPath,
                '${DateFormat('yMd_hhmmss').format(DateTime.now())}.jpg',
              );
              return SingleCaptureRequest(filePath, sensors.first);
            },
            videoPathBuilder: (sensors) async {
              final String filePath = p.join(
                outputPath,
                '${DateFormat('yMd_hhmmss').format(DateTime.now())}.mp4',
              );
              return SingleCaptureRequest(filePath, sensors.first);
            },
            videoOptions: VideoOptions(
              enableAudio: true,
              android: AndroidVideoOptions(
                bitrate: 6000000,
                fallbackStrategy: QualityFallbackStrategy.lower,
              ),
            ),
          ),
          sensorConfig: SensorConfig.single(
            sensor: Sensor.type(SensorType.telephoto),
            aspectRatio: CameraAspectRatios.ratio_16_9,
            flashMode: FlashMode.auto,
          ),
          enablePhysicalButton: true,
        ),
      ),
    );
  }

  void _showMessage(MediaCapture event, WidgetRef ref) {
    final snackBar = ref.read(snackbarProvider.notifier);

    switch ((event.status, event.isPicture, event.isVideo)) {
      case (MediaCaptureStatus.success, true, false):
        event.captureRequest.when(
          single: (single) {
            snackBar.show('Picture saved: ${single.file?.path}');
            ref.read(attachmentsProvider.notifier).updateAttachments();
          },
          multiple: (multiple) {
            multiple.fileBySensor.forEach((key, value) {
              snackBar.show('multiple image taken: $key ${value?.path}');
            });
          },
        );
      case (MediaCaptureStatus.failure, true, false):
        snackBar.show('Failed to capture picture: ${event.exception}');
      case (MediaCaptureStatus.capturing, false, true):
        snackBar.show('Capturing video...');
      case (MediaCaptureStatus.success, false, true):
        event.captureRequest.when(
          single: (single) {
            snackBar.show('Video saved: ${single.file?.path}');
            ref.read(attachmentsProvider.notifier).updateAttachments();
          },
          multiple: (multiple) {
            multiple.fileBySensor.forEach((key, value) {
              snackBar.show('multiple video taken: $key ${value?.path}');
            });
          },
        );
      case (MediaCaptureStatus.failure, false, true):
        snackBar.show('Failed to capture video: ${event.exception}');
      default:
        break;
    }
  }
}
