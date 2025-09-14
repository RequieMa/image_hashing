import "dart:io";
import "dart:typed_data";
import "package:image/image.dart" as img;
import "hashing_base.dart";
import "utils/image_utils.dart";
import "utils/logger.dart";

/// Logger instance for D-Hashing
final loggerDHash = returnLogger("DHash");

class DHash extends Hashing {
  DHash({super.verbose = true});

  @override
  String? encodeImage(String imageFile) {
    if (!File(imageFile).existsSync()) {
      throw ArgumentError("Image file does not exist: $imageFile");
    }

    try {
      final image = loadImage(
        imageFile,
        targetSize: [9, 8],
        isGrayscale: true,
      );
      return hashFunc(image);
    } on img.ImageException catch (e) {
      if (verbose) {
        loggerDHash.severe("Decoding failed: ${e.message}");
      }
      return null;
    }
  }

  @override
  Uint8List hashAlgo(img.Image image) {
    final diff = <bool>[];
    const hashSize = 8;
    for (var y = 0; y < hashSize; ++y) {
      for (var x = 0; x < hashSize; ++x) {
        final leftPixel = image.getPixel(x, y).r;
        final rightPixel = image.getPixel(x + 1, y).r;
        diff.add(leftPixel > rightPixel);
      }
    }
    return toIntFromBoolList(diff);
  }
}


