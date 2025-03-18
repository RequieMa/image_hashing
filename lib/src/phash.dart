import "dart:typed_data";
import 'package:collection/collection.dart';
import 'package:dartcv4/contrib.dart';
import 'package:dartcv4/imgcodecs.dart';
import "hashing_base.dart";


class PHash extends Hashing {
  PHash({super.verbose = true});

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
