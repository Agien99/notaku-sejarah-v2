import '../domain/models/note_chapter.dart';
import '../domain/models/note_curriculum.dart';
import '../domain/models/note_form.dart';

const noteForms = <NoteForm>[
  NoteForm(
    level: 1,
    theme: 'Sejarah Kita dan Dunia',
    isAvailable: true,
    curriculum: kssm2026,
    chapters: [
      NoteChapter(
        number: 1,
        title: 'Mengenali Sejarah',
        contentAsset: 'assets/notes/kssm_2026/t1_b01.json',
      ),
      NoteChapter(
        number: 2,
        title: 'Zaman Air Batu',
        contentAsset: 'assets/notes/kssm_2026/t1_b02.json',
      ),
      NoteChapter(
        number: 3,
        title: 'Zaman Prasejarah',
        contentAsset: 'assets/notes/kssm_2026/t1_b03.json',
      ),
      NoteChapter(
        number: 4,
        title: 'Mengenali Tamadun',
        contentAsset: 'assets/notes/kssm_2026/t1_b04.json',
      ),
      NoteChapter(
        number: 5,
        title: 'Tamadun Awal Dunia',
        contentAsset: 'assets/notes/kssm_2026/t1_b05.json',
      ),
      NoteChapter(
        number: 6,
        title: 'Peningkatan Tamadun Yunani dan Rom',
        contentAsset: 'assets/notes/kssm_2026/t1_b06.json',
      ),
      NoteChapter(
        number: 7,
        title: 'Peningkatan Tamadun India dan China',
        contentAsset: 'assets/notes/kssm_2026/t1_b07.json',
      ),
      NoteChapter(
        number: 8,
        title: 'Tamadun Islam dan Sumbangannya',
        contentAsset: 'assets/notes/kssm_2026/t1_b08.json',
      ),
    ],
  ),
  NoteForm(
    level: 2,
    theme: 'Warisan Negara',
    isAvailable: true,
    curriculum: kssm2026,
    chapters: [
      NoteChapter(
        number: 1,
        title: 'Kerajaan Alam Melayu',
        contentAsset: 'assets/notes/kssm_2026/t2_b01.json',
      ),
      NoteChapter(
        number: 2,
        title: 'Sistem Pemerintahan dan Kegiatan Ekonomi Masyarakat Kerajaan Alam Melayu',
        contentAsset: 'assets/notes/kssm_2026/t2_b02.json',
      ),
      NoteChapter(
        number: 3,
        title: 'Sosiobudaya Masyarakat Kerajaan Alam Melayu',
        contentAsset: 'assets/notes/kssm_2026/t2_b03.json',
      ),
      NoteChapter(
        number: 4,
        title: 'Agama, Kepercayaan dan Keunikan Warisan Masyarakat Kerajaan Alam Melayu',
        contentAsset: 'assets/notes/kssm_2026/t2_b04.json',
      ),
      NoteChapter(
        number: 5,
        title: 'Kesultanan Melayu Melaka',
        contentAsset: 'assets/notes/kssm_2026/t2_b05.json',
      ),
      NoteChapter(
        number: 6,
        title: 'Kesultanan Johor Riau',
        contentAsset: 'assets/notes/kssm_2026/t2_b06.json',
      ),
      NoteChapter(
        number: 7,
        title: 'Kesultanan Melayu Pahang, Perak, Terengganu dan Selangor',
        contentAsset: 'assets/notes/kssm_2026/t2_b07.json',
      ),
      NoteChapter(
        number: 8,
        title: 'Kerajaan Kedah, Kelantan, Negeri Sembilan dan Perlis',
        contentAsset: 'assets/notes/kssm_2026/t2_b08.json',
      ),
      NoteChapter(
        number: 9,
        title: 'Warisan Kerajaan Kedah, Kelantan, Negeri Sembilan dan Perlis',
        contentAsset: 'assets/notes/kssm_2026/t2_b09.json',
      ),
      NoteChapter(
        number: 10,
        title: 'Sarawak dan Sabah',
        contentAsset: 'assets/notes/kssm_2026/t2_b10.json',
      ),
    ],
  ),
  NoteForm(
    level: 3,
    theme: 'Kedatangan Kuasa Asing',
    isAvailable: true,
    curriculum: kssm2026,
    chapters: [
      NoteChapter(
        number: 1,
        title: 'Kedatangan Kuasa Barat',
        contentAsset: 'assets/notes/kssm_2026/t3_b01.json',
      ),
      NoteChapter(
        number: 2,
        title: 'Pentadbiran Negeri-negeri Selat',
        contentAsset: 'assets/notes/kssm_2026/t3_b02.json',
      ),
      NoteChapter(
        number: 3,
        title: 'Pentadbiran Negeri-negeri Melayu Bersekutu',
        contentAsset: 'assets/notes/kssm_2026/t3_b03.json',
      ),
      NoteChapter(
        number: 4,
        title: 'Pentadbiran Negeri-negeri Melayu Tidak Bersekutu',
        contentAsset: 'assets/notes/kssm_2026/t3_b04.json',
      ),
      NoteChapter(
        number: 5,
        title: 'Pentadbiran Barat di Sarawak dan Sabah',
        contentAsset: 'assets/notes/kssm_2026/t3_b05.json',
      ),
      NoteChapter(
        number: 6,
        title: 'Kesan Pentadbiran Barat Terhadap Ekonomi dan Sosial',
        contentAsset: 'assets/notes/kssm_2026/t3_b06.json',
      ),
      NoteChapter(
        number: 7,
        title: 'Penentangan Masyarakat Tempatan',
        contentAsset: 'assets/notes/kssm_2026/t3_b07.json',
      ),
      NoteChapter(
        number: 8,
        title: 'Kebijaksanaan Raja dan Pembesar Melayu Menangani Cabaran Barat',
        contentAsset: 'assets/notes/kssm_2026/t3_b08.json',
      ),
    ],
  ),
  NoteForm(
    level: 4,
    theme: 'Pembinaan Negara',
    isAvailable: true,
    curriculum: kssm2026,
    chapters: [
      NoteChapter(
        number: 1,
        title: 'Warisan Negara Bangsa',
        contentAsset: 'assets/notes/kssm_2026/t4_b01.json',
      ),
      NoteChapter(
        number: 2,
        title: 'Kebangkitan Nasionalisme',
        contentAsset: 'assets/notes/kssm_2026/t4_b02.json',
      ),
      NoteChapter(
        number: 3,
        title: 'Konflik Dunia dan Pendudukan Jepun di Negara Kita',
        contentAsset: 'assets/notes/kssm_2026/t4_b03.json',
      ),
      NoteChapter(
        number: 4,
        title: 'Era Peralihan Kuasa British di Negara Kita',
        contentAsset: 'assets/notes/kssm_2026/t4_b04.json',
      ),
      NoteChapter(
        number: 5,
        title: 'Persekutuan Tanah Melayu 1948',
        contentAsset: 'assets/notes/kssm_2026/t4_b05.json',
      ),
      NoteChapter(
        number: 6,
        title: 'Ancaman Komunis dan Perisytiharan Darurat',
        contentAsset: 'assets/notes/kssm_2026/t4_b06.json',
      ),
      NoteChapter(
        number: 7,
        title: 'Usaha ke Arah Kemerdekaan',
        contentAsset: 'assets/notes/kssm_2026/t4_b07.json',
      ),
      NoteChapter(
        number: 8,
        title: 'Pilihan Raya',
        contentAsset: 'assets/notes/kssm_2026/t4_b08.json',
      ),
      NoteChapter(
        number: 9,
        title: 'Perlembagaan Persekutuan Tanah Melayu 1957',
        contentAsset: 'assets/notes/kssm_2026/t4_b09.json',
      ),
      NoteChapter(
        number: 10,
        title: 'Pemasyhuran Kemerdekaan',
        contentAsset: 'assets/notes/kssm_2026/t4_b10.json',
      ),
    ],
  ),
  NoteForm(
    level: 5,
    theme: 'Malaysia dan Masa Hadapan',
    isAvailable: true,
    curriculum: kssm2026,
    chapters: [
      NoteChapter(
        number: 1,
        title: 'Kedaulatan Negara',
        contentAsset: 'assets/notes/kssm_2026/t5_b01.json',
      ),
      NoteChapter(
        number: 2,
        title: 'Perlembagaan Persekutuan',
        contentAsset: 'assets/notes/kssm_2026/t5_b02.json',
      ),
      NoteChapter(
        number: 3,
        title: 'Raja Berperlembagaan dan Demokrasi Berparlimen',
        contentAsset: 'assets/notes/kssm_2026/t5_b03.json',
      ),
      NoteChapter(
        number: 4,
        title: 'Sistem Persekutuan',
        contentAsset: 'assets/notes/kssm_2026/t5_b04.json',
      ),
      NoteChapter(
        number: 5,
        title: 'Pembentukan Malaysia',
        contentAsset: 'assets/notes/kssm_2026/t5_b05.json',
      ),
      NoteChapter(
        number: 6,
        title: 'Cabaran Selepas Pembentukan Malaysia',
        contentAsset: 'assets/notes/kssm_2026/t5_b06.json',
      ),
      NoteChapter(
        number: 7,
        title: 'Membina Kesejahteraan Negara',
        contentAsset: 'assets/notes/kssm_2026/t5_b07.json',
      ),
      NoteChapter(
        number: 8,
        title: 'Membina Kemakmuran Negara',
        contentAsset: 'assets/notes/kssm_2026/t5_b08.json',
      ),
      NoteChapter(
        number: 9,
        title: 'Dasar Luar Malaysia',
        contentAsset: 'assets/notes/kssm_2026/t5_b09.json',
      ),
      NoteChapter(
        number: 10,
        title: 'Kecemerlangan Malaysia di Persada Dunia',
        contentAsset: 'assets/notes/kssm_2026/t5_b10.json',
      ),
    ],
  ),
];
