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

import Foundation
@testable import BeatChain

class MockKeychain: KeychainInterface {
    
    var osStatus: OSStatus = 0
    var keychainResult = KeychainResult(status: 10, queryResult: nil)
    var query: [String: AnyObject] = [:]
    var attributesToUpdate: [String : AnyObject] = [:]
    
    func add(_ query: [String : AnyObject]) -> OSStatus {
        self.query = query
        return osStatus
    }
    
    func fetch(_ query: [String : AnyObject]) -> KeychainResult {
        self.query = query
        return keychainResult
    }
    
    func update(_ query: [String : AnyObject], with attributes: [String : AnyObject]) -> OSStatus {
        self.query = query
        self.attributesToUpdate = attributes
        return osStatus
    }
    
    func delete(_ query: [String : AnyObject]) -> OSStatus {
        self.query = query
        return osStatus
    }
}
