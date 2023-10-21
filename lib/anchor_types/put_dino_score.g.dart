// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'put_dino_score.dart';

// **************************************************************************
// BorshSerializableGenerator
// **************************************************************************

mixin _$PutScoreArguments {
  int get game => throw UnimplementedError();
  int get score => throw UnimplementedError();

  Uint8List toBorsh() {
    final writer = BinaryWriter();

    const BU32().write(writer, game);
    const BU32().write(writer, score);

    return writer.toArray();
  }
}

class _PutScoreArguments extends PutScoreArguments {
  _PutScoreArguments({
    required this.game,
    required this.score,
  }) : super._();

  final int game;
  final int score;
}

class BPutScoreArguments implements BType<PutScoreArguments> {
  const BPutScoreArguments();

  @override
  void write(BinaryWriter writer, PutScoreArguments value) {
    writer.writeStruct(value.toBorsh());
  }

  @override
  PutScoreArguments read(BinaryReader reader) {
    return PutScoreArguments(
      game: const BU32().read(reader),
      score: const BU32().read(reader),
    );
  }
}

PutScoreArguments _$PutScoreArgumentsFromBorsh(Uint8List data) {
  final reader = BinaryReader(data.buffer.asByteData());

  return const BPutScoreArguments().read(reader);
}
