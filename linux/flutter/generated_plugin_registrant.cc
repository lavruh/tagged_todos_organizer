//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <flutter_timezone/flutter_timezone_plugin.h>
#include <restart_app/restart_app_plugin.h>
#include <url_launcher_linux/url_launcher_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) flutter_timezone_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "FlutterTimezonePlugin");
  flutter_timezone_plugin_register_with_registrar(flutter_timezone_registrar);
  g_autoptr(FlPluginRegistrar) restart_app_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "RestartAppPlugin");
  restart_app_plugin_register_with_registrar(restart_app_registrar);
  g_autoptr(FlPluginRegistrar) url_launcher_linux_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "UrlLauncherPlugin");
  url_launcher_plugin_register_with_registrar(url_launcher_linux_registrar);
}
