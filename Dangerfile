# Sometimes it's a README fix, or something like that - which isn't relevant for
# including in a project's CHANGELOG for example
declared_trivial = bitbucket_cloud.pr_title.include? "#trivial"

# Make it more obvious that a PR is a work in progress and shouldn't be merged yet
warn("PR is classed as Work in Progress") if bitbucket_cloud.pr_title.include? "[WIP]"

# Warn when there is a big PR
warn("Big PR") if git.lines_of_code > 500

# Don't let testing shortcuts get into master by accident
# fail("fdescribe left in tests") if `grep -r fdescribe specs/ `.length > 1
# fail("fit left in tests") if `grep -r fit specs/ `.length > 1

# Run SwiftLint
#message("Static code analysis")
swiftlint.config_file = '.swiftlint.yml'
swiftlint.lint_files

# Run Xcode Summary
#message("Test Results")
xcode_summary.report './build/reports/errors.json'

# Run Xcov
#message("Code coverage")
xcov.report(
   scheme: 'SoulSwift-Example',
   workspace: 'SoulSwift.xcworkspace',
   include_targets: "SoulSwift.framework"
)