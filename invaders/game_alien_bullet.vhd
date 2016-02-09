library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.game_package.all;

entity game_alien_bullet is

	port (	draw_clk 	: in std_logic;
			game_clk 	: in std_logic;
			rst			: in std_logic;

			draw_x		: in integer range 0 to 319;
			draw_y		: in integer range 0 to 239;
			pixel		: out std_logic;

			alien_bullet_x	: out integer range -1 to 319;
			alien_bullet_y	: out integer range -1 to 239;
			collision		: in std_logic;

			alien_x		: in alien_x_t;
			alien_y		: in alien_y_t;
			alien_dead	: in std_logic_vector (39 downto 0);

			random		: in integer range 0 to 63);

end game_alien_bullet;

architecture behavioral of game_alien_bullet is

	type state_t is (alive, dead);
	signal state : state_t;

	type sprite_t is array (3 downto 0) of std_logic_vector (2 downto 0);

	constant sprite_a : sprite_t := ("010",
									 "010",
									 "111",
									 "010");

	signal cx	: integer range 0 to 319;
	signal cy	: integer range 0 to 239;

	signal rx	: integer range -1 to 3;
	signal ry	: integer range -1 to 4;

begin

	alien_bullet_x <= -1 when (state /= alive) else cx;
	alien_bullet_y <= -1 when (state /= alive) else cy;

	--------------------------------------------------------------------------------------------------------------------
	-- UPDATE

	update_p : process (game_clk, rst)
	begin
		if (rst = '0') then

			state <= dead;

		elsif rising_edge(game_clk) then
			case state is

				when alive =>
					
					if (collision = '1') then
						state <= dead;
					elsif (cy > 232) then
						state <= dead;
					else
						cy <= cy + 2;
					end if;

				when dead =>

					if ((random < 40) and (alien_dead(random) = '0')) then
						state <= alive;
						cx <= alien_x(random) + 5;
						cy <= alien_y(random) + 8;
					end if;

			end case;
		end if;
	end process;

	--------------------------------------------------------------------------------------------------------------------
	-- DRAW

	rx <= (draw_x - cx) when ((draw_x >= cx) and (draw_x <= (cx + 2))) else -1;
	ry <= (draw_y - cy) when ((draw_y >= cy) and (draw_y <= (cy + 3))) else -1;

	draw_p : process (draw_clk)
	begin
		if rising_edge(draw_clk) then
			if ((rx = -1) or (ry = -1) or (state /= alive)) then
				pixel <= '0';
			else
				pixel <= sprite_a (3 - ry) (2 - rx);
			end if;
		end if;
	end process;

end behavioral;