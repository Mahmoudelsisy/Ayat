// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $QuranTable extends Quran with TableInfo<$QuranTable, QuranData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuranTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _surahNumberMeta = const VerificationMeta(
    'surahNumber',
  );
  @override
  late final GeneratedColumn<int> surahNumber = GeneratedColumn<int>(
    'surah_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ayahNumberMeta = const VerificationMeta(
    'ayahNumber',
  );
  @override
  late final GeneratedColumn<int> ayahNumber = GeneratedColumn<int>(
    'ayah_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _juzNumberMeta = const VerificationMeta(
    'juzNumber',
  );
  @override
  late final GeneratedColumn<int> juzNumber = GeneratedColumn<int>(
    'juz_number',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hizbNumberMeta = const VerificationMeta(
    'hizbNumber',
  );
  @override
  late final GeneratedColumn<int> hizbNumber = GeneratedColumn<int>(
    'hizb_number',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pageNumberMeta = const VerificationMeta(
    'pageNumber',
  );
  @override
  late final GeneratedColumn<int> pageNumber = GeneratedColumn<int>(
    'page_number',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _verseTextMeta = const VerificationMeta(
    'verseText',
  );
  @override
  late final GeneratedColumn<String> verseText = GeneratedColumn<String>(
    'verse_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _translationMeta = const VerificationMeta(
    'translation',
  );
  @override
  late final GeneratedColumn<String> translation = GeneratedColumn<String>(
    'translation',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _readingMeta = const VerificationMeta(
    'reading',
  );
  @override
  late final GeneratedColumn<String> reading = GeneratedColumn<String>(
    'reading',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('hafs'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    surahNumber,
    ayahNumber,
    juzNumber,
    hizbNumber,
    pageNumber,
    verseText,
    translation,
    reading,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'quran';
  @override
  VerificationContext validateIntegrity(
    Insertable<QuranData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('surah_number')) {
      context.handle(
        _surahNumberMeta,
        surahNumber.isAcceptableOrUnknown(
          data['surah_number']!,
          _surahNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_surahNumberMeta);
    }
    if (data.containsKey('ayah_number')) {
      context.handle(
        _ayahNumberMeta,
        ayahNumber.isAcceptableOrUnknown(data['ayah_number']!, _ayahNumberMeta),
      );
    } else if (isInserting) {
      context.missing(_ayahNumberMeta);
    }
    if (data.containsKey('juz_number')) {
      context.handle(
        _juzNumberMeta,
        juzNumber.isAcceptableOrUnknown(data['juz_number']!, _juzNumberMeta),
      );
    }
    if (data.containsKey('hizb_number')) {
      context.handle(
        _hizbNumberMeta,
        hizbNumber.isAcceptableOrUnknown(data['hizb_number']!, _hizbNumberMeta),
      );
    }
    if (data.containsKey('page_number')) {
      context.handle(
        _pageNumberMeta,
        pageNumber.isAcceptableOrUnknown(data['page_number']!, _pageNumberMeta),
      );
    }
    if (data.containsKey('verse_text')) {
      context.handle(
        _verseTextMeta,
        verseText.isAcceptableOrUnknown(data['verse_text']!, _verseTextMeta),
      );
    } else if (isInserting) {
      context.missing(_verseTextMeta);
    }
    if (data.containsKey('translation')) {
      context.handle(
        _translationMeta,
        translation.isAcceptableOrUnknown(
          data['translation']!,
          _translationMeta,
        ),
      );
    }
    if (data.containsKey('reading')) {
      context.handle(
        _readingMeta,
        reading.isAcceptableOrUnknown(data['reading']!, _readingMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  QuranData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return QuranData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      surahNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}surah_number'],
      )!,
      ayahNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ayah_number'],
      )!,
      juzNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}juz_number'],
      ),
      hizbNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}hizb_number'],
      ),
      pageNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}page_number'],
      ),
      verseText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}verse_text'],
      )!,
      translation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}translation'],
      ),
      reading: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reading'],
      )!,
    );
  }

  @override
  $QuranTable createAlias(String alias) {
    return $QuranTable(attachedDatabase, alias);
  }
}

