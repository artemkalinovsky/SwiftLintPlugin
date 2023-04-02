//
//  File.swift
//  
//
//  Created by Artem Kalinovsky on 02.04.2023.
//

import PackagePlugin
import Foundation

@main
struct MyCommandPlugin: CommandPlugin {
    
    func performCommand(context: PluginContext, arguments: [String]) throws {
        let tool = try context.tool(named: "swiftlint")
        let toolUrl = URL(fileURLWithPath: tool.path.string)

        for target in context.package.targets {
            guard let target = target as? SourceModuleTarget else { continue }

            let process = Process()
            process.executableURL = toolUrl
            process.arguments = [
                "--config",
                "\(context.package.directory.string)/.swiftlint.yml",
            ]

            print(toolUrl.path, process.arguments!.joined(separator: " "))

            try process.run()
            process.waitUntilExit()

            if process.terminationReason == .exit && process.terminationStatus == 0 {
                print("Linted the source code in \(target.directory).")
            } else {
                let problem = "\(process.terminationReason):\(process.terminationStatus)"
                Diagnostics.error("swiftlint invocation failed: \(problem)")
            }
        }
    }

}
