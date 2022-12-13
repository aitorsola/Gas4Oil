//
//  DomainConvertible.swift
//  Gas4Oil
//
//  Created by Aitor Sola on 4/3/22.
//

protocol DomainConvertible {
    associatedtype DomainEntityType
    func domainEntity() -> DomainEntityType?
}
