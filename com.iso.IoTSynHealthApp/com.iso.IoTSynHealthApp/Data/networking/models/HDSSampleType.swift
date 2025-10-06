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
}
