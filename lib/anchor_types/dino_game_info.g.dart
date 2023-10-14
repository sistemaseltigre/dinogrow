// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dino_game_info.dart';

// **************************************************************************
// BorshSerializableGenerator
// **************************************************************************

mixin _$DinoGameArguments {
  BigInt get score => throw UnimplementedError();
  BigInt get game => throw UnimplementedError();
  Ed25519HDPublicKey get playerPubkey => throw UnimplementedError();
  Ed25519HDPublicKey get dinoPubkey => throw UnimplementedError();

  Uint8List toBorsh() {
    final writer = BinaryWriter();

    const BU64().write(writer, score);
    const BU64().write(writer, game);
    const BPublicKey().write(writer, playerPubkey);
    const BPublicKey().write(writer, dinoPubkey);

    return writer.toArray();
  }
}

class _DinoGameArguments extends DinoGameArguments {
  _DinoGameArguments({
    required this.score,
    required this.game,
    required this.playerPubkey,
    required this.dinoPubkey,
  }) : super._();

  final BigInt score;
  final BigInt game;
  final Ed25519HDPublicKey playerPubkey;
  final Ed25519HDPublicKey dinoPubkey;
}

class BDinoGameArguments implements BType<DinoGameArguments> {
  const BDinoGameArguments();

  @override
  void write(BinaryWriter writer, DinoGameArguments value) {
    writer.writeStruct(value.toBorsh());
  }

  @override
  DinoGameArguments read(BinaryReader reader) {
    return DinoGameArguments(
      score: const BU64().read(reader),
      game: const BU64().read(reader),
      playerPubkey: const BPublicKey().read(reader),
      dinoPubkey: const BPublicKey().read(reader),
    );
  }
}

DinoGameArguments _$DinoGameArgumentsFromBorsh(Uint8List data) {
  final reader = BinaryReader(data.buffer.asByteData());

  return const BDinoGameArguments().read(reader);
}
