//
//  HDSSampleType2.swift
//  com.iso.IoTSynHealthApp
//
//  Created by PTV on 3/10/25.
//

import RealmSwift

class HDSSampleType : EmbeddedObject, Decodable {
    @Persisted var id: String
    @Persisted var sampleTypeId: String
    @Persisted var primaryUnit: String
    @Persisted var name: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case sampleTypeId = "unique_sample_type_id"
        case primaryUnit = "primary_unit"
        case name
    }
    required convenience init(from decoder: Decoder) throws {
           self.init()

           let container = try decoder.container(keyedBy: CodingKeys.self)
           self.id = try container.decode(String.self, forKey: .id)
           self.sampleTypeId = try container.decode(String.self, forKey: .sampleTypeId)
           self.primaryUnit = try container.decode(String.self, forKey: .primaryUnit)
           self.name = try container.decode(String.self, forKey: .name)
       }
}
