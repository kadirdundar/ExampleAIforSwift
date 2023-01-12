    let coordinates = [CLLocationCoordinate2D(latitude: 42.23832, longitude: 28.373792),
                       CLLocationCoordinate2D(latitude: 42.23832, longitude: 29.373792),
                       CLLocationCoordinate2D(latitude: 43.23832, longitude: 29.373792)]
    let request = MKDirections.Request()
    request.source = MKMapItem(placemark: MKPlacemark(coordinate: coordinates[0], addressDictionary: nil))
    request.destination = MKMapItem(placemark: MKPlacemark(coordinate: coordinates[coordinates.count-1], addressDictionary: nil))
    request.transportType = .automobile
    request.requestsAlternateRoutes = true
    request.destination = MKMapItem(placemark: MKPlacemark(coordinate: coordinates[coordinates.count-1], addressDictionary: nil))
    request.waypoints = coordinates.map {MKMapItem(placemark: MKPlacemark(coordinate: $0, addressDictionary: nil))}
    let directions = MKDirections(request: request)
    directions.calculate { (response, error) in
        guard let response = response else { return }
        for route in response.
