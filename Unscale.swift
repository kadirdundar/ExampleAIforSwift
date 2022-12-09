    var unscaledClusters = [[[Double]]]()
    for cluster in clusters {
        var unscaledCluster = [[Double]]()
        for datapoint in cluster {
            var unscaledDatapoint = [Double]()
            for i in 0..<datapoint.count {
                let scaledValue = datapoint[i]
                let min = mins[i]
                let max = maxes[i]
                let unscaledValue = min + scaledValue * (max - min)
                unscaledDatapoint.append(unscaledValue)
            }
            unscaledCluster.append(unscaledDatapoint)
        }
        unscaledClusters.append(unscaledCluster)
    }
    
    return unscaledClusters
}
