/// Global settings for Modulisto core behavior.
///
/// Allows toggling debug features and runtime checks.
library;

abstract final class ModulistoSettings {
  /// If true, reports type mismatches in operation triggers during debug.
  static bool debugReportOperationTypeMismatch = true;
}
