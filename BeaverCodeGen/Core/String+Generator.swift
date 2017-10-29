extension String {
    var indented: String {
        return indented(count: 1)
    }
    
    func indented(count: Int) -> String {
        let split = self.characters.split(separator: "\n", omittingEmptySubsequences: false)
        
        return split.map { chars in
            let str = String(chars)
            if str.replacingOccurrences(of: " ", with: "").characters.count == 0 {
                return ""
            } else {
                return BeaverCodeGen.tab(str, count: count)
            }
        }.joined(separator: .br)
    }
    
    static let br = "\n"
    
    static func br(_ count: Int) -> String {
        return (0..<count).map { _ in br }.joined()
    }

    var br: String {
        return self + .br
    }
    
    func br(_ count: Int) -> String {
        return self + String.br(count)
    }

    static let tab = "    "
    
    static func tab(_ count: Int) -> String {
        return (0..<count).map { _ in tab }.joined()
    }

    var tab: String {
        return self + .tab
    }
    
    func tab(_ count: Int) -> String {
        return self + String.tab(count)
    }

    var typeName: String {
        let first = String(characters.prefix(1)).capitalized
        let other = String(characters.dropFirst())
        return first + other
    }

    var varName: String {
        let first = String(characters.prefix(1)).lowercased()
        let other = String(characters.dropFirst())
        return first + other
    }
    
    var snakecase: String {
        let pattern = "([a-z0-9])([A-Z])"
        guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else {
            fatalError("Couldn't build regex with pattern: \(pattern)")
        }
        let range = NSRange(location: 0, length: self.characters.count)
        return regex.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: "$1_$2").lowercased()
    }
}

func br(_ s: String, count: Int = 1) -> String {
    return "".br(count) + s
}

func tab(_ s: String, count: Int = 1) -> String {
    return "".tab(count) + s
}

func comment(_ s: String) -> String {
    return "// " + s
}
