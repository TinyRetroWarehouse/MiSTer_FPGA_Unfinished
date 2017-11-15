library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

library work;
use work.target_pkg.all;
use work.project_pkg.all;
use work.platform_variant_pkg.all;

package platform_pkg is

	--  
	-- PACE constants which *MUST* be defined
	--

--	constant M62_VIDEO_H_SIZE				      : integer := 256;
  constant M62_VIDEO_H_OFFSET           : integer := (512-384)/2;
	constant M62_VIDEO_V_SIZE				      : integer := 256;
	
	constant PACE_VIDEO_NUM_BITMAPS		    : natural := 0;
	constant PACE_VIDEO_NUM_TILEMAPS	    : natural := 1;
	constant PACE_VIDEO_NUM_SPRITES 	    : natural := 32;
	constant PACE_VIDEO_H_SIZE				    : integer := 384;
	constant PACE_VIDEO_V_SIZE				    : integer := 256;
	constant PACE_VIDEO_L_CROP            : integer := 0;
	constant PACE_VIDEO_R_CROP            : integer := PACE_VIDEO_L_CROP;
  constant PACE_VIDEO_PIPELINE_DELAY    : integer := 5;
	
	constant PACE_INPUTS_NUM_BYTES        : integer := 6;
	
	--
	-- Platform-specific constants (optional)
	--

--  constant PLATFORM                     : string := "m62";
--  constant PLATFORM_SRC_DIR             : string := "../../../../../src/platform/" & PLATFORM & "/";
--  constant PLATFORM_VARIANT_SRC_DIR     : string := PLATFORM_SRC_DIR & "ldrun" & "/";
  
	constant CLK0_FREQ_MHz		            : natural := 
    PACE_CLKIN0 * PACE_CLK0_MULTIPLY_BY / PACE_CLK0_DIVIDE_BY;
  constant CPU_FREQ_MHz                 : natural := 3;
  
	constant M62_CPU_CLK_ENA_DIVIDE_BY    : natural := CLK0_FREQ_MHz / CPU_FREQ_MHz;

  type from_PLATFORM_IO_t is record
    not_used  : std_logic;
  end record;

  type to_PLATFORM_IO_t is record
    not_used  : std_logic;
  end record;

end;
