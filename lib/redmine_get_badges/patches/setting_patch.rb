require_relative '../../../app/services/get_badges/api'

module RedmineGetBadges
  module Patches
    module SettingPatch
      def self.included(base)

        base.extend ClassMethods
        base.send :include, InstanceMethods

        base.class_eval do
          unloadable # Send unloadable so it will not be unloaded in development

          after_validation :send_projects
        end
      end

      module ClassMethods
      end

      module InstanceMethods
        # This will send a notification associated to the setting

        def send_projects
          return unless self.name == 'plugin_redmine_get_badges'
          GetBadges::Api.send_data(Project.prepared_projects) if self.changed?
          return true
        end
      end
    end
  end
end

Rails.application.config.to_prepare do
  require_dependency 'setting'
  Setting.send :include, RedmineGetBadges::Patches::SettingPatch
end
