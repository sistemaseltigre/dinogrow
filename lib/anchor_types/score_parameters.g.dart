// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'score_parameters.dart';

// **************************************************************************
// BorshSerializableGenerator
// **************************************************************************

mixin _$ScoreArguments {
  int get game => throw UnimplementedError();
  BigInt get score => throw UnimplementedError();

  Uint8List toBorsh() {
    final writer = BinaryWriter();

    const BU32().write(writer, game);
    const BU64().write(writer, score);

    return writer.toArray();
  }
}

class _ScoreArguments extends ScoreArguments {
  _ScoreArguments({
    required this.game,
    required this.score,
  }) : super._();

  final int game;
  final BigInt score;
}

class BScoreArguments implements BType<ScoreArguments> {
  const BScoreArguments();

  @override
  void write(BinaryWriter writer, ScoreArguments value) {
    writer.writeStruct(value.toBorsh());
  }

  @override
  ScoreArguments read(BinaryReader reader) {
    return ScoreArguments(
      game: const BU32().read(reader),
      score: const BU64().read(reader),
    );
  }
}

ScoreArguments _$ScoreArgumentsFromBorsh(Uint8List data) {
  final reader = BinaryReader(data.buffer.asByteData());

  return const BScoreArguments().read(reader);
}
