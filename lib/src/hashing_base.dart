import "dart:core";
import "dart:io";
import "dart:typed_data";
import "package:image/image.dart" as img;
import "utils/image_utils.dart";
import "utils/logger.dart";

final loggerHash = returnLogger("Hashing");

/// A base class for generating perceptual image hashes.
///
/// This class provides the foundational structure for creating image hashes
/// by processing images into a standardized format and then applying a
/// hashing algorithm implemented in subclasses. Subclasses must override
/// [hashAlgo] to define the specific hashing strategy.
///
/// The target image size for hashing is set to 8x8 pixels by default, and
/// images are converted to grayscale before processing.
///
/// Example:
/// ```dart
/// class MyHasher extends Hashing {
///   @override
///   int hashAlgo(Uint8List imageArray) {
///     // Custom hashing algorithm implementation
///   }
/// }
/// ```
class Hashing {
  /// Target size for image preprocessing (width, height)
  final List<int> targetSize = [8, 8];
  final bool _verbose;

  /// Creates a [Hashing] instance with optional verbose logging.
  ///
  /// [verbose]: When `true`, enables detailed logging for debugging purposes.
  /// Defaults to `true`.
  Hashing({bool verbose = true}) : _verbose = verbose;

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
  String? encodeImage(String imageFile) {
    if (!File(imageFile).existsSync()) {
      throw ArgumentError("Image file does not exist: $imageFile");
    }

    try {
      final image = loadImage(
        imageFile,
        targetSize: targetSize,
        isGrayscale: true,
      );
      return hashFunc(image);
    } on img.ImageException catch (e) {
      if (_verbose) {
        loggerHash.severe("Decoding failed: ${e.message}");
      }
      return null;
    }
  }

  /// Processes the image array through the hashing algorithm and converts the result.
  ///
  /// This method coordinates the hashing process by:
  /// 1. Calling [hashAlgo] to compute the hash value
  /// 2. Converting the numerical result to a hexadecimal string
  ///
  /// [imageArray]: The processed image data in grayscale 8x8 format as a Uint8List.
  ///
  /// Returns the hexadecimal hash string representation of the hash value.
  String hashFunc(Uint8List imageArray) {
    final hashVal = hashAlgo(imageArray);
    return Hashing.array2Hash(hashVal);
  }

  /// Abstract method defining the core hashing algorithm.
  ///
  /// Subclasses must implement this method to provide the specific logic for
  /// converting image pixel data into a hash value.
  ///
  /// [imageArray]: The processed image data in grayscale 8x8 format as a Uint8List.
  ///
  /// Returns an integer value representing the computed hash.
  ///
  /// Throws:
  /// - [UnimplementedError] if not overridden by a subclass.
  int hashAlgo(Uint8List imageArray) {
    throw UnimplementedError("Subclasses must implement hashAlgo");
  }

  /// Converts a numerical hash value to a 16-character hexadecimal string.
  ///
  /// The conversion ensures the resulting string is always 16 characters long,
  /// padding with leading zeros if necessary.
  ///
  /// [hashVal]: The integer hash value to convert.
  ///
  /// Returns the hexadecimal representation as a fixed-length 16-character string.
  static String array2Hash(int hashVal) {
    final hexString = hashVal.toRadixString(16);
    return hexString.padLeft(16, "0");
  }
}
