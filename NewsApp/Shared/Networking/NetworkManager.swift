//
//  NetworkManager.swift
//  NewsApp
//
//  Created by Tran Minh Tung on 1/9/18.
//  Copyright © 2018 Tran Minh Tung. All rights reserved.
//

import Foundation
import Moya
import ReachabilitySwift
import RxSwift
import Alamofire

// MARK: - Provider setup
private func JSONResponseDataFormatter(_ data: Data) -> Data {
    do {
        let dataAsJSON = try JSONSerialization.jsonObject(with: data)
        let prettyData =  try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
        return prettyData
    } catch {
        return data // fallback to original data if it can't be serialized.
    }
}

let endpointClosure = { (target: NewsApp) -> Endpoint<NewsApp> in
    let defaultEndpoint = RxMoyaProvider.defaultEndpointMapping(for: target)

    // Sign all non-authenticating requests
    switch target {
    default:
        return defaultEndpoint.adding(newHTTPHeaderFields: ["Content-type": "application/json",
                                                            "X-Api-Key": "2464a5f9e7ff4d909edbbd7ee7c477eb"])
    }
}

let NewsAppProvider = RxMoyaProvider<NewsApp>(endpointClosure: endpointClosure,
                                        manager: DefaultAlamofireManager.sharedManager,
                                        plugins: [
                                            NetworkLoggerPlugin(verbose: true,
                                                                responseDataFormatter: JSONResponseDataFormatter)])

// MARK: - Provider support

private extension String {
    var urlEscaped: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
}

public enum NewsApp {
    case fetchHeadlines(String)
}

extension NewsApp: TargetType {
   public var baseURL: URL { return URL(string: "https://newsapi.org/v2")! }
    public var path: String {
        switch self {
        case .fetchHeadlines:
            return "/top-headlines"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .fetchHeadlines:
            return .get
        }
    }

    public var parameters: [String: Any]? {
        switch self {
        case .fetchHeadlines(let sources):
            return ["sources": sources]
        }
    }

    public var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }

    public var task: Task {
        return .request
    }

    public var validate: Bool {
        switch self {
        default:
            return false
        }
    }

    public var sampleData: Data {
        switch self {
        case .fetchHeadlines:
            return "".data(using: String.Encoding.utf8)!

        }
    }
}

public func url(_ route: TargetType) -> String {
    return route.baseURL.appendingPathComponent(route.path).absoluteString
}

// MARK: - Response Handlers

extension Moya.Response {
    func mapNSArray() throws -> NSArray {
        let any = try self.mapJSON()
        guard let array = any as? NSArray else {
            throw MoyaError.jsonMapping(self)
        }
        return array
    }
}

// MARK: - Network connection status
struct ConnectionStatus {
    static func isInternetAvailable() -> Bool {
        let reachability: Reachability? = Reachability.init()
        guard let unwrap = reachability else {
            return false
        }

        return unwrap.isReachable
    }
}

class DefaultAlamofireManager: Alamofire.SessionManager {
    static let sharedManager: SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        configuration.timeoutIntervalForRequest = 10 // as seconds, you can set your request timeout
        configuration.timeoutIntervalForResource = 10 // as seconds, you can set your resource timeout
        configuration.requestCachePolicy = .useProtocolCachePolicy
        return DefaultAlamofireManager(configuration: configuration)
    }()
}
