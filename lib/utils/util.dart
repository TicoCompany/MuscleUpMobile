final class Util {
  /// #region Config
  static const String extensionPNG = 'png';
  static const String extensionJPG = 'jpg';
  static const String extensionPDF = 'pdf';
  static const String directoryMedia = 'media';

  static String generateRandomCode() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}
