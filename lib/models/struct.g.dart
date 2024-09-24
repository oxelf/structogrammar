// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'struct.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetStructHeadCollection on Isar {
  IsarCollection<StructHead> get structs => this.collection();
}

const StructHeadSchema = CollectionSchema(
  name: r'StructHead',
  id: 2753164265162279301,
  properties: {
    r'primaryValue': PropertySchema(
      id: 0,
      name: r'primaryValue',
      type: IsarType.string,
    ),
    r'secondaryValue': PropertySchema(
      id: 1,
      name: r'secondaryValue',
      type: IsarType.string,
    ),
    r'structTextStyle': PropertySchema(
      id: 2,
      name: r'structTextStyle',
      type: IsarType.object,
      target: r'StructTextStyle',
    ),
    r'subStructs': PropertySchema(
      id: 3,
      name: r'subStructs',
      type: IsarType.objectList,
      target: r'Struct',
    ),
    r'type': PropertySchema(
      id: 4,
      name: r'type',
      type: IsarType.byte,
      enumMap: _StructHeadtypeEnumValueMap,
    ),
    r'width': PropertySchema(
      id: 5,
      name: r'width',
      type: IsarType.double,
    )
  },
  estimateSize: _structHeadEstimateSize,
  serialize: _structHeadSerialize,
  deserialize: _structHeadDeserialize,
  deserializeProp: _structHeadDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {
    r'StructTextStyle': StructTextStyleSchema,
    r'Struct': StructSchema
  },
  getId: _structHeadGetId,
  getLinks: _structHeadGetLinks,
  attach: _structHeadAttach,
  version: '3.1.0+1',
);

int _structHeadEstimateSize(
  StructHead object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.primaryValue.length * 3;
  bytesCount += 3 + object.secondaryValue.length * 3;
  {
    final value = object.structTextStyle;
    if (value != null) {
      bytesCount += 3 +
          StructTextStyleSchema.estimateSize(
              value, allOffsets[StructTextStyle]!, allOffsets);
    }
  }
  bytesCount += 3 + object.subStructs.length * 3;
  {
    final offsets = allOffsets[Struct]!;
    for (var i = 0; i < object.subStructs.length; i++) {
      final value = object.subStructs[i];
      bytesCount += StructSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  return bytesCount;
}

void _structHeadSerialize(
  StructHead object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.primaryValue);
  writer.writeString(offsets[1], object.secondaryValue);
  writer.writeObject<StructTextStyle>(
    offsets[2],
    allOffsets,
    StructTextStyleSchema.serialize,
    object.structTextStyle,
  );
  writer.writeObjectList<Struct>(
    offsets[3],
    allOffsets,
    StructSchema.serialize,
    object.subStructs,
  );
  writer.writeByte(offsets[4], object.type.index);
  writer.writeDouble(offsets[5], object.width);
}

StructHead _structHeadDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = StructHead(
    primaryValue: reader.readStringOrNull(offsets[0]) ?? "",
    secondaryValue: reader.readStringOrNull(offsets[1]) ?? "",
    structTextStyle: reader.readObjectOrNull<StructTextStyle>(
      offsets[2],
      StructTextStyleSchema.deserialize,
      allOffsets,
    ),
    subStructs: reader.readObjectList<Struct>(
          offsets[3],
          StructSchema.deserialize,
          allOffsets,
          Struct(),
        ) ??
        const [],
    type: _StructHeadtypeValueEnumMap[reader.readByteOrNull(offsets[4])] ??
        StructType.instruction,
    width: reader.readDoubleOrNull(offsets[5]),
  );
  object.id = id;
  return object;
}

