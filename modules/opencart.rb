require 'active_support/inflector'

module Meg
  class MyOpenCart < SubThor
    attr_accessor :pluginname
    $application_path = "#{__dir__}/.."
    $language = "en-gb"

    include Thor::Actions
    include MyCli::SharedMethods

    SUBCOMMAND = "opencart"
    DESCRIPTION = "Generate all sort of files to OpenCart extension"

    def self.exit_on_failure?
      true
    end

    def self.source_root
      File.dirname(__FILE__)
    end

    no_tasks do
        def pluginname
            @pluginname.downcase
        end
        
        def classname
            @pluginname.gsub(/ /, '').gsub(/-/, '')
        end
        
        def filename
            @pluginname.downcase.gsub(/ /, '_').gsub(/-/, '_')
        end
        
        def heading
            @pluginname.gsub(/-/, ' ')
        end
        
        def language
            $language
        end
    
        def nowformated
            Time.now.strftime('%Y%m%d%H%M%S')
        end
    end

    method_option :plugintype, :type => :string, :aliases => "-t", :default => "admin-extension"
    method_option :appdir, :type => :string, :aliases => "-a", :required => true
    desc "plugin PLUGINNAME", "Generates a new plugin named PLUGINNAME"
    def plugin(pluginname, *fields)
	self.pluginname = pluginname
	plugintype = options[:plugintype]
	appdir = options[:appdir]
	opts = { :pluginname => pluginname, :fields => fields }
        
    puts "Generating '#{plugintype}' plugin '#{pluginname}' for application '#{appdir}'"
	if (!File.directory?("#{appdir}"))
            raise Thor::Error, "No application '#{appdir}' has been found"
            return
        end
	if (!File.directory?($application_path + "/templates/plugins/opencart/#{plugintype}"))
            raise Thor::Error, "No templates found for plugin type '#{plugintype}'"
            return
        end
	directory $application_path + "/templates/plugins/opencart/#{plugintype}/", "#{appdir}/", opts
    end

  end
end
