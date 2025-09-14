import "dart:io";
import "dart:typed_data";
import "package:collection/collection.dart";
import "package:image/image.dart" as img;
import "hashing_base.dart";
import "utils/image_utils.dart";
import "utils/logger.dart";

/// Logger instance for A-Hashing
final loggerAHash = returnLogger("AHash");

/// A concrete implementation of the average hash (aHash) algorithm.
///
/// This perceptual hashing algorithm works by:
/// 1. Converting the image to grayscale and resizing to [Hashing.targetSize]
/// 2. Calculating the average pixel value
/// 3. Creating a binary hash where each bit represents whether the pixel
///    is above (1) or below (0) the average value
///
/// Example:
/// ```dart
/// final hasher = AHash();
/// final hash = hasher.encodeImage("path/to/image.jpg");
/// ```
class AHash extends Hashing {
  /// Creates an [AHash] instance with optional verbose logging.
  ///
  /// [verbose]: When `true`, enables detailed logging for debugging purposes.
  /// Defaults to `true`.
  AHash({super.verbose = true});

  /// Generates a perceptual hash for the image at the given file path.
  ///
  /// The image is resized to [targetSize], converted to grayscale, and
  /// processed through the hashing algorithm defined in [hashAlgo].
  ///
  /// [imageFile]: The path to the image file. Must be a valid file system path.
  ///
  /// Returns a 16-character hex-hash string, or `null` if processing fails.
  ///
  /// Throws:
  /// - [ArgumentError] if the image file does not exist.
  /// - [img.ImageException] if image decoding fails.
  ///
  /// Example:
  /// ```dart
  /// final hasher = Hashing();
  /// final hash = hasher.encodeImage("path/to/image.jpg");
  /// if (hash != null) {
  ///   print("Image hash: $hash");
  /// }
  /// ```
  @override
  String? encodeImage(String imageFile) {
    if (!File(imageFile).existsSync()) {
      throw ArgumentError("Image file does not exist: $imageFile");
    }

    try {
      final image = loadImage(
        imageFile,
        targetSize: [8, 8],
        isGrayscale: true,
      );
      return hashFunc(image);
    } on img.ImageException catch (e) {
      if (verbose) {
        loggerAHash.severe("Decoding failed: ${e.message}");
      }
      return null;
    }
  }

  /// Implements the aHash algorithm for generating perceptual hashes.
  ///
  /// This method:
  /// 1. Calculates the average pixel value from the preprocessed image
  /// 2. Generates a boolean list where `true` indicates pixels above average
  /// 3. Converts the boolean list to an integer hash value
  ///
  /// [imageArray]: The preprocessed 8x8 grayscale image data as a Uint8List
  ///
  /// Returns an integer representation of the hash value.
  @override
  Uint8List hashAlgo(img.Image image) {
    final imageArray = image.toUint8List();
    final avg = imageArray.average;
    final hashMat = imageArray.map((x) => x >= avg).toList();
    loggerAHash.info("image > Average booleans: $hashMat");
    return toIntFromBoolList(hashMat);
  }
}
