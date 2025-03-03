//
//  APIService.swift
//  PartTime1111
//
//  Created by 陳逸煌 on 2024/3/19.
//

import Foundation

struct Result<T> {
    let errorMessage: String?
    let model: T?
}

class ApiService {
    
    //取得職缺列表
    static func getPosition(apiAction: ApiAction = .searchPosition,
                             header: HttpHeader = .json,
                             suffix: String? = nil,
                             parameter: [String: Any]? = nil) async throws -> Result<[PositionModel]> {
        do {
            let result = try await ApiClinet.connectApi(apiAction: apiAction,
                                                         header: header,
                                                         suffix: suffix,
                                                         parameter: parameter)
            if let errorMessage = result.errorMessage {
                return Result(errorMessage: errorMessage, model: nil)
            } else if let model = result.model as? [String: Any],
                      let list = model["list"] as? [[String: Any]] {
                let positionModels = list.compactMap { PositionModel(json: $0) }
                return Result(errorMessage: nil, model: positionModels)
            } else {
                throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response format"])
            }
        } catch {
            throw error
        }
    }
}
