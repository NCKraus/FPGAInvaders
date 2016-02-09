library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity wb_buttons is
	
	port (  clk_i		: in std_logic;
			rst_i		: in std_logic;

			stb_i		: in std_logic;
			we_i		: in std_logic;
			ack_o		: out std_logic;
			irq_o		: out std_logic;
			adr_i		: in std_logic_vector (31 downto 0);
			dat_i		: in std_logic_vector (31 downto 0);
			dat_o		: out std_logic_vector (31 downto 0);

			buttons 	: in std_logic_vector (4 downto 0));

end wb_buttons;

architecture behavioral of wb_buttons is

	signal a1, a2, a3, a4, a5 	: std_logic;
	signal b1, b2, b3, b4, b5 	: std_logic;
	signal c1, c2, c3, c4, c5 	: std_logic;

	signal up		: std_logic;
	signal down 	: std_logic;
	signal left 	: std_logic;
	signal right 	: std_logic;
	signal center 	: std_logic;
	
	signal clear	: std_logic;

begin

	process (clk_i, rst_i)
	begin
		if (rst_i = '0') then
			ack_o <= '0';
			up <= '0';
			down <= '0';
			left <= '0';
			right <= '0';
			center <= '0';
		elsif rising_edge(clk_i) then

			a1 <= buttons(0);
			b1 <= a1;
			c1 <= b1;

			a2 <= buttons(1);
			b2 <= a2;
			c2 <= b2;

			a3 <= buttons(2);
			b3 <= a3;
			c3 <= b3;

			a4 <= buttons(3);
			b4 <= a4;
			c4 <= b4;

			a5 <= buttons(4);
			b5 <= a5;
			c5 <= b5;
			
			if (clear = '1') then
			
				clear <= '0';
				up <= '0';
				down <= '0';
				left <= '0';
				right <= '0';
				center <= '0';
				ack_o <= '0';

			elsif ((stb_i = '1') and (we_i = '0')) then
			
				ack_o <= '1';
				clear <= '1';
				dat_o (0) <= up;
				dat_o (1) <= down;
				dat_o (2) <= left;
				dat_o (3) <= right;
				dat_o (4) <= center;
				dat_o (31 downto 5) <= (others => '0');
				
			else
			
				if ((a1 and b1 and (not c1)) = '1') then
					up <= '1';
				end if;
				if ((a2 and b2 and c2) = '1') then
					down <= '1';
				end if;
				if ((a3 and b3 and c3) = '1') then
					left <= '1';
				end if;
				if ((a4 and b4 and c4) = '1') then
					right <= '1';
				end if;
				if ((a5 and b5 and c5) = '1') then
					center <= '1';
				end if;
				ack_o <= '0';
				
			end if;
		end if;
	end process;

end behavioral;