// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_profile_info.dart';

// **************************************************************************
// BorshSerializableGenerator
// **************************************************************************

mixin _$GetProfileArguments {
  BigInt get deterministicId => throw UnimplementedError();
  String get nickname => throw UnimplementedError();
  String get bio => throw UnimplementedError();
  String get status => throw UnimplementedError();
  String get uri => throw UnimplementedError();
  Ed25519HDPublicKey get playerkey => throw UnimplementedError();

  Uint8List toBorsh() {
    final writer = BinaryWriter();

    const BU64().write(writer, deterministicId);
    const BString().write(writer, nickname);
    const BString().write(writer, bio);
    const BString().write(writer, status);
    const BString().write(writer, uri);
    const BPublicKey().write(writer, playerkey);

    return writer.toArray();
  }
}

class _GetProfileArguments extends GetProfileArguments {
  _GetProfileArguments({
    required this.deterministicId,
    required this.nickname,
    required this.bio,
    required this.status,
    required this.uri,
    required this.playerkey,
  }) : super._();

  final BigInt deterministicId;
  final String nickname;
  final String bio;
  final String status;
  final String uri;
  final Ed25519HDPublicKey playerkey;
}

class BGetProfileArguments implements BType<GetProfileArguments> {
  const BGetProfileArguments();

  @override
  void write(BinaryWriter writer, GetProfileArguments value) {
    writer.writeStruct(value.toBorsh());
  }

  @override
  GetProfileArguments read(BinaryReader reader) {
    return GetProfileArguments(
      deterministicId: const BU64().read(reader),
      nickname: const BString().read(reader),
      bio: const BString().read(reader),
      status: const BString().read(reader),
      uri: const BString().read(reader),
      playerkey: const BPublicKey().read(reader),
    );
  }
}

GetProfileArguments _$GetProfileArgumentsFromBorsh(Uint8List data) {
  final reader = BinaryReader(data.buffer.asByteData());

  return const BGetProfileArguments().read(reader);
}
