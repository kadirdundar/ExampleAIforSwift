import Foundation

// MARK: - K-Means Clustering Algorithm

struct KMeans {
    // MARK: - Properties

    let k: Int
    let points: [[Double]]

    // MARK: - Initialization

    init(k: Int, points: [[Double]]) {
        self.k = k
        self.points = points
    }

    // MARK: - Main Method

    func cluster() -> [[Int]] {
        // 1. Initialize centroids randomly
        var centroids: [[Double]] = []
        for _ in 0..<k {
            let randomIndex = Int(arc4random_uniform(UInt32(points.count)))
            centroids.append(points[randomIndex])
        }

        // 2. Initialize clusters
        var clusters: [[Int]] = Array(repeating: [], count: k)

        // 3. Compute clusters
        var clusterChanged = true
        while clusterChanged {
            clusterChanged = false

            // 4. Clear clusters
            for i in 0..<k {
                clusters[i].removeAll()
            }

            // 5. Assign points to the closest centroid
            for (index, point) in points.enumerated() {
                var closestCentroidDistance = Double.greatestFiniteMagnitude
                var closestCentroidIndex = 0

                for (centroidIndex, centroid) in centroids.enumerated() {
                    let distance = euclideanDistance(point, centroid)
                    if distance < closestCentroidDistance {
                        closestCentroidDistance = distance
                        closestCentroidIndex = centroidIndex
                    }
                }

                clusters[closestCentroidIndex].append(index)
            }

            // 6. Recompute centroids
            for (centroidIndex, cluster) in clusters.enumerated() {
                let oldCentroid = centroids[centroidIndex]
                var newCentroid: [Double] = Array(repeating: 0, count: points[0].count)

                for pointIndex in cluster {
                    let point = points[pointIndex]
                    for (coordinateIndex, coordinate) in point.enumerated() {
                        newCentroid[coordinateIndex] += coordinate
                    }
                }

                for (coordinateIndex, coordinate) in newCentroid.enumerated() {
                    newCentroid[coordinateIndex] /= Double(cluster.count)
                }

                if newCentroid != oldCentroid {
                    clusterChanged = true
                    centroids[centroidIndex] = newCentroid
                }
            }
        }

        return clusters
    }

    // MARK: - Helper Methods

    private func euclideanDistance(_ a: [Double], _ b: [Double]) -> Double {
        return sqrt(zip(a, b).map { pow($0 - $1, 2) }.reduce(0, +))
    }
}
