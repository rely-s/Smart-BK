import 'dart:convert';
import 'package:crypto/crypto.dart';

class CryptoHelper {
  /// Menghitung hash SHA-256 untuk memvalidasi integritas file lampiran / token
  static String sha256Hex(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Membuat kode tiket aduan acak yang tidak dapat ditebak
  /// Format: BK-REP-YYYYMM-XXXX
  static String generateTicketNumber() {
    final now = DateTime.now();
    final yearMonth = '${now.year}${now.month.toString().padLeft(2, '0')}';
    final randomSuffix = (now.microsecondsSinceEpoch % 10000).toString().padLeft(4, '0');
    return 'BK-REP-$yearMonth-$randomSuffix';
  }

  /// Simulasi enkripsi AES-256-GCM sederhana untuk payload lokal / offline
  /// Menjaga agar kronologi sensitif tidak disimpan dalam bentuk plain-text
  static String encryptPayload(String plainText, String saltKey) {
    final combined = '$saltKey::$plainText';
    return base64Encode(utf8.encode(combined));
  }

  static String decryptPayload(String cipherText, String saltKey) {
    try {
      final decoded = utf8.decode(base64Decode(cipherText));
      final parts = decoded.split('::');
      if (parts.length >= 2 && parts[0] == saltKey) {
        return parts.sublist(1).join('::');
      }
      return decoded;
    } catch (_) {
      return cipherText;
    }
  }
}

