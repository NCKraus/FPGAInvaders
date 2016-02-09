library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity game_turret_bullet is

	port (	draw_clk	: in std_logic;
			game_clk 	: in std_logic;
			rst			: in std_logic;

			draw_x		: in integer range 0 to 319;
			draw_y		: in integer range 0 to 239;
			pixel		: out std_logic;

			turret_bullet_x	: out integer range -1 to 319;
			turret_bullet_y	: out integer range -1 to 239;
			collision		: in std_logic;

			turret_x	: in integer range -1 to 319;
			turret_y	: in integer range -1 to 239;

			keycode 	: in std_logic_vector (4 downto 0));

end game_turret_bullet;

architecture behavioral of game_turret_bullet is

	type state_t is (alive, dead);
	signal state : state_t;

	type sprite_t is array (3 downto 0) of std_logic_vector (0 downto 0);

	constant sprite_a : sprite_t := ("1",
									 "1",
									 "1",
									 "1");

	signal cx	: integer range 0 to 319;
	signal cy	: integer range 0 to 239;

	signal rx	: integer range -1 to 1;
	signal ry	: integer range -1 to 4;

begin

	turret_bullet_x <= -1 when (state = dead) else cx;
	turret_bullet_y <= -1 when (state = dead) else cy;

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
					elsif (cy < 4) then
						state <= dead;
					else
						cy <= cy - 4;
					end if;

				when dead =>

					if (keycode(4) = '1') then
						state <= alive;
						cx <= turret_x + 7;
						cy <= 230;
					end if;

			end case;
		end if;
	end process;

	--------------------------------------------------------------------------------------------------------------------
	-- DRAW

	rx <= (draw_x - cx) when ((draw_x >= cx) and (draw_x <= cx)) else -1;
	ry <= (draw_y - cy) when ((draw_y >= cy) and (draw_y <= (cy + 3))) else -1;

	draw_p : process (draw_clk)
	begin
		if rising_edge(draw_clk) then
			if ((rx = -1) or (ry = -1) or (state = dead)) then
				pixel <= '0';
			else
				pixel <= sprite_a (3 - ry) (rx);
			end if;
		end if;
	end process;

end behavioral;