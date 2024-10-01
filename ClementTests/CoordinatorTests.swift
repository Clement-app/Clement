//
//  CoordinatorTests.swift
//  ClementTests
//
//  Created by Alex Catchpole on 01/10/2024.
//

import Testing
import Foundation
import Dependencies
@testable import Clement

struct CoordinatorTests {

    @Test("shouldUpdate() returns true if an update has never happened")
    func shouldUpdate_neverHappened() throws {
        let defaults = UserDefaults(suiteName: "shouldUpdate_neverHappened")!
        defaults.removePersistentDomain(forName: "shouldUpdate_neverHappened")
        
        let coordinatorWithOldDate = withDependencies {
            $0.date.now = Date.now
            $0[UserDefaultsKey.self] = defaults
        } operation: {
            Coordinator()
        }
        #expect(coordinatorWithOldDate.shouldUpdate() == true)
    }
    
    @Test("shouldUpdate() returns true if the last update was over 24 hours ago")
    func shouldUpdate_over24HoursAgo() throws {
        
        // Update occurred 24h 1m ago
        let now = Date.now
        let withHours = Calendar.current.date(byAdding: .hour, value: -24, to: now)!
        let oldDate = Calendar.current.date(byAdding: .minute, value: -1, to: withHours)!
        
        let defaults = UserDefaults(suiteName: "shouldUpdate_over24HoursAgo")!
        defaults.removePersistentDomain(forName: "shouldUpdate_over24HoursAgo")
        defaults.set(oldDate.rawValue, forKey: UserDefaults.Keys.lastUpdated.rawValue)
        
        let coordinatorWithOldDate = withDependencies {
            $0.date.now = now
            $0[UserDefaultsKey.self] = defaults
        } operation: {
            Coordinator()
        }
        #expect(coordinatorWithOldDate.shouldUpdate() == true)
    }
    
    @Test("shouldUpdate() returns false if the last update was in the last 24 hours")
    func shouldUpdate_inTheLast24Hours() throws {
        
        // Update occurred 23h 30m ago
        let now = Date.now
        let withHours = Calendar.current.date(byAdding: .hour, value: -23, to: now)!
        let oldDate = Calendar.current.date(byAdding: .minute, value: -30, to: withHours)!
        
        let defaults = UserDefaults(suiteName: "shouldUpdate_inTheLast24Hours")!
        defaults.removePersistentDomain(forName: "shouldUpdate_inTheLast24Hours")
        defaults.set(oldDate.rawValue, forKey: UserDefaults.Keys.lastUpdated.rawValue)
        
        let coordinatorWithOldDate = withDependencies {
            $0.date.now = now
            $0[UserDefaultsKey.self] = defaults
        } operation: {
            Coordinator()
        }
        #expect(coordinatorWithOldDate.shouldUpdate() == false)
    }
}
