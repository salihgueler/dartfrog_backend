import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../bin/models/expense.dart';
import '../../routes/expense/[id].dart' as dynamic_route;
import '../../routes/expense/index.dart' as route;

class _MockRequestContext extends Mock implements RequestContext {}

class _MockRequest extends Mock implements Request {}

class _MockUri extends Mock implements Uri {}

void main() {
  late RequestContext context;
  late Request request;
  late Uri uri;

  setUp(() {
    context = _MockRequestContext();
    request = _MockRequest();
    uri = _MockUri();
    when(() => context.request).thenReturn(request);
    when(() => request.uri).thenReturn(uri);
    when(() => uri.resolve(any())).thenAnswer(
      (_) =>
          Uri.parse('http://localhost/expense${_.positionalArguments.first}'),
    );
    when(() => uri.queryParameters).thenReturn({});
  });

  tearDown(route.expenses.clear);

  group('GET /expense', () {
    test('responds with a 200 and an empty list', () async {
      when(() => request.method).thenReturn(HttpMethod.get);

      final response = await route.onRequest(context);

      expect(response.statusCode, equals(HttpStatus.ok));
      expect(response.json(), completion(isEmpty));
    });

    test('responds with a 200 and an seeded list', () async {
      _populateList(3);
      when(() => request.method).thenReturn(HttpMethod.get);

      final response = await route.onRequest(context);

      expect(response.statusCode, equals(HttpStatus.ok));
      expect(response.json(), completion(isNotEmpty));
    });

    test('responds with a 200 and selected item', () async {
      _populateList(3);
      when(() => request.method).thenReturn(HttpMethod.get);

      final response = await dynamic_route.onRequest(context, '2');

      expect(response.statusCode, equals(HttpStatus.ok));
      expect(
        response.json(),
        completion(
          equals(
            <String, dynamic>{
              'id': '2',
              'title': 'Test Title 2',
              'amount': 16.2,
              'type': 'other'
            },
          ),
        ),
      );
    });

    test('responds with a 404 and no item', () async {
      _populateList(3);
      when(() => request.method).thenReturn(HttpMethod.get);

      final response = await dynamic_route.onRequest(context, '5');

      expect(response.statusCode, equals(HttpStatus.notFound));
      expect(
        response.body(),
        completion(
          equals('Expense for 5 not found'),
        ),
      );
    });
  });
  group('PUT /expense', () {
    test('when method is PUT', () async {
      _populateList(3);
      when(() => request.method).thenReturn(HttpMethod.put);
      when(() => request.json()).thenAnswer((_) async {
        return <String, dynamic>{
          'id': '1',
          'title': 'Test title',
          'amount': 42.8,
          'type': 'other'
        };
      });

      final response = await route.onRequest(context);

      expect(response.statusCode, equals(HttpStatus.ok));
      expect(
        response.json(),
        completion(
          equals([
            <String, dynamic>{
              'id': '0',
              'title': 'Test Title 0',
              'amount': 14.2,
              'type': 'other'
            },
            <String, dynamic>{
              'id': '1',
              'title': 'Test title',
              'amount': 42.8,
              'type': 'other'
            },
            <String, dynamic>{
              'id': '2',
              'title': 'Test Title 2',
              'amount': 16.2,
              'type': 'other'
            },
          ]),
        ),
      );
      expect(
        route.expenses[1].toJson(),
        equals(
          <String, dynamic>{
            'id': '1',
            'title': 'Test title',
            'amount': 42.8,
            'type': 'other'
          },
        ),
      );
    });
  });

  group('POST /expense', () {
    test('responds with a 201 and the newly created Todo', () async {
      when(() => request.method).thenReturn(HttpMethod.post);
      when(() => request.json()).thenAnswer((_) async {
        return <String, dynamic>{
          'id': '1',
          'title': 'Test title',
          'amount': 42.8,
          'type': 'other'
        };
      });

      expect(route.expenses, isEmpty);
      final response = await route.onRequest(context);

      expect(response.statusCode, equals(HttpStatus.created));
      expect(
        response.json(),
        completion(
          equals(
            <String, dynamic>{
              'id': '1',
              'title': 'Test title',
              'amount': 42.8,
              'type': 'other'
            },
          ),
        ),
      );
      expect(route.expenses, isNotEmpty);
    });
  });

  group('DELETE expense', () {
    test('when method is DELETE without index', () async {
      when(() => request.method).thenReturn(HttpMethod.delete);

      final response = await route.onRequest(context);

      expect(response.statusCode, equals(HttpStatus.methodNotAllowed));
    });
    test('when method is DELETE with index', () async {
      _populateList(3);
      when(() => request.method).thenReturn(HttpMethod.delete);

      final response = await dynamic_route.onRequest(context, '1');

      expect(response.statusCode, equals(HttpStatus.ok));
      expect(
        response.json(),
        completion(
          equals([
            <String, dynamic>{
              'id': '0',
              'title': 'Test Title 0',
              'amount': 14.2,
              'type': 'other'
            },
            <String, dynamic>{
              'id': '2',
              'title': 'Test Title 2',
              'amount': 16.2,
              'type': 'other'
            },
          ]),
        ),
      );
    });
  });
  group('responds with a 405', () {
    test('when method is HEAD', () async {
      when(() => request.method).thenReturn(HttpMethod.head);

      final response = await route.onRequest(context);

      expect(response.statusCode, equals(HttpStatus.methodNotAllowed));
    });

    test('when method is OPTIONS', () async {
      when(() => request.method).thenReturn(HttpMethod.options);

      final response = await route.onRequest(context);

      expect(response.statusCode, equals(HttpStatus.methodNotAllowed));
    });

    test('when method is PATCH', () async {
      when(() => request.method).thenReturn(HttpMethod.patch);

      final response = await route.onRequest(context);

      expect(response.statusCode, equals(HttpStatus.methodNotAllowed));
    });
  });
}

void _populateList(int count) {
  for (var index = 0; index < count; index++) {
    route.expenses.add(
      Expense(
        id: '$index',
        title: 'Test Title $index',
        amount: index + 14.2,
        type: ExpenseType.other,
      ),
    );
  }
}
