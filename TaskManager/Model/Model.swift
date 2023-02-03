//
//  Model.swift
//  TaskManager
//
//  Created by grandmaster on 1.2.23..
//

import Foundation

protocol ModelProtocol {
    var lists: [List] { get set }
    var selectedList: Int { get set }
    var listCount: Int { get }
}

final class Model: ModelProtocol {
    
    private let storage: DataStorage
    
    var lists = [List]() {
        didSet {
            storage.saveData(lists)
            if lists.isEmpty {
                selectedList = 0
            }
        }
    }
    
    var listCount: Int {
        lists.count
    }
    
    var selectedList: Int = 0 {
        didSet { storage.saveSelectedListIndex(selectedList) }
    }
    
    init(storage: DataStorage = DataStorage.shared) {
        self.storage = storage
        loadData()
    }
    
    private func loadData() {
        storage.getData { lists in
            if let lists = lists {
                self.lists = lists
                self.selectedList = storage.getSelectedIndexKey()
            }
        }
    }
    
}
