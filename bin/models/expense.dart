import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'expense.g.dart';

@JsonSerializable()
class Expense extends Equatable {
  const Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.type,
  });

  final String id;
  final String title;
  final double amount;
  final ExpenseType type;

  // ignore: sort_constructors_first
  factory Expense.fromJson(Map<String, dynamic> json) =>
      _$ExpenseFromJson(json);

  Map<String, dynamic> toJson() => _$ExpenseToJson(this);

  @override
  List<Object?> get props => [id, title, amount, type];
}

enum ExpenseType {
  supermarket,
  hospital,
  food,
  other;

  @override
  String toString() => name;
}
