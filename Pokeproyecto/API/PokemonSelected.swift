//
//  PokemonSelected.swift
//  Pokeproyecto
//
//  Created by Iris Jasso on 20/04/25.
//

import Foundation

struct PokemonSelected: Codable {
    var sprites: PokemonSprites
    var weight: Int
    var height: Int
    var abilities: [Ability]
    var types: [PokemonType]
    var stats: [PokemonStat]

    struct Ability: Codable {
        struct AbilityDetail: Codable {
            var name: String
        }
        var ability: AbilityDetail
    }

    struct PokemonType: Codable {
        struct TypeDetail: Codable {
            var name: String
        }
        var type: TypeDetail
    }

    struct PokemonStat: Codable {
        struct StatDetail: Codable {
            var name: String
        }
        var stat: StatDetail
        var base_stat: Int
    }
}

struct PokemonSprites: Codable {
    var front_default: String?
}

class PokemonSelectedApi {
    func getDetail(url: String, completion:@escaping (PokemonSelected) -> ()) {
        guard let url = URL(string: url) else { return }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }

            let decoder = JSONDecoder()
            if let pokemonDetail = try? decoder.decode(PokemonSelected.self, from: data) {
                DispatchQueue.main.async {
                    completion(pokemonDetail)
                }
            }
        }.resume()
    }
    
    func getSprite(url: String, completion:@escaping (PokemonSprites) -> ()) {
        guard let url = URL(string: url) else { return }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }

            if let pokemonSprite = try? JSONDecoder().decode(PokemonSelected.self, from: data) {
                DispatchQueue.main.async {
                    completion(pokemonSprite.sprites)
                }
            }
        }.resume()
    }
}
