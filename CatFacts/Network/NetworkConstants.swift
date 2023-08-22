//
//  NetworkConstants.swift
//  CatFacts
//
//  Created by Thomas (privat) Leonhardt on 02.08.23.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

enum HTTPSchema: String {
    case http = "http"
    case https = "https"
}

enum NetworkParts: String {
    case baseUrl = "catfact.ninja"
}

enum NetworkPaths: String {
    case catFactPath = "/fact"
}

enum NetworkError: Error {
    case urlError
    case dataParsingError
}

