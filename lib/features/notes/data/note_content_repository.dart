import 'dart:convert';

import 'package:flutter/services.dart';

import '../domain/models/note_chapter.dart';
import '../domain/models/note_chapter_content.dart';

abstract interface class NoteContentRepository {
  Future<NoteChapterContent> load(NoteChapter chapter);
}

class AssetNoteContentRepository implements NoteContentRepository {
  const AssetNoteContentRepository();

  @override
  Future<NoteChapterContent> load(NoteChapter chapter) async {
    final raw = await rootBundle.loadString(chapter.contentAsset);
    final json = jsonDecode(raw) as Map<String, dynamic>;

    return NoteChapterContent.fromJson(json);
  }
}
