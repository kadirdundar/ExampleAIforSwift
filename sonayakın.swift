import Foundation
struct KMeansClusterer{
    let data: [[Double]]
    let k: Int
    
    init(data: [[Double]], k: Int) {
        self.data = data
        self.k = k
    }
    func cluster() -> [[[Double]]] {
        // Öncelikle verileri kümelerine ayrılacak şekilde rasgele dağıtıyoruz.
        var clusters = [[[Double]]](repeating: [], count: k)
        for datapoint in data {
            let clusterIndex = Int.random(in: 0..<k)
            clusters[clusterIndex].append(datapoint)
        }
        
        // K-means yöntemini uygulayarak kümeleri güncelliyoruz.
        // Bu işlem, küme merkezlerinin belirlenmesi ve verilerin kümelere
        // göre dağıtılmasını içerir.
        while true {
            let clusterCentroids = computeClusterCentroids(clusters: clusters)
            let updatedClusters = assignDataToClusters(clusters: clusters, centroids: clusterCentroids)
            
            // Eğer küme merkezleri ve verilerin dağılımı değişmemişse,
            // döngüyü sonlandırıyoruz.
            var hasChanged = false
            for i in 0..<k {
                if clusters[i].count != updatedClusters[i].count {
                    hasChanged = true
                    break
                }
            }
            if !hasChanged {
                break
            }
            clusters = updatedClusters
        }
        
        // Küme merkezlerini döndürmüyor, sadece verileri döndürüyoruz.
        return clusters.map { cluster in
            return cluster.map { datapoint in
                return datapoint
            }
        }
    }
    
    
    // Bu fonksiyon, verilen kümelerin merkezlerini hesaplar.
    func computeClusterCentroids(clusters: [[[Double]]]) -> [[Double]] {
        var clusterCentroids = [[Double]](repeating: [Double](repeating: 0.0, count: data[0].count), count: k)
        
        for i in 0..<k {
            for j in 0..<data[0].count {
                for datapoint in clusters[i] {
                    clusterCentroids[i][j] += datapoint[j]
                }
                clusterCentroids[i][j] /= Double(clusters[i].count)
            }
        }
        
        return clusterCentroids
    }
    // Bu fonksiyon, verileri verilen küme merkezlerine göre kümelere atar.
    func assignDataToClusters(clusters: [[[Double]]], centroids: [[Double]]) -> [[[Double]]] {
        var updatedClusters = [[[Double]]](repeating: [], count: k)
        
        for datapoint in data {
            var closestCentroidDistance = Double.greatestFiniteMagnitude
            var closestCentroidIndex = 0
            
            // Verinin en yakın küme merkezini buluyoruz.
            for i in 0..<k {
                let distance = computeDistance(datapoint: datapoint, centroid: centroids[i])
                if distance < closestCentroidDistance {
                    closestCentroidDistance = distance
                    closestCentroidIndex = i
                }
            }
            
            // Bulunan küme merkezine göre veriyi kümelere atıyoruz.
            updatedClusters[closestCentroidIndex].append(datapoint)
        }
        
        return updatedClusters
    }
    
    // Bu fonksiyon, verilen verinin verilen küme merkezine olan uzaklığını hesaplar.
    func computeDistance(datapoint: [Double], centroid: [Double]) -> Double {
        var distance = 0.0
        for i in 0..<datapoint.count {
            distance += (datapoint[i] - centroid[i]) * (datapoint[i] - centroid[i])
        } 
        return sqrt(distance)
        
    }
}

let data = [[41.282828, 28.123456], [41.126273, 28.198263], [41.982435, 28.624382], [41.820935, 28.152637], [41.824126, 28.016238],[41.826347, 28.003366], [41.097635, 28.268374], [41.023471, 28.226633], [41.926345, 28.115533], [41.007744, 28.004466],[41.268739, 28.981234], [41.762255, 28.114422], [41.553366, 28.274162], [41.125732, 28.526374], [41.234567, 28.982356],[41.223344, 28.927453], [41.102536,28.523461], [41.263721, 28.228899], [41.624315, 28.002536], [41.625311    , 28.553265],[41.821122, 28.882244], [41.679843,28.893456], [41.762345, 28.896231], [41.786239, 28.984536], [41.80999092352841, 29.415607306007665], [41.691182494993186, 29.507006761668112], [41.07499646306389, 29.45208480030572], [41.90100075732553, 29.783146834418048], [41.461899836802246, 29.879553509529856], [41.351350847972874, 29.928210239796417], [41.2313412395818, 29.565628875913838], [41.41171778080102, 29.742002519987725], [41.90555225805434, 29.75463215209311], [41.614239138546935, 29.985537227604148], [41.28855589774612, 29.394325063726576], [41.345293689549514, 29.6510639247847], [41.8258717633791, 29.035723786445892], [41.82326363844907, 29.278604413530505], [41.63054555598767, 29.797009368744472], [41.97086604286042, 29.941277201239103], [41.279211613387, 29.96998871605408], [41.20183702618026, 29.72228510890703], [41.39593801270771, 29.84051313047972], [41.43402957102391, 29.379011291314065], [41.95307155508905, 29.841140411425172], [41.13188836542125, 29.255460581713432], [41.776512541010234, 29.65148867504209], [41.69398482398305, 29.9168550094679], [41.31808530481868, 29.816188633744996], [41.607048987768955, 29.790638716713396], [41.33665095198067, 29.40980229128604], [41.32484611407321, 29.672469713941943], [41.608445639770856, 29.053607078463923], [41.556043695884945, 29.857388999216983], [41.517982827732006, 29.242213215138275], [41.95049252852086, 29.839586262401646], [41.0721447671115, 29.03345387800554], [41.64129037651164, 29.330647229725283], [41.7321732756088, 29.41735194337164], [41.45286613758864, 29.949633227301078], [41.16193019743424, 29.950554244659333], [41.97704582041045, 29.091115515852877], [41.23410286993398, 29.56812072897588], [41.88849989141835, 29.25895839371247]]
let k = 4

let clusterer = KMeansClusterer(data: data, k: k)
let clusters = clusterer.cluster()

// Kümelere ayrılmış verileri ekrana yazdırıyoruz.

print("-----------")
print(clusters[0])
print("-----------")
print(clusters[1])
print("-----------")
print(clusters[2])
print("-----------")
print(clusters[3])
