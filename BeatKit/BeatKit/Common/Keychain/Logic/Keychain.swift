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

public protocol KeychainInterface {
    func add(_ query: [String: AnyObject]) -> OSStatus
    func fetch(_ query: [String: AnyObject]) -> KeychainResult
    func update(_ query: [String: AnyObject], with attributes: [String: AnyObject]) -> OSStatus
    func delete(_ query: [String: AnyObject]) -> OSStatus
}

public class Keychain: KeychainInterface {
    
    public init() { }
    
    /// Add an item in the keychain that matches a certain query
    ///
    /// - Parameter query: The query for the item we want to add
    /// - Returns: A result code
    public func add(_ query: [String: AnyObject]) -> OSStatus {
        return SecItemAdd(query as CFDictionary, nil)
    }
    
    /// Fetch all the items that matches a certain query
    ///
    /// - Parameter query: The query for the items we want to fetch
    /// - Returns: An object that contains a result code and an optional object
    public func fetch(_ query: [String: AnyObject]) -> KeychainResult {
        
        var queryResult: AnyObject?
        let status = withUnsafeMutablePointer(to: &queryResult) {
            SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
        }
        
        return KeychainResult(status: status, queryResult: queryResult)
    }
    
    /// Update all the items that matches a certain query
    ///
    /// - Parameters:
    ///   - query: The query for the items we want to update
    ///   - attributes: The attributes that we want to update
    /// - Returns: A result code
    public func update(_ query: [String: AnyObject], with attributes: [String: AnyObject]) -> OSStatus {
        return SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
    }
    
    /// Delete all the items that matches a certain query
    ///
    /// - Parameter query: The query for the items we want to update
    /// - Returns: A result code
    public func delete(_ query: [String: AnyObject]) -> OSStatus {
        return SecItemDelete(query as CFDictionary)
    }
}
