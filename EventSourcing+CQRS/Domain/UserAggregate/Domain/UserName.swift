//
//  UserName.swift
//  EventSourcing+CQRS
//
//  Created by 한현규 on 1/11/24.
//

import Foundation


struct UserName: ValueObject{
    let name: String
    
    init(_ name: String) throws{
        if name.count > 50{ throw ArgumentException("UserName Length must less then 50")  }
        if name.count < 2{ throw ArgumentException("UserName Length must more then 2")  }
        self.name = name
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: CodingKeys.name.rawValue)
    }
        
    init?(coder: NSCoder) {
        guard let name =  coder.decodeString(forKey: CodingKeys.name.rawValue) else { return nil}
        self.name = name
    }
        
    private enum CodingKeys: String {
        case name = "UserName"
    }

}
