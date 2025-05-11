//
//  ParkViewModel.swift
//  Lab5
//
//  Created by mpate125 on 3/6/25.
//



import SwiftUI
import MapKit
import CoreLocation

class ParkViewModel: ObservableObject {
    
    @Published var parks: [Park] = []
    
    
    struct Place: Identifiable {
        let id = UUID()
        let name: String
        let coordinate: CLLocationCoordinate2D
    }
    

    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )
    
  
    @Published var parkCoordinate: CLLocationCoordinate2D? = nil
    
    /// A pin for the park’s location (used to differentiate from search pins).
    @Published var parkPlace: Place? = nil
    
    /// The user’s search query (e.g. “coffee”, “pizza”).
    @Published var searchQuery: String = ""
    
    /// The search results pinned on the map.
    @Published var annotations: [Place] = []
    
    private let geocoder = CLGeocoder()
    
  
    init() {
        // Preload five parks
        parks = [
            Park(name: "Grand Canyon",
                 location: "Arizona, USA",
                 description: "A steep-sided canyon carved by the Colorado River in Arizona.",
                 imageName: "grand_canyon"),
            Park(name: "Yellowstone",
                 location: "Wyoming, USA",
                 description: "First national park in the U.S., known for its wildlife and geothermal features.",
                 imageName: "yellowstone"),
            Park(name: "Banff",
                 location: "Banff, Canada",
                 description: "Famous for turquoise lakes, mountains, and scenic beauty.",
                 imageName: "banff"),
            Park(name: "Yosemite",
                 location: "California, USA",
                 description: "Known for its waterfalls, deep valleys, grand meadows, and giant sequoias.",
                 imageName: "yosemite"),
            Park(name: "Serengeti",
                 location: "Tanzania",
                 description: "Renowned for its annual migration of over 1.5 million wildebeest.",
                 imageName: "serengeti")
        ]
    }
    
  
    func addPark(name: String, location: String, description: String, imageName: String?) {
        let newPark = Park(
            name: name,
            location: location,
            description: description,
            imageName: imageName ?? "default_park" // fallback
        )
        parks.append(newPark)
        sortParks()
    }
    
    func deletePark(at offsets: IndexSet) {
        parks.remove(atOffsets: offsets)
    }
    
    private func sortParks() {
        parks.sort { $0.name < $1.name }
    }
    
    
    
    /// Geocodes the park's textual location and updates `region`, `parkCoordinate`, and `parkPlace`.
    func geocodeAndCenter(location: String) {
        geocoder.geocodeAddressString(location) { [weak self] placemarks, error in
            guard let self = self,
                  let placemark = placemarks?.first,
                  let coord = placemark.location?.coordinate,
                  error == nil else {
                print("Geocoding failed for \(location): \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            DispatchQueue.main.async {
                self.parkCoordinate = coord
                self.region = MKCoordinateRegion(
                    center: coord,
                    span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                )
                self.parkPlace = Place(name: "Park: \(location)", coordinate: coord)
            }
        }
    }
    
    /// Searches near the current `region` for `searchQuery` (e.g. “coffee”, “pizza”).
    func performSearch() {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchQuery
        request.region = region
        
        let search = MKLocalSearch(request: request)
        search.start { [weak self] response, error in
            guard let self = self, let response = response, error == nil else {
                print("Search error:", error?.localizedDescription ?? "Unknown error")
                return
            }
            DispatchQueue.main.async {
                // Convert each MKMapItem to an Identifiable Place
                self.annotations = response.mapItems.compactMap { item in
                    guard let coord = item.placemark.location?.coordinate else {
                        return nil
                    }
                    return Place(name: item.name ?? "Unknown", coordinate: coord)
                }
            }
        }
    }
}


