#!/usr/bin/swift -FRome

import Commander
import BeaverCodeGen

command(
        Argument<String>("name", description: "Your module name")
) { name in
    print(generate(command: .module(name: name)))
}.run()