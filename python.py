from random import randint
from typing import List

class KMeansClusterer:
    def __init__(self, data: List[List[float]], k: int, max_element_count: int):
        self.data = data
        self.k = k
        self.max_element_count = max_element_count

    def cluster(self) -> List[List[List[float]]]:
        # Öncelikle verileri kümelerine ayrılacak şekilde rasgele dağıtıyoruz.
        clusters = [[] for _ in range(self.k)]
        for datapoint in self.data:
            cluster_index = randint(0, self.k - 1)
            clusters[cluster_index].append(datapoint)

        # K-means yöntemini uygulayarak kümeleri güncelliyoruz.
        # Bu işlem, küme merkezlerinin belirlenmesi ve verilerin kümelere
        # göre dağıtılmasını içerir.
        while True:
            cluster_centroids = self.compute_cluster_centroids(clusters)
            updated_clusters = self.assign_data_to_clusters(clusters, cluster_centroids)

            # Eğer küme merkezleri ve verilerin dağılımı değişmemişse,
            # döngüyü sonlandırıyoruz.
            has_changed = False
            for i in range(self.k):
                if len(clusters[i]) != len(updated_clusters[i]):
                    has_changed = True
                    break
            if not has_changed:
                break
            clusters = updated_clusters

        # Küme merkezlerini döndürmüyor, sadece verileri döndürüyoruz.
        return [cluster for cluster in map(lambda x: x, clusters)]

    def compute_cluster_centroids(self, clusters: List[List[List[float]]]) -> List[List[float]]:
        cluster_centroids = [[0.0 for _ in range(len(self.data[0]))] for _ in range(self.k)]

        for i in range(self.k):
            for j in range(len(self.data[0])):
                for datapoint in clusters[i]:
                    cluster_centroids[i][j] += datapoint[j]
                cluster_centroids[i][j] /= len(clusters[i])

        return cluster_centroids

    def assign_data_to_clusters(self, clusters: List[List[List[float]]], centroids: List[List[float]]) -> List[List[List[float]]]:
        updated_clusters = [[] for _ in range(self.k)]

        for datapoint in self.data:
            closest_centroid_distance = float("inf")
            closest_centroid_index = 0

            # Find the closest cluster centroid for the current data point.
            for i in range(self.k):
                distance = self.compute_distance(datapoint, centroids[i])
                if distance < closest_centroid_distance:
                    closest_centroid_distance = distance
                    closest_centroid_index = i

            # If the closest cluster already has the maximum number of elements, search for the next closest cluster
            # that has fewer elements and assign the data point to that cluster instead.
            if len(updated_clusters[closest_centroid_index]) >= self.max_element_count:
                next_closest_centroid_index = -1
                next_closest_centroid_distance = float("inf")
                for i in range(self.k):
                    if i == closest_centroid_index:
                        continue
                    distance = self.compute_distance(datapoint, centroids[i])
                    if distance < next_closest_centroid_distance and len(updated_clusters[i]) < self.max_element_count:
                        next_closest_centroid_index = i
                        next_closest_centroid_distance = distance

                if next_closest_centroid_index != -1:
                    updated_clusters[next_closest_centroid_index].append(datapoint)
            else:
                updated_clusters[closest_centroid_index].append(datapoint)

        return updated_clusters

    def compute_distance(self, datapoint: List[float], centroid: List[float]) -> float:
        return sum([(datapoint[i] - centroid[i]) ** 2 for i in range(len(datapoint))]) ** 0.5
