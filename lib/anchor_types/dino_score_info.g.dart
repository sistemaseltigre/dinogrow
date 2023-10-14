// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dino_score_info.dart';

// **************************************************************************
// BorshSerializableGenerator
// **************************************************************************

mixin _$DinoScoreArguments {
  BigInt get score => throw UnimplementedError();
  int get gamescore => throw UnimplementedError();
  Ed25519HDPublicKey get playerPubkey => throw UnimplementedError();
  Ed25519HDPublicKey get dinoPubkey => throw UnimplementedError();

  Uint8List toBorsh() {
    final writer = BinaryWriter();

    const BU64().write(writer, score);
    const BU32().write(writer, gamescore);
    const BPublicKey().write(writer, playerPubkey);
    const BPublicKey().write(writer, dinoPubkey);

    return writer.toArray();
  }
}

class _DinoScoreArguments extends DinoScoreArguments {
  _DinoScoreArguments({
    required this.score,
    required this.gamescore,
    required this.playerPubkey,
    required this.dinoPubkey,
  }) : super._();

  final BigInt score;
  final int gamescore;
  final Ed25519HDPublicKey playerPubkey;
  final Ed25519HDPublicKey dinoPubkey;
}

class BDinoScoreArguments implements BType<DinoScoreArguments> {
  const BDinoScoreArguments();

  @override
  void write(BinaryWriter writer, DinoScoreArguments value) {
    writer.writeStruct(value.toBorsh());
  }

  @override
  DinoScoreArguments read(BinaryReader reader) {
    return DinoScoreArguments(
      score: const BU64().read(reader),
      gamescore: const BU32().read(reader),
      playerPubkey: const BPublicKey().read(reader),
      dinoPubkey: const BPublicKey().read(reader),
    );
  }
}

DinoScoreArguments _$DinoScoreArgumentsFromBorsh(Uint8List data) {
  final reader = BinaryReader(data.buffer.asByteData());

  return const BDinoScoreArguments().read(reader);
}
