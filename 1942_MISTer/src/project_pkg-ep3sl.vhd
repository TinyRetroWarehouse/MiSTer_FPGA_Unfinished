library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

library work;
use work.pace_pkg.all;
use work.target_pkg.all;
use work.video_controller_pkg.all;

package project_pkg is

	--  
	-- PACE constants which *MUST* be defined
	--
	
  -- Reference clock is 24MHz
	constant PACE_HAS_PLL								      : boolean := true;
  constant PACE_HAS_SDRAM                   : boolean := false;
  constant PACE_HAS_SERIAL                  : boolean := false;
  
	constant PACE_JAMMA	                      : PACEJamma_t := PACE_JAMMA_NONE;

  constant PACE_VIDEO_CONTROLLER_TYPE       : PACEVideoController_t := PACE_VIDEO_VGA_800x600_60Hz;
  constant PACE_CLK0_DIVIDE_BY              : natural := 3;
  constant PACE_CLK0_MULTIPLY_BY            : natural := 8;   -- 24*8/3 = 64MHz
  constant PACE_CLK1_DIVIDE_BY        		  : natural := 3;
  constant PACE_CLK1_MULTIPLY_BY      		  : natural := 5;  	-- 24*5/3 = 40MHz
	constant PACE_VIDEO_H_SCALE         		  : integer := 2;
	constant PACE_VIDEO_V_SCALE         		  : integer := 2;
  constant PACE_VIDEO_H_SYNC_POLARITY       : std_logic := '1';
  constant PACE_VIDEO_V_SYNC_POLARITY       : std_logic := '1';

--  constant PACE_VIDEO_CONTROLLER_TYPE       : PACEVideoController_t := PACE_VIDEO_VGA_1280x1024_60Hz;
--  constant PACE_CLK0_DIVIDE_BY              : natural := 96;
--  constant PACE_CLK0_MULTIPLY_BY            : natural := 157;     -- 24.675*157/96 = 40.192MHz
--  constant PACE_CLK1_DIVIDE_BY              : natural := 11;
--  constant PACE_CLK1_MULTIPLY_BY            : natural := 48;  	  -- 24.576*48/11 = 107.24MHz
--  constant PACE_VIDEO_H_SCALE       	      : integer := 2;
--  constant PACE_VIDEO_V_SCALE       	      : integer := 2;

--  constant PACE_VIDEO_CONTROLLER_TYPE       : PACEVideoController_t := PACE_VIDEO_CVBS_720x288p_50Hz;
--  constant PACE_CLK0_DIVIDE_BY              : natural := 8;
--  constant PACE_CLK0_MULTIPLY_BY            : natural := 9;   -- 24*9/8 = 27MHz
--  constant PACE_CLK1_DIVIDE_BY              : natural := 16;
--  constant PACE_CLK1_MULTIPLY_BY            : natural := 9;		-- 24*9/16 = 13.5MHz
--	constant PACE_VIDEO_H_SCALE               : integer := 2;
--	constant PACE_VIDEO_V_SCALE               : integer := 1;
--	constant USE_VIDEO_VBLANK_INTERRUPT 		  : boolean := false;
--  constant PACE_VIDEO_H_SYNC_POLARITY       : std_logic := '1';
--  constant PACE_VIDEO_V_SYNC_POLARITY       : std_logic := '1';
  
  constant PACE_VIDEO_BORDER_RGB            : RGB_t := RGB_BLACK;

  constant PACE_HAS_OSD                     : boolean := false;
  constant PACE_OSD_XPOS                    : natural := 0;
  constant PACE_OSD_YPOS                    : natural := 0;

  -- S5A-specific constants
  
  constant S5AR2_DOUBLE_VDO_IDCK            : boolean := false;

  constant S5AR2_EMULATED_FLASH_INIT_FILE   : string := "";
  constant S5AR2_EMULATE_FLASH              : boolean := true;
  constant S5AR2_EMULATED_FLASH_WIDTH_AD    : natural := 10;
  constant S5AR2_EMULATED_FLASH_WIDTH       : natural := 8;

  -- always need SRAM (for now, use for WRAM)
  constant S5AR2_EMULATE_SRAM               : boolean := true;
  -- $9800-$BFFF (so $8000-$BFFF)
  constant S5AR2_EMULATED_SRAM_WIDTH_AD     : natural := 14;
  constant S5AR2_EMULATED_SRAM_WIDTH        : natural := 8;
    
  constant S5AR2_HAS_FLOPPY_IF              : boolean := false;

	-- 1942 constants
	
  constant CAPCOM_1942_HAS_AUDIO_CPU        : boolean := true;

  constant ROM_VARIANT                      : string := "1942";
  --constant ROM_VARIANT                      : string := "1942a";
  --constant ROM_VARIANT                      : string := "1942abl";
  --constant ROM_VARIANT                      : string := "1942b";
  --constant ROM_VARIANT                      : string := "1942w";
  -- this might be NULL for platforms with no ROM variants
  constant ROM_VARIANT_SUBDIR                : string := ROM_VARIANT & "/";
	
	-- derived - do not edit

  constant PACE_HAS_SRAM                    : boolean := S5AR2_EMULATE_SRAM;
  constant PACE_HAS_FLASH                   : boolean := S5AR2_EMULATE_FLASH;

  type from_PROJECT_IO_t is record
    not_used  : std_logic;
  end record;

  type to_PROJECT_IO_t is record
    not_used  : std_logic;
  end record;

end;
