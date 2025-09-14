import "dart:core";
import "dart:typed_data";
import "package:image/image.dart" as img;
import "utils/logger.dart";

/// Logger instance for Hashing
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
  final bool verbose;

  /// Creates a [Hashing] instance with optional verbose logging.
  ///
  /// [verbose]: When `true`, enables detailed logging for debugging purposes.
  /// Defaults to `true`.
  Hashing({this.verbose = true});

   String? encodeImage(String imageFile) {
    throw UnimplementedError("Subclasses must implement encodeImage");
  }

  /// Processes the image array with the hashing algorithm and returns String.
  ///
  /// This method coordinates the hashing process by:
  /// 1. Calling [hashAlgo] to compute the hash value
  /// 2. Converting the numerical result to a hexadecimal string
  ///
  /// [imageArray]: The image data in grayscale 8x8 format as a Uint8List.
  ///
  /// Returns the hexadecimal hash string representation of the hash value.
  String hashFunc(img.Image imageArray) {
    loggerHash.info("image Array: $imageArray");
    final hashVal = hashAlgo(imageArray);
    loggerHash.info("hash Val: $hashVal");
    return Hashing.array2Hash(hashVal.first);
  }

  /// Abstract method defining the core hashing algorithm.
  ///
  /// Subclasses must implement this method to provide the specific logic for
  /// converting image pixel data into a hash value.
  ///
  /// [image]: The image data in grayscale 8x8 format as a Uint8List.
  ///
  /// Returns an integer value representing the computed hash.
  ///
  /// Throws:
  /// - [UnimplementedError] if not overridden by a subclass.
  Uint8List hashAlgo(img.Image image) {
    throw UnimplementedError("Subclasses must implement hashAlgo");
  }

  /// Converts a numerical hash value to a hexadecimal string.
  ///
  /// The conversion ensures the resulting string is always 16 characters long,
  /// padding with leading zeros if necessary.
  ///
  /// [hashVal]: The integer hash value to convert.
  ///
  /// Returns the hexadecimal representation as a fixed-length string.
  static String array2Hash(int hashVal) {
    final hexString = hashVal.toRadixString(16);
    return hexString.padLeft(16, "0");
  }
}
