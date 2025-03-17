To use `dartcv`, some dll libraries are required at [web](https://github.com/rainyl/dartcv/releases)

# Deal with various dynamic lib
Combining "Selective Download" and "Compression" is a great approach to manage package size and ensure efficient use of resources. Here’s how you can achieve this:

1. Check if the Library Exists Locally: Before downloading, check if the decompressed library already exists on the user's device.
2. Download and Decompress if Necessary: If the library doesn't exist, download the compressed file, decompress it, and save it locally.
3. Load the Library: Load the library from the local path.

Here’s a complete example:
```dart
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:archive/archive_io.dart';

Future<void> downloadAndLoadLibrary() async {
  final directory = await getApplicationDocumentsDirectory();
  final libraryPath = '${directory.path}/my_library.dll'; // Adjust extension based on platform
  final compressedPath = '${directory.path}/my_library.zip';

  if (!File(libraryPath).existsSync()) {
    // Download the compressed file
    String url;
    if (Platform.isWindows) {
      url = 'https://github.com/your_repo/releases/download/latest/my_library_windows.zip';
    } else if (Platform.isLinux) {
      url = 'https://github.com/your_repo/releases/download/latest/my_library_linux.zip';
    } else if (Platform.isMacOS) {
      url = 'https://github.com/your_repo/releases/download/latest/my_library_macos.zip';
    } else {
      throw UnsupportedError('This platform is not supported');
    }

    final response = await http.get(Uri.parse(url));
    final compressedFile = File(compressedPath);
    await compressedFile.writeAsBytes(response.bodyBytes);

    // Decompress the file
    final bytes = compressedFile.readAsBytesSync();
    final archive = ZipDecoder().decodeBytes(bytes);
    for (final file in archive) {
      final filename = '${directory.path}/${file.name}';
      if (file.isFile) {
        final outFile = File(filename);
        outFile.createSync(recursive: true);
        outFile.writeAsBytesSync(file.content as List<int>);
      }
    }
  }

  // Load the library
  final library = DynamicLibrary.open(libraryPath);
  // Use the library
}
```
Explanation:
1. Check Local Path: The code checks if the decompressed library already exists in the application's documents directory.
2. Download and Decompress: If the library doesn't exist, it downloads the compressed file from GitHub, decompresses it, and saves the decompressed files locally.
3. Load the Library: Finally, it loads the library from the local path.
This approach ensures that the library is only downloaded and decompressed once, reducing the need for repeated downloads and keeping the package size manageable.

# Some useful functions in DartCV
## core
- `batchDistance` and `batchDistanceAsync`
- `bitwiseXOR` and `bitwiseXORAsync`
- `calcCovarMatrix` and `calcCovarMatrixAsync`
- `compare` and `compareAsync`
- `countNonZero`
- `dct` and `dctAsync`
- `hconcat` and `hconcatAsync`
- `idct` and `idctAsync`
- `inRangebyScalar` and `inRangebyScalarAsync`
- `PCACompute` and `PCAComputeAsync`
- `SVDecomp`

## imgcodecs
- `haveImageReader`
- `imdecode` and `imdecodeAsync` => `Uint8List` to `Mat`
- `imencode` and `imencodeAsync` => `Mat` to `Uint8List`
- `imread` and `imreadAsync`

## imgproc
- `calcHist` and `calcHistAsync`
- `compareHist` and `compareHistAsync`
- `cvtColor` and `cvtColorAsync`
- `resize` and `resizeAsync`

# To Do Benchmark 
## Timing Processes and Creating a Benchmark Report
Using `Stopwatch`: The Stopwatch class is useful for measuring the execution time of code blocks.
```dart
void timeProcess(Function process) {
  final stopwatch = Stopwatch()..start();
  process();
  stopwatch.stop();
  print('Process executed in ${stopwatch.elapsedMilliseconds} ms');
}
```
Using `benchmark_harness`: The benchmark_harness package provides a more structured way to benchmark your code.
```dart
import 'package:benchmark_harness/benchmark_harness.dart';

class MyBenchmark extends BenchmarkBase {
  MyBenchmark() : super('MyBenchmark');

  @override
  void run() {
    // Code to benchmark
  }
}

void main() {
  final benchmark = MyBenchmark();
  benchmark.report();
}
```

## Supporting Two Implementations
Define an Interface: Create an interface that both implementations will adhere to.
```dart
abstract class ImageProcessor {
  void processImage();
}
```
Implement the Interface: Create two classes that implement the ImageProcessor interface. One for your current implementation and one for the OpenCV + SIMD implementation.
```dart
class CurrentImageProcessor implements ImageProcessor {
  @override
  void processImage() {
    // Current implementation
  }
}

class OpenCVImageProcessor implements ImageProcessor {
  @override
  void processImage() {
    // OpenCV + SIMD implementation
  }
}
```
Conditional Imports: Use conditional imports to select the appropriate implementation based on user needs or platform.
```dart
import 'current_image_processor.dart' if (dart.library.io) 'opencv_image_processor.dart';

void main() {
  ImageProcessor processor;
  if (useOpenCV) {
    processor = OpenCVImageProcessor();
  } else {
    processor = CurrentImageProcessor();
  }
  processor.processImage();
}
```
## Example of Combining Both
Here’s a complete example that combines timing, benchmarking, and supporting multiple implementations:
```dart
import 'dart:io';
import 'package:benchmark_harness/benchmark_harness.dart';

// Define the interface
abstract class ImageProcessor {
  void processImage();
}

// Current implementation
class CurrentImageProcessor implements ImageProcessor {
  @override
  void processImage() {
    // Simulate image processing
    sleep(Duration(milliseconds: 100));
  }
}

// OpenCV + SIMD implementation
class OpenCVImageProcessor implements ImageProcessor {
  @override
  void processImage() {
    // Simulate image processing
    sleep(Duration(milliseconds: 50));
  }
}

// Benchmark class
class ImageProcessingBenchmark extends BenchmarkBase {
  final ImageProcessor processor;

  ImageProcessingBenchmark(this.processor) : super('ImageProcessingBenchmark');

  @override
  void run() {
    processor.processImage();
  }
}

void main() {
  // Choose implementation
  ImageProcessor processor;
  bool useOpenCV = true; // Change based on user preference
  if (useOpenCV) {
    processor = OpenCVImageProcessor();
  } else {
    processor = CurrentImageProcessor();
  }

  // Time the process
  final stopwatch = Stopwatch()..start();
  processor.processImage();
  stopwatch.stop();
  print('Process executed in ${stopwatch.elapsedMilliseconds} ms');

  // Run benchmark
  final benchmark = ImageProcessingBenchmark(processor);
  benchmark.report();
}
```
This setup allows you to time and benchmark your image processing implementations and switch between them based on user needs.