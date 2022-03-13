/**
* Machine Blocks
* https://machinemania.net/blocks 
*
* Plug Holder
* Copyright (c) 2022 Jan Philipp Knoeller <pk@pksoftware.de>
*
* Published under license:
* Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International 
* https://creativecommons.org/licenses/by-nc-sa/4.0/
*
*/

echo(version=version());

include <../../lib/plug.scad>;

plug(
    pins=[0,0,0],
    height = 5
);