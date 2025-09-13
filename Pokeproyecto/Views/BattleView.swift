//
//  Pokemon.swift
//  Pokeproyecto
//
//  Created by Iris Jasso on 20/04/25.
//

import SwiftUI

struct BattleView: View {
    @State private var allPokemon = [PokemonEntry]()  // Todos los Pokémon disponibles
    @State private var searchText = ""  // Búsqueda de Pokémon
    @State private var selectedPokemon: [PokemonEntry] = []  // Pokémon seleccionados para la batalla
    @State private var enemyPokemon: [PokemonEntry] = []  // Pokémon enemigos aleatorios
    
    var body: some View {
        NavigationView {
            VStack {
                // Sección de Pokémon seleccionados
                selectedSection
                
                Divider()
                
                // Sección de lista de Pokémon disponibles
                pokemonListSection

                // Botón para comenzar la batalla si se han seleccionado 3 Pokémon
                battleButton
            }
            .navigationTitle("⚔️ Elige tus Pokémon")
            .searchable(text: $searchText)
            .onAppear {
                // Cargar los Pokémon desde la API
                PokeApi().getData { pokemon in
                    self.allPokemon = pokemon
                    // Obtener detalles adicionales de cada Pokémon (attack, defense, health, speed)
                    for i in 0..<self.allPokemon.count {
                        self.allPokemon[i].fetchDetails { updatedPokemon in
                            if let index = self.allPokemon.firstIndex(where: { $0.id == updatedPokemon.id }) {
                                self.allPokemon[index] = updatedPokemon
                            }
                        }
                    }
                }
            }
        }
    }

    // Sección que muestra los Pokémon seleccionados
    var selectedSection: some View {
        Group {
            if selectedPokemon.isEmpty {
                Text("Selecciona hasta 3 Pokémon para tu equipo")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                VStack(alignment: .leading) {
                    Text("🔥 Tu equipo:")
                        .font(.headline)
                        .padding(.leading)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            ForEach(selectedPokemon) { poke in
                                pokemonCard(pokemon: poke)
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.bottom)
                }
            }
        }
    }

    // Tarjeta que muestra cada Pokémon seleccionado en el equipo
    func pokemonCard(pokemon: PokemonEntry) -> some View {
        VStack {
            // Mostrar imagen del Pokémon
            PokemonImage(imageLink: pokemon.url)
                .frame(width: 60, height: 60) // Ajustar el tamaño de la imagen
            
            // Nombre del Pokémon
            Text(pokemon.name.capitalized)
                .font(.caption)
            
            // Datos de ataque, defensa, salud y velocidad
            HStack {
                Text("Ataque: \(pokemon.attack ?? 0)")
                    .font(.caption)
                    .foregroundColor(.blue)
                Text("Defensa: \(pokemon.defense ?? 0)")
                    .font(.caption)
                    .foregroundColor(.red)
            }
            .padding(.top, 5)
            
            HStack {
                Text("Salud (HP): \(pokemon.health ?? 0)")   // Mostrar salud
                    .font(.caption)
                    .foregroundColor(.green)
                Text("Velocidad: \(pokemon.speed ?? 0)")     // Mostrar velocidad
                    .font(.caption)
                    .foregroundColor(.purple)
            }
            .padding(.top, 5)
            
            // Botón para eliminar del equipo
            Button {
                selectedPokemon.removeAll { $0.id == pokemon.id } // Eliminar Pokémon
            } label: {
                Image(systemName: "trash")
                    .foregroundColor(.red)
            }
        }
        .padding(8)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }

    // Sección que muestra la lista de Pokémon para seleccionar
    var pokemonListSection: some View {
        List {
            ForEach(filteredPokemon) { entry in
                pokemonRow(entry: entry)
            }
        }
        .listStyle(.plain)
    }

    // Fila que muestra cada Pokémon en la lista
    func pokemonRow(entry: PokemonEntry) -> some View {
        HStack {
            // Mostrar imagen del Pokémon
            PokemonImage(imageLink: entry.url)
                .frame(width: 50, height: 50) // Tamaño ajustado para que no se cruce

            // Nombre del Pokémon
            Text(entry.name.capitalized)
                .font(.body) // Ajustar tamaño del texto
                .padding(.leading, 10) // Espacio adicional entre imagen y texto

            Spacer()

            // Si el Pokémon ya está seleccionado, mostrar checkmark
            if selectedPokemon.contains(where: { $0.id == entry.id }) {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
            } else if selectedPokemon.count < 3 { // Si no hay 3 Pokémon seleccionados
                Button {
                    if selectedPokemon.count < 3 {
                        selectedPokemon.append(entry)  // Agregar al equipo
                    }
                } label: {
                    Image(systemName: "plus.circle")
                        .foregroundColor(.blue)
                }
            } else {
                // Si ya hay 3 Pokémon, mostrar ícono prohibido
                Image(systemName: "x.circle")
                    .foregroundColor(.gray)
            }
        }
        .padding(.vertical, 8) // Agregar espacio vertical
        .padding(.horizontal) // Espacio horizontal para separar la lista de los bordes
        .background(Color(.systemGray6)) // Fondo suave para cada fila
        .cornerRadius(10) // Esquinas redondeadas
    }

    // Filtrar Pokémon según la búsqueda
    var filteredPokemon: [PokemonEntry] {
        if searchText.isEmpty {
            return allPokemon
        } else {
            return allPokemon.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    // Botón de batalla (solo visible si se han seleccionado 3 Pokémon)
    var battleButton: some View {
        Group {
            if selectedPokemon.count == 3 {
                NavigationLink(destination: BattleArenaView(selectedPokemon: selectedPokemon, enemyPokemon: generateRandomEnemies())) {
                    Text("¡Luchar!")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(12)
                        .padding(.bottom)
                }
            } else {
                Text("Selecciona 3 Pokémon para empezar a luchar")
                    .foregroundColor(.gray)
                    .padding(.bottom)
            }
        }
    }

    // Función que genera 3 enemigos aleatorios de la lista completa
    func generateRandomEnemies() -> [PokemonEntry] {
        let shuffledPokemon = allPokemon.shuffled()  // Barajamos la lista de Pokémon
        return Array(shuffledPokemon.prefix(3))  // Seleccionamos los primeros 3 Pokémon aleatorios
    }
}

#Preview {
    BattleView()
}
