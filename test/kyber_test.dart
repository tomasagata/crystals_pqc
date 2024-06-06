import 'dart:convert';
import 'dart:io';

import 'package:post_quantum/post_quantum.dart';
import 'package:test/test.dart';


void main() {
  group('Kyber 512-bit tests', () {
    final kyber512 = Kyber.kem512();
    final testData = jsonDecode(
      File("test/test_data/kyber/pregenerated_k512.json").readAsStringSync()
    );

    test('Creating keys with given seed returns expected pre-generated keys', () {
      var seed = base64Decode(testData["seed"]!);
      var (pk, sk) = kyber512.generateKeys(seed);
      var preGeneratedPK  = testData["pk"]!;
      var preGeneratedSK  = testData["sk"]!;

      expect(pk.base64, preGeneratedPK);
      expect(sk.base64, preGeneratedSK);
    });

    test('Generating flow with given seed and nonce returns expected pre-generated shared keys', () {
      var seed = base64Decode(testData["seed"]);
      var nonce = base64Decode(testData["nonce"]);

      var (pk, sk) = kyber512.generateKeys(seed);
      var (cipher, sharedKey1) = kyber512.encapsulate(pk, nonce);
      var sharedKey2 = kyber512.decapsulate(cipher, sk);

      expect(base64Encode(sharedKey1), testData["key1"]);
      expect(base64Encode(sharedKey2), testData["key2"]);
    });

    test('Deserialized keys are equal to generated keys', () {
      var pkBytes = base64Decode(testData["pk"]);
      var skBytes = base64Decode(testData["sk"]);
      var seed = base64Decode(testData["seed"]);

      var pk = KemPublicKey.deserialize(pkBytes, 2);
      var sk = KemPrivateKey.deserialize(skBytes, 2);
      var (genPk, genSk) = kyber512.generateKeys(seed);

      sk == genSk;

      expect(pk, genPk);
      expect(sk, genSk);
    });
  });

  group('Kyber 768-bit tests', () {
    final kyber768 = Kyber.kem768();
    final testData = jsonDecode(
      File("test/test_data/kyber/pregenerated_k768.json").readAsStringSync()
    );

    test('Creating keys with given seed returns expected pre-generated keys', () {
      var seed = base64Decode(testData["seed"]!);
      var (pk, sk) = kyber768.generateKeys(seed);
      var preGeneratedPK  = testData["pk"]!;
      var preGeneratedSK  = testData["sk"]!;

      expect(pk.base64, preGeneratedPK);
      expect(sk.base64, preGeneratedSK);
    });

    test('Generating flow with given seed and nonce returns expected flow parameters', () {
      var seed = base64Decode(testData["seed"]);
      var nonce = base64Decode(testData["nonce"]);

      var (pk, sk) = kyber768.generateKeys(seed);
      var (cipher, sharedKey1) = kyber768.encapsulate(pk, nonce);
      var sharedKey2 = kyber768.decapsulate(cipher, sk);

      expect(base64Encode(sharedKey1), testData["key1"]);
      expect(base64Encode(sharedKey2), testData["key2"]);
    });

    test('Deserialized keys are equal to generated keys', () {
      var pkBytes = base64Decode(testData["pk"]);
      var skBytes = base64Decode(testData["sk"]);
      var seed = base64Decode(testData["seed"]);

      var pk = KemPublicKey.deserialize(pkBytes, 3);
      var sk = KemPrivateKey.deserialize(skBytes, 3);
      var (genPk, genSk) = kyber768.generateKeys(seed);

      expect(pk, genPk);
      expect(sk, genSk);
    });
  });

  group('Kyber 1024-bit tests', () {
    final kyber1024 = Kyber.kem1024();
    final testData = jsonDecode(
      File("test/test_data/kyber/pregenerated_k1024.json").readAsStringSync()
    );

    test('Creating keys with given seed returns expected pre-generated keys', () {
      var seed = base64Decode(testData["seed"]!);
      var (pk, sk) = kyber1024.generateKeys(seed);
      var preGeneratedPK  = testData["pk"]!;
      var preGeneratedSK  = testData["sk"]!;

      expect(pk.base64, preGeneratedPK);
      expect(sk.base64, preGeneratedSK);
    });

    test('Generating flow with given seed and nonce returns expected flow parameters', () {
      var seed = base64Decode(testData["seed"]);
      var nonce = base64Decode(testData["nonce"]);

      var (pk, sk) = kyber1024.generateKeys(seed);
      var (cipher, sharedKey1) = kyber1024.encapsulate(pk, nonce);
      var sharedKey2 = kyber1024.decapsulate(cipher, sk);

      expect(base64Encode(sharedKey1), testData["key1"]);
      expect(base64Encode(sharedKey2), testData["key2"]);
    });

    test('Deserialized keys are equal to generated keys', () {
      var pkBytes = base64Decode(testData["pk"]);
      var skBytes = base64Decode(testData["sk"]);
      var seed = base64Decode(testData["seed"]);

      var pk = KemPublicKey.deserialize(pkBytes, 4);
      var sk = KemPrivateKey.deserialize(skBytes, 4);
      var (genPk, genSk) = kyber1024.generateKeys(seed);

      expect(pk, genPk);
      expect(sk, genSk);
    });
  });
}
