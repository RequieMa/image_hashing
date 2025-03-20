/// Computes Hamming distance between two hexadecimal hash strings
///
/// The Hamming distance measures the number of differing bits between two
/// equal-length binary representations of hexadecimal hash values. This
/// implementation:
/// 1. Validates input hex format
/// 2. Converts hex to binary with zero-padding
/// 3. Performs XOR operation on binary values
/// 4. Counts differing bits via 1's in XOR result
///
/// [a]: First hexadecimal string (case-insensitive)
/// [b]: Second hexadecimal string (case-insensitive)
/// [size]: Target bit-length for binary conversion (default 64-bit)
/// 
/// Returns number of differing bits (Hamming distance)
/// 
/// Throws [ArgumentError] if:
/// - Inputs contain non-hex characters 
int hammingDistance(String a, String b, {int size = 64}) {
  _validateHex(a);
  _validateHex(b);
  final hash1Bin = BigInt.parse(
    a,
    radix: 16,
  ).toRadixString(2).padLeft(size, "0");
  final hash2Bin = BigInt.parse(
    b,
    radix: 16,
  ).toRadixString(2).padLeft(size, "0");
  final bigInt1 = BigInt.parse(hash1Bin, radix: 2);
  final bigInt2 = BigInt.parse(hash2Bin, radix: 2);

  final xorResult = bigInt1 ^ bigInt2;
  return xorResult.toRadixString(2).replaceAll("0", "").length;
}

/// Validates hexadecimal string format
/// 
/// Ensures input only contains valid hex characters (0-9, a-f, A-F)
/// 
/// [hex]: String to validate
/// 
/// Throws [ArgumentError] if invalid characters found 
void _validateHex(String hex) {
  if (!RegExp(r"^[0-9a-fA-F]+$").hasMatch(hex)) {
    throw ArgumentError("Invalid hex characters");
  }
}
