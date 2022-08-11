import 'package:dart_frog/dart_frog.dart';

import 'index.dart';

Future<Response> onRequest(RequestContext context, String id) async {
  if (context.request.method == HttpMethod.delete) {
    expenses.removeWhere((element) => element.id == id);
    return Response.json(body: expenses);
  } else if (context.request.method == HttpMethod.get) {
    final expense = expenses.where((element) => element.id == id);
    if (expense.isEmpty) {
      return Response(statusCode: 404, body: 'Expense for $id not found');
    } else {
      return Response.json(body: expense.first);
    }
  } else {
    return Response(statusCode: 404);
  }
}
