/*
   Copyright 2019 BEAT

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
*/

import XCTest
@testable import BeatChain

class KeychainManagerTests: XCTestCase {

    let mockKeychain = MockKeychain()
    lazy var sut = KeychainManager(keychain: mockKeychain)

    override func tearDown() {
        super.tearDown()
        mockKeychain.clearData()
    }
}

// MARK: - Read value

extension KeychainManagerTests {

    func testReadValueQuery() {

        let item = GenericPasswordItem(account: nil)

        let _ = try? sut.readValue(item)
        
        let query = mockKeychain.query
        XCTAssertTrue((query[kSecMatchLimit as String] as? String) == kSecMatchLimitOne as String)
        XCTAssertTrue((query[kSecReturnAttributes as String] as? Bool) == (kCFBooleanTrue as! Bool))
        XCTAssertTrue((query[kSecReturnData as String] as? Bool) == (kCFBooleanTrue as! Bool))
    }
    
    func testReadValue_whenItemNotExist_throwItemNotFoundError() {
        
        mockKeychain.keychainResult = KeychainResult(status: errSecItemNotFound,
                                                     queryResult: [kSecValueData: "".data(using: .utf8)] as AnyObject)
        let item = GenericPasswordItem(account: nil)
        
        XCTAssertThrowsError(try sut.readValue(item), "") { (error) in
            XCTAssertTrue(error as! KeychainManagerError == KeychainManagerError.noItemFound)
        }
    }
    
    func testReadValue_whenUnxpectedError_throwUnexpectedError() {
        
        mockKeychain.keychainResult = KeychainResult(status: errSecBufferTooSmall,
                                                     queryResult: [kSecValueData: "".data(using: .utf8)] as AnyObject)
        let item = GenericPasswordItem(account: nil)
        
        XCTAssertThrowsError(try sut.readValue(item), "") { (error) in
            XCTAssertTrue(error as! KeychainManagerError == KeychainManagerError.unhandledError(status: errSecBufferTooSmall))
        }
    }
    
    func testReadValue_whenUnexpectedData_throwUnexpectedDataError() {
        
        mockKeychain.keychainResult = KeychainResult(status: noErr,
                                                     queryResult: [kSecValueData: ["":""]] as AnyObject)
        let item = GenericPasswordItem(account: nil)
        
        XCTAssertThrowsError(try sut.readValue(item), "") { (error) in
            XCTAssertTrue(error as! KeychainManagerError == KeychainManagerError.unexpectedData)
        }
    }
    
    func testReadValue_whenItemExist_itemFound() {
        
        mockKeychain.keychainResult = KeychainResult(status: noErr,
                                                     queryResult: [kSecValueData: "12345".data(using: .utf8)] as AnyObject)
        let item = GenericPasswordItem(account: nil)
        
        let value = try? sut.readValue(item)
        
        XCTAssert(value == "12345")
    }
}

// MARK: - Save value

extension KeychainManagerTests {

    func testSaveValue_whenItemExist_valueUpdated() {
        
        mockKeychain.keychainResult = KeychainResult(status: noErr,
                                                     queryResult: [kSecValueData: "12345".data(using: .utf8)] as AnyObject)
        let item = GenericPasswordItem(account: nil)
        
        XCTAssertNoThrow(try sut.saveValue("10", to: item))
        XCTAssertTrue((mockKeychain.attributesToUpdate[kSecValueData as String] as? Data) == "10".data(using: String.Encoding.utf8))
    }
    
    func testSaveValue_whenItemNotExist_valueSaved() {
        
        mockKeychain.keychainResult = KeychainResult(status: errSecItemNotFound,
                                                     queryResult: [kSecValueData: "12345".data(using: .utf8)] as AnyObject)
        let item = GenericPasswordItem(account: nil)
        
        XCTAssertNoThrow(try sut.saveValue("10", to: item))
        XCTAssertTrue((mockKeychain.query[kSecValueData as String] as? Data) == "10".data(using: String.Encoding.utf8))
    }
}


// MARK: - Delete item

extension KeychainManagerTests {
    
    func testDeleteItem_whenItemNotExist_deleteItemSucceeded() {
        
        mockKeychain.osStatus = errSecItemNotFound
        let item = GenericPasswordItem(account: nil)

        XCTAssertNoThrow(try sut.deleteItem(item))
    }
    
    func testDeleteItem_whenItemExist_deleteItemSucceeded() {
        
        mockKeychain.osStatus = noErr
        let item = GenericPasswordItem(account: nil)
        
        XCTAssertNoThrow(try sut.deleteItem(item))
    }
    
    func testDeleteItem_whenUnexpectedError_throwUnexpectedError() {
        
        mockKeychain.osStatus = errSecBufferTooSmall
        let item = GenericPasswordItem(account: nil)
        
        XCTAssertThrowsError(try sut.deleteItem(item), "") { (error) in
            XCTAssertTrue(error as! KeychainManagerError == KeychainManagerError.unhandledError(status: errSecBufferTooSmall))
        }
    }
}
