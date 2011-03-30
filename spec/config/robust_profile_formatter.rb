require 'spec/runner/formatter/progress_bar_formatter'

module Spec
  module Runner
    module Formatter
      class RobustProfileFormatter < ProgressBarFormatter
        
        def initialize(options, where)
          super
          @example_times = []
        end
        
        def start(count)
          @output.puts "Profiling enabled."
        end
        
        def example_started(example)
          @time = Time.now
        end
        
        def example_passed(example)
          super
          @example_times << [
            example_group.description,
            example.description,
            Time.now - @time
          ]
        end

        def mean(array)
          sum = array.inject(0){|acc, x| acc + x}
          return (sum.to_f / array.length.to_f)
        end

        def stdev(array)
          my_mean = mean(array)
          total = array.inject(0){|acc, x| acc + (x - my_mean) ** 2}
          total /= array.length.to_f
          Math::sqrt(total)
        end

        def start_dump
          super

          @example_times = @example_times.sort_by do |description, example, time|
          time
          end.reverse

          times = @example_times.map {|d,e,t| t}
          mean = mean(times)
          stddev = stdev(times)
          k = 2
          @example_times.reject! { |d,e,t| t < mean + k * stddev }

          @output.puts "\n\nTop #{@example_times.size} slowest examples:\n"

          @example_times.each do |description, example, time|
          @output.print red(sprintf("%.7f", time))
          @output.puts "\t#{description} #{example}"
          end

          @output.puts "\n\nStats"

          @output.puts "Mean:\t#{"%.5f" % mean}"
          @output.puts "StdDev:\t#{"%.5f" % stddev}"
          @output.puts "Total:\t#{times.size}"
          @output.puts "Slow:\t#{@example_times.size}"

          @output.flush
        end
      end
    end
  end
end
