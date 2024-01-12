//
//  UserCreated.swift
//  EventSourcing+CQRS
//
//  Created by 한현규 on 1/11/24.
//

import Foundation



final class UserCreated: DomainEvent{
    let userId: UserId
    let userName: UserName
    
    init(userId: UserId, userName: UserName){
        self.userId = userId
        self.userName = userName
        super.init()
    }
    
    override func encode(with coder: NSCoder) {
        userId.encode(with: coder)
        userName.encode(with: coder)
        super.encode(with: coder)
    }
    
    override init?(coder: NSCoder) {
        guard let userId = UserId(coder: coder),
              let userName = UserName(coder: coder) else { return nil}
                    
        self.userId = userId
        self.userName = userName
        
        
        super.init(coder: coder)
    }
    
    static var supportsSecureCoding: Bool = true

}
