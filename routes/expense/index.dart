import 'package:dart_frog/dart_frog.dart';
import '../../bin/models/expense.dart';

final expenses = <Expense>[];

Future<Response> onRequest(RequestContext context) async {
  final request = context.request;

  switch (request.method) {
    case HttpMethod.get:
      return Response.json(body: expenses);
    case HttpMethod.post:
      final json = await context.request.json();
      final body = Expense.fromJson(json);
      expenses.add(body);
      return Response.json(statusCode: 201, body: body);
    case HttpMethod.put:
      final json = await context.request.json();
      final body = Expense.fromJson(json);
      final position = expenses.indexWhere((element) => element.id == body.id);
      expenses
        ..removeAt(position)
        ..insert(position, body);
      return Response.json(body: expenses);
    case HttpMethod.head:
    case HttpMethod.options:
    case HttpMethod.patch:
      return Response(
        statusCode: 405,
        body: '${request.method} operation is not supported',
      );
    case HttpMethod.delete:
      return Response(
        statusCode: 405,
        body: '${request.method} operation requires a id',
      );
  }
}
