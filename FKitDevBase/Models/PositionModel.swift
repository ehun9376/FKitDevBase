//
//  PositionModel.swift
//  1111part_time
//
//  Created by 陳逸煌 on 2024/3/19.
//

import Foundation

struct PositionModel: Identifiable {
    
    var id: Int?
    var positionName: String?
    var positinoID: Int?
    var companyName: String?
    var location: String?
    var workPart: [String]?
    var salary: String?
    
    init(id: Int? = nil,
         positionName: String? = nil,
         positinoID: Int? = nil,
         companyName: String? = nil,
         location: String? = nil,
         workPart: [String]? = nil,
         salary: String? = nil
    ) {
        self.positionName = positionName
        self.positinoID = positinoID
        self.companyName = companyName
        self.location = location
        self.workPart = workPart
        self.salary = salary
    }
    
    // From JSON
    init(json: [String: Any]) {
        self.positionName = json["job_name"] as? String
        self.positinoID = json["job_id"] as? Int
        self.companyName = json["corp_name"] as? String
        self.location = json["workcity"] as? String
        self.salary = json["salary"] as? String
    }
    
    static func fromJsonList(_ list: [[String: Any]]) -> [PositionModel] {
        return list.compactMap { PositionModel(json: $0) }
    }
}
