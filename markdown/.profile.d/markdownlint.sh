# Notes:
# - Although I prefer 2-space indents for unordered lists, some markdown
#   formatters require 4 spaces.
# - In the documentation referenced below, it would seem that a config file such
#   as ~/.markdownlint.yaml or ~/.markdownlintrc (or similar files under
#   ~/.config/markdownlint/) would be recognized by markdownlint, but right now,
#   that is not the case. The only rule customization that works without passing
#   additional command-line flags to markdownlintrc is via environment variables.
#
# References:
# - https://github.com/DavidAnson/markdownlint/blob/main/schema/.markdownlint.yaml
# - https://www.npmjs.com/package/rc#standards
#
markdownlint_MD007__indent=4
export markdownlint_MD007__indent
