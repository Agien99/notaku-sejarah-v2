import '../domain/models/note_form.dart';
import 'note_seed_data.dart';

abstract interface class NoteRepository {
  List<NoteForm> getForms();

  NoteForm? getForm(int level);
}

class LocalNoteRepository implements NoteRepository {
  const LocalNoteRepository();

  @override
  List<NoteForm> getForms() => List<NoteForm>.unmodifiable(noteForms);

  @override
  NoteForm? getForm(int level) {
    for (final form in noteForms) {
      if (form.level == level) {
        return form;
      }
    }

    return null;
  }
}
