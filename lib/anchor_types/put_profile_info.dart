import 'package:borsh_annotation/borsh_annotation.dart';
import 'package:solana/solana.dart';

part 'put_profile_info.g.dart';

@BorshSerializable()
class PutProfileArguments with _$PutProfileArguments {
  factory PutProfileArguments(
      {
      @BString() required String nickname,
      @BString() required String bio,
      @BString() required String status,
      @BString() required String uri,
      }) = _PutProfileArguments;

  const PutProfileArguments._();

  factory PutProfileArguments.fromBorsh(Uint8List data) =>
      _$PutProfileArgumentsFromBorsh(data);
}