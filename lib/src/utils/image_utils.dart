import "dart:io";
import "dart:typed_data";
import "package:image/image.dart" as img;

/// Loads and processes an image file into a standardized format
///
/// Performs decoding, format conversion, resizing and grayscale conversion.
/// The processing pipeline includes:
/// 1. File reading and decoding
/// 2. RGB format standardization
/// 3. Optional resizing with cubic interpolation
/// 4. Optional grayscale conversion
///
/// [imageFile]: Path to the source image file (supports common formats)
/// [targetSize]: Optional target dimensions [width, height] for resizing.
///               When null, keeps original size.
/// [isGrayscale]: Converts image to grayscale when true
///
/// Returns [Uint8List] containing processed image data in RGB/RGBA format
///
/// Throws [FormatException] if image decoding fails due to unsupported format
///
/// Example:
/// ```dart
/// // Load 64x64 grayscale image
/// final img = loadImage('test.jpg', targetSize: [64, 64], isGrayscale: true);
/// ```
Uint8List loadImage(
  String imageFile, {
  List<int>? targetSize,
  bool isGrayscale = false,
}) {
  var image = img.decodeImage(File(imageFile).readAsBytesSync());
  if (image == null) {
    throw FormatException("Unsupported image format");
  }
  image = _convertToRgb(image);

  if (targetSize != null) {
    image = img.copyResize(
      image,
      width: targetSize[0],
      height: targetSize[1],
      interpolation: img.Interpolation.cubic,
    );
  }

  if (isGrayscale) {
    image = img.grayscale(image);
  }
  return image.toUint8List();
}

/// Converts image to 3-channel RGB format
///
/// Ensures consistent color space handling for downstream processing.
/// If source image has alpha channel, it will be removed. If monochrome,
/// it will be expanded to RGB format.
img.Image _convertToRgb(img.Image image) {
  if (image.numChannels == 3) return image;
  return image.convert(numChannels: 3);
}
