Configuration Files
===================

This folder contains configuration files used by all example projects.

Overview
--------

Each configuration file defines a specific set of parameters that control global behavior, such as scaling, unit sizes, and grid dimensions.

- config-default.scad – The default configuration used by all examples.  
  It is recommended not to edit this file directly. Instead, copy it, adjust the values, and reference your new file in config.scad.

- config-scale-x2.scad, config-scale-x3.scad – Example configurations that apply different scaling factors.

- config.scad – The main configuration selector. This file determines which configuration is currently active.

Usage
-----

1. Open config.scad.  
2. To activate a configuration, remove the leading double slashes (//) from its include line.  
3. To deactivate a configuration, add double slashes (//) in front of its line.  
4. Only one configuration should be active at a time.

Example:

    // Active configuration
    include <config-default.scad>;

    // Inactive configurations
    //include <config-scale-x2.scad>;
    //include <config-scale-x3.scad>;

Creating Your Own Configuration
-------------------------------

1. Copy config-default.scad and rename it (for example: config-custom.scad).  
2. Adjust the parameters as needed (for example: unitMbu, unitGrid, or scale).  
3. Update config.scad to include your new file.
