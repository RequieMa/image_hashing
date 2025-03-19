import "package:image_hashing/image_hashing.dart";
import "package:test/test.dart";

void main() {
  group("Hex Hamming Distance Tests", () {
    test("Identical all-zero hashes", () {
      expect(
        hammingDistance("0000000000000000", "0000000000000000"),
        equals(0),
      );
    });

    test("Identical random hashes", () {
      expect(
        hammingDistance("0123456789abcdef", "0123456789abcdef"),
        equals(0),
      );
    });

    test("Completely different hashes", () {
      expect(
        hammingDistance("0000000000000000", "ffffffffffffffff"),
        equals(64),
      );
    });

    test("Single character difference", () {
      expect(
        hammingDistance("aaaaaaaaaaaaaaa9", "aaaaaaaaaaaaaaaa"),
        equals(2),
      ); // Hex 9(1001) vs a(1010)
    });

    test("Middle character difference", () {
      expect(
        hammingDistance("1234567812345678", "1234567892345678"),
        equals(1),
      ); // 12 vs 92
    });

    test("Case insensitivity", () {
      expect(
        hammingDistance("ABCDEF1234567890", "abcdef1234567890"),
        equals(0),
      ); // Case insensitive
    });

    test("Short input padding", () {
      expect(hammingDistance("123", "456"), equals(7));
    });

    test("Invalid character input", () {
      expect(
        () => hammingDistance("ghijklmnopqrstuv", "0000000000000000"),
        throwsA(isA<ArgumentError>()),
      );
    });
  });
}
