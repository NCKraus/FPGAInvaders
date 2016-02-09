library ieee;
use ieee.std_logic_1164.all;

entity wb_interconnect is
	
	port (	cyc_o_m : in std_logic;
			stb_o_m : in std_logic;
			stb_i_s : out std_logic_vector (15 downto 0);
			we_o_m : in std_logic;
			we_i_s : out std_logic_vector (15 downto 0);
			ack_i_m : out std_logic;
			ack_o_s : in std_logic_vector (15 downto 0);
			irq_i_m : out std_logic;
			irqv_i_m : out std_logic_vector (3 downto 0);
			irq_o_s : in std_logic_vector (15 downto 0);
			adr_o_m : in std_logic_vector (31 downto 0);
			adr_i_s : out std_logic_vector (31 downto 0);
			dat_o_m : in std_logic_vector (31 downto 0);
			dat_i_s : out std_logic_vector (31 downto 0);
			dat_i_m : out std_logic_vector (31 downto 0);
			dat_o_s : in std_logic_vector (31 downto 0);
			
			led : out std_logic_vector (7 downto 0));

end wb_interconnect;

architecture behavioral of wb_interconnect is

	signal slave : std_logic_vector (15 downto 0);

begin

	-- stb active slave when master cyc and stb are true
	stb_i_s <= slave when ((cyc_o_m = '1') and (stb_o_m = '1')) else x"0000";

	-- we active slave when master cyc and we are true
	we_i_s <= slave when ((cyc_o_m = '1') and (we_o_m = '1')) else x"0000";

	-- ack master when master cyc and stb are true and slave ack equals active slave
	ack_i_m <= '1' when ((cyc_o_m = '1') and (ack_o_s = slave)) else '0';

	-- irq master when any slave irq is active
	--irq_i_m <= '1' when ((irq_o_s <= x"0001") or
	--			   		 (irq_o_s <= x"0002") or
	--			   		 (irq_o_s <= x"0004") or
	--			   		 (irq_o_s <= x"0008") or
	--			   		 (irq_o_s <= x"0010") or
	--			   		 (irq_o_s <= x"0020") or
	--			   		 (irq_o_s <= x"0040") or
	--			   		 (irq_o_s <= x"0080") or
	--			   		 (irq_o_s <= x"0100") or
	--			   		 (irq_o_s <= x"0200") or
	--			   		 (irq_o_s <= x"0400") or
	--			   		 (irq_o_s <= x"0800") or
	--			   		 (irq_o_s <= x"1000") or
	--			   		 (irq_o_s <= x"2000") or
	--			   		 (irq_o_s <= x"4000") or
	--			   		 (irq_o_s <= x"8000")) else '0'; 
	irq_i_m <= '1' when (irq_o_s /= x"0000") else '0';

	-- slave adr in is master adr out
	adr_i_s <= adr_o_m;

	-- slave dat in is master dat out
	dat_i_s <= dat_o_m;

	-- master dat in is slave dat out
	dat_i_m <= dat_o_s;

	-- one hot active slave process
	slave_p : process (adr_o_m)
	begin
		case adr_o_m (31 downto 28) is
			when "0000" => slave <= x"0001";
			when "0001" => slave <= x"0002";
			when "0010" => slave <= x"0004";
			when "0011" => slave <= x"0008";
			when "0100" => slave <= x"0010";
			when "0101" => slave <= x"0020";
			when "0110" => slave <= x"0040";
			when "0111" => slave <= x"0080";
			when "1000" => slave <= x"0100";
			when "1001" => slave <= x"0200";
			when "1010" => slave <= x"0400";
			when "1011" => slave <= x"0800";
			when "1100" => slave <= x"1000";
			when "1101" => slave <= x"2000";
			when "1110" => slave <= x"4000";
			when "1111" => slave <= x"8000";
			when others => slave <= x"0000";
		end case;
	end process;

	-- irq vector from slave irq out process
	irqv_p : process (irq_o_s)
	begin
		case irq_o_s is
			when x"0001" => irqv_i_m <= "0000";
			when x"0002" => irqv_i_m <= "0001";
			when x"0004" => irqv_i_m <= "0010";
			when x"0008" => irqv_i_m <= "0011";
			when x"0010" => irqv_i_m <= "0100";
			when x"0020" => irqv_i_m <= "0101";
			when x"0040" => irqv_i_m <= "0110";
			when x"0080" => irqv_i_m <= "0111";
			when x"0100" => irqv_i_m <= "1000";
			when x"0200" => irqv_i_m <= "1001";
			when x"0400" => irqv_i_m <= "1010";
			when x"0800" => irqv_i_m <= "1011";
			when x"1000" => irqv_i_m <= "1100";
			when x"2000" => irqv_i_m <= "1101";
			when x"4000" => irqv_i_m <= "1110";
			when x"8000" => irqv_i_m <= "1111";
			when others => irqv_i_m <= "0000";
		end case;
	end process;

end behavioral;