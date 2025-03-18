import "dart:typed_data";
import 'package:collection/collection.dart';
import 'package:dartcv4/contrib.dart';
import 'package:dartcv4/imgcodecs.dart';
import "hashing_base.dart";


class PHash extends Hashing {
  /// Creates an [AHash] instance with optional verbose logging.
  ///
  /// [verbose]: When `true`, enables detailed logging for debugging purposes.
  /// Defaults to `true`.
  PHash({super.verbose = true});

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
    return _hashAlgoCV(imageMat);
    // return _hashAlgoNative(imageArray);
  }

  int _hashAlgoCV(Uint8List imageArray) {
    final imageMat = imdecode(imageArray, IMREAD_UNCHANGED);
    final avgHash = PHash();
    final hash = avgHash.compute(imageMat);
    return hash.toInt(); // TODO: this may not work, check `hash.data -> Uint8List`
  }
}
