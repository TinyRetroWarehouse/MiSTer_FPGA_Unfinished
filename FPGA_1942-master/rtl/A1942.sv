//============================================================================
//  Arcade: 1942
//
//  Port to MiSTer
//  Copyright (C) 2018 Gehstock
//
//  This program is free software; you can redistribute it and/or modify it
//  under the terms of the GNU General Public License as published by the Free
//  Software Foundation; either version 2 of the License, or (at your option)
//  any later version.
//
//  This program is distributed in the hope that it will be useful, but WITHOUT
//  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
//  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
//  more details.
//
//  You should have received a copy of the GNU General Public License along
//  with this program; if not, write to the Free Software Foundation, Inc.,
//  51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
//============================================================================

module emu
(
	//Master input clock
	input         CLK_50M,

	//Async reset from top-level module.
	//Can be used as initial reset.
	input         RESET,

	//Must be passed to hps_io module
	inout  [44:0] HPS_BUS,

	//Base video clock. Usually equals to CLK_SYS.
	output        VGA_CLK,

	//Multiple resolutions are supported using different VGA_CE rates.
	//Must be based on CLK_VIDEO
	output        VGA_CE,

	output  [7:0] VGA_R,
	output  [7:0] VGA_G,
	output  [7:0] VGA_B,
	output        VGA_HS,
	output        VGA_VS,
	output        VGA_DE,    // = ~(VBlank | HBlank)

	//Base video clock. Usually equals to CLK_SYS.
	output        HDMI_CLK,

	//Multiple resolutions are supported using different HDMI_CE rates.
	//Must be based on CLK_VIDEO
	output        HDMI_CE,

	output  [7:0] HDMI_R,
	output  [7:0] HDMI_G,
	output  [7:0] HDMI_B,
	output        HDMI_HS,
	output        HDMI_VS,
	output        HDMI_DE,   // = ~(VBlank | HBlank)
	output  [1:0] HDMI_SL,   // scanlines fx

	//Video aspect ratio for HDMI. Most retro systems have ratio 4:3.
	output  [7:0] HDMI_ARX,
	output  [7:0] HDMI_ARY,

	output        LED_USER,  // 1 - ON, 0 - OFF.

	// b[1]: 0 - LED status is system status OR'd with b[0]
	//       1 - LED status is controled solely by b[0]
	// hint: supply 2'b00 to let the system control the LED.
	output  [1:0] LED_POWER,
	output  [1:0] LED_DISK,

	output [15:0] AUDIO_L,
	output [15:0] AUDIO_R,
	output        AUDIO_S    // 1 - signed audio samples, 0 - unsigned
);

assign LED_USER  = 1;
assign LED_DISK  = 0;
assign LED_POWER = 0;

assign HDMI_ARX = status[1] ? 8'd16 : status[2] ? 8'd4 : 8'd1;
assign HDMI_ARY = status[1] ? 8'd9  : status[2] ? 8'd3 : 8'd1;

`include "rtl/build_id.v" 
localparam CONF_STR = {
	"1942;;",
	"-;",
	"O1,Aspect Ratio,Original,Wide;",
	"O2,Orientation,Vert,Horz;",
	"O34,Scanlines(vert),No,25%,50%,75%;",
	"O5,Service ,Off,on;",
	"-;",
	"T6,Reset;",
	"J,Fire,Start 1P,Start 2P;",
	"V,v2.00.",`BUILD_DATE
};

////////////////////   CLOCKS   ///////////////////

wire clk_sys, clk_18, clk_6, clk_24;
wire pll_locked;

pll pll
(
	.refclk(CLK_50M),
	.rst(0),
	.outclk_0(clk_18),
	.outclk_1(clk_sys),
	.outclk_2(clk_6),
	.outclk_3(clk_24),
	.locked(pll_locked)
);

///////////////////////////////////////////////////

wire [31:0] status;
wire  [1:0] buttons;


wire [10:0] ps2_key;

wire [15:0] joystick_0,joystick_1;
wire [15:0] joy = joystick_0 | joystick_1;

hps_io #(.STRLEN($size(CONF_STR)>>3)) hps_io
(
	.clk_sys(clk_sys),
	.HPS_BUS(HPS_BUS),

	.conf_str(CONF_STR),

	.buttons(buttons),
	.status(status),

	.joystick_0(joystick_0),
	.joystick_1(joystick_1),
	.ps2_key(ps2_key)
);

wire       pressed = ps2_key[9];
wire [8:0] code    = ps2_key[8:0];
always @(posedge clk_sys) begin
	reg old_state;
	old_state <= ps2_key[10];
	
	if(old_state != ps2_key[10]) begin
		casex(code)
			'hX75: btn_up          <= pressed; // up
			'hX72: btn_down        <= pressed; // down
			'hX6B: btn_left        <= pressed; // left
			'hX74: btn_right       <= pressed; // right

			'h029: btn_fire1        <= pressed; // space
			'h014: btn_fire2        <= pressed; // ctrl

			'h005: btn_one_player  <= pressed; // F1
			'h006: btn_two_players <= pressed; // F2
		endcase
	end
end

reg btn_up    = 0;
reg btn_down  = 0;
reg btn_right = 0;
reg btn_left  = 0;
reg btn_fire1  = 0;
reg btn_fire2  = 0;
reg btn_one_player  = 0;
reg btn_two_players = 0;

