import Foundation

struct Pokemon: Codable {
    var results: [PokemonEntry]
}

struct PokemonEntry: Codable, Identifiable {
    let id = UUID()
    var name: String
    var url: String
    
    // Atributos adicionales
    var attack: Int?
    var defense: Int?
    var health: Int?
    var speed: Int? 
    
    enum CodingKeys: String, CodingKey {
        case name, url
    }
    
    func fetchDetails(completion: @escaping (PokemonEntry) -> ()) {
        guard let detailsUrl = URL(string: self.url) else { return }
        
        URLSession.shared.dataTask(with: detailsUrl) { (data, response, error) in
            guard let data = data else { return }
            
            do {
                let pokemonDetails = try JSONDecoder().decode(PokemonDetails.self, from: data)
                
                var updatedPokemon = self
                updatedPokemon.attack = pokemonDetails.stats.first(where: { $0.stat.name == "attack" })?.base_stat
                updatedPokemon.defense = pokemonDetails.stats.first(where: { $0.stat.name == "defense" })?.base_stat
                updatedPokemon.health = pokemonDetails.stats.first(where: { $0.stat.name == "hp" })?.base_stat  // HP
                updatedPokemon.speed = pokemonDetails.stats.first(where: { $0.stat.name == "speed" })?.base_stat  // Speed
                
                DispatchQueue.main.async {
                    completion(updatedPokemon)
                }
            } catch {
                print("Error al decodificar los detalles del Pokémon: \(error)")
            }
        }.resume()
    }
}

struct PokemonDetails: Codable {
    struct Stat: Codable {
        var stat: StatInfo
        var base_stat: Int
    }
    
    struct StatInfo: Codable {
        var name: String
    }
    
    var stats: [Stat]
}

class PokeApi {
    func getData(completion: @escaping ([PokemonEntry]) -> ()) {
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=1025") else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            
            do {
                let pokemonList = try JSONDecoder().decode(Pokemon.self, from: data)
                DispatchQueue.main.async {
                    completion(pokemonList.results)
                }
            } catch {
                print("Error al decodificar los datos: \(error)")
            }
        }.resume()
    }
}

