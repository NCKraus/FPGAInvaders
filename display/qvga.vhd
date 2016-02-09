library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity qvga is
	
	port (	qvga_clk		: in std_logic;
			qvga_rst		: in std_logic;
			qvga_pixel		: in std_logic;

			qvga_x			: out integer range 0 to 319;
			qvga_y			: out integer range 0 to 239;
			qvga_h_blank	: out std_logic;
			qvga_v_blank	: out std_logic;

			qvga_r			: out std_logic_vector (3 downto 0);
			qvga_g			: out std_logic_vector (3 downto 0);
			qvga_b			: out std_logic_vector (3 downto 0);
			qvga_hs			: out std_logic;
			qvga_vs			: out std_logic);

end qvga;

architecture behavioral of qvga is

	constant H_ACTIVE		: integer := 639;
	constant H_FRONT_PORCH	: integer := 655;
	constant H_SYNC_PULSE	: integer := 751;
	constant H_BACK_PORCH	: integer := 799;

	constant V_ACTIVE		: integer := 479;
	constant V_FRONT_PORCH	: integer := 489;
	constant V_SYNC_PULSE	: integer := 491;
	constant V_BACK_PORCH	: integer := 524;

	signal x				: integer range 0 to 799;
	signal y				: integer range 0 to 524;
	
	signal active 			: std_logic;

begin

	qvga_x <= (x / 2) when (x <= H_ACTIVE) else 0;
	qvga_y <= (y / 2) when (y <= V_ACTIVE) else 0;
	qvga_h_blank <= '1' when (x > H_ACTIVE) else '0';
	qvga_v_blank <= '1' when (y > V_ACTIVE) else '0';

	qvga_r <= "1100" when ((qvga_pixel = '1') and (active = '1') and (y < 378)) else 
			  "0011" when ((qvga_pixel = '1') and (active = '1') and (y >= 378)) else 
			  "0001" when ((qvga_pixel = '0') and (active = '1')) else "0000";
	qvga_g <= "1100" when ((qvga_pixel = '1') and (active = '1') and (y < 378)) else 
			  "1111" when ((qvga_pixel = '1') and (active = '1') and (y >= 378)) else 
			  "0001" when ((qvga_pixel = '0') and (active = '1')) else "0000";
	qvga_b <= "1100" when ((qvga_pixel = '1') and (active = '1') and (y < 378)) else 
			  "0011" when ((qvga_pixel = '1') and (active = '1') and (y >= 378)) else 
			  "0001" when ((qvga_pixel = '0') and (active = '1')) else "0000";

	qvga_hs <= '0' when ((x > H_FRONT_PORCH) and (x <= H_SYNC_PULSE)) else '1';
	qvga_vs <= '0' when ((y > V_FRONT_PORCH) and (y <= H_SYNC_PULSE)) else '1';

	active <= '1' when ((x <= H_ACTIVE) and (y <= V_ACTIVE)) else '0';

	qvga_p : process (qvga_clk, qvga_rst)
	begin
		if (qvga_rst = '0') then
			x <= 0;
			y <= 0;
		elsif rising_edge(qvga_clk) then
			if ((x = H_BACK_PORCH) and (y = V_BACK_PORCH)) then
				x <= 0;
				y <= 0;
			elsif (x = H_BACK_PORCH) then
				x <= 0;
				y <= y + 1;
			else
				x <= x + 1;
				y <= y;
			end if;
		end if;
	end process;

end behavioral;