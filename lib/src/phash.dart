import "dart:typed_data";
import "package:collection/collection.dart";
// import "package:dartcv4/contrib.dart" as cv;
// import "package:dartcv4/dartcv.dart";
// import "package:dartcv4/imgcodecs.dart";
import "hashing_base.dart";

// class PHash extends Hashing {
//   PHash({super.verbose = true});

//   @override
//   int hashAlgo(Uint8List imageArray) {
//     return _hashAlgoCV(imageArray);
//     // return _hashAlgoNative(imageArray);
//   }

//   int _hashAlgoCV(Uint8List imageArray) {
//     final imageMat = imdecode(imageArray, IMREAD_UNCHANGED);
//     final pHash = cv.PHash();
//     final hash = pHash.compute(imageMat);
//     print(hash.toList());
//     return hash.toString().length; // TODO: this may not work, check `hash.data -> Uint8List`
//   }
// }