P _structHeadDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset) ?? "") as P;
    case 1:
      return (reader.readStringOrNull(offset) ?? "") as P;
    case 2:
      return (reader.readObjectOrNull<StructTextStyle>(
        offset,
        StructTextStyleSchema.deserialize,
        allOffsets,
      )) as P;
    case 3:
      return (reader.readObjectList<Struct>(
            offset,
            StructSchema.deserialize,
            allOffsets,
            Struct(),
          ) ??
          const []) as P;
    case 4:
      return (_StructHeadtypeValueEnumMap[reader.readByteOrNull(offset)] ??
          StructType.instruction) as P;
    case 5:
      return (reader.readDoubleOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _StructHeadtypeEnumValueMap = {
  'function': 0,
  'instruction': 1,
  'ifStatement': 2,
  'ifCondition': 3,
  'switchStatement': 4,
  'caseStatement': 5,
  'forLoop': 6,
  'whileLoop': 7,
  'doWhileLoop': 8,
  'callStatement': 9,
  'returnStatement': 10,
  'tryStatement': 11,
  'catchStatement': 12,
};
const _StructHeadtypeValueEnumMap = {
  0: StructType.function,
  1: StructType.instruction,
  2: StructType.ifStatement,
  3: StructType.ifCondition,
  4: StructType.switchStatement,
  5: StructType.caseStatement,
  6: StructType.forLoop,
  7: StructType.whileLoop,
  8: StructType.doWhileLoop,
  9: StructType.callStatement,
  10: StructType.returnStatement,
  11: StructType.tryStatement,
  12: StructType.catchStatement,
};

Id _structHeadGetId(StructHead object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _structHeadGetLinks(StructHead object) {
  return [];
}

void _structHeadAttach(IsarCollection<dynamic> col, Id id, StructHead object) {
  object.id = id;
}

extension StructHeadQueryWhereSort
    on QueryBuilder<StructHead, StructHead, QWhere> {
  QueryBuilder<StructHead, StructHead, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension StructHeadQueryWhere
    on QueryBuilder<StructHead, StructHead, QWhereClause> {
  QueryBuilder<StructHead, StructHead, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<StructHead, StructHead, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<StructHead, StructHead, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<StructHead, StructHead, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<StructHead, StructHead, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension StructHeadQueryFilter
    on QueryBuilder<StructHead, StructHead, QFilterCondition> {
  QueryBuilder<StructHead, StructHead, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<StructHead, StructHead, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<StructHead, StructHead, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<StructHead, StructHead, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<StructHead, StructHead, QAfterFilterCondition>
      primaryValueEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'primaryValue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StructHead, StructHead, QAfterFilterCondition>
      primaryValueGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'primaryValue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StructHead, StructHead, QAfterFilterCondition>
      primaryValueLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'primaryValue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StructHead, StructHead, QAfterFilterCondition>
      primaryValueBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'primaryValue',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StructHead, StructHead, QAfterFilterCondition>
      primaryValueStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'primaryValue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StructHead, StructHead, QAfterFilterCondition>
      primaryValueEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'primaryValue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StructHead, StructHead, QAfterFilterCondition>
      primaryValueContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'primaryValue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StructHead, StructHead, QAfterFilterCondition>
      primaryValueMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'primaryValue',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StructHead, StructHead, QAfterFilterCondition>
      primaryValueIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'primaryValue',
        value: '',
      ));
    });
  }

  QueryBuilder<StructHead, StructHead, QAfterFilterCondition>
      primaryValueIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'primaryValue',
        value: '',
      ));
    });
  }

  QueryBuilder<StructHead, StructHead, QAfterFilterCondition>
      secondaryValueEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'secondaryValue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StructHead, StructHead, QAfterFilterCondition>
      secondaryValueGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'secondaryValue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StructHead, StructHead, QAfterFilterCondition>
      secondaryValueLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'secondaryValue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StructHead, StructHead, QAfterFilterCondition>
      secondaryValueBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'secondaryValue',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StructHead, StructHead, QAfterFilterCondition>
      secondaryValueStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'secondaryValue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StructHead, StructHead, QAfterFilterCondition>
      secondaryValueEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'secondaryValue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StructHead, StructHead, QAfterFilterCondition>
      secondaryValueContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'secondaryValue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StructHead, StructHead, QAfterFilterCondition>
      secondaryValueMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'secondaryValue',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StructHead, StructHead, QAfterFilterCondition>
      secondaryValueIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'secondaryValue',
        value: '',
      ));
    });
  }

  QueryBuilder<StructHead, StructHead, QAfterFilterCondition>
      secondaryValueIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'secondaryValue',
        value: '',
      ));
    });
  }

  QueryBuilder<StructHead, StructHead, QAfterFilterCondition>
      structTextStyleIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'structTextStyle',
      ));
    });
  }

  QueryBuilder<StructHead, StructHead, QAfterFilterCondition>
      structTextStyleIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'structTextStyle',
      ));
    });
  }

  QueryBuilder<StructHead, StructHead, QAfterFilterCondition>
      subStructsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'subStructs',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<StructHead, StructHead, QAfterFilterCondition>
      subStructsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'subStructs',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<StructHead, StructHead, QAfterFilterCondition>
      subStructsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'subStructs',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<StructHead, StructHead, QAfterFilterCondition>
      subStructsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'subStructs',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<StructHead, StructHead, QAfterFilterCondition>
      subStructsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'subStructs',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<StructHead, StructHead, QAfterFilterCondition>
      subStructsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'subStructs',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<StructHead, StructHead, QAfterFilterCondition> typeEqualTo(
      StructType value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: value,
      ));
    });
  }

  QueryBuilder<StructHead, StructHead, QAfterFilterCondition> typeGreaterThan(
    StructType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'type',
        value: value,
      ));
    });
  }

  QueryBuilder<StructHead, StructHead, QAfterFilterCondition> typeLessThan(
    StructType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'type',
        value: value,
      ));
    });
  }

  QueryBuilder<StructHead, StructHead, QAfterFilterCondition> typeBetween(
    StructType lower,
    StructType upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'type',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<StructHead, StructHead, QAfterFilterCondition> widthIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'width',
      ));
    });
  }

  QueryBuilder<StructHead, StructHead, QAfterFilterCondition> widthIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'width',
      ));
    });
  }

  QueryBuilder<StructHead, StructHead, QAfterFilterCondition> widthEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'width',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<StructHead, StructHead, QAfterFilterCondition> widthGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'width',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<StructHead, StructHead, QAfterFilterCondition> widthLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'width',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<StructHead, StructHead, QAfterFilterCondition> widthBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'width',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }
}

