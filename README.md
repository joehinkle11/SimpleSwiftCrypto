# Simple Swift Crypto

I needed a simple way of doing both symmetric and asymmetric crypto without the headache. I also didn't need to store it in the Keychain. So I made this.

Works on MacOS, iOS, WatchOS and TvOS.

## Example Usage

### AES Symmetric Encryption and Decryption

```swift
let testString: String = "Hello World!"
let testData: Data = testString.data(using: .utf8)!

let aesPrivateKey: AES256Key = SimpleSwiftCrypto.generateRandomAES256Key()!
let encryptedData: Data = aesPrivateKey.encrypt(data: testData)!

let decryptedData: Data = aesPrivateKey.decrypt(data: encryptedData)!
let decryptedString: String = String(data: decryptedData, encoding: .utf8)! // "Hello World!"
```

### RSA Asymmetric Encryption and Decryption

```swift
let testString: String = "Hello World!"
let testData: Data = testString.data(using: .utf8)!

let rsaPrivateKey: RSAKeyPair = SimpleSwiftCrypto.generateRandomRSAKeyPair()!
let rsaPublicKey: RSAPublicKey = rsaPrivateKey.extractPublicKey()
let encryptedData: Data = rsaPublicKey.encrypt(data: testData)!

let decryptedData: Data = rsaPrivateKey.decrypt(data: encryptedData)!
let decryptedString: String = String(data: decryptedData, encoding: .utf8)! // "Hello World!"
```

### Exporting and Loading AES Secret Key

```swift
let aesPrivateKey: AES256Key = SimpleSwiftCrypto.generateRandomAES256Key()!
let aesPrivateKeyAsData: Data = aesPrivateKey.exportIvAndPrivateAES256Key()

// send `aesPrivateKeyAsData` to another device securely, then...  
let sameAesPrivateKeyFromData: AES256Key = .loadIvAndPrivateAES256Key(ivAndPrivateAES256Key: aesPrivateKeyAsData)!
```

### Exporting and Loading RSA Public Key

```swift
let rsaPrivateKey: RSAKeyPair = SimpleSwiftCrypto.generateRandomRSAKeyPair()!
let rsaPublicKey: RSAPublicKey = rsaPrivateKey.extractPublicKey()
let rsaPublicKeyAsData: Data = rsaPublicKey.export()!


// send `rsaPublicKeyAsData` to another device, then...  
let sameRsaPublicKeyFromData: RSAPublicKey = .load(rsaPublicKeyData: rsaPublicKeyAsData)!
```

## Add as Swift Package

```swift
// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "Example",
    dependencies: [
        .package(name: "SimpleSwiftCrypto", url: "https://github.com/joehinkle11/SimpleSwiftCrypto.git", from: "1.0.0"),
    ],
    targets: [
        "SimpleSwiftCrypto"
    ]
)
```

## Why did I make this?

I'm working on an IDE for iPad/iOS called [App Maker Professional](https://www.appmakerios.com). A new feature I'm adding is multiplayer, and I don't want to have my users' files on the server. So I made this to be able to encrypt their files locally on device so the server can't read them.

## Contributions

If someone wants to add Keychain support, that'd be great. I'll take a look at a PR.

## License

[MIT](https://github.com/joehinkle11/SimpleSwiftCrypto/blob/main/LICENSE)

## Sources

- https://github.com/henrinormak/Heimdall

- Apple Docs

- Wikipedia

- StackOverflow 😎
