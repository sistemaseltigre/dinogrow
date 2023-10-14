import 'package:borsh_annotation/borsh_annotation.dart';
import 'package:solana/solana.dart';

part 'dino_game_info.g.dart';


@BorshSerializable()
class DinoGameArguments with _$DinoGameArguments {
  factory DinoGameArguments(
      {
      @BU64() required BigInt score,
      @BU64() required BigInt game,
      @BPublicKey() required Ed25519HDPublicKey playerPubkey,
      @BPublicKey() required Ed25519HDPublicKey dinoPubkey,
      
      }) = _DinoGameArguments;

  const DinoGameArguments._();

  factory DinoGameArguments.fromBorsh(Uint8List data) =>
      _$DinoGameArgumentsFromBorsh(data);
}
