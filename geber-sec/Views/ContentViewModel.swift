//
//  ContentViewModel.swift
//  geber-sec
//
//  Created by bernanda on 31/03/24.
//

import Foundation
import SwiftyRedis
import SwiftRedis
import Network

final class ContentViewModel : ObservableObject {
    @Published var s1_event : Row = Row(location: SectionLocation.s1, numberOfCalls: 0, latestCall: "")
    @Published var s2_event : Row = Row(location: SectionLocation.s2, numberOfCalls: 0, latestCall: "")
    @Published var s3_event : Row = Row(location: SectionLocation.s3, numberOfCalls: 0, latestCall: "")
    
    private let client = RedisClient(NWEndpoint.Host(EnvManager.shared.REDIS_HOST), username: EnvManager.shared.REDIS_USER, password: EnvManager.shared.REDIS_PASS)
    private let redis = Redis()
    
    init() {
        redis.connect(host: EnvManager.shared.REDIS_HOST, port: 6379) { (redisError: NSError?) in
            if let error = redisError {
                print(error)
            }
            else {
                print("Connected to Redis")
                redis.auth(EnvManager.shared.REDIS_PASS) { (err : NSError?) in
                    if let error = redisError {
                        print(error)
                    }
                    
                    print("Redis connection established")
                }
                
            }
        }
    }
    
    func subscribe(loc: String) async {
        do {
            let c = try await client.get_pub_sub_connection()
            try await c.psubscribe("__keyspace*:\(loc)*")
            let messageStream = await c.messages()
            
            for try await _ in messageStream {
                await MainActor.run {
                    getAndParse(loc: loc)
                }
            }
            
            print(messageStream)
            
        } catch {
            print("\(error)")
        }
    }
    
    func getAndParse(loc: String) {
        redis.keys(pattern: "\(loc)_event_*") { (redisKeys: [RedisString?]?, redisError: NSError?) in
            if let error = redisError {
                print(error)
            }
            else if var keys = redisKeys {
                if keys.count == 0 {
                    updateRow(loc: loc, num: 0, latestCall: "00:00:00")
                }
                
                keys.sort() { (a : RedisString?, b: RedisString?) in
                    if let str1 = a?.asString, let str2 = b?.asString {
                        return str1 > str2
                    }
                    
                    return false
                }
                
                if let firstKey = keys.first {
                    if let firstKeyString = firstKey?.asString {
                        
                        if let timeComponent = firstKeyString.split(separator: "_").last {
                            if let timeValue = Int(timeComponent) {
                                let date = Date(timeIntervalSince1970: TimeInterval(timeValue))
                                
                                //                              end action
                                updateRow(loc: loc, num: keys.count, latestCall: Util.formattedTime(from: date))
                                
                            } else {
                                print("Failed to parse time component as integer")
                            }
                        } else {
                            print("Failed to parse key")
                        }
                    }
                }
            }
        }
    }
    
    func updateRow(loc: String, num: Int, latestCall: String) {
        switch loc {
        case "s1":
            s1_event.numberOfCalls = num
            s1_event.latestCall = latestCall
        case "s2":
            s2_event.numberOfCalls = num
            s2_event.latestCall = latestCall
        case "s3":
            s3_event.numberOfCalls = num
            s3_event.latestCall = latestCall
        default:
            break
        }
    }
}
