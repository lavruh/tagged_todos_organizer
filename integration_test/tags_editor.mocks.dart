// Mocks generated by Mockito 5.2.0 from annotations
// in tagged_todos_organizer/test/integration_test/tags_editor.dart.
// Do not manually edit this file.

import 'dart:async' as _i3;

import 'package:mockito/mockito.dart' as _i1;
import 'package:tagged_todos_organizer/utils/data/sembast_db_service.dart'
    as _i2;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types

/// A class which mocks [SembastDbService].
///
/// See the documentation for Mockito's code generation for more information.
class MockSembastDbService extends _i1.Mock implements _i2.SembastDbService {
  MockSembastDbService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Future<void> init({String? dbPath}) =>
      (super.noSuchMethod(Invocation.method(#init, [], {#dbPath: dbPath}),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i3.Future<void>);
  @override
  _i3.Future<void> add({Map<String, dynamic>? item, String? table}) => (super
      .noSuchMethod(Invocation.method(#add, [], {#item: item, #table: table}),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i3.Future<void>);
  @override
  _i3.Future<void> delete({String? id, String? table}) => (super.noSuchMethod(
      Invocation.method(#delete, [], {#id: id, #table: table}),
      returnValue: Future<void>.value(),
      returnValueForMissingStub: Future<void>.value()) as _i3.Future<void>);
  @override
  _i3.Future<void> deleteTable({String? table}) =>
      (super.noSuchMethod(Invocation.method(#deleteTable, [], {#table: table}),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i3.Future<void>);
  @override
  _i3.Stream<Map<String, dynamic>> getAll({String? table}) =>
      (super.noSuchMethod(Invocation.method(#getAll, [], {#table: table}),
              returnValue: Stream<Map<String, dynamic>>.empty())
          as _i3.Stream<Map<String, dynamic>>);
  @override
  _i3.Future<void> update(
          {String? id, Map<String, dynamic>? item, String? table}) =>
      (super.noSuchMethod(
          Invocation.method(#update, [], {#id: id, #item: item, #table: table}),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i3.Future<void>);
  @override
  _i3.Future<Map<String, String>> getChildrenIds(String? id) =>
      (super.noSuchMethod(Invocation.method(#getChildrenIds, [id]),
              returnValue:
                  Future<Map<String, String>>.value(<String, String>{}))
          as _i3.Future<Map<String, String>>);
  @override
  _i3.Future<Map<String, dynamic>> getItemByFieldValue(
          {Map<String, String>? request, String? table}) =>
      (super.noSuchMethod(
              Invocation.method(
                  #getItemByFieldValue, [], {#request: request, #table: table}),
              returnValue:
                  Future<Map<String, dynamic>>.value(<String, dynamic>{}))
          as _i3.Future<Map<String, dynamic>>);
}
