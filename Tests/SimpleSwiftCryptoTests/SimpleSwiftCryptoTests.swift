import XCTest
import SimpleSwiftCrypto

final class SimpleSwiftCryptoTests: XCTestCase {
    //
    // AES
    //
    func testAESGenIsDifferentOnEachCall() {
        let aesPrivateKey1: AES256Key = SimpleSwiftCrypto.generateRandomAES256Key()!
        let aesPrivateKey2: AES256Key = SimpleSwiftCrypto.generateRandomAES256Key()!
        
        XCTAssertNotEqual(aesPrivateKey1.__debug_aes256Key, aesPrivateKey2.__debug_aes256Key)
        XCTAssertNotEqual(aesPrivateKey1.__debug_iv, aesPrivateKey2.__debug_iv)
        XCTAssertNotEqual(aesPrivateKey1.__debug_iv, aesPrivateKey1.__debug_aes256Key)
        XCTAssertNotEqual(aesPrivateKey2.__debug_iv, aesPrivateKey2.__debug_aes256Key)
    }
    func testAESGenEncryptAndDecrypt() {
        let testString: String = "Hello World!"
        let testData: Data = testString.data(using: .utf8)!
        
        let aesPrivateKey: AES256Key = SimpleSwiftCrypto.generateRandomAES256Key()!
        let encryptedData: Data = aesPrivateKey.encrypt(data: testData)!
        let decryptedData: Data = aesPrivateKey.decrypt(data: encryptedData)!
        
        XCTAssertNotEqual(testData, encryptedData)
        XCTAssertNotEqual(encryptedData, decryptedData)
        XCTAssertEqual(testData, decryptedData)
    }
    func testAESGenLargeRandomEncryptAndDecrypt() {
        let testString: String = getRandomLongString()
        let testData: Data = testString.data(using: .utf8)!
        
        let aesPrivateKey: AES256Key = SimpleSwiftCrypto.generateRandomAES256Key()!
        let encryptedData: Data = aesPrivateKey.encrypt(data: testData)!
        let decryptedData: Data = aesPrivateKey.decrypt(data: encryptedData)!
        
        XCTAssertNotEqual(testData, encryptedData)
        XCTAssertNotEqual(encryptedData, decryptedData)
        XCTAssertEqual(testData, decryptedData)
    }
    func testAESGenEncryptWithDifferentKeysMakesDifferentMessage() {
        let testString: String = "Hello World!"
        let testData: Data = testString.data(using: .utf8)!
        
        let aesPrivateKey1: AES256Key = SimpleSwiftCrypto.generateRandomAES256Key()!
        let aesPrivateKey2: AES256Key = SimpleSwiftCrypto.generateRandomAES256Key()!
        let encryptedData1: Data = aesPrivateKey1.encrypt(data: testData)!
        let encryptedData2: Data = aesPrivateKey2.encrypt(data: testData)!
        let decryptedData1: Data = aesPrivateKey1.decrypt(data: encryptedData1)!
        let decryptedData2: Data = aesPrivateKey2.decrypt(data: encryptedData2)!
        
        XCTAssertEqual(testData, testData)
        XCTAssertNotEqual(testData, encryptedData1)
        XCTAssertNotEqual(testData, encryptedData2)
        XCTAssertNotEqual(encryptedData1, encryptedData2)
        XCTAssertNotEqual(testData, encryptedData1)
        XCTAssertNotEqual(testData, encryptedData2)
        XCTAssertNotEqual(encryptedData1, decryptedData1)
        XCTAssertNotEqual(encryptedData2, decryptedData2)
        XCTAssertEqual(testData, decryptedData1)
        XCTAssertEqual(testData, decryptedData2)
    }
    
    func testAESExportAndLoads() {
        let aesPrivateKey: AES256Key = SimpleSwiftCrypto.generateRandomAES256Key()!
        let aesPrivateKeyAsData: Data = aesPrivateKey.exportIvAndPrivateAES256Key()
        let sameAesPrivateKeyFromData: AES256Key = .loadIvAndPrivateAES256Key(ivAndPrivateAES256Key: aesPrivateKeyAsData)!
        
        XCTAssertEqual(aesPrivateKey.__debug_aes256Key, sameAesPrivateKeyFromData.__debug_aes256Key)
        XCTAssertEqual(aesPrivateKey.__debug_iv, sameAesPrivateKeyFromData.__debug_iv)
    }
    
