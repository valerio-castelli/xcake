require 'xcodeproj'

module Xcake
  # This generator processes the configuraions
  # and creates xcode build configurations.
  #
  class ConfigurationGenerator < Generator

    def self.dependencies
      [TargetGenerator, ProjectStructureGenerator]
    end

    def visit_project(project)
      create_build_configurations_for(project)
    end

    def visit_target(target)
      create_build_configurations_for(target)
    end

    def create_build_configurations_for(configuration_object)
      puts "Creating build configurations for #{configuration_object}..."

      configuration_object.flatten_configurations.each do |configuration|
        puts "Creating build configuration #{configuration.name} for #{configuration_object}..."

        build_configuration = @context.native_object_for(configuration)
        build_configuration.name = configuration.name
        build_configuration.build_settings = configuration.settings

 #      Move this to an installer:
 #      group = group_for_node(node)
 #      file_reference = group.new_reference(node.path)
 #      @native_configuration.base_configuration_reference = file_reference
 #      build_configuration.base_configuration_reference = configuration.configuration_file

        native_configuration_object = @context.native_object_for(configuration_object)
        native_configuration_object.build_configurations << build_configuration
      end
    end
  end
end