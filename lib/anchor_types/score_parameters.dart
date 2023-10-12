import 'package:borsh_annotation/borsh_annotation.dart';

part 'score_parameters.g.dart';

@BorshSerializable()
class ScoreArguments with _$ScoreArguments {
  factory ScoreArguments(
      {
      @BU32() required int game,
      @BU64() required BigInt score,
      }) = _ScoreArguments;

  const ScoreArguments._();

  factory ScoreArguments.fromBorsh(Uint8List data) =>
      _$ScoreArgumentsFromBorsh(data);
}
