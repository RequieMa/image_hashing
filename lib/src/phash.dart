import "dart:io";
import "dart:typed_data";
import "package:image/image.dart" as img;
import "package:scidart/numdart.dart";
import "package:scidart/scidart.dart";
import "hashing_base.dart";
import "utils/image_utils.dart";
import "utils/logger.dart";

/// Logger instance for P-Hashing
final loggerPHash = returnLogger("PHash");

class PHash extends Hashing {
  PHash({super.verbose = true});

  @override
  String? encodeImage(String imageFile) {
    if (!File(imageFile).existsSync()) {
      throw ArgumentError("Image file does not exist: $imageFile");
    }

    try {
      final image = loadImage(
        imageFile,
        targetSize: [32, 32],
        isGrayscale: true,
      );
      return hashFunc(image);
    } on img.ImageException catch (e) {
      if (verbose) {
        loggerPHash.severe("Decoding failed: ${e.message}");
      }
      return null;
    }
  }

  // TODO: Current booleans can be all true. This should not be possible!
  @override
  Uint8List hashAlgo(img.Image image) {
    final matrix = imageToArray2d(image);
    final dctMatrix = dct2D(matrix);
    final topLeft8x8 = extractTopLeft(dctMatrix);
    final imageArray = flattenToUint8List(topLeft8x8);
    final med = findMedian(imageArray);
    loggerPHash.info("Perceptual > median: $med");
    final hashMat = imageArray.map((x) => x >= med).toList();
    loggerPHash.info("image > Perceptual booleans: $hashMat");
    return toIntFromBoolList(hashMat);
  }
}

int findMedian(Uint8List list) {
  if (list.isEmpty) return 0;
  
  final length = list.length;
  final mid = length ~/ 2; // 中间索引
  final sortedList = Uint8List.fromList(list)..sort();
  
  if (length % 2 == 1) {
    return sortedList[mid];
  } else {
    return ((sortedList[mid - 1] + sortedList[mid]) / 2).round();
  }
}

Array2d extractTopLeft(Array2d matrix, {int rows = 8, int cols = 8}) {
  final actualRows = min(matrix.length, rows);
  final actualCols = min(matrix[0].length, cols);
  
  return Array2d(
    List.generate(actualRows, (i) => 
      Array(List.generate(actualCols, (j) => matrix[i][j])),
    ),
  );
}

Uint8List flattenToUint8List(Array2d matrix) {
  final totalElements = matrix.length * matrix[0].length;
  final result = Uint8List(totalElements);
  
  var index = 0;
  for (var i = 0; i < matrix.length; ++i) {
    for (var j = 0; j < matrix[i].length; ++j) {
      final value = matrix[i][j];
      result[index++] = value.round().clamp(0, 255);
    }
  }
  return result;
}

Array2d dct2D(Array2d matrix) 
  => _dctAlongAxis(_dctAlongAxis(matrix, axis: 0), axis: 1);

Array2d _dctAlongAxis(Array2d matrix, {int axis = 0}) {
  if (axis == 0) {
    // 沿列操作：转置 -> 行变换 -> 转置
    return matrixTranspose(_dctRows(matrixTranspose(matrix)));
  } else {
    // 沿行操作
    return _dctRows(matrix);
  }
}

Array2d _dctRows(Array2d matrix) => Array2d(
  matrix.map((row) => dct(Array(row), normalization: false)).toList(),
);

Array dct(Array input, {bool normalization = false}) {
  final n = input.length;
  final output = Array.fixed(n, initialValue: 0.0);
  
  // 步骤 1: 创建长度为 2N 的扩展序列
  final y = Array.fixed(2 * n, initialValue: 0.0);
  for (var k = 0; k < n; ++k) {
    y[k] = input[k];
    y[2 * n - 1 - k] = input[k];
  }
  
  // 步骤 2: 计算 FFT
  final yComplex = ArrayComplex(y.map((v) => Complex(real: v)).toList());
  final yFFT = fft(yComplex);
  
  // 步骤 3: 提取实部并应用相位校正
  for (var k = 0; k < n; ++k) {
    final phase = Complex(
      real: cos(pi * k / (2 * n)),
      imaginary: -sin(pi * k / (2 * n)),
    );
    
    final term = yFFT[k] * phase;
    output[k] = 2 * term.real; // 乘以 2 匹配 DCT 公式
  }
  
  // 步骤 4: 应用正交归一化 (如果需要)
  if (normalization) {
    final scale = Array.fixed(n, initialValue: 1.0);
    scale[0] = 1.0 / sqrt(n);
    for (var k = 1; k < n; ++k) {
      scale[k] = sqrt(2 / n);
    }
    for (var k = 0; k < n; ++k) {
      output[k] *= scale[k];
    }
  }
  
  return output;
}
