// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'summary_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LocalAnswerHistoryAdapter extends TypeAdapter<LocalAnswerHistory> {
  @override
  final int typeId = 0;

  @override
  LocalAnswerHistory read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LocalAnswerHistory(
      userId: fields[0] as String,
      question: fields[1] as String,
      selectedAnswer: fields[2] as int,
      isCorrect: fields[3] as bool,
      timestamp: fields[4] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, LocalAnswerHistory obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.question)
      ..writeByte(2)
      ..write(obj.selectedAnswer)
      ..writeByte(3)
      ..write(obj.isCorrect)
      ..writeByte(4)
      ..write(obj.timestamp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocalAnswerHistoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
