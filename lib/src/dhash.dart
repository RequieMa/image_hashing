import "dart:typed_data";
import "dart:io";
import 'package:collection/collection.dart';
import 'package:dartcv4/core.dart';
import 'package:dartcv4/contrib.dart';
import 'package:dartcv4/dartcv.dart';
import 'package:dartcv4/imgcodecs.dart';
import "package:image/image.dart" as img;
import "utils/image_utils.dart";
import "hashing_base.dart";


class DHash {
  final bool verbose;

  DHash({this.verbose = true});

  String? encodeImage(String imageFile) {
    if (!File(imageFile).existsSync()) {
      throw ArgumentError("Image file does not exist: $imageFile");
    }

    try {
      final imageR = loadImage(
        imageFile,
        targetSize: [8, 9],
        isGrayscale: true,
      );
      final imageC = loadImage(
        imageFile,
        targetSize: [9, 8],
        isGrayscale: true,
      );
      return hashFunc(imageR, imageC);
    } on img.ImageException catch (e) {
      if (verbose) {
        loggerHash.severe("Decoding failed: ${e.message}");
      }
      return null;
    }
  }

  String hashFunc(Uint8List imageRowArray, Uint8List imageColArray) {
    final hashVal = hashAlgo(imageRowArray, imageColArray);
    return Hashing.array2Hash(hashVal);
  }

  int hashAlgo(Uint8List imageRowArray, Uint8List imageColArray) {
    return _hashAlgoCV(imageRowArray, imageColArray);
    // return _hashAlgoNative(imageArray);
  }

  int _hashAlgoCV(Uint8List imageRowArray, Uint8List imageColArray) {
    final imageRowMat = imdecode(imageRowArray, IMREAD_UNCHANGED);
    final imageColMat = imdecode(imageColArray, IMREAD_UNCHANGED);
    final rowDiff = imageRowMat.rowRange(1, 9).addMat(imageRowMat.rowRange(0, 8).multiplyF32(-1.0));
    final colDiff = imageColMat.colRange(1, 9).addMat(imageColMat.colRange(0, 8).multiplyF32(-1.0));
    final diffHashMat = hconcat(colDiff, rowDiff);
    print(diffHashMat.toList());
    return diffHashMat.toString().length; // TODO: this may not work, check `hash.data -> Uint8List`
  }
}
