require "forwardable"
require "optparse"

module Jam
  class CLI
    class Parser
      extend Forwardable

      def_delegators :opt_parse, :accept

      attr_accessor :permit_empty_args, :permit_extra_args
      attr_writer :banner, :usage

      def initialize
        @permit_empty_args = false
        @permit_extra_args = false
        @usage = nil
        @opt_parse = OptionParser.new
        @opt_parse.banner = ""
        @opt_parse.summary_indent = "  "
        @results = {}
        add_help_option
        yield(self) if block_given?
      end

      def parse(args)
        raise "Parser#parse has already been used" if results.frozen?

        args = args.dup
        opt_parse.parse!(args)
        # TODO: print a nicer error instead of just showing the usage
        usage_and_exit!(1) if args.any? && !permit_extra_args
        usage_and_exit!(1) if args.empty? && !permit_empty_args

        results[:extra_args] = args
        results.freeze
      end

      def on(*args)
        opt_parse.on(*args) do |data|
          yield(data, results)
        end
      end

      def on_tail(*args)
        opt_parse.on_tail(*args) do |data|
          yield(data, results)
        end
      end

      def add(parser_extensions)
        parser_extensions.call(self, results)
      end

      private

      attr_reader :banner, :opt_parse, :results, :usage

      def add_help_option
        on_tail("-h", "--help", "Print this documentation") do
          usage_and_exit!
        end
      end

      def usage_and_exit!(status=0)
        puts
        puts banner.gsub(/^/, "  ")
        puts
        if usage
          puts usage.gsub(/^/, "  ")
        else
          puts "  Options:"
          puts opt_parse.to_s.gsub(/^/, "  ")
        end
        puts
        exit(status)
      end
    end
  end
end
