//
//  Pokemon.swift
//  pokedex_christian_leovido_swift3
//
//  Created by Christian Leovido on 14/09/2016.
//  Copyright © 2016 Christian Leovido. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    
    fileprivate var _name: String!
    fileprivate var _pokedexId: Int!
    fileprivate var _description: String!
    fileprivate var _type: String!
    fileprivate var _defense: String!
    fileprivate var _height: String!
    fileprivate var _weight: String!
    fileprivate var _attack: String!
    fileprivate var _nextEvolutionTxt: String!
    fileprivate var _nextEvolutionName: String!
    fileprivate var _nextEvolutionId: String!
    fileprivate var _nextEvolutionLevel: String!
    fileprivate var _pokemonURL: String!
    fileprivate var _moves: [[String:Any]]!
    
    var moves: [[String:Any]] {
        
        if _moves == nil {
            _moves = [[String:Any]]()
        }
        
        return _moves
        
    }
    
    var nextEvolutionId: String {
        
        if _nextEvolutionId == nil {
            _nextEvolutionId = ""
        }
        
        return _nextEvolutionId
        
        
    }
    
    var nextEvolutionLevel: String {
        
        if _nextEvolutionLevel == nil {
            _nextEvolutionLevel = ""
        }
        
        return _nextEvolutionLevel
        
        
    }
    
    var nextEvolutionName: String {
        
        if _nextEvolutionName == nil {
            _nextEvolutionName = ""
        }
        
        return _nextEvolutionName
        
        
    }
    
    var description: String {
        
        if _description == nil {
            _description = ""
        }
        
        return _description
        
    }
    
    var type: String {
        
        if _type == nil {
            _type = ""
        }
        
        return _type
        
    }
    
    var height: String {
        
        if _height == nil {
            
            _height = ""
        }
        return _height
        
    }
    
    var weight: String {
        
        if _weight == nil {
            
            _weight = ""
        }
        return _weight
        
    }
    
    var defense: String {
        
        if _defense == nil {
            
            _defense = ""
        }
        return _defense
        
    }
    
    var attack: String {
        
        if _attack == nil {
            
                _attack = ""
        }
        return _attack
        
    }
    
    var nextEvolutionText: String {
        
        if _nextEvolutionTxt == nil {
             _nextEvolutionTxt = ""
        }
        return _nextEvolutionTxt
    }
    
    
    var name: String {
        
        return _name
    }
    
    var pokedexId: Int {
        
        return _pokedexId
    }
    
    init(name: String, pokedexId: Int) {
        
        self._name = name
        self._pokedexId = pokedexId
        
        self._pokemonURL = "\(URL_BASE)\(URL_POKEMON)\(self.pokedexId)/"
    }
    
    func downloadPokemonDetail(completed: @escaping DownloadComplete) {
        
        Alamofire.request(_pokemonURL).responseJSON { (response) in
            
            if let dict = response.result.value as? Dictionary<String, AnyObject> {
                
                if let move = dict["moves"] as? [[String:Any]] {
                    
                    var appendThisMove = [[String:Any]]()
                    
                    for (_, value) in move.enumerated() {
                        
                        if value["learn_type"] as? String == "level up" {
                            
                            var i = [String:Any]()
                            i["level"] = value["level"]
                            i["name"] = value["name"]
                            
                            appendThisMove.append(i)

                        }

                    }
                    
                    self._moves = appendThisMove.sorted(by: {$1["level"] as! Int > $0["level"] as! Int})
                    
                }
                
                if let weight = dict["weight"] as? String {
                    
                    self._weight = weight
                    
                }
                
                if let height = dict["height"] as? String {
                    
                    self._height = height
                }
                
                if let attack = dict["attack"] as? Int {
                    
                    self._attack = "\(attack)"
                    
                }
                
                if let defense = dict["defense"] as? Int {
                    
                    self._defense = "\(defense)"
                    
                    
                }
                
                
                if let types = dict["types"] as? [Dictionary<String, String>] , types.count > 0 {
                    
                    if let name = types[0]["name"] {
                        
                        self._type = name.capitalized
                    }
                    
                    if types.count > 1 {
                        
                        for x in 1..<types.count {
                            if let name = types[x]["name"] {
                                self._type! += "/\(name.capitalized)"
                            }
                        }
                    }
                    
                    print(self._type)
                    
                    
                } else {
                    
                    self._type = ""
                }
                
                if let descArr = dict["descriptions"] as? [Dictionary<String, String>], descArr.count > 0 {
                    
                    if let url = descArr[0]["resource_uri"] {
                        
                        let descURL = "\(URL_BASE)\(url)"
                        
                        Alamofire.request(descURL).responseJSON(completionHandler: { (response) in
                            
                            if let descDict = response.result.value as? Dictionary<String, AnyObject> {
                                
                                if let description = descDict["description"] as? String {
                                    
                                    let newDescription = description.replacingOccurrences(of: "POKMON", with: "Pokemon")
                                    
                                    
                                    self._description = newDescription
                                    print(newDescription)
                                    
                                }
                                
                            }
                            
                            completed()
                            
                        })
                        
                    }
                    
                } else {
                    
                    self._description = ""
                }
                
                if let evolutions = dict["evolutions"] as? [Dictionary<String, AnyObject>] , evolutions.count > 0 {
                    
                    if let nextEvo = evolutions[0]["to"] as? String {
                        
                        if nextEvo.range(of: "mega") == nil {
                            
                            self._nextEvolutionName = nextEvo
                            
                            if let uri = evolutions[0]["resource_uri"] as? String {
                                
                                let newStr = uri.replacingOccurrences(of: "/api/v1/pokemon/", with: "")
                                let nextEvoId = newStr.replacingOccurrences(of: "/", with: "")
                                
                                self._nextEvolutionId = nextEvoId
                                
                                if let lvlExist = evolutions[0]["level"] {
                                    
                                    if let lvl = lvlExist as? Int {
                                        
                                        self._nextEvolutionLevel = "\(lvl)"
                                    }
                                    
                                } else {
                                    
                                    self._nextEvolutionLevel = ""
                                }
                            }
                            
                        }
                        
                    }
                    print(self.nextEvolutionName)
                    print(self.nextEvolutionId)
                    print(self.nextEvolutionLevel)
                }

            }
            completed()
            }
        }
    
}
