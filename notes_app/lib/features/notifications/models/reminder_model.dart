import 'package:flutter/foundation.dart';

/// ============================================================================
/// File: reminder_model.dart
/// ============================================================================
///
/// Reminder Model
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// • Represents a locally scheduled notification reminder.
/// • Stores notification scheduling information.
/// • Supports local persistence.
/// • Provides immutable reminder state.
///
/// Notes
/// ----------------------------------------------------------------------------
/// This model belongs ONLY to the Flutter application.
///
/// It is NOT:
/// - Sent to FastAPI.
/// - Stored in PostgreSQL.
///
/// It is used by:
/// - ReminderManager.
/// - NotificationService.
/// - Local storage.
///
/// ============================================================================

@immutable
final class ReminderModel {
  const ReminderModel({
    required this.notificationId,
    required this.noteId,
    required this.title,
    required this.body,
    required this.scheduledAt,
    this.payload,
    this.isEnabled = true,
    this.repeatDaily = false,
  });

  // ===========================================================================
  // Fields
  // ===========================================================================

  /// Unique notification identifier.
  ///
  /// Required by flutter_local_notifications.
  final int notificationId;

  /// Related note identifier.
  final int noteId;

  /// Notification title.
  final String title;

  /// Notification message body.
  final String body;

  /// Scheduled notification date/time.
  final DateTime scheduledAt;

  /// Optional navigation payload.
  ///
  /// Example:
  /// "note/12"
  final String? payload;

  /// Whether this reminder is active.
  final bool isEnabled;

  /// Whether reminder repeats daily.
  final bool repeatDaily;

  // ===========================================================================
  // Computed Properties
  // ===========================================================================

  /// Returns true when reminder time has passed.
  bool get isExpired => scheduledAt.isBefore(DateTime.now());

  /// Returns true when reminder is in future.
  bool get isUpcoming => scheduledAt.isAfter(DateTime.now());

  /// Alias for readability.
  bool get isPast => isExpired;

  /// Alias for readability.
  bool get isFuture => isUpcoming;

  /// Basic validation.
  bool get isValid => title.trim().isNotEmpty && body.trim().isNotEmpty;

  /// Human readable date.
  String get formattedDateTime =>
      '${scheduledAt.day}/'
      '${scheduledAt.month}/'
      '${scheduledAt.year} '
      '${scheduledAt.hour}:'
      '${scheduledAt.minute.toString().padLeft(2, '0')}';

  // ===========================================================================
  // JSON
  // ===========================================================================

  factory ReminderModel.fromJson(Map<String, dynamic> json) {
    return ReminderModel(
      notificationId: (json['notification_id'] as num?)?.toInt() ?? 0,

      noteId: (json['note_id'] as num?)?.toInt() ?? 0,

      title: json['title'] as String? ?? '',

      body: json['body'] as String? ?? '',

      scheduledAt:
          DateTime.tryParse(json['scheduled_at'] as String? ?? '') ??
          DateTime.now(),

      payload: json['payload'] as String?,

      isEnabled: json['is_enabled'] as bool? ?? true,

      repeatDaily: json['repeat_daily'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'notification_id': notificationId,

      'note_id': noteId,

      'title': title,

      'body': body,

      'scheduled_at': scheduledAt.toIso8601String(),

      'payload': payload,

      'is_enabled': isEnabled,

      'repeat_daily': repeatDaily,
    };
  }

  // ===========================================================================
  // Copy With
  // ===========================================================================

  ReminderModel copyWith({
    int? notificationId,
    int? noteId,
    String? title,
    String? body,
    DateTime? scheduledAt,
    String? payload,
    bool? isEnabled,
    bool? repeatDaily,
  }) {
    return ReminderModel(
      notificationId: notificationId ?? this.notificationId,

      noteId: noteId ?? this.noteId,

      title: title ?? this.title,

      body: body ?? this.body,

      scheduledAt: scheduledAt ?? this.scheduledAt,

      payload: payload ?? this.payload,

      isEnabled: isEnabled ?? this.isEnabled,

      repeatDaily: repeatDaily ?? this.repeatDaily,
    );
  }

  // ===========================================================================
  // Equality
  // ===========================================================================

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ReminderModel &&
            runtimeType == other.runtimeType &&
            notificationId == other.notificationId &&
            noteId == other.noteId &&
            title == other.title &&
            body == other.body &&
            scheduledAt == other.scheduledAt &&
            payload == other.payload &&
            isEnabled == other.isEnabled &&
            repeatDaily == other.repeatDaily;
  }

  @override
  int get hashCode => Object.hash(
    notificationId,
    noteId,
    title,
    body,
    scheduledAt,
    payload,
    isEnabled,
    repeatDaily,
  );

  // ===========================================================================
  // Debug
  // ===========================================================================

  @override
  String toString() {
    return 'ReminderModel('
        'notificationId: $notificationId, '
        'noteId: $noteId, '
        'title: $title, '
        'body: $body, '
        'scheduledAt: $scheduledAt, '
        'payload: $payload, '
        'isEnabled: $isEnabled, '
        'repeatDaily: $repeatDaily'
        ')';
  }
}
