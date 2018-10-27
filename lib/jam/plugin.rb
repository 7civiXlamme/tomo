module Jam
  module Plugin
    def self.extended(mod)
      mod.instance_variable_set(:@helper_modules, [])
      mod.instance_variable_set(:@default_settings, {})
      mod.instance_variable_set(:@tasks_classes, [])
    end

    attr_reader :helper_modules, :default_settings, :tasks_classes

    def helpers(mod, *more_mods)
      @helper_modules.append(mod, *more_mods)
    end

    def defaults(settings)
      @default_settings.merge!(settings)
    end

    def tasks(tasks_class, *more_tasks_classes)
      @tasks_classes.append(tasks_class, *more_tasks_classes)
    end
  end
end
