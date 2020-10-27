//
//  BackForwardDataSource.swift
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
import WebKit

class BackForwardDataSource: NSObject, UITableViewDataSource {

    private let items: [WKBackForwardListItem]

    init(items: [WKBackForwardListItem]) {
        self.items = items
    }

    func listItem(at indexPath: IndexPath) -> WKBackForwardListItem? {
        guard items.indices.contains(indexPath.item) else { return nil }
        return items[indexPath.item]
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BackForwardItemCell.reuseIdentifier) as? BackForwardItemCell else {
            fatalError("Failed to dequeue \(BackForwardItemCell.reuseIdentifier) as BackForwardItemCell")
        }

        let listItem = items[indexPath.item]

        cell.link = Link(title: listItem.title, url: listItem.url)

        let theme = ThemeManager.shared.currentTheme
        cell.backgroundColor = theme.tableCellBackgroundColor
        cell.title?.textColor = theme.tableCellTextColor
        cell.url.textColor = theme.tableCellAccessoryTextColor
        cell.setHighlightedStateBackgroundColor(theme.tableCellHighlightedBackgroundColor)

        return cell
    }
}