extension StructHeadQueryObject
    on QueryBuilder<StructHead, StructHead, QFilterCondition> {
  QueryBuilder<StructHead, StructHead, QAfterFilterCondition> structTextStyle(
      FilterQuery<StructTextStyle> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'structTextStyle');
    });
  }

  QueryBuilder<StructHead, StructHead, QAfterFilterCondition> subStructsElement(
      FilterQuery<Struct> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'subStructs');
    });
  }
}

extension StructHeadQueryLinks
    on QueryBuilder<StructHead, StructHead, QFilterCondition> {}

extension StructHeadQuerySortBy
    on QueryBuilder<StructHead, StructHead, QSortBy> {
  QueryBuilder<StructHead, StructHead, QAfterSortBy> sortByPrimaryValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'primaryValue', Sort.asc);
    });
  }

  QueryBuilder<StructHead, StructHead, QAfterSortBy> sortByPrimaryValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'primaryValue', Sort.desc);
    });
  }

  QueryBuilder<StructHead, StructHead, QAfterSortBy> sortBySecondaryValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'secondaryValue', Sort.asc);
    });
  }

  QueryBuilder<StructHead, StructHead, QAfterSortBy>
      sortBySecondaryValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'secondaryValue', Sort.desc);
    });
  }

  QueryBuilder<StructHead, StructHead, QAfterSortBy> sortByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<StructHead, StructHead, QAfterSortBy> sortByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }

  QueryBuilder<StructHead, StructHead, QAfterSortBy> sortByWidth() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'width', Sort.asc);
    });
  }

  QueryBuilder<StructHead, StructHead, QAfterSortBy> sortByWidthDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'width', Sort.desc);
    });
  }
}

