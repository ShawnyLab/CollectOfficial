import UIKit
import ObjectMapper
import RxSwift
import RxCocoa
import NSObject_Rx

//class MainBannerModel: Mappable {
//    
//}

class BrandModel: Mappable {
    var name: String?
    var des: URL?
    var wallPaper: [URL] = []   //로고 홈 대문사진
    var logoImage: UIImage = UIImage()
    var items: [String] = []
    var wallColor: String?
    var realItemModels: [ItemModel] = []
    var desImage: UIImage = UIImage()
    var blackOrWhite: String?
    
    init(name: String, wallColor: String) {
        self.name = name
        self.wallColor = wallColor
    }
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        name <- map["name"]
        wallColor <- map["wallColor"]
        blackOrWhite <- map["blackOrWhite"]
    }
}

class ItemModel: Mappable {
    
    var name: String?
    var nameKor: String?
    var des: String?
    var cost: Int?
    var brand: String?
    var date: Int64?
    //
    var madeIn: String?
    var size: String?
    var material: String?
    var shape: String?
    var itemCode: String?
    //
    var mainImage: URL?
    var mainRealImg: UIImage?
    var colorCodes: [String] = []
    var colorItems: [ColorItemModel] = []
    var events: [String] = []
    var isExclusive: Bool = true
        
    init(name: String, nameKor: String, des: String, material: String, shape: String, size: String, brand: String, cost: Int, madeIn: String, date: Int64, itemCode: String) {
        self.name = name
        self.des = des
        self.cost = cost
        self.material = material
        self.shape = shape
        self.size = size
        self.brand = brand
        self.nameKor = nameKor
        self.madeIn = madeIn
        self.date = date
        self.itemCode = itemCode
    }
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        name <- map["name"]
        nameKor <- map["nameKor"]
        des <- map["des"]
        cost <- map["cost"]
        material <- map["material"]
        shape <- map["shape"]
        size <- map["size"]
        brand <- map["brand"]
        cost <- map["cost"]
        isExclusive <- map["isExclusive"]
        madeIn <- map["madeIn"]
        date <- map["date"]
    }
    
}

class ColorItemModel: Mappable {
    var fileName: String?
    var itemName: String?
    var brand: String?
    var colorCode: String?
    var isEmpty: Bool = false
    var colorNameKor: String?
    var images: [URL] = []
    var realImages: [UIImage] = []
    var code: String?
    
    required init?(map: Map) {}
    
    init(itemName: String, fileName: String, colorCode: String, isEmpty: Bool, colorNameKor: String, brand: String, code: String) {
        self.itemName = itemName
        self.fileName = fileName
        self.colorCode = colorCode
        self.isEmpty = isEmpty
        self.colorNameKor = colorNameKor
        self.brand = brand
        self.code = code
    }

    func mapping(map: Map) {
        fileName <- map["fileName"]
        itemName <- map["itemName"]
        colorCode <- map["colorCode"]
        isEmpty <- map["isEmpty"]
        colorNameKor <- map["colorNameKor"]
        brand <- map["brand"]
        isEmpty <- map["isEmpty"]
        code <- map["code"]
    }
}


class CartModel {
    static let shared = CartModel()
    
    let defaultItem = ColorItemModel(itemName: "default", fileName: "d", colorCode: "d", isEmpty: false, colorNameKor: "d", brand: "d", code: "d")
    var colorItemSubject = BehaviorRelay<[ColorItemModel]>(value: [])
    var colorItemModels: [ColorItemModel]
    var somethingEmpty = BehaviorRelay<Bool>(value: false)
    
    let bag = DisposeBag()
    
    private init() {
        colorItemModels = Array(repeating: defaultItem, count: 3)
        colorItemSubject.accept(colorItemModels)
        
        colorItemSubject
            .map{ arr -> Bool in
                for item in arr {
                    if item.isEmpty == true {
                        return true
                    }
                }
                return false
            }
            .bind(to: somethingEmpty)
            .disposed(by: bag)
    }
    
    func addItemOnCart(_ colorItem: ColorItemModel) {
        if colorItemModels[0].itemName == "default" {
            colorItemModels[0] = colorItem
        } else if colorItemModels[1].itemName == "default" {
            colorItemModels[1] = colorItem
        } else if colorItemModels[2].itemName == "default" {
            colorItemModels[2] = colorItem
        }
        colorItemSubject.accept(colorItemModels)
    }
    
    func removeItemOnCart(_ idx: Int) {
        colorItemModels[idx] = defaultItem
        colorItemSubject.accept(colorItemModels)
    }
    
    func resetCart() {
        colorItemModels = Array(repeating: defaultItem, count: 3)
        colorItemSubject.accept(colorItemModels)
    }

}

class NoticeModel: Mappable {
    var timestamp: Int?
    var name: String?
    var colorItems: [String] = []
    var phoneNum: String?
    var type: Int?
    var key: String?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        timestamp <- map["timestamp"]
        name <- map["name"]
        phoneNum <- map["phoneNum"]
        type <- map["type"]
        key <- map["key"]
    }

}
