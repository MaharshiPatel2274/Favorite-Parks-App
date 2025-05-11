//
//  ParkModel.swift
//  Lab5
//
//  Created by mpate125 on 3/6/25.
//


import Foundation

struct Park: Identifiable, Hashable {
    let id = UUID()
    var name: String
    var location: String
    var description: String
    var imageName: String        
}

