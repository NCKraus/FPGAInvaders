library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity wb_display is
	
	port (  clk_i		: in std_logic;
			pixel_clk_i	: in std_logic;
			rst_i		: in std_logic;

			stb_i		: in std_logic;
			we_i		: in std_logic;
			ack_o		: out std_logic;
			irq_o		: out std_logic;
			adr_i		: in std_logic_vector (31 downto 0);
			dat_i		: in std_logic_vector (31 downto 0);
			dat_o		: out std_logic_vector (31 downto 0);

			vga_r	 	: out std_logic_vector (3 downto 0);
			vga_g	 	: out std_logic_vector (3 downto 0);
			vga_b	 	: out std_logic_vector (3 downto 0);
			vga_hs	 	: out std_logic;
			vga_vs	 	: out std_logic;
			
			led		: out std_logic_vector (7 downto 0));

end wb_display;

architecture behavioral of wb_display is

	type wb_state_t is (wb_idle, wb_irq, wb_read, wb_ram_write);
	signal wb_state : wb_state_t;

	type disp_state_t is (disp_active, disp_h_blank, disp_ram_read1, disp_ram_read2, disp_buff_write, disp_inc_block, disp_wait);
	signal disp_state : disp_state_t;

	signal x		: integer range 0 to 319;
	signal y		: integer range 0 to 239;
	signal h_blank	: std_logic;
	signal v_blank	: std_logic;
	signal pixel	: std_logic;

	signal ram_en_a		: std_logic;
	signal ram_we_a		: std_logic;
	signal ram_addr_a 	: std_logic_vector (11 downto 0);
	signal ram_data_i_a	: std_logic_vector (31 downto 0);
	signal ram_data_o_a : std_logic_vector (31 downto 0);

	signal ram_en_b		: std_logic;
	signal ram_we_b		: std_logic;
	signal ram_addr_b 	: std_logic_vector (11 downto 0);
	signal ram_data_i_b : std_logic_vector (31 downto 0);
	signal ram_data_o_b : std_logic_vector (31 downto 0);

	signal disp_buffer 	: std_logic_vector (319 downto 0);
	signal disp_rev		: std_logic_vector (31 downto 0);
	signal disp_block	: integer range 0 to 9;


