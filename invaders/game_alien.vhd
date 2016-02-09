library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity game_alien is

	generic (	start_x	: integer range 0 to 319;
				start_y	: integer range 0 to 239);

	port (	draw_clk	: in std_logic;
			game_clk 	: in std_logic;
			rst			: in std_logic;

			draw_x		: in integer range 0 to 319;
			draw_y		: in integer range 0 to 239;
			pixel		: out std_logic;

			alien_x		: out integer range -1 to 319;
			alien_y		: out integer range -1 to 239;
			collision	: in std_logic;

			change		: in std_logic;
			dead		: out std_logic);

end game_alien;

architecture behavioral of game_alien is

	type state_t is (s_left, s_right, s_dead);
	signal state : state_t;

	type sprite_t is array (7 downto 0) of std_logic_vector (10 downto 0);

	constant sprite_a : sprite_t := ("00100000100",
									 "00010001000",
									 "00111111100",
									 "01101110110",
									 "11111111111",
									 "10111111101",
									 "10100000101",
									 "00011011000");

	constant sprite_b : sprite_t := ("00100000100",
									 "10010001001",
									 "10111111101",
									 "11101110111",
									 "11111111111",
									 "01111111110",
									 "00100000100",
									 "01000000010");
	
	signal cx		: integer range 0 to 319;
	signal cy		: integer range 0 to 239;

	signal rx		: integer range -1 to 11;
	signal ry		: integer range -1 to 8;

	signal limit		: integer range 0 to 40;
	signal count 		: integer range 0 to 40;

	signal sprite 			: std_logic;
	signal sprite_switch	: integer range 0 to 30;

begin

	alien_x <= -1 when (state = s_dead) else cx;
	alien_y <= -1 when (state = s_dead) else cy;

	dead <= '1' when (state = s_dead) else '0';
	
	limit <= 2;

	--------------------------------------------------------------------------------------------------------------------
	-- UPDATE

	update_p : process (game_clk, rst)
	begin
		if (rst = '0') then

			state <= s_right;
			cx <= start_x;
			cy <= start_y;
			sprite <= '1';

		elsif rising_edge(game_clk) then

			if (sprite_switch = 30) then
				sprite_switch <= 0;
				sprite <= not sprite;
			else
				sprite_switch <= sprite_switch + 1;
			end if;

			case state is

				when s_left =>

					if (collision = '1') then
						state <= s_dead;
					elsif (change = '1') then
						state <= s_right;
						cx <= cx + 1;
						cy <= cy + 10;
						count <= 0;
					elsif (count = limit) then
						state <= s_left;
						cx <= cx - 1;
						cy <= cy;
						count <= 0;
					else
						state <= s_left;
						cx <= cx;
						cy <= cy;
						count <= count + 1;
					end if;

				when s_right =>

					if (collision = '1') then
						state <= s_dead;
					elsif (change = '1') then
						state <= s_left;
						cx <= cx - 1;
						cy <= cy + 10;
						count <= 0;
					elsif (count = limit) then
						state <= s_right;
						cx <= cx + 1;
						cy <= cy;
						count <= 0;
					else
						state <= s_right;
						cx <= cx;
						cy <= cy;
						count <= count + 1;
					end if;

				when s_dead =>

					state <= s_dead;

			end case;
		end if;
	end process;

	--------------------------------------------------------------------------------------------------------------------
	-- DRAW

	rx <= (draw_x - cx) when ((draw_x >= cx) and (draw_x <= (cx + 10))) else -1;
	ry <= (draw_y - cy) when ((draw_y >= cy) and (draw_y <= (cy + 7))) else -1;

	draw_p : process (draw_clk) --(rx, ry, state)
	begin
		if rising_edge(draw_clk) then
			if ((rx = -1) or (ry = -1) or (state = s_dead)) then
				pixel <= '0';
			else
				if (sprite = '1') then
					pixel <= sprite_a (7 - ry) (10 - rx);
				else
					pixel <= sprite_b (7 - ry) (10 - rx);
				end if;
			end if;
		end if;
	end process;

end behavioral;