//
//  DataModel.swift
//  NotePad
//
//  Created by Duc Pham on 3/31/20.
//  Copyright © 2020 Duc Pham. All rights reserved.
//

import Foundation
import RealmSwift

class Note: Object {
    @objc dynamic var noteName : String = "AAA"
}
