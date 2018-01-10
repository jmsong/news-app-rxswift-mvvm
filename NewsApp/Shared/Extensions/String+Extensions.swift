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
    case something_wrong, no_internet
    case enter_username, enter_email, enter_valid_email,
    enter_first_name, enter_last_name,
    enter_password, enter_confirm_password, password_not_match, password_min
    case forgot_password_title, enter_email_title, enter_email_hint, password_request_sent_title, password_request_sent
    case first_name, last_name, email_address, password, confirm_password
    case news_feed, pulse_news_feed, empty_feed_message, pull_to_refresh
    case no_news, no_events, no_tweets, no_trials
    case no_likes_message
    case invalid_url
    case ok, cancel, request
    case search_placeholder,
    search_kol_placeholder,
    search_disease_placeholder,
    search_trial_placeholder,
    recent_search, no_result_found

    case like_icon = "\u{E800}"
    case comment_icon = "\u{F0E5}"
    case sign_out_icon = "\u{E802}"
    case lock_icon = "\u{E803}"
    case user_icon = "\u{E805}"
    case mail_icon = "\u{F0E0}"
    case vcard_icon = "\u{E804}"
    case close_icon = "\u{E801}"
    case subscribe_icon = "\u{E809}"
    case ok_icon = "\u{E807}"
    case linkedin_icon = "\u{F318}"
    case twitter_icon = "\u{F309}"
    case share_icon = "\u{E806}"
    case info_icon = "\u{E808}"
    case search_icon = "\u{E80A}"
    case back_icon = "\u{E80B}"
    case clear_icon = "\u{E80C}"
    case unfavorite_icon = "\u{E80D}"
    case favorite_icon = "\u{E80E}"
    case big_dot = "\u{2022}"

    var description: String {
        return self.rawValue.localized
    }
}
