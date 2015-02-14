require_dependency 'issue'
require_relative '../../../app/services/get_badges/api'

module RedmineGetBadges
  module Patches
    module IssuePatch
      def self.included(base)

        base.extend ClassMethods
        base.send :include, InstanceMethods

        base.class_eval do
          unloadable # Send unloadable so it will not be unloaded in development

          after_create :send_issue_create
          after_update :send_issue_update
          after_destroy :send_issue_destroy

          # Add visible to Redmine 0.8.x
          unless respond_to?(:visible)
            named_scope :visible, lambda { |*args| { include: :project,
                conditions: Project.allowed_to_condition(args.first || User.current, :view_issues) } }
          end
        end
      end

      module ClassMethods
      end

      module InstanceMethods
        # This will send a notification associated to the issue
        require 'net/http'

        attr_accessor :event, :project_name

        def email
          User.current.try(:mail).to_s.strip.downcase if User.current.try(:mail).present?
        end

        def send_issue_create
          GetBadges::Api.send_data(serialize_data('redmine.issue.create'))
          return true
        end

        def send_issue_update
          if self.status_id_changed?
            if self.status.is_closed?
              GetBadges::Api.send_data(serialize_data('redmine.issue.close'))
            elsif IssueStatus.find(self.status_id_change.first).is_closed?
              GetBadges::Api.send_data(serialize_data('redmine.issue.reopen'))
            end
          end
          return true
        end

        def send_issue_destroy
          GetBadges::Api.send_data(serialize_data('redmine.issue.delete'))
          return true
        end

        def serialize_data(event)
          self.event = event
          self.project_name = self.project.try(:name)
          self.serializable_hash(
            methods: [:event, :email, :project_name],
            only: [:event, :email, :project_name, :id],
          )
        end
      end
    end
  end
end

Rails.application.config.to_prepare do
  Issue.send :include, RedmineGetBadges::Patches::IssuePatch
end
