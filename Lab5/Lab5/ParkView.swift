//
//  ParkView.swift
//  Lab5
//
//  Created by mpate125 on 3/6/25.
//


import SwiftUI
import MapKit


struct FavoriteParksApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

/// View for adding a new Park to the list.
struct AddParkView: View {
    @ObservedObject var viewModel: ParkViewModel
    @Binding var isPresented: Bool
    
    @State private var name: String = ""
    @State private var location: String = ""
    @State private var description: String = ""
    @State private var imageName: String = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Park Info")) {
                    TextField("Name", text: $name)
                    TextField("Location", text: $location)
                    TextField("Description", text: $description)
                }
                Section(header: Text("Image")) {
                    TextField("Image Name (in Assets)", text: $imageName)
                    Text("Leave empty to use a default image.")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle("Add a Park")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        guard !name.isEmpty, !location.isEmpty else { return }
                        viewModel.addPark(
                            name: name,
                            location: location,
                            description: description,
                            imageName: imageName.isEmpty ? nil : imageName
                        )
                        isPresented = false
                    }
                }
            }
        }
    }
}

/// Detail screen showing a single park’s info, map with pinned location, lat/long, and search.
struct ParkDetailView: View {
    let park: Park
    @ObservedObject var viewModel: ParkViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            // Scrollable area for park name, image, description
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text(park.name)
                        .font(.largeTitle)
                        .bold()
                    
                    Image(park.imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                    
                    Text(park.description)
                        .font(.body)
                    
                    // If we have a parkCoordinate, show lat/long
                    if let coordinate = viewModel.parkCoordinate {
                        Text("Latitude: \(coordinate.latitude)")
                        Text("Longitude: \(coordinate.longitude)")
                    } else {
                        Text("Latitude: -")
                        Text("Longitude: -")
                    }
                }
                .padding()
            }
            
            // Search field + Map
            VStack {
                // Let user search places near the displayed park location
                TextField("Search nearby (e.g. coffee, pizza)",
                          text: $viewModel.searchQuery,
                          onCommit: {
                              viewModel.performSearch()
                          })
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                
                // Combine the park’s own pin (if any) + search results
                let pins = ([viewModel.parkPlace].compactMap { $0 }) + viewModel.annotations
                
                Map(coordinateRegion: $viewModel.region, annotationItems: pins) { place in
                    // We can use a MapAnnotation to show place name
                    MapAnnotation(coordinate: place.coordinate) {
                        VStack(spacing: 2) {
                            Text(place.name)
                                .font(.caption2)
                                .padding(4)
                                .background(Color.white)
                                .cornerRadius(5)
                            Image(systemName: "mappin.circle.fill")
                                .font(.title)
                                .foregroundColor(.red)
                        }
                    }
                }
                .frame(height: 300)
                .onAppear {
                    // Geocode the park’s location & center the map
                    viewModel.geocodeAndCenter(location: park.location)
                }
            }
        }
        .navigationTitle("Park Detail")
        .navigationBarTitleDisplayMode(.inline)
    }
}