class QuranData extends DataClass implements Insertable<QuranData> {
  final int id;
  final int surahNumber;
  final int ayahNumber;
  final int? juzNumber;
  final int? hizbNumber;
  final int? pageNumber;
  final String verseText;
  final String? translation;
  final String reading;
  const QuranData({
    required this.id,
    required this.surahNumber,
    required this.ayahNumber,
    this.juzNumber,
    this.hizbNumber,
    this.pageNumber,
    required this.verseText,
    this.translation,
    required this.reading,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['surah_number'] = Variable<int>(surahNumber);
    map['ayah_number'] = Variable<int>(ayahNumber);
    if (!nullToAbsent || juzNumber != null) {
      map['juz_number'] = Variable<int>(juzNumber);
    }
    if (!nullToAbsent || hizbNumber != null) {
      map['hizb_number'] = Variable<int>(hizbNumber);
    }
    if (!nullToAbsent || pageNumber != null) {
      map['page_number'] = Variable<int>(pageNumber);
    }
    map['verse_text'] = Variable<String>(verseText);
    if (!nullToAbsent || translation != null) {
      map['translation'] = Variable<String>(translation);
    }
    map['reading'] = Variable<String>(reading);
    return map;
  }

  QuranCompanion toCompanion(bool nullToAbsent) {
    return QuranCompanion(
      id: Value(id),
      surahNumber: Value(surahNumber),
      ayahNumber: Value(ayahNumber),
      juzNumber: juzNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(juzNumber),
      hizbNumber: hizbNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(hizbNumber),
      pageNumber: pageNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(pageNumber),
      verseText: Value(verseText),
      translation: translation == null && nullToAbsent
          ? const Value.absent()
          : Value(translation),
      reading: Value(reading),
    );
  }

  factory QuranData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return QuranData(
      id: serializer.fromJson<int>(json['id']),
      surahNumber: serializer.fromJson<int>(json['surahNumber']),
      ayahNumber: serializer.fromJson<int>(json['ayahNumber']),
      juzNumber: serializer.fromJson<int?>(json['juzNumber']),
      hizbNumber: serializer.fromJson<int?>(json['hizbNumber']),
      pageNumber: serializer.fromJson<int?>(json['pageNumber']),
      verseText: serializer.fromJson<String>(json['verseText']),
      translation: serializer.fromJson<String?>(json['translation']),
      reading: serializer.fromJson<String>(json['reading']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'surahNumber': serializer.toJson<int>(surahNumber),
      'ayahNumber': serializer.toJson<int>(ayahNumber),
      'juzNumber': serializer.toJson<int?>(juzNumber),
      'hizbNumber': serializer.toJson<int?>(hizbNumber),
      'pageNumber': serializer.toJson<int?>(pageNumber),
      'verseText': serializer.toJson<String>(verseText),
      'translation': serializer.toJson<String?>(translation),
      'reading': serializer.toJson<String>(reading),
    };
  }

  QuranData copyWith({
    int? id,
    int? surahNumber,
    int? ayahNumber,
    Value<int?> juzNumber = const Value.absent(),
    Value<int?> hizbNumber = const Value.absent(),
    Value<int?> pageNumber = const Value.absent(),
    String? verseText,
    Value<String?> translation = const Value.absent(),
    String? reading,
  }) => QuranData(
    id: id ?? this.id,
    surahNumber: surahNumber ?? this.surahNumber,
    ayahNumber: ayahNumber ?? this.ayahNumber,
    juzNumber: juzNumber.present ? juzNumber.value : this.juzNumber,
    hizbNumber: hizbNumber.present ? hizbNumber.value : this.hizbNumber,
    pageNumber: pageNumber.present ? pageNumber.value : this.pageNumber,
    verseText: verseText ?? this.verseText,
    translation: translation.present ? translation.value : this.translation,
    reading: reading ?? this.reading,
  );
  QuranData copyWithCompanion(QuranCompanion data) {
    return QuranData(
      id: data.id.present ? data.id.value : this.id,
      surahNumber: data.surahNumber.present
          ? data.surahNumber.value
          : this.surahNumber,
      ayahNumber: data.ayahNumber.present
          ? data.ayahNumber.value
          : this.ayahNumber,
      juzNumber: data.juzNumber.present ? data.juzNumber.value : this.juzNumber,
      hizbNumber: data.hizbNumber.present
          ? data.hizbNumber.value
          : this.hizbNumber,
      pageNumber: data.pageNumber.present
          ? data.pageNumber.value
          : this.pageNumber,
      verseText: data.verseText.present ? data.verseText.value : this.verseText,
      translation: data.translation.present
          ? data.translation.value
          : this.translation,
      reading: data.reading.present ? data.reading.value : this.reading,
    );
  }

  @override
  String toString() {
    return (StringBuffer('QuranData(')
          ..write('id: $id, ')
          ..write('surahNumber: $surahNumber, ')
          ..write('ayahNumber: $ayahNumber, ')
          ..write('juzNumber: $juzNumber, ')
          ..write('hizbNumber: $hizbNumber, ')
          ..write('pageNumber: $pageNumber, ')
          ..write('verseText: $verseText, ')
          ..write('translation: $translation, ')
          ..write('reading: $reading')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    surahNumber,
    ayahNumber,
    juzNumber,
    hizbNumber,
    pageNumber,
    verseText,
    translation,
    reading,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is QuranData &&
          other.id == this.id &&
          other.surahNumber == this.surahNumber &&
          other.ayahNumber == this.ayahNumber &&
          other.juzNumber == this.juzNumber &&
          other.hizbNumber == this.hizbNumber &&
          other.pageNumber == this.pageNumber &&
          other.verseText == this.verseText &&
          other.translation == this.translation &&
          other.reading == this.reading);
}

class QuranCompanion extends UpdateCompanion<QuranData> {
  final Value<int> id;
  final Value<int> surahNumber;
  final Value<int> ayahNumber;
  final Value<int?> juzNumber;
  final Value<int?> hizbNumber;
  final Value<int?> pageNumber;
  final Value<String> verseText;
  final Value<String?> translation;
  final Value<String> reading;
  const QuranCompanion({
    this.id = const Value.absent(),
    this.surahNumber = const Value.absent(),
    this.ayahNumber = const Value.absent(),
    this.juzNumber = const Value.absent(),
    this.hizbNumber = const Value.absent(),
    this.pageNumber = const Value.absent(),
    this.verseText = const Value.absent(),
    this.translation = const Value.absent(),
    this.reading = const Value.absent(),
  });
  QuranCompanion.insert({
    this.id = const Value.absent(),
    required int surahNumber,
    required int ayahNumber,
    this.juzNumber = const Value.absent(),
    this.hizbNumber = const Value.absent(),
    this.pageNumber = const Value.absent(),
    required String verseText,
    this.translation = const Value.absent(),
    this.reading = const Value.absent(),
  }) : surahNumber = Value(surahNumber),
       ayahNumber = Value(ayahNumber),
       verseText = Value(verseText);
  static Insertable<QuranData> custom({
    Expression<int>? id,
    Expression<int>? surahNumber,
    Expression<int>? ayahNumber,
    Expression<int>? juzNumber,
    Expression<int>? hizbNumber,
    Expression<int>? pageNumber,
    Expression<String>? verseText,
    Expression<String>? translation,
    Expression<String>? reading,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (surahNumber != null) 'surah_number': surahNumber,
      if (ayahNumber != null) 'ayah_number': ayahNumber,
      if (juzNumber != null) 'juz_number': juzNumber,
      if (hizbNumber != null) 'hizb_number': hizbNumber,
      if (pageNumber != null) 'page_number': pageNumber,
      if (verseText != null) 'verse_text': verseText,
      if (translation != null) 'translation': translation,
      if (reading != null) 'reading': reading,
    });
  }

  QuranCompanion copyWith({
    Value<int>? id,
    Value<int>? surahNumber,
    Value<int>? ayahNumber,
    Value<int?>? juzNumber,
    Value<int?>? hizbNumber,
    Value<int?>? pageNumber,
    Value<String>? verseText,
    Value<String?>? translation,
    Value<String>? reading,
  }) {
    return QuranCompanion(
      id: id ?? this.id,
      surahNumber: surahNumber ?? this.surahNumber,
      ayahNumber: ayahNumber ?? this.ayahNumber,
      juzNumber: juzNumber ?? this.juzNumber,
      hizbNumber: hizbNumber ?? this.hizbNumber,
      pageNumber: pageNumber ?? this.pageNumber,
      verseText: verseText ?? this.verseText,
      translation: translation ?? this.translation,
      reading: reading ?? this.reading,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (surahNumber.present) {
      map['surah_number'] = Variable<int>(surahNumber.value);
    }
    if (ayahNumber.present) {
      map['ayah_number'] = Variable<int>(ayahNumber.value);
    }
    if (juzNumber.present) {
      map['juz_number'] = Variable<int>(juzNumber.value);
    }
    if (hizbNumber.present) {
      map['hizb_number'] = Variable<int>(hizbNumber.value);
    }
    if (pageNumber.present) {
      map['page_number'] = Variable<int>(pageNumber.value);
    }
    if (verseText.present) {
      map['verse_text'] = Variable<String>(verseText.value);
    }
    if (translation.present) {
      map['translation'] = Variable<String>(translation.value);
    }
    if (reading.present) {
      map['reading'] = Variable<String>(reading.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QuranCompanion(')
          ..write('id: $id, ')
          ..write('surahNumber: $surahNumber, ')
          ..write('ayahNumber: $ayahNumber, ')
          ..write('juzNumber: $juzNumber, ')
          ..write('hizbNumber: $hizbNumber, ')
          ..write('pageNumber: $pageNumber, ')
          ..write('verseText: $verseText, ')
          ..write('translation: $translation, ')
          ..write('reading: $reading')
          ..write(')'))
        .toString();
  }
}

class $TafsirsTable extends Tafsirs with TableInfo<$TafsirsTable, Tafsir> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TafsirsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _surahNumberMeta = const VerificationMeta(
    'surahNumber',
  );
  @override
  late final GeneratedColumn<int> surahNumber = GeneratedColumn<int>(
    'surah_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ayahNumberMeta = const VerificationMeta(
    'ayahNumber',
  );
  @override
  late final GeneratedColumn<int> ayahNumber = GeneratedColumn<int>(
    'ayah_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tafsirTextMeta = const VerificationMeta(
    'tafsirText',
  );
  @override
  late final GeneratedColumn<String> tafsirText = GeneratedColumn<String>(
    'tafsir_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    surahNumber,
    ayahNumber,
    tafsirText,
    type,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tafsirs';
  @override
  VerificationContext validateIntegrity(
    Insertable<Tafsir> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('surah_number')) {
      context.handle(
        _surahNumberMeta,
        surahNumber.isAcceptableOrUnknown(
          data['surah_number']!,
          _surahNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_surahNumberMeta);
    }
    if (data.containsKey('ayah_number')) {
      context.handle(
        _ayahNumberMeta,
        ayahNumber.isAcceptableOrUnknown(data['ayah_number']!, _ayahNumberMeta),
      );
    } else if (isInserting) {
      context.missing(_ayahNumberMeta);
    }
    if (data.containsKey('tafsir_text')) {
      context.handle(
        _tafsirTextMeta,
        tafsirText.isAcceptableOrUnknown(data['tafsir_text']!, _tafsirTextMeta),
      );
    } else if (isInserting) {
      context.missing(_tafsirTextMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Tafsir map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Tafsir(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      surahNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}surah_number'],
      )!,
      ayahNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ayah_number'],
      )!,
      tafsirText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tafsir_text'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
    );
  }

  @override
  $TafsirsTable createAlias(String alias) {
    return $TafsirsTable(attachedDatabase, alias);
  }
}

class Tafsir extends DataClass implements Insertable<Tafsir> {
  final int id;
  final int surahNumber;
  final int ayahNumber;
  final String tafsirText;
  final String type;
  const Tafsir({
    required this.id,
    required this.surahNumber,
    required this.ayahNumber,
    required this.tafsirText,
    required this.type,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['surah_number'] = Variable<int>(surahNumber);
    map['ayah_number'] = Variable<int>(ayahNumber);
    map['tafsir_text'] = Variable<String>(tafsirText);
    map['type'] = Variable<String>(type);
    return map;
  }

  TafsirsCompanion toCompanion(bool nullToAbsent) {
    return TafsirsCompanion(
      id: Value(id),
      surahNumber: Value(surahNumber),
      ayahNumber: Value(ayahNumber),
      tafsirText: Value(tafsirText),
      type: Value(type),
    );
  }

  factory Tafsir.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Tafsir(
      id: serializer.fromJson<int>(json['id']),
      surahNumber: serializer.fromJson<int>(json['surahNumber']),
      ayahNumber: serializer.fromJson<int>(json['ayahNumber']),
      tafsirText: serializer.fromJson<String>(json['tafsirText']),
      type: serializer.fromJson<String>(json['type']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'surahNumber': serializer.toJson<int>(surahNumber),
      'ayahNumber': serializer.toJson<int>(ayahNumber),
      'tafsirText': serializer.toJson<String>(tafsirText),
      'type': serializer.toJson<String>(type),
    };
  }

  Tafsir copyWith({
    int? id,
    int? surahNumber,
    int? ayahNumber,
    String? tafsirText,
    String? type,
  }) => Tafsir(
    id: id ?? this.id,
    surahNumber: surahNumber ?? this.surahNumber,
    ayahNumber: ayahNumber ?? this.ayahNumber,
    tafsirText: tafsirText ?? this.tafsirText,
    type: type ?? this.type,
  );
  Tafsir copyWithCompanion(TafsirsCompanion data) {
    return Tafsir(
      id: data.id.present ? data.id.value : this.id,
      surahNumber: data.surahNumber.present
          ? data.surahNumber.value
          : this.surahNumber,
      ayahNumber: data.ayahNumber.present
          ? data.ayahNumber.value
          : this.ayahNumber,
      tafsirText: data.tafsirText.present
          ? data.tafsirText.value
          : this.tafsirText,
      type: data.type.present ? data.type.value : this.type,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Tafsir(')
          ..write('id: $id, ')
          ..write('surahNumber: $surahNumber, ')
          ..write('ayahNumber: $ayahNumber, ')
          ..write('tafsirText: $tafsirText, ')
          ..write('type: $type')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, surahNumber, ayahNumber, tafsirText, type);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Tafsir &&
          other.id == this.id &&
          other.surahNumber == this.surahNumber &&
          other.ayahNumber == this.ayahNumber &&
          other.tafsirText == this.tafsirText &&
          other.type == this.type);
}

class TafsirsCompanion extends UpdateCompanion<Tafsir> {
  final Value<int> id;
  final Value<int> surahNumber;
  final Value<int> ayahNumber;
  final Value<String> tafsirText;
  final Value<String> type;
  const TafsirsCompanion({
    this.id = const Value.absent(),
    this.surahNumber = const Value.absent(),
    this.ayahNumber = const Value.absent(),
    this.tafsirText = const Value.absent(),
    this.type = const Value.absent(),
  });
  TafsirsCompanion.insert({
    this.id = const Value.absent(),
    required int surahNumber,
    required int ayahNumber,
    required String tafsirText,
    required String type,
  }) : surahNumber = Value(surahNumber),
       ayahNumber = Value(ayahNumber),
       tafsirText = Value(tafsirText),
       type = Value(type);
  static Insertable<Tafsir> custom({
    Expression<int>? id,
    Expression<int>? surahNumber,
    Expression<int>? ayahNumber,
    Expression<String>? tafsirText,
    Expression<String>? type,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (surahNumber != null) 'surah_number': surahNumber,
      if (ayahNumber != null) 'ayah_number': ayahNumber,
      if (tafsirText != null) 'tafsir_text': tafsirText,
      if (type != null) 'type': type,
    });
  }

  TafsirsCompanion copyWith({
    Value<int>? id,
    Value<int>? surahNumber,
    Value<int>? ayahNumber,
    Value<String>? tafsirText,
    Value<String>? type,
  }) {
    return TafsirsCompanion(
      id: id ?? this.id,
      surahNumber: surahNumber ?? this.surahNumber,
      ayahNumber: ayahNumber ?? this.ayahNumber,
      tafsirText: tafsirText ?? this.tafsirText,
      type: type ?? this.type,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (surahNumber.present) {
      map['surah_number'] = Variable<int>(surahNumber.value);
    }
    if (ayahNumber.present) {
      map['ayah_number'] = Variable<int>(ayahNumber.value);
    }
    if (tafsirText.present) {
      map['tafsir_text'] = Variable<String>(tafsirText.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TafsirsCompanion(')
          ..write('id: $id, ')
          ..write('surahNumber: $surahNumber, ')
          ..write('ayahNumber: $ayahNumber, ')
          ..write('tafsirText: $tafsirText, ')
          ..write('type: $type')
          ..write(')'))
        .toString();
  }
}

class $AzkarTable extends Azkar with TableInfo<$AzkarTable, AzkarData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AzkarTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _zikrTextMeta = const VerificationMeta(
    'zikrText',
  );
  @override
  late final GeneratedColumn<String> zikrText = GeneratedColumn<String>(
    'zikr_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _referenceMeta = const VerificationMeta(
    'reference',
  );
  @override
  late final GeneratedColumn<String> reference = GeneratedColumn<String>(
    'reference',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _countMeta = const VerificationMeta('count');
  @override
  late final GeneratedColumn<int> count = GeneratedColumn<int>(
    'count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    category,
    zikrText,
    reference,
    count,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'azkar';
  @override
  VerificationContext validateIntegrity(
    Insertable<AzkarData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('zikr_text')) {
      context.handle(
        _zikrTextMeta,
        zikrText.isAcceptableOrUnknown(data['zikr_text']!, _zikrTextMeta),
      );
    } else if (isInserting) {
      context.missing(_zikrTextMeta);
    }
    if (data.containsKey('reference')) {
      context.handle(
        _referenceMeta,
        reference.isAcceptableOrUnknown(data['reference']!, _referenceMeta),
      );
    }
    if (data.containsKey('count')) {
      context.handle(
        _countMeta,
        count.isAcceptableOrUnknown(data['count']!, _countMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AzkarData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AzkarData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      zikrText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}zikr_text'],
      )!,
      reference: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reference'],
      ),
      count: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}count'],
      )!,
    );
  }

  @override
  $AzkarTable createAlias(String alias) {
    return $AzkarTable(attachedDatabase, alias);
  }
}

class AzkarData extends DataClass implements Insertable<AzkarData> {
  final int id;
  final String category;
  final String zikrText;
  final String? reference;
  final int count;
  const AzkarData({
    required this.id,
    required this.category,
    required this.zikrText,
    this.reference,
    required this.count,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['category'] = Variable<String>(category);
    map['zikr_text'] = Variable<String>(zikrText);
    if (!nullToAbsent || reference != null) {
      map['reference'] = Variable<String>(reference);
    }
    map['count'] = Variable<int>(count);
    return map;
  }

  AzkarCompanion toCompanion(bool nullToAbsent) {
    return AzkarCompanion(
      id: Value(id),
      category: Value(category),
      zikrText: Value(zikrText),
      reference: reference == null && nullToAbsent
          ? const Value.absent()
          : Value(reference),
      count: Value(count),
    );
  }

  factory AzkarData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AzkarData(
      id: serializer.fromJson<int>(json['id']),
      category: serializer.fromJson<String>(json['category']),
      zikrText: serializer.fromJson<String>(json['zikrText']),
      reference: serializer.fromJson<String?>(json['reference']),
      count: serializer.fromJson<int>(json['count']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'category': serializer.toJson<String>(category),
      'zikrText': serializer.toJson<String>(zikrText),
      'reference': serializer.toJson<String?>(reference),
      'count': serializer.toJson<int>(count),
    };
  }

  AzkarData copyWith({
    int? id,
    String? category,
    String? zikrText,
    Value<String?> reference = const Value.absent(),
    int? count,
  }) => AzkarData(
    id: id ?? this.id,
    category: category ?? this.category,
    zikrText: zikrText ?? this.zikrText,
    reference: reference.present ? reference.value : this.reference,
    count: count ?? this.count,
  );
  AzkarData copyWithCompanion(AzkarCompanion data) {
    return AzkarData(
      id: data.id.present ? data.id.value : this.id,
      category: data.category.present ? data.category.value : this.category,
      zikrText: data.zikrText.present ? data.zikrText.value : this.zikrText,
      reference: data.reference.present ? data.reference.value : this.reference,
      count: data.count.present ? data.count.value : this.count,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AzkarData(')
          ..write('id: $id, ')
          ..write('category: $category, ')
          ..write('zikrText: $zikrText, ')
          ..write('reference: $reference, ')
          ..write('count: $count')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, category, zikrText, reference, count);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AzkarData &&
          other.id == this.id &&
          other.category == this.category &&
          other.zikrText == this.zikrText &&
          other.reference == this.reference &&
          other.count == this.count);
}

class AzkarCompanion extends UpdateCompanion<AzkarData> {
  final Value<int> id;
  final Value<String> category;
  final Value<String> zikrText;
  final Value<String?> reference;
  final Value<int> count;
  const AzkarCompanion({
    this.id = const Value.absent(),
    this.category = const Value.absent(),
    this.zikrText = const Value.absent(),
    this.reference = const Value.absent(),
    this.count = const Value.absent(),
  });
  AzkarCompanion.insert({
    this.id = const Value.absent(),
    required String category,
    required String zikrText,
    this.reference = const Value.absent(),
    this.count = const Value.absent(),
  }) : category = Value(category),
       zikrText = Value(zikrText);
  static Insertable<AzkarData> custom({
    Expression<int>? id,
    Expression<String>? category,
    Expression<String>? zikrText,
    Expression<String>? reference,
    Expression<int>? count,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (category != null) 'category': category,
      if (zikrText != null) 'zikr_text': zikrText,
      if (reference != null) 'reference': reference,
      if (count != null) 'count': count,
    });
  }

  AzkarCompanion copyWith({
    Value<int>? id,
    Value<String>? category,
    Value<String>? zikrText,
    Value<String?>? reference,
    Value<int>? count,
  }) {
    return AzkarCompanion(
      id: id ?? this.id,
      category: category ?? this.category,
      zikrText: zikrText ?? this.zikrText,
      reference: reference ?? this.reference,
      count: count ?? this.count,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (zikrText.present) {
      map['zikr_text'] = Variable<String>(zikrText.value);
    }
    if (reference.present) {
      map['reference'] = Variable<String>(reference.value);
    }
    if (count.present) {
      map['count'] = Variable<int>(count.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AzkarCompanion(')
          ..write('id: $id, ')
          ..write('category: $category, ')
          ..write('zikrText: $zikrText, ')
          ..write('reference: $reference, ')
          ..write('count: $count')
          ..write(')'))
        .toString();
  }
}

class $UserProgressTable extends UserProgress
    with TableInfo<$UserProgressTable, UserProgressData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserProgressTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _surahNumberMeta = const VerificationMeta(
    'surahNumber',
  );
  @override
  late final GeneratedColumn<int> surahNumber = GeneratedColumn<int>(
    'surah_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ayahNumberMeta = const VerificationMeta(
    'ayahNumber',
  );
  @override
  late final GeneratedColumn<int> ayahNumber = GeneratedColumn<int>(
    'ayah_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    surahNumber,
    ayahNumber,
    timestamp,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_progress';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserProgressData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('surah_number')) {
      context.handle(
        _surahNumberMeta,
        surahNumber.isAcceptableOrUnknown(
          data['surah_number']!,
          _surahNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_surahNumberMeta);
    }
    if (data.containsKey('ayah_number')) {
      context.handle(
        _ayahNumberMeta,
        ayahNumber.isAcceptableOrUnknown(data['ayah_number']!, _ayahNumberMeta),
      );
    } else if (isInserting) {
      context.missing(_ayahNumberMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserProgressData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserProgressData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      surahNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}surah_number'],
      )!,
      ayahNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ayah_number'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
    );
  }

  @override
  $UserProgressTable createAlias(String alias) {
    return $UserProgressTable(attachedDatabase, alias);
  }
}

class UserProgressData extends DataClass
    implements Insertable<UserProgressData> {
  final int id;
  final int surahNumber;
  final int ayahNumber;
  final DateTime timestamp;
  const UserProgressData({
    required this.id,
    required this.surahNumber,
    required this.ayahNumber,
    required this.timestamp,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['surah_number'] = Variable<int>(surahNumber);
    map['ayah_number'] = Variable<int>(ayahNumber);
    map['timestamp'] = Variable<DateTime>(timestamp);
    return map;
  }

  UserProgressCompanion toCompanion(bool nullToAbsent) {
    return UserProgressCompanion(
      id: Value(id),
      surahNumber: Value(surahNumber),
      ayahNumber: Value(ayahNumber),
      timestamp: Value(timestamp),
    );
  }

  factory UserProgressData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserProgressData(
      id: serializer.fromJson<int>(json['id']),
      surahNumber: serializer.fromJson<int>(json['surahNumber']),
      ayahNumber: serializer.fromJson<int>(json['ayahNumber']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'surahNumber': serializer.toJson<int>(surahNumber),
      'ayahNumber': serializer.toJson<int>(ayahNumber),
      'timestamp': serializer.toJson<DateTime>(timestamp),
    };
  }

  UserProgressData copyWith({
    int? id,
    int? surahNumber,
    int? ayahNumber,
    DateTime? timestamp,
  }) => UserProgressData(
    id: id ?? this.id,
    surahNumber: surahNumber ?? this.surahNumber,
    ayahNumber: ayahNumber ?? this.ayahNumber,
    timestamp: timestamp ?? this.timestamp,
  );
  UserProgressData copyWithCompanion(UserProgressCompanion data) {
    return UserProgressData(
      id: data.id.present ? data.id.value : this.id,
      surahNumber: data.surahNumber.present
          ? data.surahNumber.value
          : this.surahNumber,
      ayahNumber: data.ayahNumber.present
          ? data.ayahNumber.value
          : this.ayahNumber,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserProgressData(')
          ..write('id: $id, ')
          ..write('surahNumber: $surahNumber, ')
          ..write('ayahNumber: $ayahNumber, ')
          ..write('timestamp: $timestamp')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, surahNumber, ayahNumber, timestamp);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserProgressData &&
          other.id == this.id &&
          other.surahNumber == this.surahNumber &&
          other.ayahNumber == this.ayahNumber &&
          other.timestamp == this.timestamp);
}

class UserProgressCompanion extends UpdateCompanion<UserProgressData> {
  final Value<int> id;
  final Value<int> surahNumber;
  final Value<int> ayahNumber;
  final Value<DateTime> timestamp;
  const UserProgressCompanion({
    this.id = const Value.absent(),
    this.surahNumber = const Value.absent(),
    this.ayahNumber = const Value.absent(),
    this.timestamp = const Value.absent(),
  });
  UserProgressCompanion.insert({
    this.id = const Value.absent(),
    required int surahNumber,
    required int ayahNumber,
    this.timestamp = const Value.absent(),
  }) : surahNumber = Value(surahNumber),
       ayahNumber = Value(ayahNumber);
  static Insertable<UserProgressData> custom({
    Expression<int>? id,
    Expression<int>? surahNumber,
    Expression<int>? ayahNumber,
    Expression<DateTime>? timestamp,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (surahNumber != null) 'surah_number': surahNumber,
      if (ayahNumber != null) 'ayah_number': ayahNumber,
      if (timestamp != null) 'timestamp': timestamp,
    });
  }

  UserProgressCompanion copyWith({
    Value<int>? id,
    Value<int>? surahNumber,
    Value<int>? ayahNumber,
    Value<DateTime>? timestamp,
  }) {
    return UserProgressCompanion(
      id: id ?? this.id,
      surahNumber: surahNumber ?? this.surahNumber,
      ayahNumber: ayahNumber ?? this.ayahNumber,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (surahNumber.present) {
      map['surah_number'] = Variable<int>(surahNumber.value);
    }
    if (ayahNumber.present) {
      map['ayah_number'] = Variable<int>(ayahNumber.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserProgressCompanion(')
          ..write('id: $id, ')
          ..write('surahNumber: $surahNumber, ')
          ..write('ayahNumber: $ayahNumber, ')
          ..write('timestamp: $timestamp')
          ..write(')'))
        .toString();
  }
}

class $BookmarksTable extends Bookmarks
    with TableInfo<$BookmarksTable, Bookmark> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BookmarksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _surahNumberMeta = const VerificationMeta(
    'surahNumber',
  );
  @override
  late final GeneratedColumn<int> surahNumber = GeneratedColumn<int>(
    'surah_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ayahNumberMeta = const VerificationMeta(
    'ayahNumber',
  );
  @override
  late final GeneratedColumn<int> ayahNumber = GeneratedColumn<int>(
    'ayah_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    surahNumber,
    ayahNumber,
    note,
    timestamp,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'bookmarks';
  @override
  VerificationContext validateIntegrity(
    Insertable<Bookmark> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('surah_number')) {
      context.handle(
        _surahNumberMeta,
        surahNumber.isAcceptableOrUnknown(
          data['surah_number']!,
          _surahNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_surahNumberMeta);
    }
    if (data.containsKey('ayah_number')) {
      context.handle(
        _ayahNumberMeta,
        ayahNumber.isAcceptableOrUnknown(data['ayah_number']!, _ayahNumberMeta),
      );
    } else if (isInserting) {
      context.missing(_ayahNumberMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Bookmark map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Bookmark(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      surahNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}surah_number'],
      )!,
      ayahNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ayah_number'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
    );
  }

  @override
  $BookmarksTable createAlias(String alias) {
    return $BookmarksTable(attachedDatabase, alias);
  }
}

class Bookmark extends DataClass implements Insertable<Bookmark> {
  final int id;
  final int surahNumber;
  final int ayahNumber;
  final String? note;
  final DateTime timestamp;
  const Bookmark({
    required this.id,
    required this.surahNumber,
    required this.ayahNumber,
    this.note,
    required this.timestamp,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['surah_number'] = Variable<int>(surahNumber);
    map['ayah_number'] = Variable<int>(ayahNumber);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['timestamp'] = Variable<DateTime>(timestamp);
    return map;
  }

  BookmarksCompanion toCompanion(bool nullToAbsent) {
    return BookmarksCompanion(
      id: Value(id),
      surahNumber: Value(surahNumber),
      ayahNumber: Value(ayahNumber),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      timestamp: Value(timestamp),
    );
  }

  factory Bookmark.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Bookmark(
      id: serializer.fromJson<int>(json['id']),
      surahNumber: serializer.fromJson<int>(json['surahNumber']),
      ayahNumber: serializer.fromJson<int>(json['ayahNumber']),
      note: serializer.fromJson<String?>(json['note']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'surahNumber': serializer.toJson<int>(surahNumber),
      'ayahNumber': serializer.toJson<int>(ayahNumber),
      'note': serializer.toJson<String?>(note),
      'timestamp': serializer.toJson<DateTime>(timestamp),
    };
  }

  Bookmark copyWith({
    int? id,
    int? surahNumber,
    int? ayahNumber,
    Value<String?> note = const Value.absent(),
    DateTime? timestamp,
  }) => Bookmark(
    id: id ?? this.id,
    surahNumber: surahNumber ?? this.surahNumber,
    ayahNumber: ayahNumber ?? this.ayahNumber,
    note: note.present ? note.value : this.note,
    timestamp: timestamp ?? this.timestamp,
  );
  Bookmark copyWithCompanion(BookmarksCompanion data) {
    return Bookmark(
      id: data.id.present ? data.id.value : this.id,
      surahNumber: data.surahNumber.present
          ? data.surahNumber.value
          : this.surahNumber,
      ayahNumber: data.ayahNumber.present
          ? data.ayahNumber.value
          : this.ayahNumber,
      note: data.note.present ? data.note.value : this.note,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Bookmark(')
          ..write('id: $id, ')
          ..write('surahNumber: $surahNumber, ')
          ..write('ayahNumber: $ayahNumber, ')
          ..write('note: $note, ')
          ..write('timestamp: $timestamp')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, surahNumber, ayahNumber, note, timestamp);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Bookmark &&
          other.id == this.id &&
          other.surahNumber == this.surahNumber &&
          other.ayahNumber == this.ayahNumber &&
          other.note == this.note &&
          other.timestamp == this.timestamp);
}

class BookmarksCompanion extends UpdateCompanion<Bookmark> {
  final Value<int> id;
  final Value<int> surahNumber;
  final Value<int> ayahNumber;
  final Value<String?> note;
  final Value<DateTime> timestamp;
  const BookmarksCompanion({
    this.id = const Value.absent(),
    this.surahNumber = const Value.absent(),
    this.ayahNumber = const Value.absent(),
    this.note = const Value.absent(),
    this.timestamp = const Value.absent(),
  });
  BookmarksCompanion.insert({
    this.id = const Value.absent(),
    required int surahNumber,
    required int ayahNumber,
    this.note = const Value.absent(),
    this.timestamp = const Value.absent(),
  }) : surahNumber = Value(surahNumber),
       ayahNumber = Value(ayahNumber);
  static Insertable<Bookmark> custom({
    Expression<int>? id,
    Expression<int>? surahNumber,
    Expression<int>? ayahNumber,
    Expression<String>? note,
    Expression<DateTime>? timestamp,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (surahNumber != null) 'surah_number': surahNumber,
      if (ayahNumber != null) 'ayah_number': ayahNumber,
      if (note != null) 'note': note,
      if (timestamp != null) 'timestamp': timestamp,
    });
  }

  BookmarksCompanion copyWith({
    Value<int>? id,
    Value<int>? surahNumber,
    Value<int>? ayahNumber,
    Value<String?>? note,
    Value<DateTime>? timestamp,
  }) {
    return BookmarksCompanion(
      id: id ?? this.id,
      surahNumber: surahNumber ?? this.surahNumber,
      ayahNumber: ayahNumber ?? this.ayahNumber,
      note: note ?? this.note,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (surahNumber.present) {
      map['surah_number'] = Variable<int>(surahNumber.value);
    }
    if (ayahNumber.present) {
      map['ayah_number'] = Variable<int>(ayahNumber.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BookmarksCompanion(')
          ..write('id: $id, ')
          ..write('surahNumber: $surahNumber, ')
          ..write('ayahNumber: $ayahNumber, ')
          ..write('note: $note, ')
          ..write('timestamp: $timestamp')
          ..write(')'))
        .toString();
  }
}

class $AllahNamesTable extends AllahNames
    with TableInfo<$AllahNamesTable, AllahName> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AllahNamesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _meaningMeta = const VerificationMeta(
    'meaning',
  );
  @override
  late final GeneratedColumn<String> meaning = GeneratedColumn<String>(
    'meaning',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, meaning];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'allah_names';
  @override
  VerificationContext validateIntegrity(
    Insertable<AllahName> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('meaning')) {
      context.handle(
        _meaningMeta,
        meaning.isAcceptableOrUnknown(data['meaning']!, _meaningMeta),
      );
    } else if (isInserting) {
      context.missing(_meaningMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AllahName map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AllahName(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      meaning: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}meaning'],
      )!,
    );
  }

  @override
  $AllahNamesTable createAlias(String alias) {
    return $AllahNamesTable(attachedDatabase, alias);
  }
}

class AllahName extends DataClass implements Insertable<AllahName> {
  final int id;
  final String name;
  final String meaning;
  const AllahName({
    required this.id,
    required this.name,
    required this.meaning,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['meaning'] = Variable<String>(meaning);
    return map;
  }

  AllahNamesCompanion toCompanion(bool nullToAbsent) {
    return AllahNamesCompanion(
      id: Value(id),
      name: Value(name),
      meaning: Value(meaning),
    );
  }

  factory AllahName.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AllahName(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      meaning: serializer.fromJson<String>(json['meaning']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'meaning': serializer.toJson<String>(meaning),
    };
  }

  AllahName copyWith({int? id, String? name, String? meaning}) => AllahName(
    id: id ?? this.id,
    name: name ?? this.name,
    meaning: meaning ?? this.meaning,
  );
  AllahName copyWithCompanion(AllahNamesCompanion data) {
    return AllahName(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      meaning: data.meaning.present ? data.meaning.value : this.meaning,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AllahName(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('meaning: $meaning')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, meaning);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AllahName &&
          other.id == this.id &&
          other.name == this.name &&
          other.meaning == this.meaning);
}

class AllahNamesCompanion extends UpdateCompanion<AllahName> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> meaning;
  const AllahNamesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.meaning = const Value.absent(),
  });
  AllahNamesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String meaning,
  }) : name = Value(name),
       meaning = Value(meaning);
  static Insertable<AllahName> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? meaning,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (meaning != null) 'meaning': meaning,
    });
  }

  AllahNamesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? meaning,
  }) {
    return AllahNamesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      meaning: meaning ?? this.meaning,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (meaning.present) {
      map['meaning'] = Variable<String>(meaning.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AllahNamesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('meaning: $meaning')
          ..write(')'))
        .toString();
  }
}

class $KhatmaPlansTable extends KhatmaPlans
    with TableInfo<$KhatmaPlansTable, KhatmaPlan> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $KhatmaPlansTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
    'start_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetDaysMeta = const VerificationMeta(
    'targetDays',
  );
  @override
  late final GeneratedColumn<int> targetDays = GeneratedColumn<int>(
    'target_days',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _progressAyahsMeta = const VerificationMeta(
    'progressAyahs',
  );
  @override
  late final GeneratedColumn<int> progressAyahs = GeneratedColumn<int>(
    'progress_ayahs',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    startDate,
    targetDays,
    progressAyahs,
    isActive,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'khatma_plans';
  @override
  VerificationContext validateIntegrity(
    Insertable<KhatmaPlan> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('target_days')) {
      context.handle(
        _targetDaysMeta,
        targetDays.isAcceptableOrUnknown(data['target_days']!, _targetDaysMeta),
      );
    } else if (isInserting) {
      context.missing(_targetDaysMeta);
    }
    if (data.containsKey('progress_ayahs')) {
      context.handle(
        _progressAyahsMeta,
        progressAyahs.isAcceptableOrUnknown(
          data['progress_ayahs']!,
          _progressAyahsMeta,
        ),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  KhatmaPlan map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return KhatmaPlan(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_date'],
      )!,
      targetDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_days'],
      )!,
      progressAyahs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}progress_ayahs'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
    );
  }

  @override
  $KhatmaPlansTable createAlias(String alias) {
    return $KhatmaPlansTable(attachedDatabase, alias);
  }
}

class KhatmaPlan extends DataClass implements Insertable<KhatmaPlan> {
  final int id;
  final String title;
  final DateTime startDate;
  final int targetDays;
  final int progressAyahs;
  final bool isActive;
  const KhatmaPlan({
    required this.id,
    required this.title,
    required this.startDate,
    required this.targetDays,
    required this.progressAyahs,
    required this.isActive,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['start_date'] = Variable<DateTime>(startDate);
    map['target_days'] = Variable<int>(targetDays);
    map['progress_ayahs'] = Variable<int>(progressAyahs);
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  KhatmaPlansCompanion toCompanion(bool nullToAbsent) {
    return KhatmaPlansCompanion(
      id: Value(id),
      title: Value(title),
      startDate: Value(startDate),
      targetDays: Value(targetDays),
      progressAyahs: Value(progressAyahs),
      isActive: Value(isActive),
    );
  }

  factory KhatmaPlan.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return KhatmaPlan(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      targetDays: serializer.fromJson<int>(json['targetDays']),
      progressAyahs: serializer.fromJson<int>(json['progressAyahs']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'startDate': serializer.toJson<DateTime>(startDate),
      'targetDays': serializer.toJson<int>(targetDays),
      'progressAyahs': serializer.toJson<int>(progressAyahs),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  KhatmaPlan copyWith({
    int? id,
    String? title,
    DateTime? startDate,
    int? targetDays,
    int? progressAyahs,
    bool? isActive,
  }) => KhatmaPlan(
    id: id ?? this.id,
    title: title ?? this.title,
    startDate: startDate ?? this.startDate,
    targetDays: targetDays ?? this.targetDays,
    progressAyahs: progressAyahs ?? this.progressAyahs,
    isActive: isActive ?? this.isActive,
  );
  KhatmaPlan copyWithCompanion(KhatmaPlansCompanion data) {
    return KhatmaPlan(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      targetDays: data.targetDays.present
          ? data.targetDays.value
          : this.targetDays,
      progressAyahs: data.progressAyahs.present
          ? data.progressAyahs.value
          : this.progressAyahs,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('KhatmaPlan(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('startDate: $startDate, ')
          ..write('targetDays: $targetDays, ')
          ..write('progressAyahs: $progressAyahs, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, title, startDate, targetDays, progressAyahs, isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is KhatmaPlan &&
          other.id == this.id &&
          other.title == this.title &&
          other.startDate == this.startDate &&
          other.targetDays == this.targetDays &&
          other.progressAyahs == this.progressAyahs &&
          other.isActive == this.isActive);
}

class KhatmaPlansCompanion extends UpdateCompanion<KhatmaPlan> {
  final Value<int> id;
  final Value<String> title;
  final Value<DateTime> startDate;
  final Value<int> targetDays;
  final Value<int> progressAyahs;
  final Value<bool> isActive;
  const KhatmaPlansCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.startDate = const Value.absent(),
    this.targetDays = const Value.absent(),
    this.progressAyahs = const Value.absent(),
    this.isActive = const Value.absent(),
  });
  KhatmaPlansCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required DateTime startDate,
    required int targetDays,
    this.progressAyahs = const Value.absent(),
    this.isActive = const Value.absent(),
  }) : title = Value(title),
       startDate = Value(startDate),
       targetDays = Value(targetDays);
  static Insertable<KhatmaPlan> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<DateTime>? startDate,
    Expression<int>? targetDays,
    Expression<int>? progressAyahs,
    Expression<bool>? isActive,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (startDate != null) 'start_date': startDate,
      if (targetDays != null) 'target_days': targetDays,
      if (progressAyahs != null) 'progress_ayahs': progressAyahs,
      if (isActive != null) 'is_active': isActive,
    });
  }

  KhatmaPlansCompanion copyWith({
    Value<int>? id,
    Value<String>? title,
    Value<DateTime>? startDate,
    Value<int>? targetDays,
    Value<int>? progressAyahs,
    Value<bool>? isActive,
  }) {
    return KhatmaPlansCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      startDate: startDate ?? this.startDate,
      targetDays: targetDays ?? this.targetDays,
      progressAyahs: progressAyahs ?? this.progressAyahs,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (targetDays.present) {
      map['target_days'] = Variable<int>(targetDays.value);
    }
    if (progressAyahs.present) {
      map['progress_ayahs'] = Variable<int>(progressAyahs.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('KhatmaPlansCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('startDate: $startDate, ')
          ..write('targetDays: $targetDays, ')
          ..write('progressAyahs: $progressAyahs, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }
}

class $AchievementsTable extends Achievements
    with TableInfo<$AchievementsTable, Achievement> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AchievementsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
    'icon',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateEarnedMeta = const VerificationMeta(
    'dateEarned',
  );
  @override
  late final GeneratedColumn<DateTime> dateEarned = GeneratedColumn<DateTime>(
    'date_earned',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    description,
    icon,
    dateEarned,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'achievements';
  @override
  VerificationContext validateIntegrity(
    Insertable<Achievement> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('icon')) {
      context.handle(
        _iconMeta,
        icon.isAcceptableOrUnknown(data['icon']!, _iconMeta),
      );
    } else if (isInserting) {
      context.missing(_iconMeta);
    }
    if (data.containsKey('date_earned')) {
      context.handle(
        _dateEarnedMeta,
        dateEarned.isAcceptableOrUnknown(data['date_earned']!, _dateEarnedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Achievement map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Achievement(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      icon: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon'],
      )!,
      dateEarned: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date_earned'],
      )!,
    );
  }

  @override
  $AchievementsTable createAlias(String alias) {
    return $AchievementsTable(attachedDatabase, alias);
  }
}

class Achievement extends DataClass implements Insertable<Achievement> {
  final int id;
  final String title;
  final String description;
  final String icon;
  final DateTime dateEarned;
  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.dateEarned,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['description'] = Variable<String>(description);
    map['icon'] = Variable<String>(icon);
    map['date_earned'] = Variable<DateTime>(dateEarned);
    return map;
  }

  AchievementsCompanion toCompanion(bool nullToAbsent) {
    return AchievementsCompanion(
      id: Value(id),
      title: Value(title),
      description: Value(description),
      icon: Value(icon),
      dateEarned: Value(dateEarned),
    );
  }

  factory Achievement.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Achievement(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String>(json['description']),
      icon: serializer.fromJson<String>(json['icon']),
      dateEarned: serializer.fromJson<DateTime>(json['dateEarned']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String>(description),
      'icon': serializer.toJson<String>(icon),
      'dateEarned': serializer.toJson<DateTime>(dateEarned),
    };
  }

  Achievement copyWith({
    int? id,
    String? title,
    String? description,
    String? icon,
    DateTime? dateEarned,
  }) => Achievement(
    id: id ?? this.id,
    title: title ?? this.title,
    description: description ?? this.description,
    icon: icon ?? this.icon,
    dateEarned: dateEarned ?? this.dateEarned,
  );
  Achievement copyWithCompanion(AchievementsCompanion data) {
    return Achievement(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      icon: data.icon.present ? data.icon.value : this.icon,
      dateEarned: data.dateEarned.present
          ? data.dateEarned.value
          : this.dateEarned,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Achievement(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('icon: $icon, ')
          ..write('dateEarned: $dateEarned')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, description, icon, dateEarned);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Achievement &&
          other.id == this.id &&
          other.title == this.title &&
          other.description == this.description &&
          other.icon == this.icon &&
          other.dateEarned == this.dateEarned);
}

class AchievementsCompanion extends UpdateCompanion<Achievement> {
  final Value<int> id;
  final Value<String> title;
  final Value<String> description;
  final Value<String> icon;
  final Value<DateTime> dateEarned;
  const AchievementsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.icon = const Value.absent(),
    this.dateEarned = const Value.absent(),
  });
  AchievementsCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required String description,
    required String icon,
    this.dateEarned = const Value.absent(),
  }) : title = Value(title),
       description = Value(description),
       icon = Value(icon);
  static Insertable<Achievement> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? icon,
    Expression<DateTime>? dateEarned,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (icon != null) 'icon': icon,
      if (dateEarned != null) 'date_earned': dateEarned,
    });
  }

  AchievementsCompanion copyWith({
    Value<int>? id,
    Value<String>? title,
    Value<String>? description,
    Value<String>? icon,
    Value<DateTime>? dateEarned,
  }) {
    return AchievementsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      dateEarned: dateEarned ?? this.dateEarned,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (dateEarned.present) {
      map['date_earned'] = Variable<DateTime>(dateEarned.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AchievementsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('icon: $icon, ')
          ..write('dateEarned: $dateEarned')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $QuranTable quran = $QuranTable(this);
  late final $TafsirsTable tafsirs = $TafsirsTable(this);
  late final $AzkarTable azkar = $AzkarTable(this);
  late final $UserProgressTable userProgress = $UserProgressTable(this);
  late final $BookmarksTable bookmarks = $BookmarksTable(this);
  late final $AllahNamesTable allahNames = $AllahNamesTable(this);
  late final $KhatmaPlansTable khatmaPlans = $KhatmaPlansTable(this);
  late final $AchievementsTable achievements = $AchievementsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    quran,
    tafsirs,
    azkar,
    userProgress,
    bookmarks,
    allahNames,
    khatmaPlans,
    achievements,
  ];
}

typedef $$QuranTableCreateCompanionBuilder =
    QuranCompanion Function({
      Value<int> id,
      required int surahNumber,
      required int ayahNumber,
      Value<int?> juzNumber,
      Value<int?> hizbNumber,
      Value<int?> pageNumber,
      required String verseText,
      Value<String?> translation,
      Value<String> reading,
    });
typedef $$QuranTableUpdateCompanionBuilder =
    QuranCompanion Function({
      Value<int> id,
      Value<int> surahNumber,
      Value<int> ayahNumber,
      Value<int?> juzNumber,
      Value<int?> hizbNumber,
      Value<int?> pageNumber,
      Value<String> verseText,
      Value<String?> translation,
      Value<String> reading,
    });

class $$QuranTableFilterComposer extends Composer<_$AppDatabase, $QuranTable> {
  $$QuranTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get surahNumber => $composableBuilder(
    column: $table.surahNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ayahNumber => $composableBuilder(
    column: $table.ayahNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get juzNumber => $composableBuilder(
    column: $table.juzNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get hizbNumber => $composableBuilder(
    column: $table.hizbNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pageNumber => $composableBuilder(
    column: $table.pageNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get verseText => $composableBuilder(
    column: $table.verseText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get translation => $composableBuilder(
    column: $table.translation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reading => $composableBuilder(
    column: $table.reading,
    builder: (column) => ColumnFilters(column),
  );
}

class $$QuranTableOrderingComposer
    extends Composer<_$AppDatabase, $QuranTable> {
  $$QuranTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get surahNumber => $composableBuilder(
    column: $table.surahNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ayahNumber => $composableBuilder(
    column: $table.ayahNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get juzNumber => $composableBuilder(
    column: $table.juzNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get hizbNumber => $composableBuilder(
    column: $table.hizbNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pageNumber => $composableBuilder(
    column: $table.pageNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get verseText => $composableBuilder(
    column: $table.verseText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get translation => $composableBuilder(
    column: $table.translation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reading => $composableBuilder(
    column: $table.reading,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$QuranTableAnnotationComposer
    extends Composer<_$AppDatabase, $QuranTable> {
  $$QuranTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get surahNumber => $composableBuilder(
    column: $table.surahNumber,
    builder: (column) => column,
  );

  GeneratedColumn<int> get ayahNumber => $composableBuilder(
    column: $table.ayahNumber,
    builder: (column) => column,
  );

  GeneratedColumn<int> get juzNumber =>
      $composableBuilder(column: $table.juzNumber, builder: (column) => column);

  GeneratedColumn<int> get hizbNumber => $composableBuilder(
    column: $table.hizbNumber,
    builder: (column) => column,
  );

  GeneratedColumn<int> get pageNumber => $composableBuilder(
    column: $table.pageNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get verseText =>
      $composableBuilder(column: $table.verseText, builder: (column) => column);

  GeneratedColumn<String> get translation => $composableBuilder(
    column: $table.translation,
    builder: (column) => column,
  );

  GeneratedColumn<String> get reading =>
      $composableBuilder(column: $table.reading, builder: (column) => column);
}

class $$QuranTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $QuranTable,
          QuranData,
          $$QuranTableFilterComposer,
          $$QuranTableOrderingComposer,
          $$QuranTableAnnotationComposer,
          $$QuranTableCreateCompanionBuilder,
          $$QuranTableUpdateCompanionBuilder,
          (QuranData, BaseReferences<_$AppDatabase, $QuranTable, QuranData>),
          QuranData,
          PrefetchHooks Function()
        > {
  $$QuranTableTableManager(_$AppDatabase db, $QuranTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QuranTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QuranTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$QuranTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> surahNumber = const Value.absent(),
                Value<int> ayahNumber = const Value.absent(),
                Value<int?> juzNumber = const Value.absent(),
                Value<int?> hizbNumber = const Value.absent(),
                Value<int?> pageNumber = const Value.absent(),
                Value<String> verseText = const Value.absent(),
                Value<String?> translation = const Value.absent(),
                Value<String> reading = const Value.absent(),
              }) => QuranCompanion(
                id: id,
                surahNumber: surahNumber,
                ayahNumber: ayahNumber,
                juzNumber: juzNumber,
                hizbNumber: hizbNumber,
                pageNumber: pageNumber,
                verseText: verseText,
                translation: translation,
                reading: reading,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int surahNumber,
                required int ayahNumber,
                Value<int?> juzNumber = const Value.absent(),
                Value<int?> hizbNumber = const Value.absent(),
                Value<int?> pageNumber = const Value.absent(),
                required String verseText,
                Value<String?> translation = const Value.absent(),
                Value<String> reading = const Value.absent(),
              }) => QuranCompanion.insert(
                id: id,
                surahNumber: surahNumber,
                ayahNumber: ayahNumber,
                juzNumber: juzNumber,
                hizbNumber: hizbNumber,
                pageNumber: pageNumber,
                verseText: verseText,
                translation: translation,
                reading: reading,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$QuranTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $QuranTable,
      QuranData,
      $$QuranTableFilterComposer,
      $$QuranTableOrderingComposer,
      $$QuranTableAnnotationComposer,
      $$QuranTableCreateCompanionBuilder,
      $$QuranTableUpdateCompanionBuilder,
      (QuranData, BaseReferences<_$AppDatabase, $QuranTable, QuranData>),
      QuranData,
      PrefetchHooks Function()
    >;
typedef $$TafsirsTableCreateCompanionBuilder =
    TafsirsCompanion Function({
      Value<int> id,
      required int surahNumber,
      required int ayahNumber,
      required String tafsirText,
      required String type,
    });
typedef $$TafsirsTableUpdateCompanionBuilder =
    TafsirsCompanion Function({
      Value<int> id,
      Value<int> surahNumber,
      Value<int> ayahNumber,
      Value<String> tafsirText,
      Value<String> type,
    });

class $$TafsirsTableFilterComposer
    extends Composer<_$AppDatabase, $TafsirsTable> {
  $$TafsirsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get surahNumber => $composableBuilder(
    column: $table.surahNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ayahNumber => $composableBuilder(
    column: $table.ayahNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tafsirText => $composableBuilder(
    column: $table.tafsirText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TafsirsTableOrderingComposer
    extends Composer<_$AppDatabase, $TafsirsTable> {
  $$TafsirsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get surahNumber => $composableBuilder(
    column: $table.surahNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ayahNumber => $composableBuilder(
    column: $table.ayahNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tafsirText => $composableBuilder(
    column: $table.tafsirText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TafsirsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TafsirsTable> {
  $$TafsirsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get surahNumber => $composableBuilder(
    column: $table.surahNumber,
    builder: (column) => column,
  );

  GeneratedColumn<int> get ayahNumber => $composableBuilder(
    column: $table.ayahNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get tafsirText => $composableBuilder(
    column: $table.tafsirText,
    builder: (column) => column,
  );

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);
}

class $$TafsirsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TafsirsTable,
          Tafsir,
          $$TafsirsTableFilterComposer,
          $$TafsirsTableOrderingComposer,
          $$TafsirsTableAnnotationComposer,
          $$TafsirsTableCreateCompanionBuilder,
          $$TafsirsTableUpdateCompanionBuilder,
          (Tafsir, BaseReferences<_$AppDatabase, $TafsirsTable, Tafsir>),
          Tafsir,
          PrefetchHooks Function()
        > {
  $$TafsirsTableTableManager(_$AppDatabase db, $TafsirsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TafsirsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TafsirsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TafsirsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> surahNumber = const Value.absent(),
                Value<int> ayahNumber = const Value.absent(),
                Value<String> tafsirText = const Value.absent(),
                Value<String> type = const Value.absent(),
              }) => TafsirsCompanion(
                id: id,
                surahNumber: surahNumber,
                ayahNumber: ayahNumber,
                tafsirText: tafsirText,
                type: type,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int surahNumber,
                required int ayahNumber,
                required String tafsirText,
                required String type,
              }) => TafsirsCompanion.insert(
                id: id,
                surahNumber: surahNumber,
                ayahNumber: ayahNumber,
                tafsirText: tafsirText,
                type: type,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TafsirsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TafsirsTable,
      Tafsir,
      $$TafsirsTableFilterComposer,
      $$TafsirsTableOrderingComposer,
      $$TafsirsTableAnnotationComposer,
      $$TafsirsTableCreateCompanionBuilder,
      $$TafsirsTableUpdateCompanionBuilder,
      (Tafsir, BaseReferences<_$AppDatabase, $TafsirsTable, Tafsir>),
      Tafsir,
      PrefetchHooks Function()
    >;
typedef $$AzkarTableCreateCompanionBuilder =
    AzkarCompanion Function({
      Value<int> id,
      required String category,
      required String zikrText,
      Value<String?> reference,
      Value<int> count,
    });
typedef $$AzkarTableUpdateCompanionBuilder =
    AzkarCompanion Function({
      Value<int> id,
      Value<String> category,
      Value<String> zikrText,
      Value<String?> reference,
      Value<int> count,
    });

class $$AzkarTableFilterComposer extends Composer<_$AppDatabase, $AzkarTable> {
  $$AzkarTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get zikrText => $composableBuilder(
    column: $table.zikrText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reference => $composableBuilder(
    column: $table.reference,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get count => $composableBuilder(
    column: $table.count,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AzkarTableOrderingComposer
    extends Composer<_$AppDatabase, $AzkarTable> {
  $$AzkarTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get zikrText => $composableBuilder(
    column: $table.zikrText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reference => $composableBuilder(
    column: $table.reference,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get count => $composableBuilder(
    column: $table.count,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AzkarTableAnnotationComposer
    extends Composer<_$AppDatabase, $AzkarTable> {
  $$AzkarTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get zikrText =>
      $composableBuilder(column: $table.zikrText, builder: (column) => column);

  GeneratedColumn<String> get reference =>
      $composableBuilder(column: $table.reference, builder: (column) => column);

  GeneratedColumn<int> get count =>
      $composableBuilder(column: $table.count, builder: (column) => column);
}

class $$AzkarTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AzkarTable,
          AzkarData,
          $$AzkarTableFilterComposer,
          $$AzkarTableOrderingComposer,
          $$AzkarTableAnnotationComposer,
          $$AzkarTableCreateCompanionBuilder,
          $$AzkarTableUpdateCompanionBuilder,
          (AzkarData, BaseReferences<_$AppDatabase, $AzkarTable, AzkarData>),
          AzkarData,
          PrefetchHooks Function()
        > {
  $$AzkarTableTableManager(_$AppDatabase db, $AzkarTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AzkarTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AzkarTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AzkarTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> zikrText = const Value.absent(),
                Value<String?> reference = const Value.absent(),
                Value<int> count = const Value.absent(),
              }) => AzkarCompanion(
                id: id,
                category: category,
                zikrText: zikrText,
                reference: reference,
                count: count,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String category,
                required String zikrText,
                Value<String?> reference = const Value.absent(),
                Value<int> count = const Value.absent(),
              }) => AzkarCompanion.insert(
                id: id,
                category: category,
                zikrText: zikrText,
                reference: reference,
                count: count,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AzkarTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AzkarTable,
      AzkarData,
      $$AzkarTableFilterComposer,
      $$AzkarTableOrderingComposer,
      $$AzkarTableAnnotationComposer,
      $$AzkarTableCreateCompanionBuilder,
      $$AzkarTableUpdateCompanionBuilder,
      (AzkarData, BaseReferences<_$AppDatabase, $AzkarTable, AzkarData>),
      AzkarData,
      PrefetchHooks Function()
    >;
typedef $$UserProgressTableCreateCompanionBuilder =
    UserProgressCompanion Function({
      Value<int> id,
      required int surahNumber,
      required int ayahNumber,
      Value<DateTime> timestamp,
    });
typedef $$UserProgressTableUpdateCompanionBuilder =
    UserProgressCompanion Function({
      Value<int> id,
      Value<int> surahNumber,
      Value<int> ayahNumber,
      Value<DateTime> timestamp,
    });

class $$UserProgressTableFilterComposer
    extends Composer<_$AppDatabase, $UserProgressTable> {
  $$UserProgressTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get surahNumber => $composableBuilder(
    column: $table.surahNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ayahNumber => $composableBuilder(
    column: $table.ayahNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UserProgressTableOrderingComposer
    extends Composer<_$AppDatabase, $UserProgressTable> {
  $$UserProgressTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get surahNumber => $composableBuilder(
    column: $table.surahNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ayahNumber => $composableBuilder(
    column: $table.ayahNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserProgressTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserProgressTable> {
  $$UserProgressTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get surahNumber => $composableBuilder(
    column: $table.surahNumber,
    builder: (column) => column,
  );

  GeneratedColumn<int> get ayahNumber => $composableBuilder(
    column: $table.ayahNumber,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);
}

class $$UserProgressTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserProgressTable,
          UserProgressData,
          $$UserProgressTableFilterComposer,
          $$UserProgressTableOrderingComposer,
          $$UserProgressTableAnnotationComposer,
          $$UserProgressTableCreateCompanionBuilder,
          $$UserProgressTableUpdateCompanionBuilder,
          (
            UserProgressData,
            BaseReferences<_$AppDatabase, $UserProgressTable, UserProgressData>,
          ),
          UserProgressData,
          PrefetchHooks Function()
        > {
  $$UserProgressTableTableManager(_$AppDatabase db, $UserProgressTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserProgressTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserProgressTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserProgressTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> surahNumber = const Value.absent(),
                Value<int> ayahNumber = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
              }) => UserProgressCompanion(
                id: id,
                surahNumber: surahNumber,
                ayahNumber: ayahNumber,
                timestamp: timestamp,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int surahNumber,
                required int ayahNumber,
                Value<DateTime> timestamp = const Value.absent(),
              }) => UserProgressCompanion.insert(
                id: id,
                surahNumber: surahNumber,
                ayahNumber: ayahNumber,
                timestamp: timestamp,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserProgressTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserProgressTable,
      UserProgressData,
      $$UserProgressTableFilterComposer,
      $$UserProgressTableOrderingComposer,
      $$UserProgressTableAnnotationComposer,
      $$UserProgressTableCreateCompanionBuilder,
      $$UserProgressTableUpdateCompanionBuilder,
      (
        UserProgressData,
        BaseReferences<_$AppDatabase, $UserProgressTable, UserProgressData>,
      ),
      UserProgressData,
      PrefetchHooks Function()
    >;
typedef $$BookmarksTableCreateCompanionBuilder =
    BookmarksCompanion Function({
      Value<int> id,
      required int surahNumber,
      required int ayahNumber,
      Value<String?> note,
      Value<DateTime> timestamp,
    });
typedef $$BookmarksTableUpdateCompanionBuilder =
    BookmarksCompanion Function({
      Value<int> id,
      Value<int> surahNumber,
      Value<int> ayahNumber,
      Value<String?> note,
      Value<DateTime> timestamp,
    });

class $$BookmarksTableFilterComposer
    extends Composer<_$AppDatabase, $BookmarksTable> {
  $$BookmarksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get surahNumber => $composableBuilder(
    column: $table.surahNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ayahNumber => $composableBuilder(
    column: $table.ayahNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BookmarksTableOrderingComposer
    extends Composer<_$AppDatabase, $BookmarksTable> {
  $$BookmarksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get surahNumber => $composableBuilder(
    column: $table.surahNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ayahNumber => $composableBuilder(
    column: $table.ayahNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BookmarksTableAnnotationComposer
    extends Composer<_$AppDatabase, $BookmarksTable> {
  $$BookmarksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get surahNumber => $composableBuilder(
    column: $table.surahNumber,
    builder: (column) => column,
  );

  GeneratedColumn<int> get ayahNumber => $composableBuilder(
    column: $table.ayahNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);
}

class $$BookmarksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BookmarksTable,
          Bookmark,
          $$BookmarksTableFilterComposer,
          $$BookmarksTableOrderingComposer,
          $$BookmarksTableAnnotationComposer,
          $$BookmarksTableCreateCompanionBuilder,
          $$BookmarksTableUpdateCompanionBuilder,
          (Bookmark, BaseReferences<_$AppDatabase, $BookmarksTable, Bookmark>),
          Bookmark,
          PrefetchHooks Function()
        > {
  $$BookmarksTableTableManager(_$AppDatabase db, $BookmarksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BookmarksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BookmarksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BookmarksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> surahNumber = const Value.absent(),
                Value<int> ayahNumber = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
              }) => BookmarksCompanion(
                id: id,
                surahNumber: surahNumber,
                ayahNumber: ayahNumber,
                note: note,
                timestamp: timestamp,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int surahNumber,
                required int ayahNumber,
                Value<String?> note = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
              }) => BookmarksCompanion.insert(
                id: id,
                surahNumber: surahNumber,
                ayahNumber: ayahNumber,
                note: note,
                timestamp: timestamp,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BookmarksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BookmarksTable,
      Bookmark,
      $$BookmarksTableFilterComposer,
      $$BookmarksTableOrderingComposer,
      $$BookmarksTableAnnotationComposer,
      $$BookmarksTableCreateCompanionBuilder,
      $$BookmarksTableUpdateCompanionBuilder,
      (Bookmark, BaseReferences<_$AppDatabase, $BookmarksTable, Bookmark>),
      Bookmark,
      PrefetchHooks Function()
    >;
typedef $$AllahNamesTableCreateCompanionBuilder =
    AllahNamesCompanion Function({
      Value<int> id,
      required String name,
      required String meaning,
    });
typedef $$AllahNamesTableUpdateCompanionBuilder =
    AllahNamesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> meaning,
    });

class $$AllahNamesTableFilterComposer
    extends Composer<_$AppDatabase, $AllahNamesTable> {
  $$AllahNamesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get meaning => $composableBuilder(
    column: $table.meaning,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AllahNamesTableOrderingComposer
    extends Composer<_$AppDatabase, $AllahNamesTable> {
  $$AllahNamesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get meaning => $composableBuilder(
    column: $table.meaning,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AllahNamesTableAnnotationComposer
    extends Composer<_$AppDatabase, $AllahNamesTable> {
  $$AllahNamesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get meaning =>
      $composableBuilder(column: $table.meaning, builder: (column) => column);
}

class $$AllahNamesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AllahNamesTable,
          AllahName,
          $$AllahNamesTableFilterComposer,
          $$AllahNamesTableOrderingComposer,
          $$AllahNamesTableAnnotationComposer,
          $$AllahNamesTableCreateCompanionBuilder,
          $$AllahNamesTableUpdateCompanionBuilder,
          (
            AllahName,
            BaseReferences<_$AppDatabase, $AllahNamesTable, AllahName>,
          ),
          AllahName,
          PrefetchHooks Function()
        > {
  $$AllahNamesTableTableManager(_$AppDatabase db, $AllahNamesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AllahNamesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AllahNamesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AllahNamesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> meaning = const Value.absent(),
              }) => AllahNamesCompanion(id: id, name: name, meaning: meaning),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String meaning,
              }) => AllahNamesCompanion.insert(
                id: id,
                name: name,
                meaning: meaning,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AllahNamesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AllahNamesTable,
      AllahName,
      $$AllahNamesTableFilterComposer,
      $$AllahNamesTableOrderingComposer,
      $$AllahNamesTableAnnotationComposer,
      $$AllahNamesTableCreateCompanionBuilder,
      $$AllahNamesTableUpdateCompanionBuilder,
      (AllahName, BaseReferences<_$AppDatabase, $AllahNamesTable, AllahName>),
      AllahName,
      PrefetchHooks Function()
    >;
typedef $$KhatmaPlansTableCreateCompanionBuilder =
    KhatmaPlansCompanion Function({
      Value<int> id,
      required String title,
      required DateTime startDate,
      required int targetDays,
      Value<int> progressAyahs,
      Value<bool> isActive,
    });
typedef $$KhatmaPlansTableUpdateCompanionBuilder =
    KhatmaPlansCompanion Function({
      Value<int> id,
      Value<String> title,
      Value<DateTime> startDate,
      Value<int> targetDays,
      Value<int> progressAyahs,
      Value<bool> isActive,
    });

class $$KhatmaPlansTableFilterComposer
    extends Composer<_$AppDatabase, $KhatmaPlansTable> {
  $$KhatmaPlansTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get targetDays => $composableBuilder(
    column: $table.targetDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get progressAyahs => $composableBuilder(
    column: $table.progressAyahs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );
}

class $$KhatmaPlansTableOrderingComposer
    extends Composer<_$AppDatabase, $KhatmaPlansTable> {
  $$KhatmaPlansTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetDays => $composableBuilder(
    column: $table.targetDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get progressAyahs => $composableBuilder(
    column: $table.progressAyahs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$KhatmaPlansTableAnnotationComposer
    extends Composer<_$AppDatabase, $KhatmaPlansTable> {
  $$KhatmaPlansTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<int> get targetDays => $composableBuilder(
    column: $table.targetDays,
    builder: (column) => column,
  );

  GeneratedColumn<int> get progressAyahs => $composableBuilder(
    column: $table.progressAyahs,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);
}

class $$KhatmaPlansTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $KhatmaPlansTable,
          KhatmaPlan,
          $$KhatmaPlansTableFilterComposer,
          $$KhatmaPlansTableOrderingComposer,
          $$KhatmaPlansTableAnnotationComposer,
          $$KhatmaPlansTableCreateCompanionBuilder,
          $$KhatmaPlansTableUpdateCompanionBuilder,
          (
            KhatmaPlan,
            BaseReferences<_$AppDatabase, $KhatmaPlansTable, KhatmaPlan>,
          ),
          KhatmaPlan,
          PrefetchHooks Function()
        > {
  $$KhatmaPlansTableTableManager(_$AppDatabase db, $KhatmaPlansTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$KhatmaPlansTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$KhatmaPlansTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$KhatmaPlansTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<DateTime> startDate = const Value.absent(),
                Value<int> targetDays = const Value.absent(),
                Value<int> progressAyahs = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
              }) => KhatmaPlansCompanion(
                id: id,
                title: title,
                startDate: startDate,
                targetDays: targetDays,
                progressAyahs: progressAyahs,
                isActive: isActive,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String title,
                required DateTime startDate,
                required int targetDays,
                Value<int> progressAyahs = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
              }) => KhatmaPlansCompanion.insert(
                id: id,
                title: title,
                startDate: startDate,
                targetDays: targetDays,
                progressAyahs: progressAyahs,
                isActive: isActive,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$KhatmaPlansTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $KhatmaPlansTable,
      KhatmaPlan,
      $$KhatmaPlansTableFilterComposer,
      $$KhatmaPlansTableOrderingComposer,
      $$KhatmaPlansTableAnnotationComposer,
      $$KhatmaPlansTableCreateCompanionBuilder,
      $$KhatmaPlansTableUpdateCompanionBuilder,
      (
        KhatmaPlan,
        BaseReferences<_$AppDatabase, $KhatmaPlansTable, KhatmaPlan>,
      ),
      KhatmaPlan,
      PrefetchHooks Function()
    >;
typedef $$AchievementsTableCreateCompanionBuilder =
    AchievementsCompanion Function({
      Value<int> id,
      required String title,
      required String description,
      required String icon,
      Value<DateTime> dateEarned,
    });
typedef $$AchievementsTableUpdateCompanionBuilder =
    AchievementsCompanion Function({
      Value<int> id,
      Value<String> title,
      Value<String> description,
      Value<String> icon,
      Value<DateTime> dateEarned,
    });

class $$AchievementsTableFilterComposer
    extends Composer<_$AppDatabase, $AchievementsTable> {
  $$AchievementsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dateEarned => $composableBuilder(
    column: $table.dateEarned,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AchievementsTableOrderingComposer
    extends Composer<_$AppDatabase, $AchievementsTable> {
  $$AchievementsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dateEarned => $composableBuilder(
    column: $table.dateEarned,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AchievementsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AchievementsTable> {
  $$AchievementsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<DateTime> get dateEarned => $composableBuilder(
    column: $table.dateEarned,
    builder: (column) => column,
  );
}

class $$AchievementsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AchievementsTable,
          Achievement,
          $$AchievementsTableFilterComposer,
          $$AchievementsTableOrderingComposer,
          $$AchievementsTableAnnotationComposer,
          $$AchievementsTableCreateCompanionBuilder,
          $$AchievementsTableUpdateCompanionBuilder,
          (
            Achievement,
            BaseReferences<_$AppDatabase, $AchievementsTable, Achievement>,
          ),
          Achievement,
          PrefetchHooks Function()
        > {
  $$AchievementsTableTableManager(_$AppDatabase db, $AchievementsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AchievementsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AchievementsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AchievementsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String> icon = const Value.absent(),
                Value<DateTime> dateEarned = const Value.absent(),
              }) => AchievementsCompanion(
                id: id,
                title: title,
                description: description,
                icon: icon,
                dateEarned: dateEarned,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String title,
                required String description,
                required String icon,
                Value<DateTime> dateEarned = const Value.absent(),
              }) => AchievementsCompanion.insert(
                id: id,
                title: title,
                description: description,
                icon: icon,
                dateEarned: dateEarned,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AchievementsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AchievementsTable,
      Achievement,
      $$AchievementsTableFilterComposer,
      $$AchievementsTableOrderingComposer,
      $$AchievementsTableAnnotationComposer,
      $$AchievementsTableCreateCompanionBuilder,
      $$AchievementsTableUpdateCompanionBuilder,
      (
        Achievement,
        BaseReferences<_$AppDatabase, $AchievementsTable, Achievement>,
      ),
      Achievement,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$QuranTableTableManager get quran =>
      $$QuranTableTableManager(_db, _db.quran);
  $$TafsirsTableTableManager get tafsirs =>
      $$TafsirsTableTableManager(_db, _db.tafsirs);
  $$AzkarTableTableManager get azkar =>
      $$AzkarTableTableManager(_db, _db.azkar);
  $$UserProgressTableTableManager get userProgress =>
      $$UserProgressTableTableManager(_db, _db.userProgress);
  $$BookmarksTableTableManager get bookmarks =>
      $$BookmarksTableTableManager(_db, _db.bookmarks);
  $$AllahNamesTableTableManager get allahNames =>
      $$AllahNamesTableTableManager(_db, _db.allahNames);
  $$KhatmaPlansTableTableManager get khatmaPlans =>
      $$KhatmaPlansTableTableManager(_db, _db.khatmaPlans);
  $$AchievementsTableTableManager get achievements =>
      $$AchievementsTableTableManager(_db, _db.achievements);
}
