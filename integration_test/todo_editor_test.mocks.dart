// Mocks generated by Mockito 5.3.2 from annotations
// in tagged_todos_organizer/test/integration_test/todo_editor_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i3;

import 'package:mockito/mockito.dart' as _i1;
import 'package:tagged_todos_organizer/utils/data/i_db_service.dart' as _i2;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

/// A class which mocks [IDbService].
///
/// See the documentation for Mockito's code generation for more information.
class MockIDbService extends _i1.Mock implements _i2.IDbService {
  MockIDbService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Future<void> init({required String? dbPath}) => (super.noSuchMethod(
        Invocation.method(
          #init,
          [],
          {#dbPath: dbPath},
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);
  @override
  _i3.Future<void> add({
    required Map<String, dynamic>? item,
    required String? table,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #add,
          [],
          {
            #item: item,
            #table: table,
          },
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);
  @override
  _i3.Future<void> update({
    required String? id,
    required Map<String, dynamic>? item,
    required String? table,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #update,
          [],
          {
            #id: id,
            #item: item,
            #table: table,
          },
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);
  @override
  _i3.Future<void> delete({
    required String? id,
    required String? table,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #delete,
          [],
          {
            #id: id,
            #table: table,
          },
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);
  @override
  _i3.Stream<Map<String, dynamic>> getAll({required String? table}) =>
      (super.noSuchMethod(
        Invocation.method(
          #getAll,
          [],
          {#table: table},
        ),
        returnValue: _i3.Stream<Map<String, dynamic>>.empty(),
      ) as _i3.Stream<Map<String, dynamic>>);
  @override
  _i3.Future<void> deleteTable({required String? table}) => (super.noSuchMethod(
        Invocation.method(
          #deleteTable,
          [],
          {#table: table},
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);
  @override
  _i3.Future<Map<String, dynamic>> getItemByFieldValue({
    required Map<String, String>? request,
    required String? table,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #getItemByFieldValue,
          [],
          {
            #request: request,
            #table: table,
          },
        ),
        returnValue:
            _i3.Future<Map<String, dynamic>>.value(<String, dynamic>{}),
      ) as _i3.Future<Map<String, dynamic>>);
}
