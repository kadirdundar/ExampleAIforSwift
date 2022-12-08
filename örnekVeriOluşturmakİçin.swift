let coordinates: [[Double]] = (0..<40).map { _ in
    let latitude = Double.random(in: 41.0...42.0)
    let longitude = Double.random(in: 29.0...30.0)
    return [latitude, longitude]
}
