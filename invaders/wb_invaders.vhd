library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity wb_invaders is

	port (  clk_i 	: in std_logic;
			rst_i 	: in std_logic;

			cyc_o	: out std_logic;
			stb_o 	: out std_logic;
			we_o 	: out std_logic;
			ack_i 	: in std_logic;
			irq_i 	: in std_logic;
			irqv_i 	: in std_logic_vector (3 downto 0);
			adr_o 	: out std_logic_vector (31 downto 0);
			dat_o 	: out std_logic_vector (31 downto 0);
			dat_i 	: in std_logic_vector (31 downto 0);
			
			led		: out std_logic_vector (7 downto 0));

end wb_invaders;

architecture behavioral of wb_invaders is

	type state_t is (idle, read_ram1, read_ram2, write_disp, inc_ptr1, read_input, game_update, read_pixel, write_buffer, write_ram, inc_ptr2);
	signal state : state_t;

	signal ram_we		: std_logic;
	signal ram_addr 	: std_logic_vector (11 downto 0);
	signal ram_data_i 	: std_logic_vector (31 downto 0);
	signal ram_data_o	: std_logic_vector (31 downto 0);
	signal ram_buffer 	: std_logic_vector (31 downto 0);
	
	signal b 			: integer range 0 to 9;
	signal x			: integer range 0 to 319;
	signal y			: integer range 0 to 239;

	signal update_start : std_logic;
	signal update_done 	: std_logic;

	signal pixel 		: std_logic;
	
	signal keycode		: std_logic_vector (4 downto 0);

begin

	led(0) <= '1' when (state = idle) else '0';
	led(1) <= '1' when (state = write_disp) else '0';
	led(2) <= '1' when (state = game_update) else '0';
	led(3) <= '1' when (state = read_pixel) else '0';
	led(4) <= '1' when (state = write_ram) else '0';

	ram_e : entity work.invaders_ram
		port map (	clk => clk_i,
					we => ram_we,
					addr => ram_addr,
					data_i => ram_data_i,
					data_o => ram_data_o);

	game_e : entity work.invaders_game
		port map (	clk => clk_i,
					rst => rst_i,

					update_start => update_start,
					update_done => update_done,

					draw_x => x,
					draw_y => y,
					pixel => pixel,

					keycode => keycode);

	process (clk_i, rst_i) 
	begin
		if (rst_i = '0') then

			state <= idle;
			cyc_o <= '0';
			ram_we <= '0';
			b <= 0;
			x <= 0;
			y <= 0;

		elsif rising_edge(clk_i) then
			case state is

				when idle =>

					if (irq_i = '1') then

						state <= read_ram1;
						cyc_o <= '0';
						ram_we <= '0';
						ram_addr <= std_logic_vector(to_unsigned(((y * 10) + b), 12));

					else
						
						state <= idle;
						cyc_o <= '0';
						ram_we <= '0';
						b <= 0;
						x <= 0;
						y <= 0;

					end if;

				when read_ram1 =>

					state <= read_ram2;
					cyc_o <= '0';
					ram_we <= '0';
					ram_addr <= std_logic_vector(to_unsigned(((y * 10) + b), 12));

				when read_ram2 =>

					state <= write_disp;
					cyc_o <= '1';
					stb_o <= '1';
					we_o <= '1';
					adr_o <= std_logic_vector(to_unsigned(((y * 10) + b), 32));
					dat_o <= ram_data_o;
					ram_we <= '0';

				when write_disp =>

					if ((ack_i = '1') and (b = 9) and (y = 239)) then

						state <= read_input;
						cyc_o <= '1';
						stb_o <= '1';
						we_o <= '0';
						adr_o <= x"10000000";
						keycode <= dat_i (4 downto 0);
						ram_we <= '0';


					elsif ((ack_i = '1') and (b = 9)) then

						state <= inc_ptr1;
						cyc_o <= '0';
						ram_we <= '0';
						b <= 0;
						y <= y + 1;

					elsif (ack_i = '1') then

						state <= inc_ptr1;
						cyc_o <= '0';
						ram_we <= '0';
						b <= b + 1;
						y <= y;

					else

						state <= write_disp;
						cyc_o <= '1';
						stb_o <= '1';
						we_o <= '1';
						adr_o <= std_logic_vector(to_unsigned(((y * 10) + b), 32));
						dat_o <= ram_data_o;
						ram_we <= '0';
						
					end if;

				when inc_ptr1 =>

					state <= read_ram1;
					cyc_o <= '0';
					ram_we <= '0';
					ram_addr <= std_logic_vector(to_unsigned(((y * 10) + b), 12));

				when read_input =>

					if (ack_i = '1') then

						state <= game_update;
						update_start <= '1';
						cyc_o <= '0';
						ram_we <= '0';

					else
						
						state <= read_input;
						cyc_o <= '1';
						stb_o <= '1';
						we_o <= '0';
						adr_o <= x"10000000";
						keycode <= dat_i (4 downto 0);
						ram_we <= '0';

					end if;

				when game_update =>

					if (update_done = '1') then

						state <= read_pixel;
						update_start <= '0';
						cyc_o <= '0';
						ram_we <= '0';
						b <= 0;
						x <= 0;
						y <= 0;

					else
						
						state <= game_update;
						update_start <= '1';
						cyc_o <= '0';
						ram_we <= '0';

					end if;

				when read_pixel =>

					state <= write_buffer;
					cyc_o <= '0';
					ram_we <= '0';
					ram_buffer(x mod 32) <= pixel;

				when write_buffer =>

					if ((x + 1) mod 32 = 0) then

						state <= write_ram;
						cyc_o <= '0';
						ram_we <= '1';
						ram_addr <= std_logic_vector(to_unsigned(((y * 10) + b), 12));
						ram_data_i <= ram_buffer;

					else
						
						state <= inc_ptr2;
						cyc_o <= '0';
						ram_we <= '0';
						b <= (x / 32);
						x <= x + 1;
						y <= y;

					end if;

				when write_ram =>

					if ((x = 319) and (y = 239)) then

						state <= idle;
						cyc_o <= '0';
						ram_we <= '0';
						b <= (x / 32);
						x <= 0;
						y <= 0;

					elsif (x = 319) then

						state <= inc_ptr2;
						cyc_o <= '0';
						ram_we <= '0';
						b <= (x / 32);
						x <= 0;
						y <= y + 1;

					else
						
						state <= inc_ptr2;
						cyc_o <= '0';
						ram_we <= '0';
						b <= (x / 32);
						x <= x + 1;
						y <= y;

					end if;

				when inc_ptr2 =>

					state <= read_pixel;
					cyc_o <= '0';
					ram_we <= '0';

			end case;
		end if;
	end process;

end behavioral;