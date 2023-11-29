import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

final packageInfoProvider =
    FutureProvider<PackageInfo>((ref) => PackageInfo.fromPlatform());

final appVersionProvider = Provider<String>((ref) {
  String version = '';
  ref.watch(packageInfoProvider).whenData((pkgInfo){
    version = "version: ${pkgInfo.version} build: ${pkgInfo.buildNumber}";
  });
  return version;
});
