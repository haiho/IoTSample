//
//  HdsSetting2.swift
//  com.iso.IoTSynHealthApp
//
//  Created by PTV on 3/10/25.
//

struct HDSSetting: Decodable {
    let syncDate: String
    let hdsSampleType: HDSSampleType

    enum CodingKeys: String, CodingKey {
        case syncDate = "sync_date"
        case hdsSampleType = "sample_type_id"
       
    }
}
