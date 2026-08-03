import 'package:flutter/foundation.dart';

/// ============================================================================
/// File: reminder_model.dart
/// ============================================================================
///
/// Enterprise Reminder Model
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// • Represents a locally scheduled notification.
/// • Stores scheduling metadata.
/// • Supports JSON serialization.
/// • Supports immutable state.
/// • Optimized for Flutter Stable.
///
/// Notes
/// ----------------------------------------------------------------------------
/// • Used only by Flutter.
/// • Never sent to FastAPI.
/// • Never stored in PostgreSQL.
/// • Used by NotificationService and ReminderManager.
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

  /// Local notification identifier.
  final int notificationId;

  /// Related note identifier.
  final int noteId;

  /// Notification title.
  final String title;

  /// Notification body.
  final String body;

  /// Scheduled notification date/time.
  final DateTime scheduledAt;

  /// Optional navigation payload.
  final String? payload;

  /// Whether reminder is enabled.
  final bool isEnabled;

  /// Whether reminder repeats every day.
  final bool repeatDaily;

  // ===========================================================================
  // Computed Properties
  // ===========================================================================

  /// Returns the normalized title.
  String get normalizedTitle => title.trim();

  /// Returns the normalized body.
  String get normalizedBody => body.trim();

  /// Returns true if payload exists.
  bool get hasPayload => payload != null && payload!.trim().isNotEmpty;

  /// Returns true if reminder repeats.
  bool get isRepeating => repeatDaily;

  /// Returns true if reminder is enabled.
  bool get isActive => isEnabled;

  /// Returns true when reminder contains valid data.
  bool get isValid => normalizedTitle.isNotEmpty && normalizedBody.isNotEmpty;

  /// Returns true when reminder time is in the past.
  bool get isExpired {
    final DateTime now = DateTime.now();
    return scheduledAt.isBefore(now);
  }

  /// Returns true when reminder is scheduled in the future.
  bool get isUpcoming {
    final DateTime now = DateTime.now();
    return scheduledAt.isAfter(now);
  }

  /// Readability alias.
  bool get isPast => isExpired;

  /// Readability alias.
  bool get isFuture => isUpcoming;

  /// Human-readable date.
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
    final DateTime scheduled =
        DateTime.tryParse(json['scheduled_at'] as String? ?? '') ??
        DateTime.now();

    return ReminderModel(
      notificationId: (json['notification_id'] as num?)?.toInt() ?? 0,

      noteId: (json['note_id'] as num?)?.toInt() ?? 0,

      title: (json['title'] as String? ?? '').trim(),

      body: (json['body'] as String? ?? '').trim(),

      scheduledAt: scheduled,

      payload: (json['payload'] as String?)?.trim(),

      isEnabled: json['is_enabled'] as bool? ?? true,

      repeatDaily: json['repeat_daily'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'notification_id': notificationId,
      'note_id': noteId,
      'title': normalizedTitle,
      'body': normalizedBody,
      'scheduled_at': scheduledAt.toIso8601String(),
      'payload': hasPayload ? payload!.trim() : null,
      'is_enabled': isEnabled,
      'repeat_daily': repeatDaily,
    };
  }

  // ===========================================================================
  // Copy With
  // ===========================================================================

  /// Creates a copy of this reminder.
  ///
  /// Set [clearPayload] to true to remove the payload.
  ReminderModel copyWith({
    int? notificationId,
    int? noteId,
    String? title,
    String? body,
    DateTime? scheduledAt,
    String? payload,
    bool clearPayload = false,
    bool? isEnabled,
    bool? repeatDaily,
  }) {
    return ReminderModel(
      notificationId: notificationId ?? this.notificationId,
      noteId: noteId ?? this.noteId,
      title: title ?? this.title,
      body: body ?? this.body,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      payload: clearPayload ? null : (payload ?? this.payload),
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
