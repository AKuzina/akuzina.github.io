require "rbconfig"

configured_headers = RbConfig::CONFIG["rubyarchhdrdir"]
configured_header = File.join(configured_headers, "ruby", "config.h")

# On some recent macOS versions Apple Ruby reports a newer Darwin directory
# than the one shipped in the Command Line Tools SDK. Use the compatible SDK
# header directory when that happens. Other Ruby installations are untouched.
unless File.file?(configured_header)
  candidates = Dir.glob(
    File.join(File.dirname(configured_headers), "universal-darwin*", "ruby", "config.h")
  ).sort

  if candidates.any?
    compatible_headers = File.dirname(File.dirname(candidates.last))
    RbConfig::CONFIG["rubyarchhdrdir"] = compatible_headers
    RbConfig::MAKEFILE_CONFIG["rubyarchhdrdir"] = compatible_headers
  end
end
