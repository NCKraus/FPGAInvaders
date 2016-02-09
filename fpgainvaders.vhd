library ieee;
use ieee.std_logic_1164.all;

entity fpgainvaders is
	port (  VGA_R 		: out std_logic_vector (3 downto 0);
			VGA_G 		: out std_logic_vector (3 downto 0);
			VGA_B 		: out std_logic_vector (3 downto 0);
			VGA_HS 		: out std_logic;
			VGA_VS 		: out std_logic;

			BTNC		: in std_logic;
			BTNU		: in std_logic;
			BTNL		: in std_logic;
			BTNR		: in std_logic;
			BTND		: in std_logic;
			
			PS2_CLK		: inout std_logic;
			PS2_DATA	: inout std_logic;
			
			LED			: out std_logic_vector (15 downto 0);
			
			CLK100MHZ 	: in std_logic;
			CPU_RESETN	: in std_logic);
end fpgainvaders;

architecture behavioral of fpgainvaders is

	-- Clock Management Tile
	component master_clk_tile is
		port (  clk100_i 	: in std_logic;
				clk100_o	: out std_logic;
				clk25_o 	: out std_logic);
	end component;

	-- System signals
	signal clk_100		: std_logic;
	signal clk_25		: std_logic;
	signal rst 			: std_logic;
	
	signal buttons		: std_logic_vector (4 downto 0);

	-- Wishbone signals

	signal cyc_o_m  	: std_logic;
	signal stb_o_m  	: std_logic;
	signal stb_i_s  	: std_logic_vector (15 downto 0);
	signal we_o_m  		: std_logic;
	signal we_i_s  		: std_logic_vector (15 downto 0);
	signal ack_i_m  	: std_logic;
	signal ack_o_s  	: std_logic_vector (15 downto 0);
	signal irq_i_m 		: std_logic;
	signal irqv_i_m  	: std_logic_vector (3 downto 0);
	signal irq_o_s  	: std_logic_vector (15 downto 0);
	signal adr_o_m  	: std_logic_vector (31 downto 0);
	signal adr_i_s  	: std_logic_vector (31 downto 0);
	signal dat_o_m  	: std_logic_vector (31 downto 0);
	signal dat_i_s  	: std_logic_vector (31 downto 0);
	signal dat_i_m  	: std_logic_vector (31 downto 0);
	signal dat_o_s  	: std_logic_vector (31 downto 0);

begin

	rst <= cpu_resetn;
	
	--buttons(0) <= btnu;
	--buttons(1) <= btnd;
	--buttons(2) <= btnl;
	--buttons(3) <= btnr;
	--buttons(4) <= btnc;

	master_clk_e : master_clk_tile
		port map (  clk100_i => clk100mhz,
					clk100_o => clk_100,
					clk25_o => clk_25);

	-- wishbone interconnect
	wb_interconnect_e : entity work.wb_interconnect
		port map (  cyc_o_m => cyc_o_m,
					stb_o_m => stb_o_m,
					stb_i_s => stb_i_s,
					we_o_m => we_o_m,
					we_i_s => we_i_s,
					ack_i_m => ack_i_m,
					ack_o_s => ack_o_s,
					irq_i_m => irq_i_m,
					irqv_i_m => irqv_i_m,
					irq_o_s => irq_o_s,
					adr_o_m => adr_o_m,
					adr_i_s => adr_i_s,
					dat_o_m => dat_o_m,
					dat_i_s => dat_i_s,
					dat_i_m => dat_i_m,
					dat_o_s => dat_o_s);

	-- wishbone master
	wb_invaders_e : entity work.wb_invaders
		port map (  clk_i => clk_100,
					rst_i => rst,

					cyc_o => cyc_o_m,
					stb_o => stb_o_m,
					we_o => we_o_m,
					ack_i => ack_i_m,
					irq_i => irq_i_m,
					irqv_i => irqv_i_m,
					adr_o => adr_o_m,
					dat_o => dat_o_m,
					dat_i => dat_i_m,
					
					led => led (7 downto 0));

	-- wishbone slave 0
	wb_display_e : entity work.wb_display
		port map ( 	clk_i => clk_100,
					pixel_clk_i => clk_25,
					rst_i => rst,

					stb_i => stb_i_s(0),
					we_i => we_i_s(0),
					ack_o => ack_o_s(0),
					irq_o => irq_o_s(0),
					adr_i => adr_i_s,
					dat_i => dat_i_s,
					dat_o => dat_o_s,

					vga_r => vga_r,
					vga_g => vga_g,
					vga_b => vga_b,
					vga_hs => vga_hs,
					vga_vs => vga_vs);
					
	-- wishbone slave 1
	
	wb_keyboard_e : entity work.wb_keyboard
		port map (	clk_i => clk_100,
					rst_i => rst,
					
					stb_i => stb_i_s(1),
					we_i => we_i_s(1),
					ack_o => ack_o_s(1),
					irq_o => irq_o_s(1),
					adr_i => adr_i_s,
					dat_i => dat_i_s,
					dat_o => dat_o_s,
					
					ps2_clk => ps2_clk,
					ps2_data => ps2_data);
	
--	wb_buttons_e : entity work.wb_buttons
--		port map (	clk_i => clk_100,
--					rst_i => rst,
					
--					stb_i => stb_i_s(1),
--					we_i => we_i_s(1),
--					ack_o => ack_o_s(1),
--					irq_o => irq_o_s(1),
--					adr_i => adr_i_s,
--					dat_i => dat_i_s,
--					dat_o => dat_o_s,
					
--					buttons => buttons);
					
end behavioral;