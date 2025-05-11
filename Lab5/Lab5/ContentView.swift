//
//  ContentView.swift
//  Lab5
//
//  Created by mpate125 on 3/6/25.
//


import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ParkViewModel()
    @State private var showAddParkView = false
    
    var body: some View {
        NavigationStack {
            // Group parks by first letter of their name
            let groupedParks = Dictionary(grouping: viewModel.parks, by: { $0.name.prefix(1) })
                .sorted { $0.key < $1.key }
            
            List {
                ForEach(groupedParks, id: \.0) { (letter, parksInSection) in
                    Section(header: Text(String(letter))) {
                        ForEach(parksInSection) { park in
                            NavigationLink(destination: ParkDetailView(park: park, viewModel: viewModel)) {
                                // Row: image + name & location
                                HStack {
                                    Image(park.imageName)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 50, height: 50)
                                        .clipShape(RoundedRectangle(cornerRadius: 5))
                                        .padding(.trailing, 8)
                                    
                                    VStack(alignment: .leading) {
                                        Text(park.name)
                                            .font(.headline)
                                        Text(park.location)
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }
                                }
                            }
                        }
                        .onDelete { indexSet in
                            // Delete from the main array
                            for index in indexSet {
                                if let actualIndex = viewModel.parks.firstIndex(of: parksInSection[index]) {
                                    viewModel.parks.remove(at: actualIndex)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Favorite Parks")
            .toolbar {
                Button {
                    showAddParkView.toggle()
                } label: {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $showAddParkView) {
                AddParkView(viewModel: viewModel, isPresented: $showAddParkView)
            }
        }
    }
}



