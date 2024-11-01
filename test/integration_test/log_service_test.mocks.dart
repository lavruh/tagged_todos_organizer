// Mocks generated by Mockito 5.4.4 from annotations
// in tagged_todos_organizer/test/integration_test/log_service_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i5;
import 'dart:io' as _i2;

import 'package:flutter_riverpod/flutter_riverpod.dart' as _i3;
import 'package:mockito/mockito.dart' as _i1;
import 'package:mockito/src/dummies.dart' as _i6;
import 'package:state_notifier/state_notifier.dart' as _i7;
import 'package:tagged_todos_organizer/todos/domain/attachments_provider.dart'
    as _i4;
import 'package:tagged_todos_organizer/utils/data/i_db_service.dart' as _i8;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeDirectory_0 extends _i1.SmartFake implements _i2.Directory {
  _FakeDirectory_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeStateNotifierProviderRef_1<NotifierT extends _i3.StateNotifier<T>, T>
    extends _i1.SmartFake
    implements _i3.StateNotifierProviderRef<NotifierT, T> {
  _FakeStateNotifierProviderRef_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [AttachmentsNotifier].
///
/// See the documentation for Mockito's code generation for more information.
class MockAttachmentsNotifier extends _i1.Mock
    implements _i4.AttachmentsNotifier {
  @override
  set path(String? _path) => super.noSuchMethod(
        Invocation.setter(
          #path,
          _path,
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i2.Directory get root => (super.noSuchMethod(
        Invocation.getter(#root),
        returnValue: _FakeDirectory_0(
          this,
          Invocation.getter(#root),
        ),
        returnValueForMissingStub: _FakeDirectory_0(
          this,
          Invocation.getter(#root),
        ),
      ) as _i2.Directory);

  @override
  set root(_i2.Directory? _root) => super.noSuchMethod(
        Invocation.setter(
          #root,
          _root,
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i3.StateNotifierProviderRef<_i3.StateNotifier<dynamic>, dynamic> get ref =>
      (super.noSuchMethod(
        Invocation.getter(#ref),
        returnValue: _FakeStateNotifierProviderRef_1<_i3.StateNotifier<dynamic>,
            dynamic>(
          this,
          Invocation.getter(#ref),
        ),
        returnValueForMissingStub: _FakeStateNotifierProviderRef_1<
            _i3.StateNotifier<dynamic>, dynamic>(
          this,
          Invocation.getter(#ref),
        ),
      ) as _i3.StateNotifierProviderRef<_i3.StateNotifier<dynamic>, dynamic>);

  @override
  set ref(
          _i3.StateNotifierProviderRef<_i3.StateNotifier<dynamic>, dynamic>?
              _ref) =>
      super.noSuchMethod(
        Invocation.setter(
          #ref,
          _ref,
        ),
        returnValueForMissingStub: null,
      );

  @override
  set onError(_i3.ErrorListener? _onError) => super.noSuchMethod(
        Invocation.setter(
          #onError,
          _onError,
        ),
        returnValueForMissingStub: null,
      );

  @override
  bool get mounted => (super.noSuchMethod(
        Invocation.getter(#mounted),
        returnValue: false,
        returnValueForMissingStub: false,
      ) as bool);

  @override
  _i5.Stream<List<String>> get stream => (super.noSuchMethod(
        Invocation.getter(#stream),
        returnValue: _i5.Stream<List<String>>.empty(),
        returnValueForMissingStub: _i5.Stream<List<String>>.empty(),
      ) as _i5.Stream<List<String>>);

  @override
  List<String> get state => (super.noSuchMethod(
        Invocation.getter(#state),
        returnValue: <String>[],
        returnValueForMissingStub: <String>[],
      ) as List<String>);

  @override
  set state(List<String>? value) => super.noSuchMethod(
        Invocation.setter(
          #state,
          value,
        ),
        returnValueForMissingStub: null,
      );

  @override
  List<String> get debugState => (super.noSuchMethod(
        Invocation.getter(#debugState),
        returnValue: <String>[],
        returnValueForMissingStub: <String>[],
      ) as List<String>);

  @override
  bool get hasListeners => (super.noSuchMethod(
        Invocation.getter(#hasListeners),
        returnValue: false,
        returnValueForMissingStub: false,
      ) as bool);

  @override
  String? manage({
    required String? id,
    bool? createDir = false,
    required String? attachmentsDirPath,
    String? parentId,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #manage,
          [],
          {
            #id: id,
            #createDir: createDir,
            #attachmentsDirPath: attachmentsDirPath,
            #parentId: parentId,
          },
        ),
        returnValueForMissingStub: null,
      ) as String?);

  @override
  dynamic setPath({required String? attachmentsFolder}) => super.noSuchMethod(
        Invocation.method(
          #setPath,
          [],
          {#attachmentsFolder: attachmentsFolder},
        ),
        returnValueForMissingStub: null,
      );

  @override
  void addPhoto() => super.noSuchMethod(
        Invocation.method(
          #addPhoto,
          [],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void attachFile() => super.noSuchMethod(
        Invocation.method(
          #attachFile,
          [],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void openFolder() => super.noSuchMethod(
        Invocation.method(
          #openFolder,
          [],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void showNotification() => super.noSuchMethod(
        Invocation.method(
          #showNotification,
          [],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void openFile({required String? file}) => super.noSuchMethod(
        Invocation.method(
          #openFile,
          [],
          {#file: file},
        ),
        returnValueForMissingStub: null,
      );

  @override
  String getParentDirPath({String? parentId}) => (super.noSuchMethod(
        Invocation.method(
          #getParentDirPath,
          [],
          {#parentId: parentId},
        ),
        returnValue: _i6.dummyValue<String>(
          this,
          Invocation.method(
            #getParentDirPath,
            [],
            {#parentId: parentId},
          ),
        ),
        returnValueForMissingStub: _i6.dummyValue<String>(
          this,
          Invocation.method(
            #getParentDirPath,
            [],
            {#parentId: parentId},
          ),
        ),
      ) as String);

  @override
  _i2.Directory moveAttachments({
    required String? oldPath,
    String? newParent,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #moveAttachments,
          [],
          {
            #oldPath: oldPath,
            #newParent: newParent,
          },
        ),
        returnValue: _FakeDirectory_0(
          this,
          Invocation.method(
            #moveAttachments,
            [],
            {
              #oldPath: oldPath,
              #newParent: newParent,
            },
          ),
        ),
        returnValueForMissingStub: _FakeDirectory_0(
          this,
          Invocation.method(
            #moveAttachments,
            [],
            {
              #oldPath: oldPath,
              #newParent: newParent,
            },
          ),
        ),
      ) as _i2.Directory);

  @override
  bool updateShouldNotify(
    List<String>? old,
    List<String>? current,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #updateShouldNotify,
          [
            old,
            current,
          ],
        ),
        returnValue: false,
        returnValueForMissingStub: false,
      ) as bool);

  @override
  _i3.RemoveListener addListener(
    _i7.Listener<List<String>>? listener, {
    bool? fireImmediately = true,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #addListener,
          [listener],
          {#fireImmediately: fireImmediately},
        ),
        returnValue: () {},
        returnValueForMissingStub: () {},
      ) as _i3.RemoveListener);

  @override
  void dispose() => super.noSuchMethod(
        Invocation.method(
          #dispose,
          [],
        ),
        returnValueForMissingStub: null,
      );
}

/// A class which mocks [IDbService].
///
/// See the documentation for Mockito's code generation for more information.
class MockIDbService extends _i1.Mock implements _i8.IDbService {
  @override
  _i5.Future<void> init({required String? dbPath}) => (super.noSuchMethod(
        Invocation.method(
          #init,
          [],
          {#dbPath: dbPath},
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i5.Future<void> add({
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
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i5.Future<void> update({
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
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i5.Future<void> delete({
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
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i5.Stream<Map<String, dynamic>> getAll({required String? table}) =>
      (super.noSuchMethod(
        Invocation.method(
          #getAll,
          [],
          {#table: table},
        ),
        returnValue: _i5.Stream<Map<String, dynamic>>.empty(),
        returnValueForMissingStub: _i5.Stream<Map<String, dynamic>>.empty(),
      ) as _i5.Stream<Map<String, dynamic>>);

  @override
  _i5.Future<void> deleteTable({required String? table}) => (super.noSuchMethod(
        Invocation.method(
          #deleteTable,
          [],
          {#table: table},
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i5.Future<Map<String, dynamic>> getItemByFieldValue({
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
            _i5.Future<Map<String, dynamic>>.value(<String, dynamic>{}),
        returnValueForMissingStub:
            _i5.Future<Map<String, dynamic>>.value(<String, dynamic>{}),
      ) as _i5.Future<Map<String, dynamic>>);
}
