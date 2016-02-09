library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity invaders_ram is

	port (  clk		: in std_logic;
			we		: in std_logic;
			addr	: in std_logic_vector (11 downto 0);
			data_i	: in std_logic_vector (31 downto 0);
			data_o	: out std_logic_vector (31 downto 0));

end invaders_ram;

architecture behavioral of invaders_ram is

	type ram_t is array (2399 downto 0) of std_logic_vector (31 downto 0);
	signal ram_e : ram_t := (others => (others => '0'));

begin

	ram_p : process (clk)
	begin
		if rising_edge(clk) then
			if (we = '1') then
				ram_e(to_integer(unsigned(addr))) <= data_i;
			else
				data_o <= ram_e(to_integer(unsigned(addr)));
			end if;
		end if;
	end process;

end behavioral;