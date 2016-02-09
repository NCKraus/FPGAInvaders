library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity display_ram is

	port (  clk_a		: in std_logic;
			en_a 		: in std_logic;
			we_a		: in std_logic;
			addr_a		: in std_logic_vector (11 downto 0);
			data_i_a	: in std_logic_vector (31 downto 0);
			data_o_a	: out std_logic_vector (31 downto 0);

			clk_b		: in std_logic;
			en_b 		: in std_logic;
			we_b		: in std_logic;
			addr_b		: in std_logic_vector (11 downto 0);
			data_i_b	: in std_logic_vector (31 downto 0);
			data_o_b	: out std_logic_vector (31 downto 0));

end display_ram;

architecture behavioral of display_ram is

	type ram_t is array (2399 downto 0) of std_logic_vector (31 downto 0);
	shared variable ram_e : ram_t := (x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"FFFFFFFF", x"FFFFFFFF", x"FFFFFFFF", x"FFFFFFFF", x"FFFFFFFF", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"FFFFFFFF", x"FFFFFFFF", x"FFFFFFFF", x"FFFFFFFF", x"FFFFFFFF", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"FFFFFFFF", x"FFFFFFFF", x"FFFFFFFF", x"FFFFFFFF", x"FFFFFFFF", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"FFFFFFFF", x"FFFFFFFF", x"FFFFFFFF", x"FFFFFFFF", x"FFFFFFFF", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"FFFFFFFF", x"FFFFFFFF", x"FFFFFFFF", x"FFFFFFFF", x"FFFFFFFF", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"FFFFFFFF", x"FFFFFFFF", x"FFFFFFFF", x"FFFFFFFF", x"FFFFFFFF", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"FFFFFFFF", x"FFFFFFFF", x"FFFFFFFF", x"FFFFFFFF", x"FFFFFFFF", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"FFFFFFFF", x"FFFFFFFF", x"FFFFFFFF", x"FFFFFFFF", x"FFFFFFFF", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"FFFFFFFF", x"FFFFFFFF", x"FFFFFFFF", x"FFFFFFFF", x"FFFFFFFF", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"FFFFFFFF", x"FFFFFFFF", x"FFFFFFFF", x"FFFFFFFF", x"FFFFFFFF", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"FFFFFFFF", x"FFFFFFFF", x"FFFFFFFF", x"FFFFFFFF", x"FFFFFFFF", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"FFFFFFFF", x"FFFFFFFF", x"FFFFFFFF", x"FFFFFFFF", x"FFFFFFFF", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"FFFFFFFF", x"FFFFFFFF", x"FFFFFFFF", x"FFFFFFFF", x"FFFFFFFF", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"FFFFFFFF", x"FFFFFFFF", x"FFFFFFFF", x"FFFFFFFF", x"FFFFFFFF", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"FFFFFFFF", x"FFFFFFFF", x"FFFFFFFF", x"FFFFFFFF", x"FFFFFFFF", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"FFFFFFFF", x"FFFFFFFF", x"FFFFFFFF", x"FFFFFFFF", x"FFFFFFFF", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"FFFFFFFF", x"FFFFFFFF", x"FFFFFFFF", x"FFFFFFFF", x"FFFFFFFF", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"FFFFFFFF", x"FFFFFFFF", x"FFFFFFFF", x"FFFFFFFF", x"FFFFFFFF", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"FFFFFFFF", x"FFFFFFFF", x"FFFFFFFF", x"FFFFFFFF", x"FFFFFFFF", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000",
									  x"FFFFFFFF", x"FFFFFFFF", x"FFFFFFFF", x"FFFFFFFF", x"FFFFFFFF", x"00000000", x"00000000", x"00000000", x"00000000", x"00000000");

begin

	port_a_p : process (clk_a)
	begin
		if rising_edge(clk_a) then
			if (en_a = '1') then
				if (we_a = '1') then
					ram_e(to_integer(unsigned(addr_a))) := data_i_a;
				else
					data_o_a <= ram_e(to_integer(unsigned(addr_a)));
				end if;
			end if;
		end if;
	end process;

	port_b_p : process (clk_b)
	begin
		if rising_edge(clk_b) then
			if (en_b = '1') then
				if (we_b = '1') then
					ram_e(to_integer(unsigned(addr_b))) := data_i_b;
				else
					data_o_b <= ram_e(to_integer(unsigned(addr_b)));
				end if;
			end if;
		end if;
	end process;

end behavioral;