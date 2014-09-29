//
//  StatusArray.swift
//  TwitterLite
//
//  Created by Yili Aiwazian on 9/28/14.
//  Copyright (c) 2014 Yili Aiwazian. All rights reserved.
//

import UIKit

class StatusArray: NSObject {
   
    var count: Int {
        get {
            return statusArray.count
        }
    }
    func getStatus(index: Int) -> Status? {
        if (index >= statusArray.count) {
            return nil
        }
        return statusArray[index]
    }
    
    private var statusArray: [Status]
    
    // newest status id in the array (not including the newly composed fake items)
    private var newestStatusId: Int? {
        get {
            let index = newestStatusIndex
            if index != nil {
                return statusArray[index!].statusId
            }
            return nil
        }
    }
    
    // array index of the newest comfirmed status (not including the newly composed fake items)
    private var newestStatusIndex: Int? {
        get {
            if (statusArray.count == 0) {
                return nil
            }
            for i in 0...statusArray.count-1 {
                if statusArray[i].statusId != nil {
                    return i
                }
            }
            return nil
        }
    }

    // oldest status id in the array
    private var oldestStatusId: Int? {
        get {
            return statusArray.count > 0 ? statusArray[statusArray.count - 1].statusId! : nil
        }
    }
    
    override init() {
        statusArray = [Status]()
    }
    
    // Inserting a new status to the end of the array
    func addToEnd(newStatus: Status) {
        if (newStatus.statusId == nil) {
            println("Error: Cannot add a new status without an ID to the end of the array")
            return
        }
        if (statusArray.count > 0 && newStatus.statusId > oldestStatusId) {
            println("Error: Cannot add a new status with a larger status ID than the one at the end of the array")
            return
        }
        statusArray.append(newStatus)
    }
    
    // Insert a new status to the beginning of the array
    func addToBeginning(newStatus: Status) {
        if (statusArray.count > 0 && newStatus.statusId? < newestStatusId) {
            println("Error: Cannot add a new status with a smaller status ID than the one at the beginning of the array")
            return
        }
        statusArray.insert(newStatus, atIndex: 0)
    }
}
