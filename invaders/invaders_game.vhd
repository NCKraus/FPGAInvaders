library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.game_package.all;

entity invaders_game is

	port (	clk 			: in std_logic;
			rst				: in std_logic;

			update_start 	: in std_logic;
			update_done 	: out std_logic;

			draw_x			: in integer range 0 to 319;
			draw_y			: in integer range 0 to 239;
			pixel			: out std_logic;

			keycode 		: in std_logic_vector (4 downto 0));

end invaders_game;

architecture behavioral of invaders_game is

	type state_t is (idle, mode, collision, tick, done, won, lost);
	signal state : state_t;
	
	signal coll_clk_to_buf	: std_logic;
	signal coll_clk 		: std_logic;
	signal game_clk_to_buf	: std_logic;
	signal game_clk			: std_logic;
	signal game_rst_to_buf	: std_logic;
	signal game_rst 		: std_logic;
	signal tick_count		: integer range 0 to 100000;

	signal pixels 		: std_logic_vector (46 downto 0);
	signal text_pixel	: std_logic;

	signal win		: std_logic;
	signal lose		: std_logic;
	signal pause	: std_logic;

	signal random 	: integer range 0 to 63;

	--------------------------------------------------------------------------------------------------------------------
	-- TURRET

	signal turret_x			: integer range -1 to 319;
	signal turret_y			: integer range -1 to 239;
	signal turret_collision : std_logic;
	signal turret_dead		: std_logic;

	--------------------------------------------------------------------------------------------------------------------
	-- TURRET BULLET

	signal turret_bullet_x			: integer range -1 to 319;
	signal turret_bullet_y			: integer range -1 to 239;
	signal turret_bullet_collision	: std_logic;

	--------------------------------------------------------------------------------------------------------------------
	-- ALIENS
	
	signal alien_x			: alien_x_t;
	signal alien_y			: alien_y_t;
	signal alien_collision 	: alien_collision_t;
	signal alien_change		: std_logic;
	signal alien_dead		: std_logic_vector (39 downto 0);

	--------------------------------------------------------------------------------------------------------------------
	-- ALIEN BULLETS

	signal alien_bullet_1_x			: integer range -1 to 319;
	signal alien_bullet_1_y			: integer range -1 to 239;
	signal alien_bullet_1_collision	: std_logic;

	--------------------------------------------------------------------------------------------------------------------
	-- GAME CLOCK BUFFER
	
	component bufg
		port (	i : in std_logic;
				o : out std_logic);
	end component;

