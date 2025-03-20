// import "dart:io";
// import "package:http/http.dart" as http;
// import "package:archive/archive_io.dart";

// String getAppDocumentsPath() {
//   if (Platform.isWindows) {
//     // Windows：通常使用 AppData\Roaming 目录
//     final appData = Platform.environment["APPDATA"];
//     return "$appData\\image_dup";
//   } else if (Platform.isLinux || Platform.isMacOS) {
//     // Linux/macOS：使用用户目录下的隐藏文件夹（如 ~/.config）
//     final home = Platform.environment["HOME"];
//     return "$home/.config/image_dup";
//   } else {
//     throw UnsupportedError("当前平台不支持");
//   }
// }

// Future<void> downloadAndLoadLibrary(
//   String url,
//   String libraryPath,
//   String compressedPath,
//   String libraryDirPath,
// ) async {
//   if (!File(libraryPath).existsSync()) {
//     final response = await http.get(Uri.parse(url));
//     final compressedFile = File(compressedPath);
//     await compressedFile.writeAsBytes(response.bodyBytes);

//     // Decompress the file
//     final bytes = await compressedFile.readAsBytes();
//     final archive = ZipDecoder().decodeBytes(bytes);
//     for (final file in archive) {
//       final filename = "$libraryDirPath/${file.name}";
//       if (file.isFile) {
//         final outFile = File(filename);
//         await outFile.create(recursive: true);
//         await outFile.writeAsBytes(file.content as List<int>);
//       }
//     }
//   }
//   // // Load the library
//   // final library = DynamicLibrary.open(libraryPath);
// }

// Future<void> initOpenCV() async {
//   var url = "";
//   var libraryPath = "";
//   var compressedPath = "";
//   final directory = getAppDocumentsPath();
//   final libraryDir = Directory("$directory/.dartcv");
//   // Get URL and Set environment variables
//   if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
//     final arch = Platform.environment["PROCESSOR_ARCHITECTURE"];
//     final is64Bit = arch != null && arch.contains("64");
//     final isArm = arch != null && arch.contains("ARM");
//     if (Platform.isWindows) {
//       if (is64Bit) {
//         url =
//             "https://github.com/rainyl/dartcv/releases/download/4.11.0.2/libdartcv-windows-x64-vs2022.tar.gz";
//       } else if (isArm) {
//         url =
//             "https://github.com/rainyl/dartcv/releases/download/4.11.0.2/libdartcv-windows-arm64-vs2022.tar.gz";
//       } else {
//         throw UnsupportedError("On Win, this architecture is not supported");
//       }
//       final path = Platform.environment["PATH"];
//       Platform.environment["PATH"] =
//           "$path;${libraryDir.path}"; // TODO: Cannot!!!
//       libraryPath = "${libraryDir.path}/my_library.dll";
//       compressedPath = "$directory/my_library.zip";
//     } else if (Platform.isLinux) {
//       if (is64Bit) {
//         url =
//             "https://github.com/rainyl/dartcv/releases/download/4.11.0.2/libdartcv-linux-x64.tar.gz";
//       } else if (isArm) {
//         url =
//             "https://github.com/rainyl/dartcv/releases/download/4.11.0.2/libdartcv-linux-arm64.tar.gz";
//       } else {
//         throw UnsupportedError(
//           "On Linux, this architecture is not supported"
//         );
//       }
//       final ldLibraryPath = Platform.environment["LD_LIBRARY_PATH"];
//       Platform.environment["LD_LIBRARY_PATH"] =
//           "$ldLibraryPath:${libraryDir.path}";
//     } else if (Platform.isMacOS) {
//       if (is64Bit) {
//         url =
//             "https://github.com/rainyl/dartcv/releases/download/4.11.0.2/libdartcv-macos-x64.tar.gz";
//       } else if (isArm) {
//         url =
//             "https://github.com/rainyl/dartcv/releases/download/4.11.0.2/libdartcv-macos-arm64.tar.gz";
//       } else {
//         throw UnsupportedError(
//           "On Linux, this architecture is not supported"
//         );
//       }
//       final dyldFallbackLibraryPath =
//           Platform.environment["DYLD_FALLBACK_LIBRARY_PATH"];
//       Platform.environment["DYLD_FALLBACK_LIBRARY_PATH"] =
//           "$dyldFallbackLibraryPath:${libraryDir.path}";
//     }
//   } else if (Platform.isAndroid || Platform.isIOS) {
//     if (Platform.isAndroid) {
//       url =
//           "https://github.com/rainyl/dartcv/releases/download/4.11.0.2/libdartcv-android.tar.gz";
//       final path = Platform.environment["PATH"];
//       Platform.environment["PATH"] = "$path;${libraryDir.path}";
//       libraryPath = "${libraryDir.path}/my_library.dll";
//       compressedPath = "$directory/my_library.zip";
//     } else if (Platform.isIOS) {
//       url =
//           "https://github.com/rainyl/dartcv/releases/download/4.11.0.2/libdartcv-linux-x64.tar.gz";
//       final ldLibraryPath = Platform.environment["LD_LIBRARY_PATH"];
//       Platform.environment["LD_LIBRARY_PATH"] =
//           "$ldLibraryPath:${libraryDir.path}";
//     }
//   } else {
//     throw UnsupportedError("This platform is not supported");
//   }
//   print("$url, $libraryPath, $compressedPath, ${libraryDir.path}");
//   await downloadAndLoadLibrary(
//     url,
//     libraryPath,
//     compressedPath,
//     "${libraryDir.path}",
//   );
// }
