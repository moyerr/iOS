//
//  BackForwardItemCell.swift
//  DuckDuckGo
//
//  Copyright © 2020 DuckDuckGo. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import Core
import UIKit

class BackForwardItemCell: UITableViewCell {

    static let reuseIdentifier = "BackForwardItemCell"

    @IBOutlet weak var linkImage: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var url: UILabel!

    var link: Link? {
        didSet {
            title.text = link?.displayTitle
            url.text = urlString(from: link)
            linkImage.loadFavicon(forDomain: link?.url.host, usingCache: .tabs)
        }
    }

    private func urlString(from link: Link?) -> String? {
        let scheme = link?.url.scheme ?? ""

        return link?.url.absoluteString
            .dropPrefix(prefix: "\(scheme)://")
            .dropPrefix(prefix: "www.")
    }
}
