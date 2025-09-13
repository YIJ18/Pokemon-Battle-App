//
//  ContentView.swift
//  Pokeproyecto
//
//  Created by Iris Jasso on 20/04/25.
//

import SwiftUI

struct ContentView: View {
    
    @State var pokemon = [PokemonEntry]()
    @State var searchText = ""
    
    var body: some View {
        NavigationView {
            List {
                ForEach(searchText == "" ? pokemon : pokemon.filter({ $0.name.contains(searchText.lowercased()) })) { entry in
                    
                    HStack {
                        PokemonImage(imageLink: "\(entry.url)")
                            .padding(.trailing, 20)
                        
                        NavigationLink(destination: PokemonDetailView(entry: entry)) {
                            Text(entry.name.capitalized)
                        }
                    }
                }
            }
            .onAppear {
                PokeApi().getData() { pokemon in
                    self.pokemon = pokemon
                }
            }
            .searchable(text: $searchText)
            .navigationTitle("Pokemones")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
