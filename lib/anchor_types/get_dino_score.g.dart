// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_dino_score.dart';

// **************************************************************************
// BorshSerializableGenerator
// **************************************************************************

mixin _$GetScoreArguments {
  BigInt get deterministicId => throw UnimplementedError();
  int get score => throw UnimplementedError();
  int get game => throw UnimplementedError();
  Ed25519HDPublicKey get playerkey => throw UnimplementedError();
  Ed25519HDPublicKey get dinokey => throw UnimplementedError();

  Uint8List toBorsh() {
    final writer = BinaryWriter();

    const BU64().write(writer, deterministicId);
    const BU32().write(writer, score);
    const BU32().write(writer, game);
    const BPublicKey().write(writer, playerkey);
    const BPublicKey().write(writer, dinokey);

    return writer.toArray();
  }
}

class _GetScoreArguments extends GetScoreArguments {
  _GetScoreArguments({
    required this.deterministicId,
    required this.score,
    required this.game,
    required this.playerkey,
    required this.dinokey,
  }) : super._();

  final BigInt deterministicId;
  final int score;
  final int game;
  final Ed25519HDPublicKey playerkey;
  final Ed25519HDPublicKey dinokey;
}

class BGetScoreArguments implements BType<GetScoreArguments> {
  const BGetScoreArguments();

  @override
  void write(BinaryWriter writer, GetScoreArguments value) {
    writer.writeStruct(value.toBorsh());
  }

  @override
  GetScoreArguments read(BinaryReader reader) {
    return GetScoreArguments(
      deterministicId: const BU64().read(reader),
      score: const BU32().read(reader),
      game: const BU32().read(reader),
      playerkey: const BPublicKey().read(reader),
      dinokey: const BPublicKey().read(reader),
    );
  }
}

GetScoreArguments _$GetScoreArgumentsFromBorsh(Uint8List data) {
  final reader = BinaryReader(data.buffer.asByteData());

  return const BGetScoreArguments().read(reader);
}