begin

	ram_e : entity work.display_ram
		port map (	clk_a => pixel_clk_i,
					en_a => ram_en_a,
					we_a => ram_we_a,
					addr_a => ram_addr_a,
					data_i_a => ram_data_i_a,
					data_o_a => ram_data_o_a,
					
					clk_b => clk_i,
					en_b => ram_en_b,
					we_b => ram_we_b,
					addr_b => ram_addr_b,
					data_i_b => ram_data_i_b,
					data_o_b => ram_data_o_b);

	vga_e : entity work.qvga
		port map (	qvga_clk => pixel_clk_i,
					qvga_rst => rst_i,
					qvga_pixel => pixel,

					qvga_x => x,
					qvga_y => y,
					qvga_h_blank => h_blank,
					qvga_v_blank => v_blank,

					qvga_r => vga_r,
					qvga_g => vga_g,
					qvga_b => vga_b,
					qvga_hs => vga_hs,
					qvga_vs => vga_vs);

	wb_fsm_p : process (clk_i, rst_i)
	begin
		if (rst_i = '0') then

			wb_state <= wb_idle;
			ram_en_b <= '0';
			ack_o <= '0';

		elsif rising_edge(clk_i) then
			case wb_state is

				when wb_idle =>

					if (v_blank = '1') then

						wb_state <= wb_irq;
						irq_o <= '1';
						ack_o <= '0';

					else
						
						wb_state <= wb_idle;
						ram_en_b <= '0';
						ack_o <= '0';

					end if;

				when wb_irq =>

					wb_state <= wb_read;
					ram_en_b <= '1';
					ram_we_b <= '1';
					ram_addr_b <= adr_i (11 downto 0);
					ram_data_i_b <= dat_i;
					ack_o <= '0';

				when wb_read =>

					if (v_blank = '0') then

						wb_state <= wb_idle;
						ram_en_b <= '0';
						ack_o <= '0';
						irq_o <= '0';

					elsif ((stb_i = '1') and (we_i = '1')) then

						wb_state <= wb_ram_write;
						ram_en_b <= '1';
						ram_we_b <= '1';
						ram_addr_b <= adr_i (11 downto 0);
						ram_data_i_b <= dat_i;
						ack_o <= '1';
						irq_o <= '0';

					else
						
						wb_state <= wb_read;
						ram_en_b <= '1';
						ram_we_b <= '1';
						ram_addr_b <= adr_i (11 downto 0);
						ram_data_i_b <= dat_i;
						ack_o <= '0';

					end if;

				when wb_ram_write =>

					wb_state <= wb_read;
					ram_en_b <= '1';
					ram_we_b <= '1';
					ack_o <= '0';
					irq_o <= '0';

			end case;
		end if;
	end process;

	disp_fsm_p : process (pixel_clk_i, rst_i)
	begin
		if (rst_i = '0') then

			disp_state <= disp_active;
			pixel <= disp_buffer(x + 1);
			ram_en_a <= '0';

		elsif rising_edge(pixel_clk_i) then
			case disp_state is

				when disp_active =>

					if ((h_blank = '1') and (v_blank = '0')) then

						disp_state <= disp_h_blank;
						disp_block <= 0;
						ram_en_a <= '1';
						ram_we_a <= '0';
						ram_addr_a <= std_logic_vector(to_unsigned((((y + 1) * 10) + disp_block), 12));

					else

						disp_state <= disp_active;
						pixel <= disp_buffer(x + 1);
						ram_en_a <= '0';
						
					end if;

				when disp_h_blank =>

					disp_state <= disp_ram_read1;
					ram_en_a <= '1';
					ram_we_a <= '0';
					ram_addr_a <= std_logic_vector(to_unsigned((((y + 1) * 10) + disp_block), 12));

				when disp_ram_read1 =>

					disp_state <= disp_ram_read2;
					ram_en_a <= '1';
					ram_we_a <= '0';
					ram_addr_a <= std_logic_vector(to_unsigned((((y + 1) * 10) + disp_block), 12));

				when disp_ram_read2 =>

					disp_state <= disp_buff_write;
					ram_en_a <= '0';

					--for i in ram_data_o_a'range loop
					--	disp_rev(i) <= ram_data_o_a(31 - i);
					--end loop;

					case disp_block is
						when 0 => disp_buffer (31 downto 0) <= ram_data_o_a;
						when 1 => disp_buffer (63 downto 32) <= ram_data_o_a;
						when 2 => disp_buffer (95 downto 64) <= ram_data_o_a;
						when 3 => disp_buffer (127 downto 96) <= ram_data_o_a;
						when 4 => disp_buffer (159 downto 128) <= ram_data_o_a;
						when 5 => disp_buffer (191 downto 160) <= ram_data_o_a;
						when 6 => disp_buffer (223 downto 192) <= ram_data_o_a;
						when 7 => disp_buffer (255 downto 224) <= ram_data_o_a;
						when 8 => disp_buffer (287 downto 256) <= ram_data_o_a;
						when 9 => disp_buffer (319 downto 288) <= ram_data_o_a;
					end case;

				when disp_buff_write =>

					if (disp_block = 9) then

						disp_state <= disp_wait;
						ram_en_a <= '0';

					else

						disp_state <= disp_inc_block;
						disp_block <= disp_block + 1;

					end if;

				when disp_inc_block =>

					disp_state <= disp_h_blank;
					ram_en_a <= '1';
					ram_we_a <= '0';
					ram_addr_a <= std_logic_vector(to_unsigned((((y + 1) * 10) + disp_block), 12));

				when disp_wait =>

					if (h_blank = '0') then

						disp_state <= disp_active;
						pixel <= disp_buffer(x + 1);
						ram_en_a <= '0';

					else
						
						disp_state <= disp_wait;
						ram_en_a <= '0';

					end if;

			end case;
		end if;
	end process;

end behavioral;