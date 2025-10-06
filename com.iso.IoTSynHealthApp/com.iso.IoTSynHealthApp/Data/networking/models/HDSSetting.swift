//
//  HdsSetting2.swift
//  com.iso.IoTSynHealthApp
//
//  Created by PTV on 3/10/25.
//
import RealmSwift
import SwiftUI

class HDSSetting: Object, Decodable {
    @Persisted(primaryKey: true) var id: String
    @Persisted var syncDate: String
    @Persisted var syncNumber: Int
    @Persisted var hdsSampleType: HDSSampleType?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case syncDate = "sync_date"
        case syncNumber = "sync_number"
        case hdsSampleType = "sample_type_id"

    }
    required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.syncDate = try container.decode(String.self, forKey: .syncDate)
        self.syncNumber = try container.decode(Int.self, forKey: .syncNumber)
        self.hdsSampleType = try container.decodeIfPresent(
            HDSSampleType.self,
            forKey: .hdsSampleType
        )
    }
}
