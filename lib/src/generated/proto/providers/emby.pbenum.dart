// This is a generated file - do not edit.
//
// Generated from proto/providers/emby.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class ListMode extends $pb.ProtobufEnum {
  static const ListMode LIST_MODE_FOLDER =
      ListMode._(0, _omitEnumNames ? '' : 'LIST_MODE_FOLDER');
  static const ListMode LIST_MODE_FAVORITE_ITEMS =
      ListMode._(1, _omitEnumNames ? '' : 'LIST_MODE_FAVORITE_ITEMS');
  static const ListMode LIST_MODE_FAVORITE_PEOPLE =
      ListMode._(2, _omitEnumNames ? '' : 'LIST_MODE_FAVORITE_PEOPLE');
  static const ListMode LIST_MODE_PERSON_ITEMS =
      ListMode._(3, _omitEnumNames ? '' : 'LIST_MODE_PERSON_ITEMS');
  static const ListMode LIST_MODE_CONTINUE_WATCHING =
      ListMode._(4, _omitEnumNames ? '' : 'LIST_MODE_CONTINUE_WATCHING');
  static const ListMode LIST_MODE_NEXT_UP =
      ListMode._(5, _omitEnumNames ? '' : 'LIST_MODE_NEXT_UP');
  static const ListMode LIST_MODE_RECENTLY_ADDED =
      ListMode._(6, _omitEnumNames ? '' : 'LIST_MODE_RECENTLY_ADDED');
  static const ListMode LIST_MODE_PLAYLISTS =
      ListMode._(7, _omitEnumNames ? '' : 'LIST_MODE_PLAYLISTS');
  static const ListMode LIST_MODE_COLLECTIONS =
      ListMode._(8, _omitEnumNames ? '' : 'LIST_MODE_COLLECTIONS');
  static const ListMode LIST_MODE_GENRES =
      ListMode._(9, _omitEnumNames ? '' : 'LIST_MODE_GENRES');
  static const ListMode LIST_MODE_GENRE_ITEMS =
      ListMode._(10, _omitEnumNames ? '' : 'LIST_MODE_GENRE_ITEMS');

  static const $core.List<ListMode> values = <ListMode>[
    LIST_MODE_FOLDER,
    LIST_MODE_FAVORITE_ITEMS,
    LIST_MODE_FAVORITE_PEOPLE,
    LIST_MODE_PERSON_ITEMS,
    LIST_MODE_CONTINUE_WATCHING,
    LIST_MODE_NEXT_UP,
    LIST_MODE_RECENTLY_ADDED,
    LIST_MODE_PLAYLISTS,
    LIST_MODE_COLLECTIONS,
    LIST_MODE_GENRES,
    LIST_MODE_GENRE_ITEMS,
  ];

  static final $core.List<ListMode?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 10);
  static ListMode? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ListMode._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
