import 'package:borsh_annotation/borsh_annotation.dart';
import 'package:solana/solana.dart';

part 'get_dino_score.g.dart';

@BorshSerializable()
class GetScoreArguments with _$GetScoreArguments {
  factory GetScoreArguments(
      {
      @BU64() required BigInt deterministicId,
      @BU32() required int score,
      @BU32() required int game,
      @BPublicKey() required Ed25519HDPublicKey playerkey,
      @BPublicKey() required Ed25519HDPublicKey dinokey,
      }) = _GetScoreArguments;

  const GetScoreArguments._();

  factory GetScoreArguments.fromBorsh(Uint8List data) =>
      _$GetScoreArgumentsFromBorsh(data);
}