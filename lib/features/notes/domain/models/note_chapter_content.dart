class NoteChapterContent {
  const NoteChapterContent({
    required this.curriculum,
    required this.contentVersion,
    required this.reviewedOn,
    required this.form,
    required this.chapter,
    required this.title,
    required this.overview,
    required this.keywords,
    required this.sections,
    required this.keyFacts,
    required this.summary,
  });

  factory NoteChapterContent.fromJson(Map<String, dynamic> json) {
    return NoteChapterContent(
      curriculum: json['curriculum'] as String,
      contentVersion: json['contentVersion'] as String,
      reviewedOn: json['reviewedOn'] as String,
      form: json['form'] as int,
      chapter: json['chapter'] as int,
      title: json['title'] as String,
      overview: json['overview'] as String,
      keywords: _stringList(json['keywords']),
      sections: (json['sections'] as List<dynamic>)
          .map(
            (item) => NoteSection.fromJson(item as Map<String, dynamic>),
          )
          .toList(growable: false),
      keyFacts: _stringList(json['keyFacts']),
      summary: _stringList(json['summary']),
    );
  }

  final String curriculum;
  final String contentVersion;
  final String reviewedOn;
  final int form;
  final int chapter;
  final String title;
  final String overview;
  final List<String> keywords;
  final List<NoteSection> sections;
  final List<String> keyFacts;
  final List<String> summary;
}

class NoteSection {
  const NoteSection({
    required this.id,
    required this.title,
    required this.intro,
    required this.points,
  });

  factory NoteSection.fromJson(Map<String, dynamic> json) {
    return NoteSection(
      id: json['id'] as String,
      title: json['title'] as String,
      intro: json['intro'] as String,
      points: _stringList(json['points']),
    );
  }

  final String id;
  final String title;
  final String intro;
  final List<String> points;
}

List<String> _stringList(Object? value) {
  return (value as List<dynamic>).cast<String>().toList(growable: false);
}
