import 'package:flutter/material.dart';

// Global locale controller. Set `value` to override the system locale.
// Setting null restores automatic system-locale detection.
final localeController = ValueNotifier<Locale?>(null);
