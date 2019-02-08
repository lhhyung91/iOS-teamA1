//
//  APIManager.swift
//  tree
//
//  Created by ParkSungJoon on 25/01/2019.
//  Copyright © 2019 gardener. All rights reserved.
//

import Foundation

final class APIManager {
    static func getArticles(
        keyword: String,
        keywordLoc: String,
        lang: String,
        articlesSortBy: String,
        articlesPage: Int,
        completion: @escaping (Result<Articles>
    ) -> Void ) {
        APICenter<EventRegistryAPI>().request(.getArticles(
                keyword: keyword,
                keywordLoc: keywordLoc,
                lang: lang,
                articlesSortBy: articlesSortBy,
                articlesPage: articlesPage)) { (data, error) in
                    guard error == nil else {
                        return completion(Result.failure(error!))
                    }
                    guard let responseData = data else { return }
                    do {
                        let decodeJSON = try JSONDecoder().decode(Articles.self, from: responseData)
                        completion(Result.success(decodeJSON))
                    } catch {
                        completion(Result.failure(NetworkError.decodingFail))
                    }
                }
    }
    
    static func getDailyTrends(
        hl: String,
        geo: String,
        completion: @escaping (Result<TrendDays>
    ) -> Void) {
        APICenter<GoogleTrendAPI>().requestDownload(.getDailyTrends(hl: hl, geo: geo)) { (prettyJSON, error)  in
            guard error == nil else {
                return completion(Result.failure(error!))
            }
            guard let prettyJSON = prettyJSON else { return }
            guard let jsonData = prettyJSON.data(using: .utf8) else { return }
            do {
                let decodeJSON = try JSONDecoder().decode(TrendDays.self, from: jsonData)
                completion(Result.success(decodeJSON))
            } catch {
                completion(Result.failure(NetworkError.decodingFail))
            }
        }
    }
    
    static func getGraphData(
        startDate: String,
        endDate: String,
        timeUnit: String,
        keywordGroups: [[String: Any]],
        completion: @escaping (Result<Graph>
    ) -> Void) {
        APICenter<NaverAPI>().request(.getKeywordTrend(
            startDate: startDate,
            endDate: endDate,
            timeUnit: timeUnit,
            keywordGroups: keywordGroups
        )) { (data, error) in
            guard error == nil else {
                return completion(Result.failure(error!))
            }
            guard let responseData = data else { return }
            do {
                let decodeJSON = try JSONDecoder().decode(Graph.self, from: responseData)
                completion(Result.success(decodeJSON))
            } catch {
                completion(Result.failure(NetworkError.decodingFail))
            }
        }
    }
}
