//
//  Strings+Localized.swift
//  NewsApp
//
//  Created by Tran Minh Tung on 1/9/18.
//  Copyright © 2018 Tran Minh Tung. All rights reserved.
//

import Foundation
import UIKit

extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }

    func localized(withComment: String) -> String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: withComment)
    }
}

extension String {
    init?(htmlEncodedString: String) {
        guard let data = htmlEncodedString.data(using: .utf8) else {
            return nil
        }

        let options: [String: Any] = [
            NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
            NSCharacterEncodingDocumentAttribute: String.Encoding.utf8.rawValue
        ]

        guard let attributedString = try? NSAttributedString(data: data,
                                                             options: options,
                                                             documentAttributes: nil) else {
            return nil
        }

        self.init(attributedString.string)
    }
}

extension String {
    init?(dateStr: String?) {
        guard let inputDateStr = dateStr, !inputDateStr.isEmpty else {
            return nil
        }

        let input = DateFormatter()
        input.dateFormat = "yyyy-MM-dd HH:mm:ss"
        guard let ouputDate = input.date(from: inputDateStr) else {
            return nil
        }

        let output = DateFormatter()
        output.dateFormat = "MMM d, yyyy"

        self.init(output.string(from: ouputDate))
    }
}

extension String {
    func GMTToLocal() -> String {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"

        let dt = formatter.date(from: self)
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        return formatter.string(from: dt!)
    }

    func timeAgoSinceNow() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: self.GMTToLocal())
        return date?.timeAgoSinceNow()
    }
}

enum Localizer: String {
    // swiftlint:disable identifier_name
    case something_wrong, no_internet, invalid_url, no_news_found

    var description: String {
        return self.rawValue.localized
    }
}
