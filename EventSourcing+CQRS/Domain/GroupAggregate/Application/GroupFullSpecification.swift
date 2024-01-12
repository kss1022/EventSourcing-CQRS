//
//  GroupFullSpecification.swift
//  EventSourcing+CQRS
//
//  Created by 한현규 on 1/11/24.
//

import Foundation


class GroupFullSpecification: Specification<Members>{
    override func isSatisfiedBy(_ canidate: Members) -> Bool {
        canidate.members.count < 6
    }
}
