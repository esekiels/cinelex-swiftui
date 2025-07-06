//
//  NetworkLogger.swift
//  Network
//
//  Created by Esekiel Surbakti on 06/07/25.
//

import Alamofire
import Foundation
import Base

final class NetworkLogger: EventMonitor {
    
    func request<Value>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>) {
        
        if let urlRequest = request.request {
            AppLogger.debug("REQUEST:")
            AppLogger.debug("Method: \(urlRequest.httpMethod ?? "Unknown")")
            AppLogger.debug("URL: \(urlRequest.url?.absoluteString ?? "Unknown URL")")
            AppLogger.debug("Request Headers: \(urlRequest.allHTTPHeaderFields ?? [:])")
            
            if let httpBody = urlRequest.httpBody, let bodyString = String(data: httpBody, encoding: .utf8) {
                AppLogger.debug("Request Body: \(bodyString)")
            }
        }
        
        if let httpResponse = response.response {
            AppLogger.debug("\nRESPONSE:")
            AppLogger.debug("Status Code: \(httpResponse.statusCode)")
        }
        
        if let data = response.data, let responseString = String(data: data, encoding: .utf8) {
            AppLogger.debug("Response Body: \(responseString)")
        }
        
        if let error = response.error {
            AppLogger.error("Error: \(error.localizedDescription)")
        }
        
        AppLogger.debug("-------------------------\n")
    }
}
