//
//  DecksView-ViewModel.swift
//  AnkiMind
//
//  Created by Matthew Zierl on 2/6/25.
//

import Foundation
import SwiftData

extension AnkiView {
    
    @Observable
    class ViewModel {
        
        enum TabState {
            case gallery
            case list
        }
        var modelContext: ModelContext
        
        var ipAddress: String
        var urlStr: String {
            "http://\(ipAddress):8765"
        }
        
        enum Error: Swift.Error {
            case urlCreation
            case jsonEncoding
            case jsonDecoding
            case networkError
            case responseError
            case deckNotFound
            case misalignment
        }
        
        init(modelContext: ModelContext, ipAddress: String) {
            self.modelContext = modelContext
            self.ipAddress = ipAddress
            print("IP: \(ipAddress)")
            print(urlStr)
        }
        
        /*
            Used by 'sync' button in view
         */
        func sync() {
            Task {
                do {
                    try modelContext.delete(model: DeckStructureNode.self)
                    try await refreshDeck()
                } catch {
                    print(error)
                    throw error
                }
            }
        }
        
        /*
            Initiates a request for deck stats given the name(s) of the deck.
            Returns a dictionary of deck object(s) with keys being string of their ids.
         */
        private func getDeckStats(names: [String]) async throws -> [String: Deck] {
            struct Param: Encodable {
                let decks: [String]
            }
            struct Request: Encodable {
                let action: String
                let version: Int
                let params: Param
            }
            struct Response: Decodable {
                let result: [String: Deck]
                let error: String?
            }
            
            guard let url = URL(string: urlStr) else {
                throw Error.urlCreation
            }

            let requestBody = Request(action: "getDeckStats", version: 6, params: Param(decks: names))

            guard let jsonData = try? JSONEncoder().encode(requestBody) else {
                throw Error.jsonEncoding
            }

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData

            do {
                let (data, response) = try await URLSession.shared.data(for: request)
                
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                    print("HTTP Error Code: \(httpResponse.statusCode)")
                    throw Error.networkError
                }

                let decodedResponse = try JSONDecoder().decode(Response.self, from: data)
                
                if decodedResponse.error != nil {
                    throw Error.responseError
                }

                return decodedResponse.result
            } catch {
                throw error
            }
        }
        
        
        @MainActor
        func insertNode(pathComponents: [String], deck: Deck) throws {
            print("ENTIRE PATH: \(pathComponents)")
            let rootDescriptor = FetchDescriptor<DeckStructureNode>(predicate: #Predicate { node in
                node.isRoot
            })
            do {
                let rootNodes = try modelContext.fetch(rootDescriptor)
                if let rootIndex = rootNodes.firstIndex(where: { $0.name == pathComponents[0]}) {
                    rootNodes[rootIndex].insert(pathComponents: Array(pathComponents.dropFirst()), deck: deck, modelContext: modelContext)
                } else {
                    // no root node available
                    let newNode = DeckStructureNode(name: pathComponents[0], isRoot: true)
                    newNode.insert(pathComponents: Array(pathComponents.dropFirst()), deck: deck, modelContext: modelContext)
                }
                try modelContext.save()
            } catch {
                throw error
            }
        }


        /*
            Input: n/a
            Output: n/a
            Purpose:
                - Basically reload all deck data including deck names, stats, and
                restructure deck nodes/hierachy if they have changed
         */
        func refreshDeck() async throws {
            struct Request: Encodable { // send to ankiConnect
                let action: String
                let version: Int
            }
            struct Response: Decodable { // receive from ankiConnect
                let result: [String: Int]
                let error: String?
            }
            
            guard let url = URL(string: urlStr) else { throw Error.urlCreation }
            let requestBody = Request(action: "deckNamesAndIds", version: 6)
            guard let jsonData = try? JSONEncoder().encode(requestBody) else { throw Error.jsonEncoding }
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
            do {
                let (data, response) = try await URLSession.shared.data(for: request)
                if let networkError = response as? HTTPURLResponse, networkError.statusCode != 200 {
                    print("HTTP Error Code: \(networkError.statusCode)")
                    throw Error.networkError
                }
                let decodedResponse = try JSONDecoder().decode(Response.self , from: data) // contains dictionary of all names and IDs, and error
                if decodedResponse.error != nil {
                    throw Error.responseError
                }
                let deckDictionary = decodedResponse.result
                let deckStatsDictionary = try await getDeckStats(names: Array(deckDictionary.keys))
                
                for name in deckDictionary.keys { // check for changes for each deck
                    if name == "Default" { // we don't want decks users didn't create
                        continue
                    }
                    let id = deckDictionary[name]!
                    guard let deck = deckStatsDictionary[String(id)] else {
                        throw Error.deckNotFound
                    }
                    let pathComponents = name.components(separatedBy: "::")
                    try await insertNode(pathComponents: pathComponents, deck: deck)
                }
            } catch {
                throw error
            }
        }
        
    }
}