extension StructHeadQuerySortThenBy
    on QueryBuilder<StructHead, StructHead, QSortThenBy> {
  QueryBuilder<StructHead, StructHead, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<StructHead, StructHead, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<StructHead, StructHead, QAfterSortBy> thenByPrimaryValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'primaryValue', Sort.asc);
    });
  }

  QueryBuilder<StructHead, StructHead, QAfterSortBy> thenByPrimaryValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'primaryValue', Sort.desc);
    });
  }

  QueryBuilder<StructHead, StructHead, QAfterSortBy> thenBySecondaryValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'secondaryValue', Sort.asc);
    });
  }

  QueryBuilder<StructHead, StructHead, QAfterSortBy>
      thenBySecondaryValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'secondaryValue', Sort.desc);
    });
  }

  QueryBuilder<StructHead, StructHead, QAfterSortBy> thenByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<StructHead, StructHead, QAfterSortBy> thenByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }

  QueryBuilder<StructHead, StructHead, QAfterSortBy> thenByWidth() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'width', Sort.asc);
    });
  }

  QueryBuilder<StructHead, StructHead, QAfterSortBy> thenByWidthDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'width', Sort.desc);
    });
  }
}

extension StructHeadQueryWhereDistinct
    on QueryBuilder<StructHead, StructHead, QDistinct> {
  QueryBuilder<StructHead, StructHead, QDistinct> distinctByPrimaryValue(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'primaryValue', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<StructHead, StructHead, QDistinct> distinctBySecondaryValue(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'secondaryValue',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<StructHead, StructHead, QDistinct> distinctByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'type');
    });
  }

  QueryBuilder<StructHead, StructHead, QDistinct> distinctByWidth() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'width');
    });
  }
}

extension StructHeadQueryProperty
    on QueryBuilder<StructHead, StructHead, QQueryProperty> {
  QueryBuilder<StructHead, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<StructHead, String, QQueryOperations> primaryValueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'primaryValue');
    });
  }

  QueryBuilder<StructHead, String, QQueryOperations> secondaryValueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'secondaryValue');
    });
  }

  QueryBuilder<StructHead, StructTextStyle?, QQueryOperations>
      structTextStyleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'structTextStyle');
    });
  }

  QueryBuilder<StructHead, List<Struct>, QQueryOperations>
      subStructsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'subStructs');
    });
  }

  QueryBuilder<StructHead, StructType, QQueryOperations> typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'type');
    });
  }

  QueryBuilder<StructHead, double?, QQueryOperations> widthProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'width');
    });
  }
}

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const StructTextStyleSchema = Schema(
  name: r'StructTextStyle',
  id: -7943660380423433803,
  properties: {
    r'color': PropertySchema(
      id: 0,
      name: r'color',
      type: IsarType.string,
    ),
    r'fontFamily': PropertySchema(
      id: 1,
      name: r'fontFamily',
      type: IsarType.string,
    ),
    r'fontSize': PropertySchema(
      id: 2,
      name: r'fontSize',
      type: IsarType.long,
    ),
    r'fontWeight': PropertySchema(
      id: 3,
      name: r'fontWeight',
      type: IsarType.byte,
      enumMap: _StructTextStylefontWeightEnumValueMap,
    )
  },
  estimateSize: _structTextStyleEstimateSize,
  serialize: _structTextStyleSerialize,
  deserialize: _structTextStyleDeserialize,
  deserializeProp: _structTextStyleDeserializeProp,
);

int _structTextStyleEstimateSize(
  StructTextStyle object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.color;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.fontFamily;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _structTextStyleSerialize(
  StructTextStyle object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.color);
  writer.writeString(offsets[1], object.fontFamily);
  writer.writeLong(offsets[2], object.fontSize);
  writer.writeByte(offsets[3], object.fontWeight.index);
}

