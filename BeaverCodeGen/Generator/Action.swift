struct Action {
    let name: String
}

extension Action: CustomStringConvertible {
    var description: String {
        var s = ""

        s << "enum \(name) {"
        s <<< "open \(comment("Opens the main controller of the module"))"
        s << "}"

        return s
    }
}
