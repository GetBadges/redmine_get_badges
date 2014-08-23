require 'redmine_get_badges/patches/issue_patch'
Redmine::Plugin.register :redmine_get_badges do
  settings default: {'empty' => true}, partial: 'redmine_get_badges/settings'
  name 'Redmine Get Badges plugin'
  author 'Justyna Wojtczak'
  description 'A plugin for managing getbadges functionality'
  version '0.0.2'
end

