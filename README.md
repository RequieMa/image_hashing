# image_hashing

[![Pub Version](https://img.shields.io/pub/v/image_hashing)](https://pub.dev/packages/image_hashing) 
[![Pub Points](https://img.shields.io/pub/points/image_hashing)](https://pub.dev/packages/image_hashing/score)
[![License](https://img.shields.io/badge/license-BSD--3--Clause-blue?style=flat-square)](LICENSE)
[![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/RequieMa/image_hashing/publish.yml)](https://github.com/RequieMa/image_hashing/actions/workflows/publish.yml)

NOTE: UNDER DEVELOPMENT!

A Dart library for generating perceptual hashes (AHash, PHash, DHash, WHash) from images, providing efficient single-image hash computation and comparison with pure Dart implementation.

**Compatibility**: Dart `^3.6.0` 
<!-- | Flutter `^3.16.0` | [Other Requirements] -->

## 🚀 Getting Started

### Installation
**Method 1 (Recommended)**
With Dart:
```cmd
dart pub add image_hashing
```

With Flutter:
```cmd
flutter pub add image_hashing
```

**Method 2**
Add to `pubspec.yaml`:
```yaml
dependencies:
  image_hashing: ^0.1.1
```
Then run:
```bash
dart pub get
```

### Basic Usage
```dart
import 'package:image_hashing/image_hashing.dart';

void main() {
  final hasher = AHash(); // or other hasher types
  final hashRes = hasher.encodeImage("YourImageFile");
}
```
Currently only `AHash` is supported, to validate the whole process.

`encodeImage` will return you a `String` of hash value. 

For `AHash` and `PHash`, it will be **64 bits** (After hashing, you will obtain an $(8 \times 8)$ image).

For `DHash`, it will be **128 bits** (Here, I decide to use both row difference and column difference to increase the countability, so you will obtain 2 $(8 \times 8)$ images).

`WHash` is still under-planning. 

## 📦 Features

- **Core Feature 1**: Different Hashing Methods
  ```dart
  final ahasher = AHash();
  final phasher = PHash();
  final dhasher = DHash();
  final whasher = WHash(); // Wavelet Transform Hashing dependency is under development
  ```

  To encode an image:
  ```dart
  final ahasher = AHash(useCV: false); // OpenCV compatibility is under development
  final ahash = ahasher.encodeImage("YourImageFile");
  ```

- **Core Feature 2**: Hamming Distances of Image Hashing
  After hashing, you can use the following function to calculate the Hamming Distances
  ```dart
  final distance = hammingDistance(a, b, size: 64)
  ```
  where `a` and `b` are the hash strings. `size` is 64 for `AHash` and `PHash`, 128 for `DHash`.

  Result will in an int value.

## 🧪 Testing

Unit tests are under development. Currently only unit tests for hamming distance

```bash
dart test
```

<!-- | Metric          | Status                      |
|-----------------|-----------------------------|
| Test Coverage   | 100% (core logic)           |
| Static Analysis | Enforced via `pedantic`     | -->

## 🤝 Contributing

### Workflow
1. Fork repository
2. Create feature branch:
   ```bash
   git checkout -b feat/your-feature
   ```
3. Follow [Conventional Commits](https://www.conventionalcommits.org):
   ```bash
   git commit -m "feat: add new validation method"
   ```

### Code Style
Follow the **Effective Dart** and `analysis_options.yaml`

## 📚 Documentation

<!-- | Resource         | Link                                   |
|------------------|----------------------------------------|
| API Reference    | [View Docs](https://pub.dev/documentation/your_package) |
| Example Project  | [/example](example/)                   |
| Tutorial Series  | [YouTube Playlist](https://youtube.com/your-channel) | -->

## 📜 License

BSD 3-Clause "New" or "Revised" License © 2025 RequieMa

Full text at [LICENSE](LICENSE)

## 🚧 Maintenance Status
Basic functionalities are under development.

Please report issues via [GitHub Issues](https://github.com/RequieMa/image_hashing/issues)