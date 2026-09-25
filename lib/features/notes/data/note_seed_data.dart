import '../domain/models/note_chapter.dart';
import '../domain/models/note_form.dart';

const noteForms = <NoteForm>[
  NoteForm(
    level: 1,
    theme: 'Sejarah Kita dan Dunia',
    isAvailable: true,
    documentAsset: 'assets/notes/tingkatan_1.pdf',
    chapters: [
      NoteChapter(number: 1, title: 'Mengenali Sejarah'),
      NoteChapter(number: 2, title: 'Zaman Air Batu'),
      NoteChapter(number: 3, title: 'Zaman Prasejarah'),
      NoteChapter(number: 4, title: 'Mengenali Tamadun'),
      NoteChapter(number: 5, title: 'Tamadun Awal Dunia'),
      NoteChapter(number: 6, title: 'Peningkatan Tamadun Yunani dan Rom'),
      NoteChapter(number: 7, title: 'Peningkatan Tamadun India dan China'),
      NoteChapter(number: 8, title: 'Tamadun Islam dan Sumbangannya'),
    ],
  ),
  NoteForm(
    level: 2,
    theme: 'Warisan Negara',
    isAvailable: true,
    documentAsset: 'assets/notes/tingkatan_2.pdf',
    chapters: [
      NoteChapter(number: 1, title: 'Kerajaan Alam Melayu'),
      NoteChapter(
        number: 2,
        title:
            'Sistem Pemerintahan dan Kegiatan Ekonomi Masyarakat '
            'Kerajaan Alam Melayu',
      ),
      NoteChapter(
        number: 3,
        title: 'Sosiobudaya Masyarakat Kerajaan Alam Melayu',
      ),
      NoteChapter(
        number: 4,
        title:
            'Agama, Kepercayaan dan Keunikan Warisan Masyarakat '
            'Kerajaan Alam Melayu',
      ),
      NoteChapter(number: 5, title: 'Kesultanan Melayu Melaka'),
      NoteChapter(number: 6, title: 'Kesultanan Johor Riau'),
      NoteChapter(
        number: 7,
        title: 'Kesultanan Melayu Pahang, Perak, Terengganu dan Selangor',
      ),
      NoteChapter(
        number: 8,
        title: 'Kerajaan Kedah, Kelantan, Negeri Sembilan dan Perlis',
      ),
      NoteChapter(
        number: 9,
        title: 'Warisan Kerajaan Kedah, Kelantan, Negeri Sembilan dan Perlis',
      ),
      NoteChapter(number: 10, title: 'Sarawak dan Sabah'),
    ],
  ),
  NoteForm(
    level: 3,
    theme: 'Kedatangan Kuasa Asing',
    isAvailable: true,
    documentAsset: 'assets/notes/tingkatan_3.pdf',
    chapters: [
      NoteChapter(number: 1, title: 'Kedatangan Kuasa Barat'),
      NoteChapter(number: 2, title: 'Pentadbiran Negeri-negeri Selat'),
      NoteChapter(
        number: 3,
        title: 'Pentadbiran Negeri-negeri Melayu Bersekutu',
      ),
      NoteChapter(
        number: 4,
        title: 'Pentadbiran Negeri-negeri Melayu Tidak Bersekutu',
      ),
      NoteChapter(number: 5, title: 'Pentadbiran Barat di Sarawak dan Sabah'),
      NoteChapter(
        number: 6,
        title: 'Kesan Pentadbiran Barat Terhadap Ekonomi dan Sosial',
      ),
      NoteChapter(number: 7, title: 'Penentangan Masyarakat Tempatan'),
      NoteChapter(
        number: 8,
        title: 'Kebijaksanaan Raja dan Pembesar Melayu Menangani Cabaran Barat',
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
