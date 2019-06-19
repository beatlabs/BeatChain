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

class GenericPasswordItemTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testItem_whenAccountExist() {
        
        let query = GenericPasswordItem(account: "123").query

        XCTAssertTrue((query[kSecClass as String] as? String) == kSecClassGenericPassword as String)
        XCTAssertTrue((query[kSecAttrService as String] as? String) == "")
        XCTAssertTrue(query[kSecAttrAccount as String] as? String == "123")
        XCTAssertTrue((query[kSecAttrAccessGroup as String] as? String) == "")
        XCTAssertTrue((query[kSecAttrAccessible as String] as? String) == kSecAttrAccessibleAfterFirstUnlock as String)
    }
    
    func testItem_whenAccountNoExist() {
        
        let query = GenericPasswordItem(account: nil).query
        
        XCTAssertNil(query[kSecAttrAccount as String])
    }
}
