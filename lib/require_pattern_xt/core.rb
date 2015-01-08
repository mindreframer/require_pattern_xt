module RequirePatternXt
  module Core
    # Requires all files matching the glob patterns provided.
    # If a file fails to load, it keeps retrying until all remaining files fail to load, in which case the exception is
    # output to STDERR for each failed file.
    def self.require_pattern(*patterns)
      loaded = false # Indicates whether any files were loaded at all
      require_map = patterns.
        map { |pattern| Dir.glob(pattern) }.
        flatten.
        reduce({}) { |m,v|  m[v] = nil; m }
      loop do
        remaining = require_map.reject! do |file,_|
          begin
            loaded = true if require File.expand_path(file)
            true
          rescue => require_map[file]
            false
          end
        end

        if require_map.empty?
          break loaded
        elsif remaining.nil?
          log_error(require_map)
        end
      end
    end
    def self.log_error(require_map)
      STDERR.puts Coloring.red("\nSome files failed:")
      require_map.each { |file, e|
        msg = Coloring.red("    #{file}: ") + Coloring.yellow("#{e.backtrace[0]} #{e}")
        STDERR.puts msg
      }
      STDERR.puts
      raise LoadError, "One or more files failed to load. See STDERR output for details."
    end
  end
end
