--	(c) 2012 d18c7db(a)hotmail
--
--	This program is free software; you can redistribute it and/or modify it under
--	the terms of the GNU General Public License version 3 or, at your option,
--	any later version as published by the Free Software Foundation.
--
--	This program is distributed in the hope that it will be useful,
--	but WITHOUT ANY WARRANTY; without even the implied warranty of
--	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
--
-- For full details, see the GNU General Public License at www.gnu.org/licenses

--------------------------------------------------------------------------------
-- Video scan converter - works with active negative input sync signals
--
--	Horizonal Timing
-- _____________              ______________________              _____________________
-- VIDEO (last) |____________|         VIDEO        |____________|         VIDEO (next)
-- -hV----------|-hF-|hS|-hB-|----------hV----------|-hF-|hS|-hB-|----------hV---------
-- __________________|  |________________________________|  |__________________________
-- HSYNC             |__|              HSYNC             |__|              HSYNC

------------------------------------------------------------------------------------------------------------------
-- HORIZONTAL   - Line       | Pixel      | Front     | HSYNC      | Back       | Active     | HSYNC    | Total  |
-- Resolution   - Rate       | Clock      | Porch hF  | Pulse hS   | Porch hB   | Video hV   | Polarity | Pixels |
------------------------------------------------------------------------------------------------------------------
--  In  256x224 - 15625.00Hz |  6.000 MHz | 38 pixels |  32 pixels |  58 pixels | 256 pixels | negative | 384    |
--  Out 640x480 - 31250.00Hz | 24.000 MHz |  2 pixels |  92 pixels |  34 pixels | 640 pixels | negative | 768    |
--  VGA 640x480 - 31468.75Hz | 25.175 MHz | 16 pixels |  96 pixels |  48 pixels | 640 pixels | negative | 800    |
------------------------------------------------------------------------------------------------------------------

-- Vertical Timing
-- _____________              ______________________              _____________________
-- VIDEO (last) |____________|         VIDEO        |____________|         VIDEO (next)
-- -vV----------|-vF-|vS|-vB-|----------vV----------|-vF-|vS|-vB-|----------vV---------
-- __________________|  |________________________________|  |__________________________
-- VSYNC             |__|              VSYNC             |__|              VSYNC

------------------------------------------------------------------------------------------------------------------
-- VERTICAL     - Frame      | Pixel      | Front     | VSYNC      | Back       | Active     | VSYNC    | Total  |
-- Resolution   - Rate       | Clock      | Porch vF  | Pulse vS   | Porch vB   | Video vV   | Polarity | Pixels |
------------------------------------------------------------------------------------------------------------------
--  In  256x224 - 59.18Hz    |  6.000 MHz | 16 lines  | 8 lines    | 16 lines   | 224 lines  | negative | 264    |
--  Out 640x480 - 59.18Hz    | 24.000 MHz | 17 lines  | 2 lines    | 29 lines   | 480 lines  | negative | 528    |
--  VGA 640x480 - 59.94Hz    | 25.175 MHz | 10 lines  | 2 lines    | 33 lines   | 480 lines  | negative | 525    |
------------------------------------------------------------------------------------------------------------------

library ieee;
	use ieee.std_logic_1164.all;
	use ieee.std_logic_unsigned.all;
	use ieee.numeric_std.all;

--pragma translate_off
	use ieee.std_logic_textio.all;
	use std.textio.all;
--pragma translate_on

entity VGA_SCANCONV is
	generic (
		vstart		: integer range 0 to 1023 := 127;	-- start  of active video
		vlength		: integer range 0 to 1023 := 256;	-- length of active video

		hF				: integer range 0 to 1023 :=   8;	-- h front porch
		hS				: integer range 0 to 1023 :=  45;	-- h sync
		hB				: integer range 0 to 1023 :=  23;	-- h back porch
		hV				: integer range 0 to 1023 := 256;	-- visible video
		hpad			: integer range 0 to 1023 :=  26;	-- H black border

		vF				: integer range 0 to 1023 :=  35;	-- v front porch
		vS				: integer range 0 to 1023 :=   2;	-- v sync
		vB				: integer range 0 to 1023 :=  35;	-- v back porch
		vV				: integer range 0 to 1023 := 226;	-- visible video
		vpad			: integer range 0 to 1023 :=   0		-- V black border
	);
	port (
		I_VIDEO				: in  std_logic_vector(15 downto 0);
		I_HSYNC				: in  std_logic;
		I_VSYNC				: in  std_logic;
		--
		O_VIDEO				: out std_logic_vector(15 downto 0);
		O_HSYNC				: out std_logic;
		O_VSYNC				: out std_logic;
		O_CMPBLK_N			: out std_logic;
		--
		CLK					: in  std_logic;
		CLK_x2				: in  std_logic
	);
end;

