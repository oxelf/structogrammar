#include "include/flutter_tree_sitter/flutter_tree_sitter_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "flutter_tree_sitter_plugin.h"

void FlutterTreeSitterPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  flutter_tree_sitter::FlutterTreeSitterPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
