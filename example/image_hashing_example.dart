import "package:image_hashing/image_hashing.dart";
// import "dart:ffi";
// import "dart:io" show Platform, Directory, File;
// import "package:path/path.dart" as path;

void main() {
  // print(loadImage("example/example_img/cat.png"));
  print(
    loadImage(
      "example/example_img/gray21.512.tiff",
      targetSize: [8, 8],
      isGrayscale: true,
    ),
  );
  // var libraryPath = path.join(Directory.current.path, "dartcv.dll");
  // final dllFile = File(libraryPath);
  // print(dllFile.path);
  // final dylib = DynamicLibrary.open(dllFile.path);
  // print(dylib);
  // final ahasher = AHash(useCV: true);
  final ahasher = AHash(useCV: false);
  print(ahasher);
  final ahash = ahasher.encodeImage("example/example_img/gray21.512.tiff");
  print(ahash);
  // final phasher = PHash();
  // print(phasher);
  // final phash = phasher.encodeImage("example/example_img/gray21.512.tiff");
  // print(phash);
  // final dhasher = DHash();
  // print(dhasher);
  // final dhash = dhasher.encodeImage("example/example_img/gray21.512.tiff");
  // print(dhash);
}
