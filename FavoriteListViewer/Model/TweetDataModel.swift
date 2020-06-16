//
//  TweetDataModel.swift
//  FavoriteListViewer
//
//  Created by 植田圭祐 on 2020/05/23.
//  Copyright © 2020 Keisuke Ueda. All rights reserved.
//

//TwitterAPIの取得データモデル

import Foundation

//TwitterAPIからの取得データはめる
struct TwitterSetting: Decodable {
    let language: String
    let screenName: String
    
    enum CodingKeys: String, CodingKey {
        case language = "language"
        case screenName = "screen_name"
    }
}

struct Favorite: Decodable {
    let created: String
    let entities: Entities
    let id_str: String
    let text: String
    let extended_entities: Extended_entities?
    let user: User
    
    enum CodingKeys: String, CodingKey {
        case created = "created_at"
        case entities = "entities"
        case id_str = "id_str"
        case text = "text"
        case extended_entities = "extended_entities"
        case user = "user"
    }
    
    
    struct Entities: Decodable {
        let urls: [URLs]?
        
        struct URLs: Decodable {
            let expanded_url: String
            
            enum CodingKeys: String, CodingKey {
                case expanded_url = "expanded_url"
            }
        }
        
        enum CodingKeys: String, CodingKey {
            case urls = "urls"
        }
    }
    
    struct Extended_entities: Decodable {
        let media: [Media]
        
        struct Media: Decodable {
            let media_url_https: String
            let type: String
            let video_info: Video_info?
            
            enum CodingKeys: String, CodingKey {
                case media_url_https = "media_url_https"
                case type = "type"
                case video_info = "video_info"
            }
        }
        
        enum CodingKeys: String, CodingKey {
            case media = "media"
        }
    }
    
    struct Video_info: Decodable {
        let variants: [variants]
        
        enum CodingKeys: String, CodingKey {
            case variants = "variants"
        }
    }
    
    struct variants: Decodable {
        let bitrate: Int?
        let content_type: String
        let url: String
        
        enum CodingKeys: String, CodingKey {
            case bitrate = "bitrate"
            case content_type = "content_type"
            case url = "url"
        }
    }
    
    
    struct User: Decodable {
        let id_str: String
        let name: String
        let screen_name: String
        //let url: String
        let profile_image_url_https: String
        
        enum CodingKeys: String, CodingKey {
            case id_str = "id_str"
            case name = "name"
            case screen_name = "screen_name"
            //case url = "url"
            case profile_image_url_https = "profile_image_url_https"
        }
    }
}
