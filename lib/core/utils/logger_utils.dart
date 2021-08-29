import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class LoggerUtil extends Logger {
  LogPrinter? printer;
  Level? level;

  LoggerUtil({
    @required this.printer,
    @required this.level,
  }) : super(
    printer: printer,
    level: level,
  );

  void error(dynamic message, [dynamic error, StackTrace? stackTrace]) =>
      e('[ERROR] $message', error, stackTrace);

  void warn(dynamic message, [dynamic error, StackTrace? stackTrace]) =>
      w('[WARN] $message', error, stackTrace);

  void info(dynamic message) => i('[INFO] $message');

  void debug(dynamic message, [dynamic error, StackTrace? stackTrace]) =>
      d('[DEBUG] $message', error, stackTrace);

  void verbose(dynamic message) => v('[VERBOSE]\n$message');

  static Level logLevel() {
    if (kReleaseMode) {
      return Level.nothing;
    }
    return Level.verbose;
  }
}

LoggerUtil LOG = LoggerUtil(
  printer: PrettyPrinter(
    methodCount: 0,
    lineLength: 150,
    printTime: true,
    printEmojis: false,
  ),
  level: LoggerUtil.logLevel(),
);
