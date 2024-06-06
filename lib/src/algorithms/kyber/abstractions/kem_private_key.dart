import 'dart:convert';
import 'dart:typed_data';

import 'package:post_quantum/src/algorithms/kyber/abstractions/pke_private_key.dart';
import 'package:post_quantum/src/algorithms/kyber/abstractions/pke_public_key.dart';

class KemPrivateKey {
  final PKEPrivateKey sk;
  final PKEPublicKey pk;
  final Uint8List pkHash;
  final Uint8List z;
  String get base64 => base64Encode(serialize());

  const KemPrivateKey({
    required this.sk,
    required this.pk,
    required this.pkHash,
    required this.z
  });

  factory KemPrivateKey.deserialize(Uint8List bytes, int kyberVersion) {
    if (kyberVersion != 2 && kyberVersion != 3 && kyberVersion != 4) {
      throw UnimplementedError("Unknown kyber version");
    }

    var skSize = 12 * kyberVersion * 32; // (12 * k * n)/8
    var pkSize = 32 + (12 * kyberVersion * 32); // 32 + (12 * k * n)/8
    if (bytes.length != skSize + pkSize + 64) {
      throw ArgumentError(
          "Expected ${skSize + pkSize + 64} bytes but found ${bytes.length} instead.");
    }

    var offset = 0;
    var skBytes = bytes.sublist(offset, offset + skSize);
    offset += skSize;

    var pkBytes = bytes.sublist(offset, offset + pkSize);
    offset += pkSize;

    var h = bytes.sublist(offset, offset + 32);
    offset += 32;

    var z = bytes.sublist(offset);

    return KemPrivateKey(
        sk: PKEPrivateKey.deserialize(skBytes, kyberVersion),
        pk: PKEPublicKey.deserialize(pkBytes, kyberVersion),
        pkHash: h,
        z: z
    );
  }


  Uint8List serialize() {
    var builder = BytesBuilder();
    builder.add(sk.serialize());
    builder.add(pk.serialize());
    builder.add(pkHash);
    builder.add(z);
    return builder.toBytes();
  }

  @override
  bool operator ==(covariant KemPrivateKey other) {
    sk == other.sk;

    for (int i=0; i<pkHash.length; i++) {
      if (pkHash[i] != other.pkHash[i]) return false;
    }

    for (int i=0; i<z.length; i++) {
      if (z[i] != other.z[i]) return false;
    }

    return pk == other.pk && sk == other.sk;
  }
}


