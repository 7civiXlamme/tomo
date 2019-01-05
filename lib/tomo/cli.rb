module Tomo
  class CLI
    autoload :DeployOptions, "tomo/cli/deploy_options"
    autoload :Error, "tomo/cli/error"
    autoload :Parser, "tomo/cli/parser"
    autoload :UnknownOptionError, "tomo/cli/unknown_option_error"

    class << self
      attr_accessor :show_backtrace
    end

    COMMANDS = {
      "deploy" => Tomo::Commands::Deploy,
      "init" => Tomo::Commands::Init,
      "run" => Tomo::Commands::Run,
      "tasks" => Tomo::Commands::Tasks
    }.freeze

    def call(argv)
      command = if COMMANDS.key?(argv.first)
                  command_name = argv.shift
                  COMMANDS[command_name].new
                else
                  Tomo::Commands::Default.new
                end

      options = command.parser.parse(argv)
      command.call(options)
    rescue StandardError => error
      handle_error(error, command_name)
    end

    private

    def handle_error(error, command_name)
      raise error unless error.respond_to?(:to_console)

      error.command_name = command_name if error.respond_to?(:command_name=)
      Tomo.logger.error(error.to_console)
      status = error.respond_to?(:exit_status) ? error.exit_status : 1
      exit(status) unless Tomo::CLI.show_backtrace

      raise error
    end
  end
end
