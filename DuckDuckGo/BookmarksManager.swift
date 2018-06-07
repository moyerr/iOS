//
//  BookmarksManager.swift
//  DuckDuckGo
//
//  Copyright © 2017 DuckDuckGo. All rights reserved.
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

class BookmarksManager {
    
    struct ExportedBookmark: Encodable, Decodable {
        
        var title: String
        var url: String
        
    }
    
    struct BookmarksJson: Encodable, Decodable {
        
        var bookmarks: [ExportedBookmark]?
        
    }
    
    private let dataStore: BookmarkUserDefaults

    init(dataStore: BookmarkUserDefaults = BookmarkUserDefaults()) {
        self.dataStore = dataStore
    }

    var isEmpty: Bool {
        return dataStore.bookmarks?.isEmpty ?? true
    }
    
    var count: Int {
        return dataStore.bookmarks?.count ?? 0
    }
    
    func bookmark(atIndex index: Int) -> Link {
        return dataStore.bookmarks![index]
    }
    
    func save(bookmark: Link) {
        dataStore.addBookmark(bookmark)
    }
    
    func exportJson() -> Data {
        var bookmarks = [ExportedBookmark]()
        if let links = dataStore.bookmarks {
            for link in links {
                bookmarks.append(ExportedBookmark(title: link.title ?? link.url.host ?? "", url: link.url.absoluteString))
            }
        }
        
        return (try? JSONEncoder().encode(BookmarksJson(bookmarks: bookmarks))) ?? "{}".data(using: .utf8)!
    }
    
    func importJson(from data: Data) -> Bool {
        
        guard let bookmarksJson = try? JSONDecoder().decode(BookmarksJson.self, from: data) else {
            return false
        }
        
        guard let bookmarks = bookmarksJson.bookmarks else {
            // JSON was valid, but empty so consider them imported
            return true
        }
        
        for bookmark in bookmarks {
            guard let url = URL(string: bookmark.url) else { continue }
            save(bookmark: Link(title: bookmark.title, url: url))
        }
        
        return true
    }
    
    func delete(itemAtIndex index: Int) {
        if var newBookmarks = dataStore.bookmarks {
            newBookmarks.remove(at: index)
            dataStore.bookmarks = newBookmarks
        }
    }
    
    func move(itemAtIndex oldIndex: Int, to newIndex: Int) {
        if var newBookmarks = dataStore.bookmarks {
            let link = newBookmarks.remove(at: oldIndex)
            newBookmarks.insert(link, at: newIndex)
            dataStore.bookmarks = newBookmarks
        }
    }
    
    func update(index: Int, withBookmark newBookmark: Link) {
        if var newBookmarks = dataStore.bookmarks {
            _ = newBookmarks.remove(at: index)
            newBookmarks.insert(newBookmark, at: index)
            dataStore.bookmarks = newBookmarks
        }
    }
    
    func clear() {
        dataStore.bookmarks = [Link]()
    }

    func indexOf(url: URL) -> Int? {
        guard let bookmarks = dataStore.bookmarks else { return nil }
        var index = 0
        for link in bookmarks {
            if link.url == url {
                return index
            }
            index += 1
        }
        return nil
    }

}
