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

public enum KeychainManagerError: Error, Equatable {
    case noItemFound
    case unexpectedData
    case unhandledError(status: OSStatus)
}

public protocol KeychainManagerProtocol {
    func readValue(_ item: Queryable) throws -> String
    func saveValue(_ value: String, to item: Queryable) throws
    func deleteItem(_ item: Queryable) throws
}

public class KeychainManager: KeychainManagerProtocol {
    
    private let keychain: KeychainProtocol
    
    // MARK: - Interface
    
    public init(keychain: KeychainProtocol = Keychain()) {
        self.keychain = keychain
    }
    
    // MARK: - public interface
    
    /// Read a string value from keychain using a queryable item
    ///
    /// - Parameter item: The queryable item
    /// - Returns: The Value for the queryable item
    /// - Throws: An error if somthing fails
    public func readValue(_ item: Queryable) throws -> String {
        
        // Build a query
        var query = item.query
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        query[kSecReturnAttributes as String] = kCFBooleanTrue
        query[kSecReturnData as String] = kCFBooleanTrue
        
        // Try to fetch the existing keychain item that matches the query.
        let keychainResponse = keychain.fetch(query)
        
        // Check the return status and throw an error if appropriate.
        guard keychainResponse.status != errSecItemNotFound else {
            throw KeychainManagerError.noItemFound
        }
        
        guard keychainResponse.status == noErr else {
            throw KeychainManagerError.unhandledError(status: keychainResponse.status)
        }
        
        // Parse the string value from the query result.
        guard let existingItem = keychainResponse.queryResult as? [String : AnyObject],
            let data = existingItem[kSecValueData as String] as? Data,
            let value = String(data: data, encoding: String.Encoding.utf8) else {
                throw KeychainManagerError.unexpectedData
        }
        
        return value
    }
    
    /// Save a string value to the keychain using a queryable item
    ///
    /// - Parameters:
    ///   - value: The value to be saved
    ///   - item: The queryable item
    /// - Throws: An error if something fails
    public func saveValue(_ value: String, to item: Queryable) throws {
        
        // Encode the value into a Data object.
        let encodedValue = value.data(using: String.Encoding.utf8)!
        
        do {
            // Check for an existing item in the keychain.
            try _ = readValue(item)
            
            // Update the existing item with the new password.
            var attributesToUpdate = [String : AnyObject]()
            attributesToUpdate[kSecValueData as String] = encodedValue as AnyObject?
            
            let status = keychain.update(item.query, with: attributesToUpdate)
            
            // Throw an error if an unexpected status was returned.
            guard status == noErr else {
                throw KeychainManagerError.unhandledError(status: status)
            }
        }
        catch KeychainManagerError.noItemFound {
            
            // No item was found in the keychain. Create a dictionary to save as a new keychain item.
            var newItem = item.query
            newItem[kSecValueData as String] = encodedValue as AnyObject?
            
            // Add the new item to the keychain.
            let status = keychain.add(newItem)
            
            // Throw an error if an unexpected status was returned.
            guard status == noErr else {
                throw KeychainManagerError.unhandledError(status: status)
            }
        }
    }
    
    /// Delete all the keychain items that matches a specific queryable item
    ///
    /// - Parameter item: A queryable item
    /// - Throws: An error if something fails
    public func deleteItem(_ item: Queryable) throws {
        
        // Delete the existing item(s) from the keychain.
        let status = keychain.delete(item.query)
        
        // Throw an error if an unexpected status was returned.
        guard status == noErr || status == errSecItemNotFound else {
            throw KeychainManagerError.unhandledError(status: status)
        }
    }
}
