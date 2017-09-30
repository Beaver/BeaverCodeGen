struct SwitchCase {
    let enumCases: [EnumCase]
}

extension SwitchCase: CustomStringConvertible {
    var description: String {
        var s = ""

        s += "case ("
        s += enumCases.enumerated().map { (index, enumCase) in
            let indexName = enumCases.count > 1 ? "\(index + 1)" : ""

            var s = ".\(enumCase.name)"
            if enumCase.arguments.count > 0 {
                s += "("
                s += enumCase.arguments.map { argument in
                    if let name = argument.name {
                        return "let \(name.varName)\(indexName)"
                    } else {
                        return "let \(argument.type.varName)\(indexName)"
                    }
                }.joined(separator: ", ")

                s += ")"
            }
            return s
        }.joined(separator: ", ")
        s += "):"

        return s
    }
}

struct CompareSwitchCase {
    let base: EnumCase
}

extension CompareSwitchCase: CustomStringConvertible {
    var description: String {
        var s = ""

        s += SwitchCase(enumCases: [base, base]).description.br
        s += tab("return " + (base.arguments.count > 0 ? base.arguments.map { argument in
            if let name = argument.name {
                return "\(name.varName)1 == \(name.varName)2"
            } else {
                return "\(argument.type.varName)1 == \(argument.type.varName)2"
            }
        }.joined(separator: " &&" + .br + .tab + "        ") : "true"))

        return s
    }
}

struct CompareSwitch {
    let enumCases: [EnumCase]
}

extension CompareSwitch: CustomStringConvertible {
    var description: String {
        return """
        switch (lhs, rhs) {
        \(enumCases.map {
            CompareSwitchCase(base: $0).description
        }.joined(separator: .br).indented)
        }
        """
    }
}
