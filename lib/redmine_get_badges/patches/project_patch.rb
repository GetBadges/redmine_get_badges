require_dependency 'project'
require_relative '../../../app/services/get_badges/api'

module RedmineGetBadges
  module Patches
    module ProjectPatch
      def self.included(base)

        base.extend ClassMethods
        base.send :include, InstanceMethods

        base.class_eval do
          unloadable # Send unloadable so it will not be unloaded in development

          after_create :send_projects
          after_update :send_projects
          after_destroy :send_projects
        end
      end

      module ClassMethods
        def prepared_projects
          data = {}
          data['projects'] = []
          Project.all.each do |project|
            data['projects'] << project.serialize_data
          end
          return data
        end
      end

      module InstanceMethods
        # This will send a notification associated to the project

        attr_accessor :project_name

        def send_projects
          GetBadges::Api.send_data(Project.prepared_projects)
          return true
        end

        def serialize_data()
          self.project_name = self.project.try(:name)
           serializable_hash(
                methods: [:project_name],
                only: [:project_name, :id],
           )
        end
      end
    end
  end
end

Rails.application.config.to_prepare do
  Project.send :include, RedmineGetBadges::Patches::ProjectPatch
end
