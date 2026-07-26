/// ============================================================================
/// File: reminder_model.dart
/// ============================================================================
///
/// Reminder Model
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// - Represents a locally scheduled reminder.
/// - Stores all information required to schedule/cancel notifications.
/// - Supports JSON serialization for local persistence.
/// - Immutable data model.
///
/// Notes
/// ----------------------------------------------------------------------------
/// This model is local to the device. It is NOT sent to the FastAPI backend.
/// It is stored locally and used by NotificationService to schedule reminders.
///
/// ============================================================================

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

  /// Unique notification identifier.
  ///
  /// Used by flutter_local_notifications.
  final int notificationId;

  /// Associated note identifier.
  final int noteId;

  /// Notification title.
  final String title;

  /// Notification body.
  final String body;

  /// Date & time when the notification should fire.
  final DateTime scheduledAt;

  /// Optional payload.
  ///
  /// Used to open the corresponding note when the notification is tapped.
  final String? payload;

  /// Whether the reminder is enabled.
  final bool isEnabled;

  /// Whether the reminder should repeat every day.
  ///
  /// Stretch Goal support.
  final bool repeatDaily;

  // ===========================================================================
  // Convenience Getters
  // ===========================================================================

  /// Returns true if the reminder time has already passed.
  bool get isExpired => scheduledAt.isBefore(DateTime.now());

  /// Returns true if the reminder is scheduled in the future.
  bool get isUpcoming => scheduledAt.isAfter(DateTime.now());

  // ===========================================================================
  // JSON Serialization
  // ===========================================================================

  factory ReminderModel.fromJson(Map<String, dynamic> json) {
    return ReminderModel(
      notificationId: (json['notification_id'] as num).toInt(),
      noteId: (json['note_id'] as num).toInt(),
      title: json['title'] as String,
      body: json['body'] as String,
      scheduledAt: DateTime.parse(json['scheduled_at'] as String),
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
    if (identical(this, other)) {
      return true;
    }

    return other is ReminderModel &&
        other.notificationId == notificationId &&
        other.noteId == noteId &&
        other.title == title &&
        other.body == body &&
        other.scheduledAt == scheduledAt &&
        other.payload == payload &&
        other.isEnabled == isEnabled &&
        other.repeatDaily == repeatDaily;
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
