library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity game_turret is

	port (	draw_clk 	: in std_logic;
			game_clk 	: in std_logic;
			rst			: in std_logic;

			draw_x		: in integer range 0 to 319;
			draw_y		: in integer range 0 to 239;
			pixel		: out std_logic;

			turret_x	: out integer range -1 to 319;
			turret_y	: out integer range -1 to 239;
			collision	: in std_logic;

			keycode 	: in std_logic_vector (4 downto 0);
			turret_dead	: out std_logic);

end game_turret;

architecture behavioral of game_turret is

	type state_t is (alive, dead);
	signal state : state_t;

	type sprite_t is array (7 downto 0) of std_logic_vector (14 downto 0);

	constant sprite_a : sprite_t := ("000000010000000",
									 "000000111000000",
									 "000000111000000",
									 "011111111111110",
									 "111111111111111",
									 "111111111111111",
									 "111111111111111",
									 "111111111111111");
	
	signal cx		: integer range 0 to 319;
	signal cy		: integer range 0 to 239;

	signal rx		: integer range -1 to 15;
	signal ry		: integer range -1 to 8;

begin

	cy <= 230;
	turret_x <= cx;
	turret_y <= cy;
	
	turret_dead <= '1' when (state = dead) else '0';

	--------------------------------------------------------------------------------------------------------------------
	-- UPDATE

	update_p : process (game_clk, rst)
	begin
		if (rst = '0') then

			state <= alive;
			cx <= 5;

		elsif rising_edge(game_clk) then
			case state is

				when alive =>

					if (collision = '1') then
						state <= dead;
					elsif ((keycode(2) = '1') and (cx <= 1)) then
						cx <= 1;
					elsif (keycode(2) = '1') then
						cx <= cx - 1;
					elsif ((keycode(3) = '1') and (cx >= 305)) then
						cx <= 305;
					elsif (keycode(3) = '1') then
						cx <= cx + 1;
					end if;

				when dead =>

					state <= dead;

			end case;
		end if;
	end process;

	--------------------------------------------------------------------------------------------------------------------
	-- DRAW

	rx <= (draw_x - cx) when ((draw_x >= cx) and (draw_x <= (cx + 14))) else -1;
	ry <= (draw_y - cy) when ((draw_y >= cy) and (draw_y <= (cy + 7))) else -1;

	draw_p : process (draw_clk)
	begin
		if rising_edge(draw_clk) then
			if ((rx = -1) or (ry = -1)) then
				pixel <= '0';
			else
				pixel <= sprite_a (7 - ry) (14 - rx);
			end if;
		end if;
	end process;

end behavioral;