//
//  GCDBlackBoc.swift
//  OnTheMap
//
//  Created by Carl Lee on 9/28/16.
//  Copyright © 2016 Carl Lee. All rights reserved.
//

import Foundation

func performUIUpdateOnMain(updates: @escaping () -> Void) {
    DispatchQueue.main.async{
        updates()
    }
}

