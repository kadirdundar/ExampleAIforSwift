import Foundation

// Function that performs k-means clustering
func kMeans(data: [[Double]], k: Int) -> ([[Double]], [Int]) {

    // Randomly initialize cluster centers
    var clusterCenters = [[Double]]()
    for _ in 0..<k {
        let randomIndex = Int.random(in: 0..<data.count)
        clusterCenters.append(data[randomIndex])
    }

    // Cluster assignments for each data point
    var clusters = [Int](repeating: 0, count: data.count)

    // Distance between data points and cluster centers
    func distance(point: [Double], center: [Double]) -> Double {
        return sqrt(pow(point[0] - center[0], 2) + pow(point[1] - center[1], 2))
    }

    // Repeat until convergence
    while true {

        // Assign data points to clusters
        var clusterSizes = [Int](repeating: 0, count: k)
        for i in 0..<data.count {
            let point = data[i]
            var minDistance = Double.infinity
            var minIndex = 0
            for j in 0..<k {
                let center = clusterCenters[j]
                let d = distance(point: point, center: center)
                if d < minDistance {
                    minDistance = d
                    minIndex = j
                }
            }
            clusters[i] = minIndex
            clusterSizes[minIndex] += 1
        }

        // Recompute cluster centers
        var newClusterCenters = [[Double]](repeating: [Double](repeating: 0, count: data[0].count), count: k)
        for i in 0..<data.count {
            let point = data[i]
            let clusterIndex = clusters[i]
            for j in 0..<point.count {
                newClusterCenters[clusterIndex][j] += point[j]
            }
        }
        for i in 0..<k {
            for j in 0..<newClusterCenters[0].count {
                newClusterCenters[i][j] /= Double(clusterSizes[i])
            }
        }

        // Check for convergence
        var converged = true
        for i in 0..<k {
            if newClusterCenters[i] != clusterCenters[i] {
                converged = false
                break
            }
        }
        if converged {
            break
        }
        clusterCenters = newClusterCenters
    }

    // Return the results
    return (clusterCenters, clusters)
}

// Example usage
let data = [[1.0, 2.0], [1.5, 2.5], [3.0, 4.0], [5.0, 7.0], [3.5, 5.0], [4.5, 5.0], [3.5, 4.5]]
let (clusterCenters, clusters) = kMeans(data: data, k: 2)

print("Cluster Centers:")