wire m_up     = status[2] ? btn_left  | joy[1] : btn_up    | joy[3];
wire m_down   = status[2] ? btn_right | joy[0] : btn_down  | joy[2];
wire m_left   = status[2] ? btn_down  | joy[2] : btn_left  | joy[1];
wire m_right  = status[2] ? btn_up    | joy[3] : btn_right | joy[0];
wire m_fire1   = btn_fire1 | joy[4];
wire m_fire2   = btn_fire2 | joy[5];
wire m_start1 = btn_one_player  | joy[5];
wire m_start2 = btn_two_players | joy[6];
wire m_coin   = m_start1 | m_start2;

wire hblank, vblank;
wire ce_vid = clk_6;
wire hs, vs, hsi, vsi;
wire rde, rhs, rvs;
wire [3:0] r,g,rr,rg,b,rb, ri, bi, gi;

assign VGA_CLK  = clk_sys;
assign VGA_CE   = ce_vid;
assign VGA_R    = {r,r};
assign VGA_G    = {g,g};
assign VGA_B    = {b,b};
assign VGA_HS   = hs;
assign VGA_VS   = vs;

assign HDMI_CLK = status[2] ? VGA_CLK: clk_24;
assign HDMI_CE  = status[2] ? VGA_CE : 1'b1;
assign HDMI_R   = status[2] ? VGA_R  : {rr,rr};
assign HDMI_G   = status[2] ? VGA_G  : {rg,rg};
assign HDMI_B   = status[2] ? VGA_B  : {rb,rb};
assign HDMI_DE  = status[2] ? VGA_DE : rde;
assign HDMI_HS  = status[2] ? VGA_HS : rhs;
assign HDMI_VS  = status[2] ? VGA_VS : rvs;
assign HDMI_SL  = status[2] ? 2'd0   : status[4:3];

screen_rotate #(257,224,9) screen_rotate
(
	.clk_in(clk_sys),
	.ce_in(ce_vid),
	.video_in({r,g,b}),
	.hblank(hblank),
	.vblank(vblank),

	.clk_out(clk_24),
	.video_out({rr,rg,rb}),
	.hsync(rhs),
	.vsync(rvs),
	.de(rde)
);

FPGA_1942 FPGA_1942
(
	.I_CLK_12M(clk_sys),
	.I_RESET(RESET | status[0] | status[6] | buttons[1]),
	.I_P1(~{m_coin,m_start1,m_fire2,m_fire1,m_up,m_down,m_left,m_right}),// COIN    & P1_START & P1_LOOP & P1_FIRE & P1_U & P1_D & P1_L & P1_R
	.I_P2(~{status[5],m_start2,m_fire2,m_fire1,m_up,m_down,m_left,m_right}),// SERVICE & P2_START & P2_LOOP & P2_FIRE & P2_U & P2_D & P2_L & P2_R
	.I_DIP_A("01110111"),
	.I_DIP_B("11111111"),
	.O_AUDIO_L(audiol),
	.O_AUDIO_R(audior),
	.O_VIDEO_R(ri),
	.O_VIDEO_G(gi),
	.O_VIDEO_B(bi),
	.O_HSYNC(hsi),
	.O_VSYNC(vsi),
	.O_HBlank(hblank),//todo
	.O_VBlank(vblank),//todo
	.O_CSYNC()
	);
	
wire [7:0] audiol, audior;
assign AUDIO_L = {audiol, 8'b00000000};
assign AUDIO_R = {audior, 8'b00000000};
assign AUDIO_S = 0;

VGA_SCANCONV #(
	.vstart(127),
	.vlength(256),
	.hF(8),
	.hS(46),
	.hB(22),
	.hV(288),
	.hpad(10),
	.vF(1),
	.vS(1),
	.vB(36),
	.vV(224),
	.vpad(0))
VGA_SCANCONV (
	.I_VIDEO({"0000",ri,gi,bi}),
	.I_HSYNC(hsi),
	.I_VSYNC(vsi),
	.O_VIDEO({dummy,r,g,b}),
	.O_HSYNC(hs),
	.O_VSYNC(vs),
	.O_CMPBLK_N(VGA_DE),
	.CLK(clk_6),
	.CLK_x2(clk_sys)
	);

	
wire [3:0]dummy;

endmodule

/*
-- DIP SW A
--		I_DIP_A					=> x"77",		-- Default Settings
		I_DIP_A(7 downto 6)	=> "01",			-- Planes: 00=5, 01=2, 10=1, 11=3
		I_DIP_A(5 downto 4)	=> "11",			-- Bonus: 00=30K/100K, 01=30K/80K, 10=20K/100K, 11=20K/80K
		I_DIP_A(3)				=> '0',			-- Type: 0=Upright, 1=Table
		I_DIP_A(2 downto 0)	=> "111",		-- Play/Coins: 000=FreePlay, 001=1P/4C, 010=1P/3C, 011=3P/2C, 100=1P/2C, 101=4P/1C, 110=2P/1C, 111=1P/1C

		-- DIP SW B
--		I_DIP_B					=> x"FF",		-- Default Settings
		I_DIP_B(7)				=> '1',			-- Stop: 0=Stop, 1=Run
		I_DIP_B(6 downto 5)	=> "11",			-- Difficulty: 00=Very Hard, 01=Difficult, 10=Easy, 11=Normal
		I_DIP_B(4)				=> '1',			-- Picture: 0=Reverse, 1=Normal
		I_DIP_B(3)				=> '1',			-- Mode: 0=Test, 1=Normal
		I_DIP_B(2 downto 0)	=> "111",		-- Reserved set to 111
*/
