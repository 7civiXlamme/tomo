module Jam
  module Commands
    class Default
      def parser
        Jam::CLI::Parser.new do |parser|
          parser.banner = "Usage: jam COMMAND [options]"
          parser.usage = <<~USAGE
            Jam is an extensible tool for deploying projects to remote hosts via SSH.
            Please specify a COMMAND, which can be:

            #{Jam::CLI::COMMANDS.keys.map { |key| "  - #{key}" }.join("\n")}

            For additional help, run:

              jam COMMAND -h
          USAGE
          parser.on("-v", "--version") do
            puts "jam #{Jam::VERSION}"
            exit
          end
        end
      end
    end
  end
end
