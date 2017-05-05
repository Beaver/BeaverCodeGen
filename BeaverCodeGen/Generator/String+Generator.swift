infix operator <<<

extension String {
    var indented: String {
        let split = self.characters.split(separator: "\n")
        return split.map { "".tab + String($0) }.joined(separator: "\n")
    }
    
    static func <<(lhs: inout String, rhs: String) {
        return lhs.append(rhs.br)
    }

    static func <<<(lhs: inout String, rhs: String) {
        return lhs << rhs.indented
    }

    var br: String {
        return self + "\n"
    }

    var tab: String {
        return self + "    "
    }
}

func tab(_ s: String) -> String {
    return "".tab + s
}

func comment(_ s: String) -> String {
    return "// " + s
}
