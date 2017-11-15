library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.pace_pkg.all;
use work.project_pkg.all;
use work.platform_pkg.all;
use work.video_controller_pkg.all;

--
--	1942 Foreground Character Tilemap Controller
--
--static const gfx_layout charlayout =
--{
--	8,8,
--	RGN_FRAC(1,1),
--	2,
--	{ 4, 0 },
--	{ 0, 1, 2, 3, 8+0, 8+1, 8+2, 8+3 },
--	{ 0*16, 1*16, 2*16, 3*16, 4*16, 5*16, 6*16, 7*16 },
--	16*8
--};
--

architecture TILEMAP_1 of tilemapCtl is

  alias clk       : std_logic is video_ctl.clk;
  alias clk_ena   : std_logic is video_ctl.clk_ena;
  alias stb       : std_logic is video_ctl.stb;
  alias hblank    : std_logic is video_ctl.hblank;
  alias vblank    : std_logic is video_ctl.vblank;
  alias x         : std_logic_vector(video_ctl.x'range) is video_ctl.x;
  alias y         : std_logic_vector(video_ctl.y'range) is video_ctl.y;
  
begin

  -- technically, this is actually scroll x
	-- these are constant for a whole line
  ctl_o.map_a(ctl_o.map_a'left downto 10) <= (others => '0');
  ctl_o.map_a(4 downto 0) <= x(7 downto 3);
  ctl_o.tile_a(ctl_o.tile_a'left downto 12) <= (others => '0');
  ctl_o.tile_a(3 downto 1) <= y(2 downto 0);

  -- generate attribute RAM address (same, different memory bank)
  ctl_o.attr_a(ctl_o.map_a'left downto 10) <= (others => '0');
  ctl_o.attr_a(4 downto 0) <= x(7 downto 3);
  
  -- generate pixel
  process (clk, clk_ena)

		variable x_adj		  : unsigned(x'range);
    variable tile_d_r   : std_logic_vector(7 downto 0); --ctl_i.tile_d'range);
		variable attr_d_r	  : std_logic_vector(7 downto 0);
    variable pel        : std_logic_vector(1 downto 0);

    variable clut_i     : integer range 0 to 63;
    variable clut_entry : fg_clut_entry_t;
    variable pel_i      : integer range 0 to 3;
    variable pal_i      : integer range 0 to 255;
    variable pal_entry  : palette_entry_t;

  begin

  	if rising_edge(clk) then
      if clk_ena = '1' then

        -- video is clipped left and right (only 224 wide)
        x_adj := unsigned(x); -- + (256-PACE_VIDEO_H_SIZE)/2;
          
        -- 1st stage of pipeline
        -- - read tile from tilemap
        -- - read attribute data
        if stb = '1' then
          ctl_o.map_a(9 downto 5) <= std_logic_vector(y(7 downto 3));
          ctl_o.attr_a(9 downto 5) <= std_logic_vector(y(7 downto 3));
        end if;
        
        -- 2nd stage of pipeline
        -- - read tile data from tile ROM
        if stb = '1' then
          if x_adj(2 downto 0) = "010" then
            attr_d_r := ctl_i.attr_d(7 downto 0);
          end if;
        end if;
        ctl_o.tile_a(11 downto 4) <= ctl_i.map_d(7 downto 0); -- each tile is 16 bytes
        ctl_o.tile_a(0) <= x_adj(2);

        if stb = '1' then
          if x_adj(1 downto 0) = "10" then
            tile_d_r := ctl_i.tile_d(7 downto 0);
          else
            tile_d_r := tile_d_r(tile_d_r'left-1 downto 0) & '0';
          end if;
        end if;
        pel := tile_d_r(3) & tile_d_r(7);

        -- extract R,G,B from colour palette
        clut_i := to_integer(unsigned(attr_d_r(4 downto 0)));
        clut_entry := fg_clut(clut_i);
        pel_i := to_integer(unsigned(pel));
        pal_i := 128 + to_integer(unsigned(clut_entry(pel_i)));
        pal_entry := pal(pal_i);
        ctl_o.rgb.r <= pal_entry(0) & "0000";
        ctl_o.rgb.g <= pal_entry(1) & "0000";
        ctl_o.rgb.b <= pal_entry(2) & "0000";
        -- transparency
        if pel_i = 0 then
          ctl_o.set <= '0';
        else
          ctl_o.set <= '1';
        end if;

      end if; -- clk_ena
		end if;
  end process;

end TILEMAP_1;
