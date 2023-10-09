import 'package:borsh_annotation/borsh_annotation.dart';

part 'nft_parameters.g.dart';

@BorshSerializable()
class NftArguments with _$NftArguments {
  factory NftArguments(
      {
      @BString() required String id,
      @BString() required String name,
      @BString() required String symbol,
      @BString() required String uri
      }) = _NftArguments;

  const NftArguments._();

  factory NftArguments.fromBorsh(Uint8List data) =>
      _$NftArgumentsFromBorsh(data);
}
