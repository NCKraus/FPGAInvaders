library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity wb_keyboard is
	
	port (  clk_i		: in std_logic;
			rst_i		: in std_logic;

			stb_i		: in std_logic;
			we_i		: in std_logic;
			ack_o		: out std_logic;
			irq_o		: out std_logic;
			adr_i		: in std_logic_vector (31 downto 0);
			dat_i		: in std_logic_vector (31 downto 0);
			dat_o		: out std_logic_vector (31 downto 0);

			ps2_clk 	: inout std_logic;
			ps2_data 	: inout std_logic);

end wb_keyboard;

architecture behavioral of wb_keyboard is

	type state_type is (start, data0, data1, data2, data3, data4, data5, data6, data7, parity, done);
	signal state : state_type;
	
	signal par			: std_logic;
	signal available	: std_logic;
	signal keyup		: std_logic;
	signal code			: std_logic_vector (7 downto 0);
	signal scancode		: std_logic_vector (7 downto 0);

	signal left		: std_logic;
	signal right 	: std_logic;
	signal fire 	: std_logic;
	signal reset 	: std_logic;
	signal pause 	: std_logic;

begin
	
	ps2_p : process (ps2_clk, rst_i)
	begin
		if (rst_i = '0') then
			state <= start;
			available <= '0';
		elsif falling_edge(ps2_clk) then
			case state is

				when start =>
					available <= '0';
					if (ps2_data = '0') then
						state <= data0;
						par <= '1';
					end if;

				when data0 =>
					code(0) <= ps2_data;
					par <= par xor ps2_data;
					state <= data1;

				when data1 =>
					code(1) <= ps2_data;
					par <= par xor ps2_data;
					state <= data2;

				when data2 =>
					code(2) <= ps2_data;
					par <= par xor ps2_data;
					state <= data3;

				when data3 =>
					code(3) <= ps2_data;
					par <= par xor ps2_data;
					state <= data4;

				when data4 =>
					code(4) <= ps2_data;
					par <= par xor ps2_data;
					state <= data5;

				when data5 =>
					code(5) <= ps2_data;
					par <= par xor ps2_data;
					state <= data6;

				when data6 =>
					code(6) <= ps2_data;
					par <= par xor ps2_data;
					state <= data7;

				when data7 =>
					code(7) <= ps2_data;
					par <= par xor ps2_data;
					state <= parity;

				when parity =>
					if (ps2_data = par) then
						state <= done;
					else
						state <= start;
					end if;

				when done =>
					if (ps2_data = '1') then
						available <= '1';
						scancode <= code;

						if (code = x"f0") then
							keyup <= '1';
						elsif (keyup = '1') then
							keyup <= '0';
							if (code = x"6b") then
								left <= '0';
							elsif (code = x"74") then
								right <= '0';
							elsif (code = x"29") then
								fire <= '0';
							elsif (code = x"76") then
								reset <= '0';
							elsif (code = x"5a") then
								pause <= '0';
							end if;
						elsif (code = x"6b") then
							left <= '1';
						elsif (code = x"74") then
							right <= '1';
						elsif (code = x"29") then
							fire <= '1';
						elsif (code = x"76") then
							reset <= '1';
						elsif (code = x"5a") then
							pause <= '1';
						end if;
					end if;
					state <= start;

			end case;
		end if;
	end process;

	wb_p : process (clk_i)
	begin
		if rising_edge(clk_i) then

			if ((stb_i = '1') and (we_i = '0')) then

				ack_o <= '1';
				dat_o (0) <= pause;
				dat_o (1) <= reset;
				dat_o (2) <= left;
				dat_o (3) <= right;
				dat_o (4) <= fire;
				dat_o (31 downto 5) <= (others => '0');

			else
				
				ack_o <= '0';

			end if;

		end if;
	end process;

end behavioral;