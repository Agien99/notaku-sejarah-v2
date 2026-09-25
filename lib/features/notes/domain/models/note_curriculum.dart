class NoteCurriculum {
  const NoteCurriculum({
    required this.code,
    required this.label,
    required this.effectiveYear,
    required this.contentVersion,
    required this.reviewedOn,
  });

  final String code;
  final String label;
  final int effectiveYear;
  final String contentVersion;
  final String reviewedOn;

  String get displayLabel => '$label · $effectiveYear';
}

const kssm2026 = NoteCurriculum(
  code: 'KSSM',
  label: 'KSSM',
  effectiveYear: 2026,
  contentVersion: '2026.1',
  reviewedOn: '25 September 2026',
);
