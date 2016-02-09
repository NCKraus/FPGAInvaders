library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package game_package is

	type alien_X_t is array (39 downto 0) of integer range -1 to 319;
	type alien_y_t is array (39 downto 0) of integer range -1 to 239;
	type alien_collision_t is array (39 downto 0) of std_logic;

end game_package;