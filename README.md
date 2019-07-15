# BeatChain

**BeatChain** is a manager for saving and retrieving string values into keychain written in swift.

[![Build Status](https://travis-ci.com/beatlabs/BeatChain.svg?branch=master)](https://travis-ci.com/beatlabs/BeatChain) [![Cocoapods Compatible](https://img.shields.io/cocoapods/v/BeatChain.svg)](https://cocoapods.org/pods/BeatChain) [![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](#carthage) ![Swift 4.0.x](https://img.shields.io/badge/Swift-4.0.x-green.svg) ![platforms](https://img.shields.io/badge/platforms-iOS-lightgrey.svg)

## Contents

- [Requirements](#requirements)
- [Installation](#installation)
- [Usage](#usage)
- [Documentation](#documentation)
- [License](#license)
- [Authors](#authors)
- [Credits](#credits)

## Requirements

- iOS 10.0+
- Swift 4.0+
- Xcode 10.0+

## Installation

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

to integrate BeatChain into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
use_frameworks!

target '<Your Target Name>' do
    pod 'BeatChain', '~> 1.0.0'
end
```

then, run the following command, this will fetch and install the BeatChain pod:

```bash
$ pod install
```

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew install carthage
```

to integrate BeatChain into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "beatlabs/BeatChain" "master"
```

Run `carthage update` to build the framework and drag the built `BeatChain.framework` into your Xcode project.

### Swift Package Manager

You can use [The Swift Package Manager](https://swift.org/package-manager) to install `BeatChain` by adding the proper description to your `Package.swift` file:

```swift
// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "YOUR_PROJECT_NAME",
    dependencies: [
        .package(url: "https://github.com/beatlabs/BeatChain.git", from: "1.0.0"),
    ]
)
```

then, run the following command:

```bash
$ swift build
```

### Manually

If you prefer you can build the framework manually and drag generated framework `BeatChain.framework` into your Xcode project.

## Usage

### Quick Start

```swift
import BeatChain
```

```swift
let keychainManager = KeychainManager()

// save password into keychain
do {
    let item = GenericPasswordItem(account: "username", accessGroup: "accessGroup")
    try keychainManager.saveValue(password, to: item)
} catch {
    assertionFailure("Save password failed")
}

// read password from keychain
do {
    let item = GenericPasswordItem(account: "account", accessGroup: "accessGroup")
    return try keychainManager.readValue(item)
} catch KeychainManagerError.noItemFound {
    assertionFailure("Item not found")
} catch {
    assertionFailure("Get password failed")
}

// delete password item from keychain
do {
    let item = GenericPasswordItem(account: nil, accessGroup: "accessGroup")
    try keychainManager.deleteItem(item)
} catch {
    assertionFailure("Delete password failed")
}
```

## Documentation

Install [Jazzy](https://github.com/realm/jazzy)

```bash
$ gem install jazzy
```

then you can generate documentation by using the following command:

```bash
$ jazzy --min-acl internal
```

## License

BeatChain is released under the Apache License Version 2.0. See [LICENSE](LICENSE) for details.

## Authors

The iOS BEAT team

[https://github.com/beatlabs/BeatChain](https://github.com/beatlabs/BeatChain)

## Credits

* [GenericKeychain](https://developer.apple.com/library/archive/samplecode/GenericKeychain/Introduction/Intro.html#//apple_ref/doc/uid/DTS40007797)
* [Keychain Services API Tutorial for Passwords in Swift](https://www.raywenderlich.com/9240-keychain-services-api-tutorial-for-passwords-in-swift)
