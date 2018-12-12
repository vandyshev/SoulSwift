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
swiftlint.config_file = '.swiftlint.yml'
swiftlint.lint_files

# Run Xcode Summary
xcode_summary.report './build/reports/errors.json'

# Run Slather
slather.configure("SoulSwift.xcodeproj", "SoulSwift-Example", options: {
  workspace: 'SoulSwift.xcworkspace',
  ci_service: :teamcity,
  source_directory: 'Sources/Classes',
  binary_file: 'SoulSwift',
})
slather.notify_if_coverage_is_less_than(minimum_coverage: 80)
slather.notify_if_modified_file_is_less_than(minimum_coverage: 60)
slather.show_coverage