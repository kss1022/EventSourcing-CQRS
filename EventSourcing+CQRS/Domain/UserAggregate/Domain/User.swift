//
//  User.swift
//  EventSourcing+CQRS
//
//  Created by 한현규 on 1/11/24.
//

import Foundation



final class User: DomainEntity{
    private(set) var userId: UserId!
    private(set) var userName: UserName!
    
    
    init(userId: UserId, userName: UserName) {
        self.userId = userId
        self.userName = userName
        
        super.init()

        let event = UserCreated(userId: userId, userName: userName)
        changes.append(event)
    }
    
    required init(_ events: [Event]) {
        super.init(events)
    }
    
    override func mutate(_ event: Event) {
        if let created = event as? UserCreated{
            when(created)
        }else if let rename = event as? UserRename{
            when(rename)
        }else{
            Log.e("Event is not handling")
        }        
    }
    
    func when(_ event: UserCreated){
        self.userId = event.userId
        self.userName = event.userName
    }
    
    func when(_ event: UserRename){
        self.userName = event.userName
    }
    
        
    func rename(userName: UserName){
        self.userName = userName
        
        let event = UserRename(userId: self.userId, userName: userName)
        changes.append(event)
    }
    
    func delete(){
        let event = UserDeleted(userId: self.userId)
        changes.append(event)
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
