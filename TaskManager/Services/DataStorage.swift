//
//  DataStorage.swift
//  TaskManager
//
//  Created by grandmaster on 1.2.23..
//

import Foundation

final class DataStorage {
    
    static let shared = DataStorage()

    private let dataKey = "SaveList"
    private let selectedListIndexKey = "SelectedListIndexKey"
    
    private let storage = UserDefaults.standard
    
    func saveSelectedListIndex(_ index: Int) {
        storage.set(index, forKey: selectedListIndexKey)
    }
    
    func getSelectedIndexKey() -> Int {
        storage.integer(forKey: selectedListIndexKey)
    }
    
    func saveData(_ lists: [List]) {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(lists)
            storage.set(data, forKey: dataKey)
        } catch let error {
            print("Save failed with error: \(error.localizedDescription)")
        }
    }
    
    func getData(completion: ([List]?) -> Void) {
        if let data = storage.object(forKey: dataKey) as? Data {
            do {
                let decoder = JSONDecoder()
                let lists = try decoder.decode([List].self, from: data)
                completion(lists)
            } catch {
                print("Decode failed with error: \(error.localizedDescription)")
                completion(nil)
            }
        }
    }
}
