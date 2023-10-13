import 'package:borsh_annotation/borsh_annotation.dart';
import 'package:solana/solana.dart';

part 'dino_score_info.g.dart';


@BorshSerializable()
class DinoScoreArguments with _$DinoScoreArguments {
  factory DinoScoreArguments(
      {
      @BU64() required BigInt score,
      @BU32() required int gamescore,
      @BPublicKey() required Ed25519HDPublicKey playerPubkey,
      @BPublicKey() required Ed25519HDPublicKey dinoPubkey,      
      }) = _DinoScoreArguments;

  const DinoScoreArguments._();

  factory DinoScoreArguments.fromBorsh(Uint8List data) =>
      _$DinoScoreArgumentsFromBorsh(data);
}
