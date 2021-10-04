//
//  Service.swift
//  Collect
//
//  Created by 박진서 on 2021/09/04.
//

import Firebase
import RxSwift
import RxCocoa

class Service {
    static let shared = Service()
    private let bag = DisposeBag()
    let ref = Database.database().reference()
    let storageRef = Storage.storage().reference()
    
    var brandSubject = BehaviorSubject<[BrandModel]>(value: [])
    var bannerSubject = BehaviorSubject<[URL: String]>(value: [:])
    var bannerUrlSubject = BehaviorSubject<[URL]>(value: [])

    func fetchMainBanner() {
        var urlRefArray: [URL: String] = [:]
        var urlArray: [URL] = []
        storageRef.child("1").child("Banner").listAll { result, err in
            if let error = err {
                print(error)
            } else {
                for i in 0..<result.items.count {
                    result.items[i].downloadURL { url, err1 in
                        if let erro = err1 {
                            print(erro)
                        } else {
                            let rref = "\(result.items[i])".split(separator: "/").map{"\($0)"}.last!
                            urlRefArray[url!] = rref
                            urlArray.append(url!)
                            urlArray.sort(by: { "\($0)" < "\($1)"})
                            self.bannerSubject.onNext(urlRefArray)
                            self.bannerUrlSubject.onNext(urlArray)
                        }
                    }
                }
            }
        }
    }

    func fetchBrand() {
        var brands: [BrandModel] = []
        ref.child("1").child("Brand").queryOrdered(byChild: "name").observeSingleEvent(of: DataEventType.value) { DataSnapshot in
            var dss = DataSnapshot.children.allObjects as? [DataSnapshot]
            for i in 0..<dss!.count {
                let value = dss![i].value as! [String: Any]
                let brand = BrandModel(JSON: value)!
                var brandObservable = BehaviorSubject.just(brand)
                if i == dss!.count { dss = nil }
                //Brand Logo Image
                self.storageRef.child("1").child("Brand").child(brand.name!).child("logo.png").getData(maxSize: 1 * 2000 * 2000) { data, err in
                    if let error = err {
                        print(error)
                    } else {
                        let img = UIImage(data: data!)!
                        brand.logoImage = img
                        //Brand Wallpaper Image
                        self.storageRef.child("1").child("Brand").child(brand.name!).child("Wallpaper").listAll { result, err in
                            if let error = err {
                                 print(error)
                            } else {
                                for ref in result.items {
                                    ref.downloadURL { url, errr in
                                        if let errorr = errr {
                                            print(errorr)
                                        } else {
                                            brand.wallPaper.append(url!)
                                            self.storageRef.child("1").child("Brand").child(brand.name!)
                                                .child("des.png").getData(maxSize: 1 * 2000 * 2000) { desdata, deserr in
                                                    if let deserror = deserr {
                                                        print(deserror)
                                                        brandObservable = Observable.just(brand)
                                                    } else {
                                                        let desimg = UIImage(data: desdata!)!
                                                        brand.desImage = desimg
                                                        brandObservable = Observable.just(brand)
                                                    }
                                                }
                                        }
                                    }
                                }
                                brandObservable.subscribe(onNext: { br in
                                    brands.append(br)
                                    self.brandSubject.onNext(brands)
                                })
                                .disposed(by: self.bag)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func fetchItems(brandName: String) -> BehaviorRelay<[ItemModel]> {
        var items: [ItemModel] = []
        let itemArraySubject = BehaviorRelay<[ItemModel]>(value: [])

        ref.child("1").child("Brand").child(brandName).child("Item").observeSingleEvent(of: .value) { DataSnapshot in
            for values in DataSnapshot.children.allObjects as! [DataSnapshot] {
                let value = values.value as! [String: Any]
                let item = ItemModel(JSON: value)!

                for cValues in values.childSnapshot(forPath: "colorItems").children.allObjects as! [DataSnapshot] {
                    let cValue = cValues.value as! [String: Any]
                    let colorItem = ColorItemModel(JSON: cValue)!
                    item.colorItems.append(colorItem)
                    item.colorCodes.append(colorItem.colorCode!)
                }
                self.storageRef.child("1").child("Brand").child(brandName).child("Item").child(item.name!).child("main.jpg").downloadURL { url, _ in
                    item.mainImage = url
                    items.insert(item, at: 0)
                    itemArraySubject.accept(items)
                }
            }
        }
        return itemArraySubject
    }
    
    
    func fetchColorItemImages(colorItemModel: ColorItemModel) -> BehaviorSubject<[URL]> {
        var urls: [URL] = []
        let urlArraySubject = BehaviorSubject<[URL]>(value: [])
        storageRef.child("1").child("Brand").child(colorItemModel.brand!).child("Item").child(colorItemModel.itemName!).child(colorItemModel.fileName!).listAll { result, _ in
            for ref in result.items {
                ref.downloadURL { url, _ in
                    urls.append(url!)
                    colorItemModel.images.append(url!)
                    urlArraySubject.onNext(urls)
                }
            }
        }
        return urlArraySubject
    }
}
