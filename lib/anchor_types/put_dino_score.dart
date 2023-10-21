import 'package:borsh_annotation/borsh_annotation.dart';

part 'put_dino_score.g.dart';

@BorshSerializable()
class PutScoreArguments with _$PutScoreArguments {
  factory PutScoreArguments(
      {
      @BU32() required int game,
      @BU32() required int score,
      }) = _PutScoreArguments;

  const PutScoreArguments._();

  factory PutScoreArguments.fromBorsh(Uint8List data) =>
      _$PutScoreArgumentsFromBorsh(data);
}