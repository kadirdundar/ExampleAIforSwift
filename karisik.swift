 let firestoreDatabase = Firestore.firestore()
                
        let queue = DispatchQueue(label: "updateQueue")
        var aracnumarasi = 1
        // Semaphore değişkeni oluşturulur
        let semaphore = DispatchSemaphore(value: 0)

        for i in unscaleData {
            queue.async {
                aracnumarasi += 1
                for a in i {
                    let longitude = a[1]
                    let latitude = a[0]
                    let point = [GeoPoint(latitude: latitude, longitude: longitude)]
                    let geoPoint = point[0]
                    print(geoPoint)
                    
                    firestoreDatabase.collection("information").whereField("location", isEqualTo: geoPoint).getDocuments { [self] (snapshot, error) in
                        if let error = error {
                            return
                        } else {
                            for document in snapshot!.documents {
                                
                                document.reference.updateData(["arac": aracnumarasi])
                                print("burayagirdi")
                            }
                            semaphore.signal()
                        }
                        // Veri güncelleme işlemi tamamlandıktan sonra semaphore değişkeninin sayacı bir artırılır
                        
                    }
                    // Semaphore değişkeni veri güncelleme işlemi tamamlandıktan önce çağrılıyor
                    semaphore.wait()
                }
                
            }
        }
        
        // Tüm veri güncelleme işlemleri tamamlandıktan sonra bir sonraki adımın çalıştırılması gerekir
        print("Veri güncelleme işlemleri tamamlandı.")
        
        
