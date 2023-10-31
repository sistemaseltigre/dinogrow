import 'package:borsh_annotation/borsh_annotation.dart';
import 'package:solana/solana.dart';

part 'get_profile_info.g.dart';

@BorshSerializable()
class GetProfileArguments with _$GetProfileArguments {
  factory GetProfileArguments(
      {
      @BU64() required BigInt deterministicId,
      @BString() required String nickname,
      @BString() required String bio,
      @BString() required String status,
      @BString() required String uri,
      @BPublicKey() required Ed25519HDPublicKey playerkey,
      }) = _GetProfileArguments;

  const GetProfileArguments._();

  factory GetProfileArguments.fromBorsh(Uint8List data) =>
      _$GetProfileArgumentsFromBorsh(data);
}