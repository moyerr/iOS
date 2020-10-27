//
//  BackForwardViewController.swift
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

import UIKit
import WebKit

class BackForwardViewController: UITableViewController {

    weak var delegate: BackForwardDelegate?

    var dataSource: BackForwardDataSource? {
        didSet { tableView.dataSource = dataSource }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        applyTheme(ThemeManager.shared.currentTheme)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let listItem = dataSource?.listItem(at: indexPath) else { return }
        selectListItem(listItem)
    }

    @IBAction func onDonePressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }

    private func selectListItem(_ listItem: WKBackForwardListItem) {
        dismiss(animated: true)
        delegate?.backForwardViewController(self, didSelectListItem: listItem)
    }
}

extension BackForwardViewController: Themable {
    func decorate(with theme: Theme) {
        decorateNavigationBar(with: theme)

        if #available(iOS 13, *) {
            overrideSystemTheme(with: theme)
        }

        tableView.separatorColor = theme.tableCellSeparatorColor
        tableView.backgroundColor = theme.backgroundColor
        popoverPresentationController?.backgroundColor = theme.backgroundColor

        tableView.reloadData()
    }
}
