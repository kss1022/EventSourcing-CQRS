//
//  NSCoder+Utils.swift
//  Routine
//
//  Created by 한현규 on 2023/09/22.
//

import Foundation


extension NSCoder{
    
    // MARK: Int
    func encodeInteger(_ int : Int, forKey: String){
        encode(Int64(int), forKey: forKey)
    }
    
    // MARK: Bool
    func encodeBool(_ bool: Bool, forKey: String){
        encode(bool as Bool, forKey: forKey)
    }
    
    // MARK: UUID
    func encodeUUID(_ uuid: UUID, forKey: String){
        encode(uuid as NSUUID, forKey: forKey)
    }
    
    func decodeUUID(forKey: String) -> UUID?{
        decodeObject(of: NSUUID.self, forKey: forKey) as? UUID
    }
    
    // MARK: String
    
    func decodeString(forKey: String) -> String?{
        decodeObject(of: NSString.self, forKey: forKey) as? String
    }
    
    //MARK: Date
    func encodeDate(_ date: Date, forKey: String){
        encode(date as NSDate, forKey: forKey)
    }
    func decodeDate(forKey: String) -> Date?{        
        decodeObject(of: NSDate.self, forKey: forKey) as? Date
    }
    
    
    //MARK: Set
    func encodeSet<T>(_ set: Set<T>, forKey: String){
        encode(set as NSSet, forKey: forKey)
        //encode(set, forKey: forKey)
    }
    
    func encodeArray<T>(_ set: Array<T>, forKey: String){
        encode(set as NSArray, forKey: forKey)
    }
    
    
    func decodeSet(forKey: String) -> Set<Int>?{
        guard let getSet = self.decodeObject(of: [NSSet.self, NSNumber.self], forKey: forKey) as? NSSet else{
            return nil
        }    
        return Set(getSet.compactMap{ $0 as? Int})
    }
    
    func decodeSet(forKey: String) -> Set<UUID>?{
        guard let getSet = self.decodeObject(of: [NSSet.self, NSUUID.self], forKey: forKey) as? NSSet else{
            return nil
        }
        return Set(getSet.compactMap{ $0 as? UUID})
    }
    
    func decodeArray(forKey: String) -> [Int]?{
        guard let getSet = self.decodeObject(of: [NSArray.self, NSNumber.self], forKey: forKey) as? NSSet else{
            return nil
        }
        return Array(getSet.compactMap{ $0 as? Int})
    }
    
    func decodeArray(forKey: String) -> [UUID]?{
        guard let getSet = self.decodeObject(of: [NSArray.self, NSUUID.self], forKey: forKey) as? NSArray else{
            return nil
        }
        return Array(getSet.compactMap{ $0 as? UUID})
    }
}
