//
//  Language.swift
//  Task
//
//  Created by Alberto Martínez Fernández on 29/02/2020.
//  Copyright © 2020 Alberto Martínez Fernández. All rights reserved.
//

import Foundation

class Language {
    static var strings = [String: String]()
    static var locale: String = ""
    
    static func localizedString(string: String) -> String {
        return strings[string] ?? string
    }
    
    static func storedLocale() -> String {
        if let str = UserDefaults.standard.string(forKey:AppConstants.languagePrefKey) {
            if str == AppConstants.localeSpanish || str == AppConstants.localeEnglish {
                UserDefaults.standard.set( str, forKey: AppConstants.languagePrefKey)
            }
            
            return str
            
        } else {
            return AppConstants.localeEnglish
        }
    }
    
    static func isSet() -> Bool {
        return UserDefaults.standard.string(forKey:AppConstants.languagePrefKey) != nil
    }
    
    static func getCurrentLanguage() -> String {
        return UserDefaults.standard.string(forKey:AppConstants.languagePrefKey)!
    }
    
    static func load() {
        locale = storedLocale()
        _ = setLanguage( locale:locale, remember: false)
    }
    
    static func setLanguage( locale:String, remember:Bool ) -> Bool {
        let file = filenameFromLocale( locale:locale )
        if file == nil {
            return false
        }
        
        let filename = Bundle.main.path(forResource:file, ofType: "strings")
        if let filename = filename {
            strings = NSDictionary.init(contentsOfFile: filename) as! Dictionary<String, String>
            NotificationCenter.default.post(name:NSNotification.Name(rawValue: "language-changed"), object: nil)
            
            if remember {
                UserDefaults.standard.set(self.getValidLocaleCode(locale: locale), forKey: AppConstants.languagePrefKey)
            }
            
            self.locale = locale
            return true
            
        } else {
            print("Couldn't find file \(String(describing: file)).strings")
            return false
        }
    }
    
    private static func filenameFromLocale( locale:String ) -> String? {
        var fileName = ""
        let localeOk = locale.replacingOccurrences(of: "-", with: "_")
        
        switch localeOk.prefix(2) {
        case AppConstants.localeSpanish.prefix(2): fileName = AppConstants.localeSpanishFilename
        case AppConstants.localeEnglish.prefix(2): fileName = AppConstants.localeEnglishFilename
        default: fileName = AppConstants.localeEnglishFilename
        }
        
        return fileName
    }
    
    private static func getValidLocaleCode(locale: String) -> String {
        let localeOk = locale.replacingOccurrences(of: "-", with: "_")
        
        if localeOk.hasPrefix(String(AppConstants.localeSpanish.prefix(2))) {
            return AppConstants.localeSpanish
            
        } else if localeOk.hasPrefix(String(AppConstants.localeEnglish.prefix(2))) {
            return AppConstants.localeEnglish
            
        } else {
            return AppConstants.localeEnglish
        }
    }
}
