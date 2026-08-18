// TCC wrapper for secondbrain-backup. macOS launch constraints forbid running a
// relocated copy of /bin/zsh, so Full Disk Access is granted to this binary
// instead; it stays alive as the responsible process while zsh runs the script.
//
// Build: swiftc -O -o ~/.local/bin/secondbrain-backup-runner secondbrain-backup-runner.swift
//        codesign -f -s "Developer ID Application: Pablo Fonseca (H4H3RQ94Q3)" \
//          -i com.pablobfonseca.secondbrain-backup-runner ~/.local/bin/secondbrain-backup-runner
// The Developer ID signature keeps the TCC identity stable across rebuilds.

import Foundation

let script = FileManager.default.homeDirectoryForCurrentUser
    .appendingPathComponent(".dotfiles/scripts/secondbrain-backup").path
let process = Process()
process.executableURL = URL(fileURLWithPath: "/bin/zsh")
process.arguments = [script]
do {
    try process.run()
} catch {
    FileHandle.standardError.write(Data("failed to launch backup script: \(error)\n".utf8))
    exit(1)
}
process.waitUntilExit()
exit(process.terminationStatus)
