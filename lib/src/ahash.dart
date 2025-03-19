import "dart:typed_data";
import "package:collection/collection.dart";
import "package:dartcv4/contrib.dart";
import "package:dartcv4/dartcv.dart";
import "package:dartcv4/imgcodecs.dart";
import "hashing_base.dart";
import "utils/dartcv_load.dart";

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
  final bool useCV;

  /// Creates an [AHash] instance with optional verbose logging.
  ///
  /// [verbose]: When `true`, enables detailed logging for debugging purposes.
  /// Defaults to `true`.
  AHash({super.verbose = true, this.useCV = false});

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
  int hashAlgo(Uint8List imageArray) {
    // if (useCV) {
    //   return _hashAlgoCV(imageArray);
    // }
    return _hashAlgoNative(imageArray);
  }

  int _hashAlgoNative(Uint8List imageArray) {
    final avg = imageArray.average;
    final hashMat = imageArray.map((x) => x >= avg).toList();
    return toIntFromBoolList(hashMat);
  }

  // int _hashAlgoCV(Uint8List imageArray) {
  //   final imageMat = imdecode(imageArray, IMREAD_UNCHANGED);
  //   final avgHash = AverageHash();
  //   final hash = avgHash.compute(imageMat);
  //   print(hash.toList());
  //   return hash.toString().length; // TODO: this may not work, check `hash.data -> Uint8List`
  // }
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
int toIntFromBoolList(List<bool> booleans) {
  var number = 0;
  for (final bool in booleans) {
    number = number << 1;
    if (bool) {
      number = number | 1;
    }
  }
  return number;
}