StructTextStyle _structTextStyleDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = StructTextStyle(
    color: reader.readStringOrNull(offsets[0]),
    fontFamily: reader.readStringOrNull(offsets[1]),
    fontSize: reader.readLongOrNull(offsets[2]),
    fontWeight: _StructTextStylefontWeightValueEnumMap[
            reader.readByteOrNull(offsets[3])] ??
        StructFontWeight.w400,
  );
  return object;
}

P _structTextStyleDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readLongOrNull(offset)) as P;
    case 3:
      return (_StructTextStylefontWeightValueEnumMap[
              reader.readByteOrNull(offset)] ??
          StructFontWeight.w400) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _StructTextStylefontWeightEnumValueMap = {
  'w100': 0,
  'w200': 1,
  'w300': 2,
  'w400': 3,
  'w500': 4,
  'w600': 5,
  'w700': 6,
  'w800': 7,
  'w900': 8,
};
const _StructTextStylefontWeightValueEnumMap = {
  0: StructFontWeight.w100,
  1: StructFontWeight.w200,
  2: StructFontWeight.w300,
  3: StructFontWeight.w400,
  4: StructFontWeight.w500,
  5: StructFontWeight.w600,
  6: StructFontWeight.w700,
  7: StructFontWeight.w800,
  8: StructFontWeight.w900,
};

