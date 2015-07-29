Redmine GetBadges plugin
========================

Join our online chat at [![Gitter](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/GetBadges/redmine_get_badges)


Overview
--------
This plugin allows to sent updates from Redmine to [GetBadges](http://getbadg.es "GetBadges Homepage").


Installation Steps
-------------------
 - Clone this repo to redmine /plugins folder for the user that runs redmine and run:
 ```bash
cd redmine_get_badges
rake redmine:plugins:migrate NAME=redmine_get_badges RAILS_ENV=production
```
 - Restart Redmine

