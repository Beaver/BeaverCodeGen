infix operator <<<

extension String {
    var indented: String {
        let split = self.characters.split(separator: "\n")
        return split.map { String($0) == .tab ? "" : (.tab + String($0)) }.joined(separator: "\n")
    }
    
    static func <<(lhs: inout String, rhs: String) {
        return lhs.append(rhs.br)
    }

    static func <<<(lhs: inout String, rhs: String) {
        return lhs << rhs.indented
    }

    static let br = "\n"

    var br: String {
        return self + .br
    }

    static let tab = "    "

    var tab: String {
        return self + .tab
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

    func scope(indent: Bool = true, _ content: () -> String) -> String {
        if indent {
            return self + "{".br
                    + content().replacingOccurrences(of: "\n", with: .tab + "\n")
                    .indented
                    .replacingOccurrences(of: .tab + "\n", with: "\n")
                    .br
                    + "}"
        } else {
            return self + "{".br + content() + "}"
        }
    }
}

func tab(_ s: String) -> String {
    return "".tab + s
}

func comment(_ s: String) -> String {
    return "// " + s
}
