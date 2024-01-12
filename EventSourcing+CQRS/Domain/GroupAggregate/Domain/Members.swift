//
//  Members.swift
//  EventSourcing+CQRS
//
//  Created by 한현규 on 1/11/24.
//

import Foundation


struct Members: ValueObject{
    var members: Set<UserId>
    
    
    init(_ members: Set<UserId>) {
        self.members = members
    }

    func insert(_ member: UserId) throws -> Members{
        var members = self.members
        
        if members.contains(where: { $0.id == member.id }){
            throw GroupException.canNotJoin(message: "Join Member is already exsit")
        }
        
        members.insert(member)
        return Members(members)
    }
    
    func encode(with coder: NSCoder) {
        
        coder.encodeArray(members.map{ $0.id} ,forKey: CodingKeys.members.rawValue)
    }
        
    init?(coder: NSCoder) {
        guard let members: [UUID] = coder.decodeArray(forKey: CodingKeys.members.rawValue) else { return nil}
        self.members = Set(members.map{ UserId($0)})
    
    }
        
    private enum CodingKeys: String {
        case members = "Members"
    }
    

}
