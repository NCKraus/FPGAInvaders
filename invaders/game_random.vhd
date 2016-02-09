library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity game_random is

	port (	clk		: in std_logic;
			rst		: in std_logic;

			keycode	: in std_logic_vector (4 downto 0);
			random 	: out integer range 0 to 63);

end game_random;

architecture behavioral of game_random is

	signal lsfr 	: std_logic_vector (31 downto 0);
	signal feedback : std_logic;
	signal divide	: std_logic_vector (31 downto 0);

begin

	feedback <= lsfr(31) xor lsfr(29) xor lsfr(25) xor lsfr(24);
	random <= to_integer(unsigned(lsfr) / 67108864);

	process (clk)
	begin
		if (rst = '0') then
			lsfr <= x"030b5109";
		elsif rising_edge(Clk) then
			lsfr <= feedback & lsfr (31 downto 1);
		end if;
	end process;

end behavioral;