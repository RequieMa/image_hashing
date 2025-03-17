import "package:image_hashing/image_hashing.dart";

void main() {
  // print(loadImage("example/example_img/cat.png"));
  print(
    loadImage(
      "example/example_img/gray21.512.tiff",
      targetSize: [8, 8],
      isGrayscale: true,
    ),
  );
  final hasher = AHash();
  print(hasher);
  final hash = hasher.encodeImage("example/example_img/gray21.512.tiff");
  print(hash);
}
