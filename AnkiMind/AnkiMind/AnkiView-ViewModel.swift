//
//  DecksView-ViewModel.swift
//  AnkiMind
//
//  Created by Matthew Zierl on 2/6/25.
//

import Foundation

extension AnkiView {
    
    @Observable
    class ViewModel {
        
        enum TabState {
            case gallery
            case list
        }
        
        var deckStructure = [DeckStructureNode]()
                
        var userIP: String = "192.168.1.53"
        var urlStr: String {
            "http://\(userIP):8765"
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
        
        
        
        
        func sync() {
            Task {
                do {
                    try await refreshDeck()
                } catch {
                    print(error)
                    throw error
                }
            }
        }
        
        /*
            Initiates a request for deck stats given the name(s) of the deck.
            Returns a Deck object.
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
                print("URL Creation Error")
                throw Error.urlCreation
            }

            let requestBody = Request(action: "getDeckStats", version: 6, params: Param(decks: names))

            guard let jsonData = try? JSONEncoder().encode(requestBody) else {
                print("JSON Encoder Error")
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
        func insertNode(pathComponents: [String], deck: Deck) {
            if let rootIndex = self.deckStructure.firstIndex(where: { $0.name == pathComponents[0]}) {
                deckStructure[rootIndex].insert(pathComponents: Array(pathComponents.dropFirst()), deck: deck)
            } else {
                // create new root node and insert
                var newRoot = DeckStructureNode(name: pathComponents[0])
                if pathComponents.count > 1 {
                    newRoot.insert(pathComponents: Array(pathComponents.dropFirst()), deck: deck)
                } else {
                    newRoot.deck = deck
                }
                deckStructure.append(newRoot)
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
                let decodedResponse = try JSONDecoder().decode(Response.self , from: data) // contains array of all names and IDs
                if decodedResponse.error != nil {
                    throw Error.responseError
                }
                let deckDictionary = decodedResponse.result
                let deckStatsDictionary = try await getDeckStats(names: Array(deckDictionary.keys))
                
                
                await MainActor.run {
                    deckStructure.removeAll() // Remove all previous entries and re-add them
                }
                
                for name in deckDictionary.keys {
                    if name == "Default" { // we don't want decks users didn't create
                        continue
                    }
                    let id = deckDictionary[name]!
                    guard let deck = deckStatsDictionary[String(id)] else {
                        throw Error.deckNotFound
                    }
                    let pathComponents = name.components(separatedBy: "::")
                    await insertNode(pathComponents: pathComponents, deck: deck)
                }
            } catch {
                throw error
            }
        }
    }
}
