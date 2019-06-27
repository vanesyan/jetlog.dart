/// This package library provides a global logger.
///
/// To use this library in your code:
///
/// ```dart
/// import 'package:structlog/global_logger.dart';
/// ```
///
/// Severity level of global logger is set to [Level.debug], logging record
/// handler is set to [ConsoleHandler] with default formatting to text
/// using [TextFormatter.defaultFormatter].
library structlog.global_logger;

import 'package:structlog/handlers.dart' show ConsoleHandler;
import 'package:structlog/formatters.dart' show TextFormatter;
import 'package:structlog/structlog.dart';

final Logger _logger = Logger.detached()
  ..level = Level.debug
  ..handler = ConsoleHandler(formatter: TextFormatter.defaultFormatter);

/// Retrieves minimum severity level global logger allows a [Record] to be emitted
/// by it.
///
/// See more [Logger.level] getter.
Level get level => _logger.level;

/// Sets a minimum severity level of a [Record] to be emitted by global logger.
///
/// See more [Logger.level] setter.
set level(Level level) => _logger.level = level;

/// Sets global logger logs handler.
///
/// See more [Logger.handler] setter.
set handler(Handler handler) => _logger.handler = handler;

/// Set global logger filter.
///
/// See more [Logger.filter] setter.
set filter(Filter filter) => _logger.filter = filter;

/// Emits a record with [message] and [level] severity level.
///
/// See more [Interface.log].
void log(Level level, String message) => _logger.log(level, message);

/// Emits a record with [message] and [Level.debug] severity level.
///
/// See more [Interface.debug].
void debug(String message) => _logger.debug(message);

/// Starts tracing and emits a record with [message] and [Level.trace]
/// severity level; to stop tracing call [Tracer.stop] on the returned tracer.
///
/// See more [Interface.trace].
Tracer trace(String message) => _logger.trace(message);

/// Emits a record with [message] and [Level.info] severity level.
///
/// See more [Interface.info].
void info(String message) => _logger.info(message);

/// Emits a record with [message] and [Level.warning] severity level.
///
/// See more [Interface.warning].
void warning(String message) => _logger.warning(message);

/// Emits a record with [message] and [Level.danger] severity level.
///
/// See more [Interface.danger].
void danger(String message) => _logger.danger(message);

/// Emits a record with [message] and [Level.fatal] severity level.
///
/// See more [Interface.fatal].
void fatal(String message) => _logger.fatal(message);

/// Creates and returns a new logging context with bound [fields]
/// added to existing one.
///
/// See more [Interface.bind].
Interface bind([Iterable<Field> fields]) => _logger.bind(fields);