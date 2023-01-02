import Foundation
import SwiftUI

public extension Character {
    var string: String {
        String(self)
    }
}

public extension Int {
    func formated(style: String = "%02d") -> String {
        String(format: style, self)
    }
}

public extension String {
    static let `default`: String = ""
    public static let empty = `default`

    var int: Int {
        return Int(self) ?? 0
    }

    subscript (index: Int) -> Character {
        let charIndex = self.index(self.startIndex, offsetBy: index)
        return self[charIndex]
    }

    subscript (range: Range<Int>) -> Substring {
        let startIndex = self.index(self.startIndex, offsetBy: range.startIndex)
        let stopIndex = self.index(self.startIndex, offsetBy: range.startIndex + range.count)
        return self[startIndex..<stopIndex]
    }

    func segment(separatedBy separator: String, at index: Int = .last) -> String {
        guard self.contains(separator) else { return self }
        let segments = components(separatedBy: separator)
        let realIndex = min(index, segments.count - 1)
        return String(segments[realIndex])
    }

    func segment(from first: String) -> String {
        if var firstIndex = self.index(of: first) {
            firstIndex = self.index(firstIndex, offsetBy: 1)
            let subString = self[firstIndex..<self.endIndex]
            return String(subString)
        }
        return self
    }

//    func at(index: Int) -> String {
//        guard self.count >= index + 1 else { return .empty }
//        let endIndex = index + 1
//        return self.substring(with: index..<endIndex)
//    }


    func trim() -> String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }

    func remove(_ seg: String) -> String {
        return replacingOccurrences(of: seg, with: "")
    }

    func notEmpty()-> Bool {
        return !isEmpty
    }


    func replace(segs: String..., with replacement: String) -> String {
        var result: String = self
        for seg in segs {
            guard result.contains(seg) else { continue }
            result = result.replacingOccurrences(of: seg, with: replacement)
        }
        return result
    }

    func extractDigits() -> String {
        guard !self.isEmpty else { return .default }
        return self.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
    }


    var attributedString: AttributedString {
        do {
            let attributedString = try AttributedString(markdown: self, options:
                                                            AttributedString.MarkdownParsingOptions(interpretedSyntax: .inlineOnlyPreservingWhitespace))
            return attributedString
        } catch {
            print("Couldn't parse: \(error)")
        }
        return AttributedString("Error parsing markdown")
    }

    func urlEncoded()-> String {
        let result = self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        return result ?? .empty
    }

    func urlDecode()-> String {
        self.removingPercentEncoding ?? .empty
    }

}

public extension Optional where Wrapped == String {
    var isEmpty: Bool {
        return self?.isEmpty ?? true
    }

    var notEmpty: Bool {
        !isEmpty
    }

    var safe: String {
        return ifEmpty(.empty)
    }

    func ifEmpty(_ defaultValue: String) -> String {
        return isEmpty ? defaultValue : self!
    }
}

public extension Binding {
    var raw: Value {
        return self.wrappedValue
    }

    //    subscript<T>(_ key: Int) -> Binding<T> where Value == [T] {
    //        .init(get: {
    //            self.wrappedValue[key]
    //        },
    //              set: {
    //            self.wrappedValue[key] = $0
    //        })
    //    }

    subscript<K, V>(_ key: K) -> Binding<V> where Value == [K:V], K: Hashable {
        .init(get: {
            self.wrappedValue[key]!
        },
              set: {
            self.wrappedValue[key] = $0
        })
    }
}

public extension Int {
    static let `default`: Int = 0
    static let first: Int = 0
    static let last: Int = Int.max

    var string: String {
        return String(self)
    }
}

public extension Collection where Indices.Iterator.Element == Index {
    public subscript(safe index: Index) -> Iterator.Element? {
        return (startIndex <= index && index < endIndex) ? self[index] : nil
    }
}

public extension Sequence where Element: Hashable {
    func uniqued() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}


public extension StringProtocol {
    func index<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> Index? {
        range(of: string, options: options)?.lowerBound
    }
    func endIndex<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> Index? {
        range(of: string, options: options)?.upperBound
    }
    func indices<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> [Index] {
        ranges(of: string, options: options).map(\.lowerBound)
    }
    func ranges<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> [Range<Index>] {
        var result: [Range<Index>] = []
        var startIndex = self.startIndex
        while startIndex < endIndex,
              let range = self[startIndex...]
                .range(of: string, options: options) {
            result.append(range)
            startIndex = range.lowerBound < range.upperBound ? range.upperBound :
            index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
        }
        return result
    }
}

public extension Dictionary {
    mutating func merge(_ dict: [Key: Value]?){
        guard let dict = dict else {
            return
        }

        for (k, v) in dict {
            updateValue(v, forKey: k)
        }
    }
}

public extension Data {
    var string: String {
        return String(decoding: self, as: UTF8.self)
    }
}

public extension Date {
    static var currentTimeStamp: Int64{
        return Int64(Date().timeIntervalSince1970 * 1000)
    }
}


public extension UIFont {
    static func prfered(_ font: Font) -> UIFont {
        let uiFont: UIFont

        switch font {
            case .largeTitle:
                uiFont = UIFont.preferredFont(forTextStyle: .largeTitle)
            case .title:
                uiFont = UIFont.preferredFont(forTextStyle: .title1)
            case .title2:
                uiFont = UIFont.preferredFont(forTextStyle: .title2)
            case .title3:
                uiFont = UIFont.preferredFont(forTextStyle: .title3)
            case .headline:
                uiFont = UIFont.preferredFont(forTextStyle: .headline)
            case .subheadline:
                uiFont = UIFont.preferredFont(forTextStyle: .subheadline)
            case .callout:
                uiFont = UIFont.preferredFont(forTextStyle: .callout)
            case .caption:
                uiFont = UIFont.preferredFont(forTextStyle: .caption1)
            case .caption2:
                uiFont = UIFont.preferredFont(forTextStyle: .caption2)
            case .footnote:
                uiFont = UIFont.preferredFont(forTextStyle: .footnote)
            case .body:
                fallthrough
            default:
                uiFont = UIFont.preferredFont(forTextStyle: .body)
        }

        return uiFont
    }
}


public extension Bundle {
    static func readString(name: String?, type: String?) -> String? {
        var result: String? = nil
        if let filepath = Bundle.main.path(forResource: name, ofType: type) {
            do {
                result = try String(contentsOfFile: filepath)
                log("----------> local resource: \(result) <------------")
            } catch {
                // contents could not be loaded
            }
        } else {
            // example.txt not found!
            log("----------> local resource \(name): not found <------------")
        }
        return result
    }

}


public extension URL {
    func params() -> [String : String] {
        var dict = [String : String]()

        if let components = URLComponents(url: self, resolvingAgainstBaseURL: false) {
            if let queryItems = components.queryItems {
                for item in queryItems {
                    dict[item.name] = item.value!
                }
            }
            return dict
        } else {
            return [ : ]
        }
    }
}

public extension UIDevice {
    static var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }

    static var isIPhone: Bool {
        UIDevice.current.userInterfaceIdiom == .phone
    }
}
