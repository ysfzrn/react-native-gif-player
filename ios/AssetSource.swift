//
//  AssetSource.swift
//  react-native-gif-player
//
//  Created by Yusuf Zeren on 9.02.2024.
//

struct AssetSource {
    let type: String?
    let uri: String?
    let json: NSDictionary?
    
    init(_ json: NSDictionary!) {
        guard json != nil else {
            self.json = nil
            self.type = nil
            self.uri = nil
            return
        }
        self.json = json
        self.type = json["type"] as? String
        self.uri = json["uri"] as? String
    }
}
