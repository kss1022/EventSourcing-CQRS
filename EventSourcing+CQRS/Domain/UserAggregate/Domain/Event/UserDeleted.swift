//
//  UserDeleted.swift
//  EventSourcing+CQRS
//
//  Created by 한현규 on 1/11/24.
//

import Foundation


final class UserDeleted: DomainEvent{
    let userId: UserId
    
    init(userId: UserId){
        self.userId = userId
        super.init()
    }
    
    override func encode(with coder: NSCoder) {
        userId.encode(with: coder)
        super.encode(with: coder)
    }
    
    override init?(coder: NSCoder) {
        guard let userId = UserId(coder: coder) else { return nil}
        self.userId = userId
        super.init(coder: coder)
    }
    
    static var supportsSecureCoding: Bool = true
    
}
