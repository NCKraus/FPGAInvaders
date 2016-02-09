library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity game_barrier is

	generic (	cx		: integer range 0 to 319;
				cy		: integer range 0 to 239);

	port (	draw_clk 	: in std_logic;

			draw_x		: in integer range 0 to 319;
			draw_y		: in integer range 0 to 239;
			pixel		: out std_logic);

end game_barrier;

architecture behavioral of game_barrier is

	type sprite_t is array (15 downto 0) of std_logic_vector (23 downto 0);

	constant sprite_a : sprite_t := ("000000111111111111000000",
									 "000000111111111111000000",
									 "000011111111111111110000",
									 "000011111111111111110000",
									 "001111111111111111111100",
									 "001111111111111111111100",
									 "111111111111111111111111",
									 "111111111111111111111111",
									 "111111111111111111111111",
									 "111111111111111111111111",
									 "111111111111111111111111",
									 "111111111100001111111111",
									 "111111110000000011111111",
									 "111111110000000011111111",
									 "111111000000000000111111",
									 "111111000000000000111111");

	signal rx	: integer range -1 to 24;
	signal ry	: integer range -1 to 16;

begin

	--------------------------------------------------------------------------------------------------------------------
	-- DRAW

	rx <= (draw_x - cx) when ((draw_x >= cx) and (draw_x <= (cx + 23))) else -1;
	ry <= (draw_y - cy) when ((draw_y >= cy) and (draw_y <= (cy + 15))) else -1;

	draw_p : process (draw_clk)
	begin
		if rising_edge(draw_clk) then
			if ((rx = -1) or (ry = -1)) then
				pixel <= '0';
			else
				pixel <= sprite_a (15 - ry) (23 - rx);
			end if;
		end if;
	end process;

end behavioral;