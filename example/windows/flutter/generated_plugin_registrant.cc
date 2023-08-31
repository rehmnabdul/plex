//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <file_saver/file_saver_plugin.h>
#include <sqlite3_flutter_libs/sqlite3_flutter_libs_plugin.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  FileSaverPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("FileSaverPlugin"));
  Sqlite3FlutterLibsPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("Sqlite3FlutterLibsPlugin"));
}