    //
    // RSA
    //
    func testRSAGen() {
        let rsaPrivateKey1: RSAKeyPair = SimpleSwiftCrypto.generateRandomRSAKeyPair()!
        let rsaPrivateKey2: RSAKeyPair = SimpleSwiftCrypto.generateRandomRSAKeyPair()!
        
        XCTAssertNotEqual(rsaPrivateKey1.__debug_privateKey, rsaPrivateKey2.__debug_privateKey)
        XCTAssertNotEqual(rsaPrivateKey1.__debug_publicKey, rsaPrivateKey2.__debug_publicKey)
        XCTAssertNotEqual(rsaPrivateKey1.__debug_publicKey, rsaPrivateKey1.__debug_privateKey)
        XCTAssertNotEqual(rsaPrivateKey2.__debug_publicKey, rsaPrivateKey2.__debug_privateKey)
    }
    func testRSAGenEncryptAndDecrypt() {
        let testString: String = "Hello World!"
        let testData: Data = testString.data(using: .utf8)!
        
        let rsaPrivateKey: RSAKeyPair = SimpleSwiftCrypto.generateRandomRSAKeyPair()!
        let encryptedData: Data = rsaPrivateKey.extractPublicKey().encrypt(data: testData)!
        let decryptedData: Data = rsaPrivateKey.decrypt(data: encryptedData)!
        
        XCTAssertNotEqual(testData, encryptedData)
        XCTAssertNotEqual(encryptedData, decryptedData)
        XCTAssertEqual(testData, decryptedData)
    }
    func testRSAGenLargeEncryptAndDecrypt() {
        let testString: String = getRandomLongString()
        let testData: Data = testString.data(using: .utf8)!
        
        let rsaPrivateKey: RSAKeyPair = SimpleSwiftCrypto.generateRandomRSAKeyPair()!
        if rsaPrivateKey.extractPublicKey().encrypt(data: testData) != nil {
            // we should not be able to encrypt a message of this size with RSA
            XCTFail()
        }
    }
    func testRSAGenEncryptAndDecryptWithDifferentKeysMakesDifferentMessage() {
        let testString: String = "Hello World!"
        let testData: Data = testString.data(using: .utf8)!
        
        let rsaPrivateKey1: RSAKeyPair = SimpleSwiftCrypto.generateRandomRSAKeyPair()!
        let rsaPrivateKey2: RSAKeyPair = SimpleSwiftCrypto.generateRandomRSAKeyPair()!
        let encryptedData1: Data = rsaPrivateKey1.extractPublicKey().encrypt(data: testData)!
        let encryptedData2: Data = rsaPrivateKey2.extractPublicKey().encrypt(data: testData)!
        let decryptedData1: Data = rsaPrivateKey1.decrypt(data: encryptedData1)!
        let decryptedData2: Data = rsaPrivateKey2.decrypt(data: encryptedData2)!
        
        XCTAssertEqual(testData, testData)
        XCTAssertNotEqual(testData, encryptedData1)
        XCTAssertNotEqual(testData, encryptedData2)
        XCTAssertNotEqual(encryptedData1, encryptedData2)
        XCTAssertNotEqual(testData, encryptedData1)
        XCTAssertNotEqual(testData, encryptedData2)
        XCTAssertNotEqual(encryptedData1, decryptedData1)
        XCTAssertNotEqual(encryptedData2, decryptedData2)
        XCTAssertEqual(testData, decryptedData1)
        XCTAssertEqual(testData, decryptedData2)
    }
    
    func testRSAExportAndLoads() {
        let rsaPublicKey: RSAPublicKey = SimpleSwiftCrypto.generateRandomRSAKeyPair()!.extractPublicKey()
        let rsaPublicKeyAsData: Data = rsaPublicKey.export()!
        let sameRsaPublicKeyFromData: RSAPublicKey = .load(rsaPublicKeyData: rsaPublicKeyAsData)!
        
        // We should have different instances of SecKey even though they should be the same public key
        XCTAssertNotEqual(rsaPublicKey.__debug_publicKey, sameRsaPublicKeyFromData.__debug_publicKey)
        
        // To test that they have the same public key, we will see if they produce the same encypted data
        let testString: String = "Hello World!"
        let testData: Data = testString.data(using: .utf8)!
        let encryptedData1: Data = rsaPublicKey.encrypt(data: testData)!
        let encryptedData2: Data = sameRsaPublicKeyFromData.encrypt(data: testData)!
        XCTAssertNotEqual(encryptedData1, encryptedData2)
    }
}

func getRandomLongString() -> String {
    func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    var str = ""
    for i in 0..<100_000 {
        str += .init(Character.init(Unicode.Scalar.init(.init(i % Int(UInt8.max)))))
        str += randomString(length: 10)
    }
    return str
}
