# Settings

Settings skin generator skin. Creates a settings skin from a variables.inc file

## Notes to self:

The settings skin consists of variant skins which all have the categories menu included. The categories menu is controlled with #Selected#.

## Skin structure example:

### Outputted skin structure

* Skins\Settings Generator
  * @Resources
    * settings.inc
    * generateSettings.ps1
  * Settings
    * Categories
      * 0.ini
      * 1.ini
      * 2.ini
    * Settings.ini
