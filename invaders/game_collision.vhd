library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.game_package.all;

entity game_collision is
	
	port (	clk		: in std_logic;
			rst		: in std_logic;
	
			turret_x			: in integer range -1 to 319;
			turret_y 			: in integer range -1 to 239;
			turret_collision	: out std_logic;

			turret_bullet_x			: in integer range -1 to 319;
			turret_bullet_y			: in integer range -1 to 239;
			turret_bullet_collision	: out std_logic;

			alien_x			: in alien_x_t;
			alien_y			: in alien_y_t;
			alien_collision : out alien_collision_t;
			alien_change	: out std_logic;

			alien_bullet_1_x			: in integer range -1 to 319;
			alien_bullet_1_y			: in integer range -1 to 239;
			alien_bullet_1_collision	: out std_logic);

end game_collision;

architecture behavioral of game_collision is

begin

	collision_p : process (clk)
	begin
		if rising_edge(clk) then

			turret_collision <= '0';
			turret_bullet_collision <= '0';
			alien_collision <= (others => '0');
			alien_change <= '0';
			alien_bullet_1_collision <= '0';

			-- check turret bullet collision with barriers
			for i in 0 to 3 loop
				if ((turret_bullet_x >= (44 + (i * 69))) and (turret_bullet_x < (68 + (i * 69)))) then
					if ((turret_bullet_y >= 190) and (turret_bullet_y < 206)) then
						turret_bullet_collision <= '1';
					end if;
				end if;
			end loop;

			-- check turret bullet collision with aliens
			for i in 0 to 39 loop
				if ((turret_bullet_x >= alien_x(i)) and (turret_bullet_x < (alien_x(i) + 12))) then
					if ((turret_bullet_y >= alien_y(i)) and (turret_bullet_y < (alien_y(i) + 8))) then
						if ((alien_x(i) /= -1) and (alien_y(i) /= -1)) then
							alien_collision(i) <= '1';
							turret_bullet_collision <= '1';
						end if;
					end if;
				end if;
			end loop;

			-- check if the alien swarm needs to change directions
			for i in 0 to 39 loop
				if (((alien_x(i) <= 7) or (alien_x(i) > 301)) and (alien_x(i) >= 0)) then
					alien_change <= '1';
				end if;
			end loop;

			-- check alien bullet 1 collision with barriers
			for i in 0 to 3 loop
				if ((alien_bullet_1_x >= (44 + (i * 69))) and (alien_bullet_1_x < (68 + (i * 69)))) then
					if ((alien_bullet_1_y >= 190) and (alien_bullet_1_y < 206)) then
						alien_bullet_1_collision <= '1';
					end if;
				end if;
			end loop;

			-- check alien bullet 1 collision with ship
			if ((alien_bullet_1_x >= turret_x) and (alien_bullet_1_x < (turret_x + 14))) then
				if (alien_bullet_1_y >= 232) then
					alien_bullet_1_collision <= '1';
					turret_collision <= '1';
				end if;
			end if;

		end if;
	end process;


end behavioral;