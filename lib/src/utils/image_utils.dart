import "dart:io";
import "dart:typed_data";
import "package:image/image.dart" as img;
import "package:scidart/numdart.dart";

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
img.Image loadImage(
  String imageFile, {
  List<int>? targetSize,
  bool isGrayscale = false,
}) {
  // var bytes = await File(imageFile).readAsBytes();
  var bytes = File(imageFile).readAsBytesSync();
  var image = img.decodeImage(bytes);
  if (image == null) {
    throw FormatException("Unsupported image format");
  }
  image = _convertToRgb(image);

  if (targetSize!.length >= 2) {
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
  // return image.toUint8List();
  return image;
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

/// Converts a list of boolean values to an integer representation.
///
/// The conversion follows a left-shift pattern where:
/// - Each `true` value represents a binary 1
/// - Each `false` value represents a binary 0
///
/// [booleans]: The list of boolean values to convert. Should contain exactly
/// 64 elements for standard hash implementations (8x8 image).
///
/// Returns an integer where bits represent the boolean values from first
/// to last element in the list (big-endian bit order).
///
/// Note: The list length should not exceed 64 elements due to Dart"s int size.
Uint8List toIntFromBoolList(List<bool> booleans) {
  var number = Uint8List.fromList([0]);
  for (final boolVal in booleans) {
    number.first <<= 1;
    if (boolVal) {
      number.first |= 1;
    }
  }
  return number;
}

Array2d imageToArray2d(img.Image image) {
  final width = image.width;
  final height = image.height;
  final matrix = Array2d.fixed(height, width);
  
  // 遍历所有像素
  for (var y = 0; y < height; ++y) {
    for (var x = 0; x < width; ++x) {
      final pixel = image.getPixel(x, y);
      matrix[y][x] = pixel.r.toDouble();
    }
  }
  return matrix;
}