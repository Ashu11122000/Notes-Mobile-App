/// ============================================================================
/// File: test/mocks/mock_notes_repository.dart
/// ============================================================================
///
/// Mock Notes Repository
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// • Mock implementation of [NotesRepository].
/// • Shared across repository, provider and widget tests.
/// • Compatible with mocktail.
/// • Intentionally contains no fake request models because the application's
///   DTOs are declared as `final class`.
///
/// Usage
/// ----------------------------------------------------------------------------
///
/// final repository = MockNotesRepository();
///
/// when(
///   () => repository.getNotes(),
/// ).thenAnswer(
///   (_) async => MockData.notes,
/// );
///
/// ============================================================================

import 'package:mocktail/mocktail.dart';

import 'package:notes_app/features/notes/domain/repositories/notes_repository.dart';

/// Mock implementation of [NotesRepository].
class MockNotesRepository extends Mock implements NotesRepository {}
