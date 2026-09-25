import '../domain/models/note_chapter.dart';
import '../domain/models/note_form.dart';

const noteForms = <NoteForm>[
  NoteForm(
    level: 1,
    theme: 'Sejarah Kita dan Dunia',
    isAvailable: true,
    documentAsset: 'assets/notes/tingkatan_1.pdf',
    chapters: [
      NoteChapter(
        number: 1,
        title: 'Mengenali Sejarah',
        printedPage: 2,
        initialPageNumber: 13,
      ),
      NoteChapter(
        number: 2,
        title: 'Zaman Air Batu',
        printedPage: 24,
        initialPageNumber: 35,
      ),
      NoteChapter(
        number: 3,
        title: 'Zaman Prasejarah',
        printedPage: 44,
        initialPageNumber: 55,
      ),
      NoteChapter(
        number: 4,
        title: 'Mengenali Tamadun',
        printedPage: 74,
        initialPageNumber: 85,
      ),
      NoteChapter(
        number: 5,
        title: 'Tamadun Awal Dunia',
        printedPage: 90,
        initialPageNumber: 101,
      ),
      NoteChapter(
        number: 6,
        title: 'Peningkatan Tamadun Yunani dan Rom',
        printedPage: 116,
        initialPageNumber: 127,
      ),
      NoteChapter(
        number: 7,
        title: 'Peningkatan Tamadun India dan China',
        printedPage: 138,
        initialPageNumber: 149,
      ),
      NoteChapter(
        number: 8,
        title: 'Tamadun Islam dan Sumbangannya',
        printedPage: 158,
        initialPageNumber: 169,
      ),
    ],
  ),
  NoteForm(
    level: 2,
    theme: 'Warisan Negara',
    isAvailable: true,
    documentAsset: 'assets/notes/tingkatan_2.pdf',
    chapters: [
      NoteChapter(
        number: 1,
        title: 'Kerajaan Alam Melayu',
        printedPage: 2,
        initialPageNumber: 10,
      ),
      NoteChapter(
        number: 2,
        title: 'Sistem Pemerintahan dan Kegiatan Ekonomi Masyarakat Kerajaan Alam Melayu',
        printedPage: 24,
        initialPageNumber: 32,
      ),
      NoteChapter(
        number: 3,
        title: 'Sosiobudaya Masyarakat Kerajaan Alam Melayu',
        printedPage: 38,
        initialPageNumber: 46,
      ),
      NoteChapter(
        number: 4,
        title: 'Agama, Kepercayaan dan Keunikan Warisan Masyarakat Kerajaan Alam Melayu',
        printedPage: 54,
        initialPageNumber: 62,
      ),
      NoteChapter(
        number: 5,
        title: 'Kesultanan Melayu Melaka',
        printedPage: 70,
        initialPageNumber: 78,
      ),
      NoteChapter(
        number: 6,
        title: 'Kesultanan Johor Riau',
        printedPage: 96,
        initialPageNumber: 104,
      ),
      NoteChapter(
        number: 7,
        title: 'Kesultanan Melayu Pahang, Perak, Terengganu dan Selangor',
        printedPage: 114,
        initialPageNumber: 122,
      ),
      NoteChapter(
        number: 8,
        title: 'Kerajaan Kedah, Kelantan, Negeri Sembilan dan Perlis',
        printedPage: 136,
        initialPageNumber: 144,
      ),
      NoteChapter(
        number: 9,
        title: 'Warisan Kerajaan Kedah, Kelantan, Negeri Sembilan dan Perlis',
        printedPage: 156,
        initialPageNumber: 164,
      ),
      NoteChapter(
        number: 10,
        title: 'Sarawak dan Sabah',
        printedPage: 176,
        initialPageNumber: 184,
      ),
    ],
  ),
  NoteForm(
    level: 3,
    theme: 'Kedatangan Kuasa Asing',
    isAvailable: true,
    documentAsset: 'assets/notes/tingkatan_3.pdf',
    chapters: [
      NoteChapter(
        number: 1,
        title: 'Kedatangan Kuasa Barat',
        printedPage: 2,
        initialPageNumber: 14,
      ),
      NoteChapter(
        number: 2,
        title: 'Pentadbiran Negeri-negeri Selat',
        printedPage: 28,
        initialPageNumber: 40,
      ),
      NoteChapter(
        number: 3,
        title: 'Pentadbiran Negeri-negeri Melayu Bersekutu',
        printedPage: 56,
        initialPageNumber: 68,
      ),
      NoteChapter(
        number: 4,
        title: 'Pentadbiran Negeri-negeri Melayu Tidak Bersekutu',
        printedPage: 84,
        initialPageNumber: 96,
      ),
      NoteChapter(
        number: 5,
        title: 'Pentadbiran Barat di Sarawak dan Sabah',
        printedPage: 108,
        initialPageNumber: 120,
      ),
      NoteChapter(
        number: 6,
        title: 'Kesan Pentadbiran Barat Terhadap Ekonomi dan Sosial',
        printedPage: 136,
        initialPageNumber: 148,
      ),
      NoteChapter(
        number: 7,
        title: 'Penentangan Masyarakat Tempatan',
        printedPage: 170,
        initialPageNumber: 182,
      ),
      NoteChapter(
        number: 8,
        title: 'Kebijaksanaan Raja dan Pembesar Melayu Menangani Cabaran Barat',
        printedPage: 198,
        initialPageNumber: 210,
      ),
    ],
  ),
  NoteForm(
    level: 4,
    theme: 'Pembinaan Negara',
    isAvailable: false,
    chapters: [],
  ),
  NoteForm(
    level: 5,
    theme: 'Malaysia dan Masa Depan',
    isAvailable: false,
    chapters: [],
  ),
];