extension StructTextStyleQueryFilter
    on QueryBuilder<StructTextStyle, StructTextStyle, QFilterCondition> {
  QueryBuilder<StructTextStyle, StructTextStyle, QAfterFilterCondition>
      colorIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'color',
      ));
    });
  }

  QueryBuilder<StructTextStyle, StructTextStyle, QAfterFilterCondition>
      colorIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'color',
      ));
    });
  }

  QueryBuilder<StructTextStyle, StructTextStyle, QAfterFilterCondition>
      colorEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'color',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StructTextStyle, StructTextStyle, QAfterFilterCondition>
      colorGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'color',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StructTextStyle, StructTextStyle, QAfterFilterCondition>
      colorLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'color',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StructTextStyle, StructTextStyle, QAfterFilterCondition>
      colorBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'color',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StructTextStyle, StructTextStyle, QAfterFilterCondition>
      colorStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'color',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StructTextStyle, StructTextStyle, QAfterFilterCondition>
      colorEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'color',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StructTextStyle, StructTextStyle, QAfterFilterCondition>
      colorContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'color',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StructTextStyle, StructTextStyle, QAfterFilterCondition>
      colorMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'color',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StructTextStyle, StructTextStyle, QAfterFilterCondition>
      colorIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'color',
        value: '',
      ));
    });
  }

  QueryBuilder<StructTextStyle, StructTextStyle, QAfterFilterCondition>
      colorIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'color',
        value: '',
      ));
    });
  }

  QueryBuilder<StructTextStyle, StructTextStyle, QAfterFilterCondition>
      fontFamilyIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'fontFamily',
      ));
    });
  }

  QueryBuilder<StructTextStyle, StructTextStyle, QAfterFilterCondition>
      fontFamilyIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'fontFamily',
      ));
    });
  }

  QueryBuilder<StructTextStyle, StructTextStyle, QAfterFilterCondition>
      fontFamilyEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fontFamily',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StructTextStyle, StructTextStyle, QAfterFilterCondition>
      fontFamilyGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fontFamily',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StructTextStyle, StructTextStyle, QAfterFilterCondition>
      fontFamilyLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fontFamily',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StructTextStyle, StructTextStyle, QAfterFilterCondition>
      fontFamilyBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fontFamily',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StructTextStyle, StructTextStyle, QAfterFilterCondition>
      fontFamilyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'fontFamily',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StructTextStyle, StructTextStyle, QAfterFilterCondition>
      fontFamilyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'fontFamily',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StructTextStyle, StructTextStyle, QAfterFilterCondition>
      fontFamilyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'fontFamily',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StructTextStyle, StructTextStyle, QAfterFilterCondition>
      fontFamilyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'fontFamily',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StructTextStyle, StructTextStyle, QAfterFilterCondition>
      fontFamilyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fontFamily',
        value: '',
      ));
    });
  }

  QueryBuilder<StructTextStyle, StructTextStyle, QAfterFilterCondition>
      fontFamilyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'fontFamily',
        value: '',
      ));
    });
  }

  QueryBuilder<StructTextStyle, StructTextStyle, QAfterFilterCondition>
      fontSizeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'fontSize',
      ));
    });
  }

  QueryBuilder<StructTextStyle, StructTextStyle, QAfterFilterCondition>
      fontSizeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'fontSize',
      ));
    });
  }

  QueryBuilder<StructTextStyle, StructTextStyle, QAfterFilterCondition>
      fontSizeEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fontSize',
        value: value,
      ));
    });
  }

  QueryBuilder<StructTextStyle, StructTextStyle, QAfterFilterCondition>
      fontSizeGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fontSize',
        value: value,
      ));
    });
  }

  QueryBuilder<StructTextStyle, StructTextStyle, QAfterFilterCondition>
      fontSizeLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fontSize',
        value: value,
      ));
    });
  }

  QueryBuilder<StructTextStyle, StructTextStyle, QAfterFilterCondition>
      fontSizeBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fontSize',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<StructTextStyle, StructTextStyle, QAfterFilterCondition>
      fontWeightEqualTo(StructFontWeight value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fontWeight',
        value: value,
      ));
    });
  }

  QueryBuilder<StructTextStyle, StructTextStyle, QAfterFilterCondition>
      fontWeightGreaterThan(
    StructFontWeight value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fontWeight',
        value: value,
      ));
    });
  }

  QueryBuilder<StructTextStyle, StructTextStyle, QAfterFilterCondition>
      fontWeightLessThan(
    StructFontWeight value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fontWeight',
        value: value,
      ));
    });
  }

  QueryBuilder<StructTextStyle, StructTextStyle, QAfterFilterCondition>
      fontWeightBetween(
    StructFontWeight lower,
    StructFontWeight upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fontWeight',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension StructTextStyleQueryObject
    on QueryBuilder<StructTextStyle, StructTextStyle, QFilterCondition> {}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const StructSchema = Schema(
  name: r'Struct',
  id: 8367584819568159692,
  properties: {
    r'id': PropertySchema(
      id: 0,
      name: r'id',
      type: IsarType.long,
    ),
    r'primaryValue': PropertySchema(
      id: 1,
      name: r'primaryValue',
      type: IsarType.string,
    ),
    r'secondaryValue': PropertySchema(
      id: 2,
      name: r'secondaryValue',
      type: IsarType.string,
    ),
    r'structTextStyle': PropertySchema(
      id: 3,
      name: r'structTextStyle',
      type: IsarType.object,
      target: r'StructTextStyle',
    ),
    r'subStructs': PropertySchema(
      id: 4,
      name: r'subStructs',
      type: IsarType.objectList,
      target: r'Struct',
    ),
    r'type': PropertySchema(
      id: 5,
      name: r'type',
      type: IsarType.byte,
      enumMap: _StructtypeEnumValueMap,
    ),
    r'width': PropertySchema(
      id: 6,
      name: r'width',
      type: IsarType.double,
    )
  },
  estimateSize: _structEstimateSize,
  serialize: _structSerialize,
  deserialize: _structDeserialize,
  deserializeProp: _structDeserializeProp,
);

int _structEstimateSize(
  Struct object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.primaryValue.length * 3;
  bytesCount += 3 + object.secondaryValue.length * 3;
  {
    final value = object.structTextStyle;
    if (value != null) {
      bytesCount += 3 +
          StructTextStyleSchema.estimateSize(
              value, allOffsets[StructTextStyle]!, allOffsets);
    }
  }
  bytesCount += 3 + object.subStructs.length * 3;
  {
    final offsets = allOffsets[Struct]!;
    for (var i = 0; i < object.subStructs.length; i++) {
      final value = object.subStructs[i];
      bytesCount += StructSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  return bytesCount;
}

void _structSerialize(
  Struct object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.id);
  writer.writeString(offsets[1], object.primaryValue);
  writer.writeString(offsets[2], object.secondaryValue);
  writer.writeObject<StructTextStyle>(
    offsets[3],
    allOffsets,
    StructTextStyleSchema.serialize,
    object.structTextStyle,
  );
  writer.writeObjectList<Struct>(
    offsets[4],
    allOffsets,
    StructSchema.serialize,
    object.subStructs,
  );
  writer.writeByte(offsets[5], object.type.index);
  writer.writeDouble(offsets[6], object.width);
}

Struct _structDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Struct(
    id: reader.readLongOrNull(offsets[0]),
    primaryValue: reader.readStringOrNull(offsets[1]) ?? "",
    secondaryValue: reader.readStringOrNull(offsets[2]) ?? "",
    structTextStyle: reader.readObjectOrNull<StructTextStyle>(
      offsets[3],
      StructTextStyleSchema.deserialize,
      allOffsets,
    ),
    subStructs: reader.readObjectList<Struct>(
          offsets[4],
          StructSchema.deserialize,
          allOffsets,
          Struct(),
        ) ??
        const [],
    type: _StructtypeValueEnumMap[reader.readByteOrNull(offsets[5])] ??
        StructType.instruction,
    width: reader.readDoubleOrNull(offsets[6]),
  );
  return object;
}

P _structDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset) ?? "") as P;
    case 2:
      return (reader.readStringOrNull(offset) ?? "") as P;
    case 3:
      return (reader.readObjectOrNull<StructTextStyle>(
        offset,
        StructTextStyleSchema.deserialize,
        allOffsets,
      )) as P;
    case 4:
      return (reader.readObjectList<Struct>(
            offset,
            StructSchema.deserialize,
            allOffsets,
            Struct(),
          ) ??
          const []) as P;
    case 5:
      return (_StructtypeValueEnumMap[reader.readByteOrNull(offset)] ??
          StructType.instruction) as P;
    case 6:
      return (reader.readDoubleOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _StructtypeEnumValueMap = {
  'function': 0,
  'instruction': 1,
  'ifStatement': 2,
  'ifCondition': 3,
  'switchStatement': 4,
  'caseStatement': 5,
  'forLoop': 6,
  'whileLoop': 7,
  'doWhileLoop': 8,
  'callStatement': 9,
  'returnStatement': 10,
  'tryStatement': 11,
  'catchStatement': 12,
};
const _StructtypeValueEnumMap = {
  0: StructType.function,
  1: StructType.instruction,
  2: StructType.ifStatement,
  3: StructType.ifCondition,
  4: StructType.switchStatement,
  5: StructType.caseStatement,
  6: StructType.forLoop,
  7: StructType.whileLoop,
  8: StructType.doWhileLoop,
  9: StructType.callStatement,
  10: StructType.returnStatement,
  11: StructType.tryStatement,
  12: StructType.catchStatement,
};

extension StructQueryFilter on QueryBuilder<Struct, Struct, QFilterCondition> {
  QueryBuilder<Struct, Struct, QAfterFilterCondition> idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<Struct, Struct, QAfterFilterCondition> idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<Struct, Struct, QAfterFilterCondition> idEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Struct, Struct, QAfterFilterCondition> idGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Struct, Struct, QAfterFilterCondition> idLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Struct, Struct, QAfterFilterCondition> idBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Struct, Struct, QAfterFilterCondition> primaryValueEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'primaryValue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Struct, Struct, QAfterFilterCondition> primaryValueGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'primaryValue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Struct, Struct, QAfterFilterCondition> primaryValueLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'primaryValue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Struct, Struct, QAfterFilterCondition> primaryValueBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'primaryValue',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Struct, Struct, QAfterFilterCondition> primaryValueStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'primaryValue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Struct, Struct, QAfterFilterCondition> primaryValueEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'primaryValue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Struct, Struct, QAfterFilterCondition> primaryValueContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'primaryValue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Struct, Struct, QAfterFilterCondition> primaryValueMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'primaryValue',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Struct, Struct, QAfterFilterCondition> primaryValueIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'primaryValue',
        value: '',
      ));
    });
  }

  QueryBuilder<Struct, Struct, QAfterFilterCondition> primaryValueIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'primaryValue',
        value: '',
      ));
    });
  }

  QueryBuilder<Struct, Struct, QAfterFilterCondition> secondaryValueEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'secondaryValue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Struct, Struct, QAfterFilterCondition> secondaryValueGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'secondaryValue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Struct, Struct, QAfterFilterCondition> secondaryValueLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'secondaryValue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Struct, Struct, QAfterFilterCondition> secondaryValueBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'secondaryValue',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Struct, Struct, QAfterFilterCondition> secondaryValueStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'secondaryValue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Struct, Struct, QAfterFilterCondition> secondaryValueEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'secondaryValue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Struct, Struct, QAfterFilterCondition> secondaryValueContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'secondaryValue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Struct, Struct, QAfterFilterCondition> secondaryValueMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'secondaryValue',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Struct, Struct, QAfterFilterCondition> secondaryValueIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'secondaryValue',
        value: '',
      ));
    });
  }

  QueryBuilder<Struct, Struct, QAfterFilterCondition>
      secondaryValueIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'secondaryValue',
        value: '',
      ));
    });
  }

  QueryBuilder<Struct, Struct, QAfterFilterCondition> structTextStyleIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'structTextStyle',
      ));
    });
  }

  QueryBuilder<Struct, Struct, QAfterFilterCondition>
      structTextStyleIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'structTextStyle',
      ));
    });
  }

  QueryBuilder<Struct, Struct, QAfterFilterCondition> subStructsLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'subStructs',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Struct, Struct, QAfterFilterCondition> subStructsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'subStructs',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Struct, Struct, QAfterFilterCondition> subStructsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'subStructs',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Struct, Struct, QAfterFilterCondition> subStructsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'subStructs',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Struct, Struct, QAfterFilterCondition>
      subStructsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'subStructs',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Struct, Struct, QAfterFilterCondition> subStructsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'subStructs',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Struct, Struct, QAfterFilterCondition> typeEqualTo(
      StructType value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: value,
      ));
    });
  }

  QueryBuilder<Struct, Struct, QAfterFilterCondition> typeGreaterThan(
    StructType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'type',
        value: value,
      ));
    });
  }

  QueryBuilder<Struct, Struct, QAfterFilterCondition> typeLessThan(
    StructType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'type',
        value: value,
      ));
    });
  }

  QueryBuilder<Struct, Struct, QAfterFilterCondition> typeBetween(
    StructType lower,
    StructType upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'type',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Struct, Struct, QAfterFilterCondition> widthIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'width',
      ));
    });
  }

  QueryBuilder<Struct, Struct, QAfterFilterCondition> widthIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'width',
      ));
    });
  }

  QueryBuilder<Struct, Struct, QAfterFilterCondition> widthEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'width',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Struct, Struct, QAfterFilterCondition> widthGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'width',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Struct, Struct, QAfterFilterCondition> widthLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'width',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Struct, Struct, QAfterFilterCondition> widthBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'width',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }
}

extension StructQueryObject on QueryBuilder<Struct, Struct, QFilterCondition> {
  QueryBuilder<Struct, Struct, QAfterFilterCondition> structTextStyle(
      FilterQuery<StructTextStyle> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'structTextStyle');
    });
  }

  QueryBuilder<Struct, Struct, QAfterFilterCondition> subStructsElement(
      FilterQuery<Struct> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'subStructs');
    });
  }
}