architecture RTL of VGA_SCANCONV is
	signal
		ihsync,
		ivsync,
		ihsync_last,
		ivsync_last,
		cmpblk_n,
		alt,
		alt_n,
		ovsync,
		ovsync_last,
		ohsync
								: std_logic := '1';
	signal
		hpos_i,
		hpos_o
								: std_logic_vector(8 downto 0) := (others => '0');
	signal
		ovideo
								: std_logic_vector(15 downto 0) := (others => '0');

	signal vcnto			: integer range 0 to 1023 := 0;
	signal hcnto			: integer range 0 to 1023 := 0;
	signal hcnti			: integer range 0 to 1023 := 0;

	signal CLK_x2_n		: std_logic := '1';

begin
	O_VIDEO		<= ovideo;
	O_HSYNC		<= ohsync;
	O_VSYNC		<= ovsync;
	O_CMPBLK_N	<= cmpblk_n;

	ihsync		<= I_HSYNC;
	ivsync		<= I_VSYNC;
	CLK_x2_n 	<= not CLK_x2;
	alt_n			<= not alt;

		
	u_ram : entity work.dpram
    generic map
    (
      init_file		=> "",
      widthad_a		=> 10,
		width_a			=> 16
    )
    port map
    (
      clock_a						=> CLK_x2,
      address_a(9)				=> alt,
		address_a(8 downto 0)	=> hpos_i,
      wren_a						=> '1',
      data_a						=> I_VIDEO,
      q_a							=> open,

      clock_b						=> CLK_x2_n,
      address_b(9)				=> alt_n,
		address_b(8 downto 0)	=> hpos_o,
      wren_b						=> '0',
      data_b						=> x"0000",
      q_b							=> ovideo
    );


	-- edge transition helper signals
	p_det_egdes : process
	begin
		wait until rising_edge(CLK_x2);
		ihsync_last <= ihsync;
		ivsync_last <= ivsync;
		ovsync_last <= ovsync;
	end process;

	-------------------------
	-- Input Video Section
	-------------------------

	-- horizontal master counter for input video, reset on falling edge of HSYNC
	p_hcounter : process
	begin
		wait until rising_edge(CLK_x2);
		if (ihsync_last = '1') and (ihsync = '0') then
			hcnti <= 0;
		elsif CLK = '0' then
			hcnti <= hcnti + 1;
		end if;
	end process;

	-- memory selector for double buffering, half the memory is written to while
	-- the other half is read out at double speed, then the two halves are swapped
	p_memsel : process
	begin
		wait until rising_edge(CLK_x2);
		-- start of active input video configurable for dumb misaligned HSYNC signals
		if CLK = '0' then
			if hcnti = 2 then
				alt <= not alt;
			end if;
		end if;
	end process;

	-- increment RAM write position during HSYNC active video portion only
	p_ram_in : process
	begin
		wait until rising_edge(CLK_x2);
		if CLK = '0' then
			if (hcnti > 2) and (hcnti < vstart) then
				hpos_i <= (others => '0');
			else
				hpos_i <= hpos_i + 1;
			end if;
		end if;
	end process;

	-------------------------
	-- Output Video Section
	-------------------------

	-- VGA H and V counters, synchronized to input frame V sync, then H sync
	p_out_ctrs : process
		variable trigger : boolean;
	begin
		wait until rising_edge(CLK_x2);
		if (ivsync_last = '1') and (ivsync = '0') then
			trigger := true;
		end if;

		if trigger and ihsync = '0' then
			trigger := false;
			hcnto <= 0;
			vcnto <= 0;
		else
			if hcnto = (hF+hS+hB+hV+hpad+hpad-1) then
				hcnto <= 0;
				vcnto <= vcnto + 1;
			else
				hcnto <= hcnto + 1;
			end if;
		end if;
	end process;

	-- generate output HSYNC
	p_gen_hsync : process
	begin
		wait until rising_edge(CLK_x2);
		-- H sync timing
		if (hcnto < hS) then
			ohsync <= '0';
		else
			ohsync <= '1';
		end if;
	end process;

	-- generate output VSYNC
	p_gen_vsync : process
	begin
		wait until rising_edge(CLK_x2);
		-- V sync timing
		if (vcnto >= vF) and (vcnto < vF+vS) then
			ovsync <= '0';
		else
			ovsync <= '1';
		end if;
	end process;

	-- generate active output video
	p_gen_active_vid : process
	begin
		wait until rising_edge(CLK_x2);
		-- if hcnto within the visible video area
		if ((hcnto >= (hF + hS + hB + hpad)) and (hcnto < (hF + hS + hB + hV + hpad))) then	
			hpos_o <= hpos_o + 1;
		else
			hpos_o <= (others => '0');
		end if;
	end process;

	-- generate blanking signal including additional borders to pad the input signal to standard VGA resolution
	p_gen_blank : process
	begin
		wait until rising_edge(CLK_X2);
		-- active video area after padding with blank borders
		if ((hcnto >= (hS + hB)) and (hcnto < (hS + hB + hV + 2*hpad))) and ((vcnto > 2*(vS + vB)) and (vcnto <= 2*(vS + vB + vV + 2*vpad))) then
			cmpblk_n <= '1';
		else
			cmpblk_n <= '0';
		end if;
	end process;


end architecture RTL;
