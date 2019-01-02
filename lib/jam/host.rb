module Jam
  class Host
    PATTERN = /^(?:(\S+)@)?(\S*?)(?::(\S+))?$/
    private_constant :PATTERN

    attr_reader :name, :user, :port, :roles

    def initialize(host, roles: nil)
      host = host.to_s.strip
      @user, @name, @port = host.match(PATTERN).captures.map(&:freeze)
      @port ||= "22"
      @roles = Array(roles).map(&:freeze).freeze
      freeze
      raise ArgumentError, "host cannot be blank" if name.empty?
    end

    def to_s
      str = user ? "#{user}@#{name}" : name
      str << ":#{port}" unless port == "22"
      str
    end

    def to_ssh_args
      args = [user ? "#{user}@#{name}" : name]
      args.push("-p", port) unless port == "22"
      args
    end
  end
end
