// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'put_profile_info.dart';

// **************************************************************************
// BorshSerializableGenerator
// **************************************************************************

mixin _$PutProfileArguments {
  String get nickname => throw UnimplementedError();
  String get bio => throw UnimplementedError();
  String get status => throw UnimplementedError();
  String get uri => throw UnimplementedError();

  Uint8List toBorsh() {
    final writer = BinaryWriter();

    const BString().write(writer, nickname);
    const BString().write(writer, bio);
    const BString().write(writer, status);
    const BString().write(writer, uri);

    return writer.toArray();
  }
}

class _PutProfileArguments extends PutProfileArguments {
  _PutProfileArguments({
    required this.nickname,
    required this.bio,
    required this.status,
    required this.uri,
  }) : super._();

  final String nickname;
  final String bio;
  final String status;
  final String uri;
}

class BPutProfileArguments implements BType<PutProfileArguments> {
  const BPutProfileArguments();

  @override
  void write(BinaryWriter writer, PutProfileArguments value) {
    writer.writeStruct(value.toBorsh());
  }

  @override
  PutProfileArguments read(BinaryReader reader) {
    return PutProfileArguments(
      nickname: const BString().read(reader),
      bio: const BString().read(reader),
      status: const BString().read(reader),
      uri: const BString().read(reader),
    );
  }
}

PutProfileArguments _$PutProfileArgumentsFromBorsh(Uint8List data) {
  final reader = BinaryReader(data.buffer.asByteData());

  return const BPutProfileArguments().read(reader);
}
