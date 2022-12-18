var updatePromises = [];

for i in unscaleData {
  for a in i {
    let queue = DispatchQueue(label: "updateQueue")

    queue.sync(flags: .barrier){
      let longitude = a[1]
      let latitude = a[0]
      let point = [GeoPoint(latitude: latitude, longitude: longitude)]
      let geoPoint = point[0]
      
      let updatePromise = new Promise((resolve, reject) => {
        firestoreDatabase.collection("information").whereField("location", isEqualTo: geoPoint).getDocuments { [self] (snapshot, error) in
          if let error = error {
            reject(error);
          } else {
            for document in snapshot!.documents {
              print("burayagirdi")
              document.reference.updateData(["arac": aracnumarasi])
            }
            resolve();
          }
        }
      });

      updatePromises.push(updatePromise);
      aracnumarasi += 1
    }
  }
}

Promise.all(updatePromises).then(() => {
  // tüm veri güncelleme işlemleri tamamlandıktan sonra yapılacak işlemler
});
