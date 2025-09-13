//
//  PokemonDetailView.swift
//  Pokeproyecto
//
//  Created by Iris Jasso on 20/04/25.
//

import SwiftUI

struct PokemonDetailView: View {
    var entry: PokemonEntry
    @State private var pokemon: PokemonSelected?

    var attackStat: Int? {
        pokemon?.stats.first(where: { $0.stat.name == "attack" })?.base_stat
    }

    var defenseStat: Int? {
        pokemon?.stats.first(where: { $0.stat.name == "defense" })?.base_stat
    }

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue.opacity(0.2), .white]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                if let pokemon = pokemon {
                    VStack(spacing: 16) {
                        if let sprite = pokemon.sprites.front_default {
                            AsyncImage(url: URL(string: sprite)) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 160, height: 160)
                                    .background(Color.white)
                                    .clipShape(Circle())
                                    .shadow(radius: 10)
                            } placeholder: {
                                ProgressView()
                            }
                        }

                        Text(entry.name.capitalized)
                            .font(.system(size: 32, weight: .heavy, design: .rounded))
                            .foregroundColor(.black)

                        HStack {
                            Label("\(pokemon.height)", systemImage: "arrow.up.and.down")
                            Spacer()
                            Label("\(pokemon.weight)", systemImage: "scalemass")
                        }
                        .font(.subheadline)
                        .padding()
                        .background(Color.white.opacity(0.6))
                        .cornerRadius(10)

                        GroupBox(label: Label("Tipos", systemImage: "flame.fill")) {
                            HStack {
                                ForEach(pokemon.types, id: \.type.name) { type in
                                    Text(type.type.name.capitalized)
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 6)
                                        .background(Color.gray.opacity(0.3))
                                        .cornerRadius(10)
                                }
                            }
                        }

                        GroupBox(label: Label("Habilidades", systemImage: "bolt.fill")) {
                            VStack(alignment: .leading) {
                                ForEach(pokemon.abilities, id: \.ability.name) { ability in
                                    Text("• \(ability.ability.name.capitalized)")
                                        .padding(.vertical, 2)
                                }
                            }
                        }

                        // Sección de estadísticas
                        GroupBox(label: Label("Estadísticas", systemImage: "chart.bar.fill")) {
                            VStack(alignment: .leading) {
                                if let attack = attackStat {
                                    Text("• Ataque: \(attack)")
                                        .padding(.vertical, 2)
                                }
                                if let defense = defenseStat {
                                    Text("• Defensa: \(defense)")
                                        .padding(.vertical, 2)
                                }
                            }
                        }
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 20).fill(Color.white.opacity(0.9)))
                    .shadow(radius: 5)
                } else {
                    ProgressView("Cargando información...")
                        .font(.headline)
                        .padding()
                }

                Spacer()
            }
            .padding()
        }
        .navigationTitle(entry.name.capitalized)
        .navigationBarHidden(true) // Ocultar la barra de navegación
        .onAppear {
            PokemonSelectedApi().getDetail(url: entry.url) { data in
                self.pokemon = data
            }
        }
    }
}

