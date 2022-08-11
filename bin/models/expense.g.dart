// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Expense _$ExpenseFromJson(Map<String, dynamic> json) => Expense(
      id: json['id'] as String,
      title: json['title'] as String,
      amount: (json['amount'] as num).toDouble(),
      type: $enumDecode(_$ExpenseTypeEnumMap, json['type']),
    );

Map<String, dynamic> _$ExpenseToJson(Expense instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'amount': instance.amount,
      'type': _$ExpenseTypeEnumMap[instance.type]!,
    };

const _$ExpenseTypeEnumMap = {
  ExpenseType.supermarket: 'supermarket',
  ExpenseType.hospital: 'hospital',
  ExpenseType.food: 'food',
  ExpenseType.other: 'other',
};
