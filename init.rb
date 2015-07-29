require 'redmine_get_badges/patches/issue_patch'
require 'redmine_get_badges/patches/project_patch'
require 'redmine_get_badges/patches/setting_patch'

Redmine::Plugin.register :redmine_get_badges do
  settings default: {'empty' => true}, partial: 'redmine_get_badges/settings'
  name 'Redmine GetBadges plugin'
  author 'Justyna Wojtczak'
  description 'A plugin for managing GetBadges functionality'
  version '0.1.5'
end

