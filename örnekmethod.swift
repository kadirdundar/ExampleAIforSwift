import Foundation
import CoreLocation

// Represents a location with latitude and longitude coordinates
struct Location {
  let latitude: Double
  let longitude: Double
}

// Computes the Euclidean distance between two locations
func euclideanDistance(from location1: Location, to location2: Location) -> Double {
  let distanceSquared = pow(location1.latitude - location2.latitude, 2) + pow(location1.longitude - location2.longitude, 2)
  return sqrt(distanceSquared)
}

// Performs k-means clustering on a set of locations
func kMeansClustering(locations: [Location], numberOfClusters: Int) -> [Int] {
  // Choose random initial cluster centers
  var clusterCenters: [Location] = []
  for _ in 0..<numberOfClusters {
    let randomIndex = Int.random(in: 0..<locations.count)
    clusterCenters.append(locations[randomIndex])
  }

  // Assign each location to the nearest cluster center
  var clusterAssignments: [Int] = []
  for location in locations {
    var nearestClusterCenterDistance = Double.greatestFiniteMagnitude
    var nearestClusterCenterIndex = 0
    for (index, clusterCenter) in clusterCenters.enumerated() {
      let distance = euclideanDistance(from: location, to: clusterCenter)
      if distance < nearestClusterCenterDistance {
        nearestClusterCenterDistance = distance
        nearestClusterCenterIndex = index
      }
    }
    clusterAssignments.append(nearestClusterCenterIndex)
  }

  // Re-compute cluster centers as the mean of all locations assigned to them
  var converged = false
  while !converged {
    var newClusterCenters: [Location] = Array(repeating: Location(latitude: 0, longitude: 0), count: numberOfClusters)
    var newClusterCenterCounts: [Int] = Array(repeating: 0, count: numberOfClusters)

    for (index, location) in locations.enumerated() {
      let clusterIndex = clusterAssignments[index]
      newClusterCenters[clusterIndex].latitude += location.latitude
      newClusterCenters[clusterIndex].longitude += location.longitude
      newClusterCenterCounts[clusterIndex] += 1
    }

    converged = true
    for clusterIndex in 0..<numberOfClusters {
      if newClusterCenterCounts[clusterIndex] > 0 {
        let previousClusterCenter = clusterCenters[clusterIndex]
        let newClusterCenter = Location(
          latitude: newClusterCenters[clusterIndex].latitude / Double(newClusterCenterCounts[clusterIndex]),
          longitude: newClusterCenters[clusterIndex].longitude / Double(newClusterCenterCounts[clusterIndex])
        )
        clusterCenters[clusterIndex] = newClusterCenter
        if euclideanDistance(from: previousClusterCenter, to: newClusterCenter


let locations = [
  Location(latitude: 37.783333, longitude: -122.416667), // San Francisco
  Location(latitude: 40.7128, longitude: -74.0060), // New York
  Location(latitude: 41.8719, longitude: -87.6278), // Chicago
  Location(latitude: 29.7604, longitude: -95.3698), // Houston
  Location(latitude: 39.2904, longitude: -76.6122), // Baltimore
  Location(latitude: 38.9072, longitude: -77.0369), // Washington, D.C.
  Location(latitude: 32.7157, longitude: -117.1611), // San Diego
  Location(latitude: 32.7767, longitude: -96.7970), // Dallas
  Location(latitude: 34.0522, longitude: -118.2437), // Los Angeles
  Location(latlitude: 25.7617, longitude: -80.1918), // Miami
  Location(latitude: 25.4358, longitude: -80.8301), // Miami Beach
  Location(latitude: 29.9511, longitude: -90.0715), // New Orleans
  Location(latitude: 41.2524, longitude: -95.9980), // Omaha
  Location(latitude: 39.0997, longitude: -94.5786), // Kansas City
  Location(latitude: 44.9778, longitude: -93.2650), // Minneapolis
]

let clusterAssignments = kMeansClustering(locations: locations, numberOfClusters: 3)
print(clusterAssignments)