begin

	--------------------------------------------------------------------------------------------------------------------
	-- DECLARATIONS
	
	game_clk_bufg_e : bufg
		port map (	i => game_clk_to_buf,
					o => game_clk);

	coll_clk_bufg_e : bufg
		port map (	i => coll_clk_to_buf,
					o => coll_clk);

	game_rst_bufg_e : bufg
		port map (	i => game_rst_to_buf,
					o => game_rst);

	--game_rst <= game_rst_to_buf;

	randome_e : entity work.game_random
		port map (	clk => clk,
					rst => game_rst,
					keycode => keycode,
					random => random);

	text_e : entity work.game_text
		port map (	draw_clk => clk,

					win => win,
					lose => lose,

					draw_x => draw_x,
					draw_y => draw_y,
					pixel => text_pixel);
	
	collision_e : entity work.game_collision
		port map (	clk => coll_clk,
					rst => game_rst,
		
					turret_x => turret_x,
					turret_y => turret_y,
					turret_collision => turret_collision,
					
					turret_bullet_x => turret_bullet_x,
					turret_bullet_y => turret_bullet_y,
					turret_bullet_collision => turret_bullet_collision,

					alien_x => alien_x,
					alien_y => alien_y,
					alien_collision => alien_collision,
					alien_change => alien_change,

					alien_bullet_1_x => alien_bullet_1_x,
					alien_bullet_1_y => alien_bullet_1_y,
					alien_bullet_1_collision => alien_bullet_1_collision);

	turret_e : entity work.game_turret
		port map (	draw_clk => clk,
					game_clk => game_clk,
					rst => game_rst,
					draw_x => draw_x,
					draw_y => draw_y,
					pixel => pixels(0),
					turret_x => turret_x,
					turret_y => turret_y,
					collision => turret_collision,
					keycode => keycode,
					turret_dead => turret_dead);

	turret_bullet_e : entity work.game_turret_bullet
		port map (	draw_clk => clk,
					game_clk => game_clk,
					rst => game_rst,
					draw_x => draw_x,
					draw_y => draw_y,
					pixel => pixels(1),
					turret_bullet_x => turret_bullet_x,
					turret_bullet_y => turret_bullet_y,
					collision => turret_bullet_collision,
					turret_x => turret_x,
					turret_y => turret_y,
					keycode => keycode);

	barrier_1_e : entity work.game_barrier
		generic map (	cx => 44,
						cy => 190)
		port map (	draw_clk => clk,
					draw_x => draw_x,
					draw_y => draw_y,
					pixel => pixels(2));

	barrier_2_e : entity work.game_barrier
		generic map (	cx => 113,
						cy => 190)
		port map (	draw_clk => clk,
					draw_x => draw_x,
					draw_y => draw_y,
					pixel => pixels(3));

	barrier_3_e : entity work.game_barrier
		generic map (	cx => 182,
						cy => 190)
		port map (	draw_clk => clk,
					draw_x => draw_x,
					draw_y => draw_y,
					pixel => pixels(4));

	barrier_4_e : entity work.game_barrier
		generic map (	cx => 251,
						cy => 190)
		port map (	draw_clk => clk,
					draw_x => draw_x,
					draw_y => draw_y,
					pixel => pixels(5));

	alien_gen : for i in 0 to 39 generate
		alien_e : entity work.game_alien
			generic map (	start_x => (10 + (20 * (i mod 8))),
							start_y => (10 + (20 * (i / 8))))
			port map (	draw_clk => clk,
						game_clk => game_clk,
						rst => game_rst,
						draw_x => draw_x,
						draw_y => draw_y,
						pixel => pixels(i + 6),
						alien_x => alien_x(i),
						alien_y => alien_y(i),
						collision => alien_collision(i),
						change => alien_change,
						dead => alien_dead(i));
	end generate alien_gen;

	alien_bullet_1_e : entity work.game_alien_bullet
		port map (	draw_clk => clk,
					game_clk => game_clk,
					rst => game_rst,
					draw_x => draw_x,
					draw_y => draw_y,
					pixel => pixels(46),
					alien_bullet_x => alien_bullet_1_x,
					alien_bullet_y => alien_bullet_1_y,
					collision => alien_bullet_1_collision,
					alien_x => alien_x,
					alien_y => alien_y,
					alien_dead => alien_dead,
					random => random);

	--------------------------------------------------------------------------------------------------------------------
	-- UPDATE

	update_done <= '1' when ((state = done) or (state = won) or (state = lost)) else '0';

	pixel <= '1' when (((win = '1') or (lose = '1')) and (text_pixel = '1')) else '1' when ((win = '0') and (lose = '0') and (pixels /= (pixels'range => '0'))) else '0';

	coll_clk_to_buf <= '1' when (state = collision) else '0';
	game_clk_to_buf <= '1' when (state = tick) else '0';
	game_rst_to_buf <= '0' when ((rst = '0') or (keycode(1) = '1')) else '1';

	update_p : process (clk, game_rst)
	begin
		if (game_rst = '0') then

			state <= done;
			pause <= '1';
			win <= '0';
			lose <= '0';

		elsif rising_edge(clk) then

			case state is

				when idle =>
				
					if (update_start = '1') then
						state <= mode;
						if (keycode(0) = '1') then
							pause <= not pause;
						end if;
					else
						state <= idle;
					end if;
					
				when mode =>
				
					if (pause = '1') then
						state <= done;
					elsif (win = '1') then
						state <= won;
					elsif (turret_dead = '1') then
						state <= lost;
						lose <= '1';
					elsif (lose = '1') then
						state <= lost;
					else
						state <= collision;
						tick_count <= 0;
					end if;

				when collision =>

					if (tick_count = 100000) then
						state <= tick;
						tick_count <= 0;
					else
						state <= collision;
						tick_count <= tick_count + 1;
					end if;
					
					win <= '0';
					lose <= '0';
					
					if (alien_dead = (alien_dead'range => '1')) then
						win <= '1';
					else
						win <= '0';
					end if;
						
					for i in 0 to 39 loop
						if (alien_y(i) >= 182) then
							lose <= '1';
						end if;
					end loop;

				when tick =>

					if (tick_count = 100000) then
						state <= done;
						tick_count <= 0;
					else
						state <= tick;
						tick_count <= tick_count + 1;
					end if;

				when done =>

					state <= idle;

				when won =>

					state <= won;

				when lost =>

					state <= lost;

			end case;
		end if;
	end process;

end behavioral;