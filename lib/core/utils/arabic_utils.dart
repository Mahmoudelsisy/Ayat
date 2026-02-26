class ArabicUtils {
  static String normalize(String text) {
    if (text.isEmpty) return text;

    // Remove Tashkeel
    final tashkeelRegex = RegExp(r'[\u064B-\u0652\u0653\u0654\u0655]');
    var normalized = text.replaceAll(tashkeelRegex, '');

    // Normalize Alif
    normalized = normalized.replaceAll(RegExp(r'[أإآ]'), 'ا');

    // Normalize Ya
    normalized = normalized.replaceAll(RegExp(r'[ى]'), 'ي');

    // Normalize Ha
    normalized = normalized.replaceAll(RegExp(r'[ة]'), 'ه');

    return normalized;
  }

  static bool containsNormalized(String text, String query) {
    return normalize(text).contains(normalize(query));
  }
}
