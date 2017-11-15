library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

library work;
use work.target_pkg.all;
use work.project_pkg.all;
use work.platform_pkg.all;

package platform_variant_pkg is

	--  
	-- PACE constants which *MUST* be defined
	--

	constant M62_VIDEO_H_SIZE				      : integer := 384;
  
	--
	-- Platform-specific constants (optional)
	--

  constant PLATFORM_VARIANT             : string := "ldrun";
  
  type rom_a is array (natural range <>) of string;
  
  constant M62_ROM                      : rom_a(0 to 3) := 
                                          (
                                            0 => "lr-a-4e", 
                                            1 => "lr-a-4d",
                                            2 => "lr-a-4b",
                                            3 => "lr-a-4a"
                                          );
  constant M62_ROM_WIDTHAD              : natural := 13;

  constant M62_CHAR_ROM                 : rom_a(0 to 2) := 
                                          (
                                            0 => "lr-e-2d", 
                                            1 => "lr-e-2j",
                                            2 => "lr-e-2f"
                                          );

  constant M62_SPRITE_ROM               : rom_a(0 to 2) := 
                                          (
                                            0 => "lr-b-4k", 
                                            1 => "lr-b-3n",
                                            2 => "lr-b-4c"
                                          );

	type pal_rgb_t is array (0 to 2) of std_logic_vector(7 downto 0);
	type pal_a is array (natural range <>) of pal_rgb_t;

	constant tile_pal : pal_a(0 to 255) :=
	(
    17 => (0=>"00000011", 1=>"11111111", 2=>"11111111"),  -- 03FFFF
    25 => (0=>"11111111", 1=>"11111111", 2=>"00000011"),  -- FFFF03
    33 => (0=>"11111111", 1=>"11111111", 2=>"11111111"),  -- FFFFFF
    40 => (0=>"01100010", 1=>"01100010", 2=>"01100010"),  -- 626262
    41 => (0=>"11011100", 1=>"01100010", 2=>"00000011"),  -- DC6203
    42 => (0=>"00000011", 1=>"11111111", 2=>"11001100"),  -- 03FFCC
    43 => (0=>"11011100", 1=>"11011100", 2=>"00000011"),  -- DCDC03
    44 => (0=>"11011100", 1=>"10110111", 2=>"01010000"),  -- DCB750
    45 => (0=>"10000100", 1=>"10100110", 2=>"10100110"),  -- 84A6A6
    46 => (0=>"10010100", 1=>"01100010", 2=>"01100010"),  -- 946262
    49 => (0=>"11111111", 1=>"00000011", 2=>"00000011"),  -- FF0303
    50 => (0=>"00000011", 1=>"11111111", 2=>"00000011"),  -- 03FF03
    51 => (0=>"11111111", 1=>"11111111", 2=>"00000011"),  -- FFFF03
    52 => (0=>"00000011", 1=>"00000011", 2=>"11111111"),  -- 0303FF
    53 => (0=>"11111111", 1=>"00000011", 2=>"11111111"),  -- FF03FF
    54 => (0=>"00000011", 1=>"11111111", 2=>"11111111"),  -- 03FFFF
    55 => (0=>"11111111", 1=>"11111111", 2=>"11111111"),  -- FFFFFF
    56 => (0=>"01100010", 1=>"01100010", 2=>"01100010"),  -- 626262
    57 => (0=>"11111111", 1=>"11111111", 2=>"00000011"),  -- FFFF03
    63 => (0=>"11111111", 1=>"00000011", 2=>"00000011"),  -- FF0303
    72 => (0=>"11111111", 1=>"11111111", 2=>"11111111"),  -- FFFFFF
    73 => (0=>"11001100", 1=>"00000011", 2=>"11110000"),  -- CC03F0
    74 => (0=>"11111111", 1=>"11111111", 2=>"11111111"),  -- FFFFFF
    75 => (0=>"11111111", 1=>"11111111", 2=>"11111111"),  -- FFFFFF
    76 => (0=>"11111111", 1=>"11111111", 2=>"11111111"),  -- FFFFFF
    77 => (0=>"11111111", 1=>"11111111", 2=>"11111111"),  -- FFFFFF
    78 => (0=>"11111111", 1=>"11111111", 2=>"11111111"),  -- FFFFFF
    79 => (0=>"11111111", 1=>"11111111", 2=>"11111111"),  -- FFFFFF
    80 => (0=>"01100010", 1=>"01100010", 2=>"01100010"),  -- 626262
    81 => (0=>"11110000", 1=>"11011100", 2=>"00000011"),  -- F0DC03
    82 => (0=>"11110000", 1=>"10010100", 2=>"00000011"),  -- F09403
    83 => (0=>"11111111", 1=>"11111111", 2=>"10100110"),  -- FFFFA6
    84 => (0=>"10000100", 1=>"10000100", 2=>"11111111"),  -- 8484FF
    85 => (0=>"11011100", 1=>"10010100", 2=>"00000011"),  -- DC9403
    86 => (0=>"00000011", 1=>"11011100", 2=>"11011100"),  -- 03DCDC
    89 => (0=>"11111111", 1=>"00000011", 2=>"00000011"),  -- FF0303
    91 => (0=>"11111111", 1=>"00000011", 2=>"00000011"),  -- FF0303
    93 => (0=>"11111111", 1=>"00000011", 2=>"00000011"),  -- FF0303
    95 => (0=>"11111111", 1=>"00000011", 2=>"00000011"),  -- FF0303
    97 => (0=>"11111111", 1=>"11001100", 2=>"00000011"),  -- FFCC03
    98 => (0=>"11111111", 1=>"00000011", 2=>"00000011"),  -- FF0303
    99 => (0=>"11111111", 1=>"00000011", 2=>"00000011"),  -- FF0303
    101 => (0=>"11111111", 1=>"11001100", 2=>"00000011"),  -- FFCC03
    102 => (0=>"11111111", 1=>"00000011", 2=>"00000011"),  -- FF0303
    103 => (0=>"11111111", 1=>"00000011", 2=>"00000011"),  -- FF0303
    105 => (0=>"00000011", 1=>"00000011", 2=>"11111111"),  -- 0303FF
    106 => (0=>"11111111", 1=>"11001100", 2=>"00000011"),  -- FFCC03
    107 => (0=>"11111111", 1=>"11001100", 2=>"00000011"),  -- FFCC03
    108 => (0=>"11111111", 1=>"00000011", 2=>"00000011"),  -- FF0303
    109 => (0=>"11111111", 1=>"00000011", 2=>"00000011"),  -- FF0303
    110 => (0=>"11111111", 1=>"00000011", 2=>"00000011"),  -- FF0303
    111 => (0=>"11111111", 1=>"00000011", 2=>"00000011"),  -- FF0303
    113 => (0=>"11111111", 1=>"00000011", 2=>"00000011"),  -- FF0303
    114 => (0=>"00000011", 1=>"00000011", 2=>"11111111"),  -- 0303FF
    115 => (0=>"00000011", 1=>"00000011", 2=>"11111111"),  -- 0303FF
    116 => (0=>"11111111", 1=>"11001100", 2=>"00000011"),  -- FFCC03
    117 => (0=>"11111111", 1=>"11001100", 2=>"00000011"),  -- FFCC03
    118 => (0=>"11111111", 1=>"11001100", 2=>"00000011"),  -- FFCC03
    119 => (0=>"11111111", 1=>"11001100", 2=>"00000011"),  -- FFCC03
    121 => (0=>"11111111", 1=>"11001100", 2=>"00000011"),  -- FFCC03
    122 => (0=>"11111111", 1=>"00000011", 2=>"00000011"),  -- FF0303
    123 => (0=>"11111111", 1=>"00000011", 2=>"00000011"),  -- FF0303
    124 => (0=>"00000011", 1=>"00000011", 2=>"11111111"),  -- 0303FF
    125 => (0=>"00000011", 1=>"00000011", 2=>"11111111"),  -- 0303FF
    126 => (0=>"00000011", 1=>"00000011", 2=>"11111111"),  -- 0303FF
    127 => (0=>"00000011", 1=>"00000011", 2=>"11111111"),  -- 0303FF
    136 => (0=>"10000100", 1=>"10000100", 2=>"10000100"),  -- 848484
    137 => (0=>"10010100", 1=>"10010100", 2=>"10010100"),  -- 949494
    138 => (0=>"01100010", 1=>"01100010", 2=>"01100010"),  -- 626262
    139 => (0=>"11011100", 1=>"10110111", 2=>"10000100"),  -- DCB784
    140 => (0=>"01100010", 1=>"01100010", 2=>"11001100"),  -- 6262CC
    141 => (0=>"11001100", 1=>"11001100", 2=>"11001100"),  -- CCCCCC
    142 => (0=>"10110111", 1=>"11011100", 2=>"11110000"),  -- B7DCF0
    143 => (0=>"11111111", 1=>"11111111", 2=>"11111111"),  -- FFFFFF
    145 => (0=>"11110000", 1=>"11001100", 2=>"10010100"),  -- F0CC94
    146 => (0=>"10000100", 1=>"10000100", 2=>"10000100"),  -- 848484
    147 => (0=>"10000100", 1=>"10000100", 2=>"10000100"),  -- 848484
    148 => (0=>"11001100", 1=>"11001100", 2=>"11001100"),  -- CCCCCC
    149 => (0=>"11001100", 1=>"11001100", 2=>"10100110"),  -- CCCCA6
    150 => (0=>"10110111", 1=>"10110111", 2=>"10110111"),  -- B7B7B7
    153 => (0=>"10110111", 1=>"00000011", 2=>"11001100"),  -- B703CC
    154 => (0=>"00000011", 1=>"10010100", 2=>"00000011"),  -- 039403
    155 => (0=>"11011100", 1=>"10110111", 2=>"10000100"),  -- DCB784
    156 => (0=>"01100010", 1=>"01100010", 2=>"11001100"),  -- 6262CC
    157 => (0=>"11111111", 1=>"11111111", 2=>"00000011"),  -- FFFF03
    158 => (0=>"10100110", 1=>"11011100", 2=>"10100110"),  -- A6DCA6
    159 => (0=>"11111111", 1=>"11111111", 2=>"11111111"),  -- FFFFFF
    160 => (0=>"10000100", 1=>"10000100", 2=>"10000100"),  -- 848484
    161 => (0=>"10110111", 1=>"00000011", 2=>"11001100"),  -- B703CC
    162 => (0=>"11111111", 1=>"11111111", 2=>"11111111"),  -- FFFFFF
    163 => (0=>"11111111", 1=>"11111111", 2=>"11111111"),  -- FFFFFF
    164 => (0=>"11111111", 1=>"11111111", 2=>"11111111"),  -- FFFFFF
    165 => (0=>"11001100", 1=>"10100110", 2=>"11011100"),  -- CCA6DC
    166 => (0=>"10110111", 1=>"11011100", 2=>"11110000"),  -- B7DCF0
    167 => (0=>"11111111", 1=>"11111111", 2=>"11111111"),  -- FFFFFF
    168 => (0=>"10000100", 1=>"10000100", 2=>"10000100"),  -- 848484
    169 => (0=>"10100110", 1=>"01110000", 2=>"00000011"),  -- A67003
    170 => (0=>"11001100", 1=>"10100110", 2=>"00000011"),  -- CCA603
    171 => (0=>"11110000", 1=>"11011100", 2=>"00000011"),  -- F0DC03
    173 => (0=>"10100110", 1=>"10000100", 2=>"01110000"),  -- A68470
    174 => (0=>"10110111", 1=>"11011100", 2=>"11110000"),  -- B7DCF0
    175 => (0=>"10110111", 1=>"10110111", 2=>"10110111"),  -- B7B7B7
    176 => (0=>"10010100", 1=>"11001100", 2=>"11001100"),  -- 94CCCC
    177 => (0=>"11111111", 1=>"00000011", 2=>"00000011"),  -- FF0303
    178 => (0=>"01100010", 1=>"10010100", 2=>"00000011"),  -- 629403
    179 => (0=>"11011100", 1=>"10100110", 2=>"01010000"),  -- DCA650
    180 => (0=>"00000011", 1=>"01100010", 2=>"01010000"),  -- 036250
    181 => (0=>"11001100", 1=>"01110000", 2=>"00000011"),  -- CC7003
    182 => (0=>"10010100", 1=>"11001100", 2=>"11001100"),  -- 94CCCC
    183 => (0=>"11001100", 1=>"11011100", 2=>"10000100"),  -- CCDC84
    184 => (0=>"11001100", 1=>"11011100", 2=>"10000100"),  -- CCDC84
    185 => (0=>"10010100", 1=>"01100010", 2=>"00000011"),  -- 946203
    186 => (0=>"01100010", 1=>"10010100", 2=>"00000011"),  -- 629403
    187 => (0=>"11011100", 1=>"10100110", 2=>"01010000"),  -- DCA650
    188 => (0=>"00000011", 1=>"01100010", 2=>"01010000"),  -- 036250
    189 => (0=>"11001100", 1=>"01110000", 2=>"00000011"),  -- CC7003
    190 => (0=>"10110111", 1=>"10000100", 2=>"01010000"),  -- B78450
    192 => (0=>"11001100", 1=>"11011100", 2=>"10000100"),  -- CCDC84
    193 => (0=>"01110000", 1=>"01000001", 2=>"00000011"),  -- 704103
    194 => (0=>"10100110", 1=>"10000100", 2=>"01010000"),  -- A68450
    195 => (0=>"11011100", 1=>"10100110", 2=>"00000011"),  -- DCA603
    197 => (0=>"10100110", 1=>"01100010", 2=>"00000011"),  -- A66203
    198 => (0=>"10010100", 1=>"10000100", 2=>"01110000"),  -- 948470
    199 => (0=>"10110111", 1=>"10100110", 2=>"10010100"),  -- B7A694
    200 => (0=>"11011100", 1=>"10100110", 2=>"01010000"),  -- DCA650
    201 => (0=>"01110000", 1=>"01000001", 2=>"00000011"),  -- 704103
    202 => (0=>"10100110", 1=>"10000100", 2=>"01010000"),  -- A68450
    203 => (0=>"11011100", 1=>"10100110", 2=>"00000011"),  -- DCA603
    204 => (0=>"11001100", 1=>"11011100", 2=>"10000100"),  -- CCDC84
    205 => (0=>"10100110", 1=>"01100010", 2=>"00000011"),  -- A66203
    206 => (0=>"10010100", 1=>"10000100", 2=>"01110000"),  -- 948470
    207 => (0=>"10110111", 1=>"10100110", 2=>"10010100"),  -- B7A694
    208 => (0=>"11011100", 1=>"10100110", 2=>"01010000"),  -- DCA650
    209 => (0=>"11110000", 1=>"00000011", 2=>"10000100"),  -- F00384
    210 => (0=>"11001100", 1=>"11011100", 2=>"10000100"),  -- CCDC84
    212 => (0=>"00000011", 1=>"00000011", 2=>"11110000"),  -- 0303F0
    213 => (0=>"11001100", 1=>"10110111", 2=>"11001100"),  -- CCB7CC
    214 => (0=>"10010100", 1=>"11001100", 2=>"11001100"),  -- 94CCCC
    215 => (0=>"11110000", 1=>"11110000", 2=>"11110000"),  -- F0F0F0
    224 => (0=>"01100010", 1=>"01100010", 2=>"01100010"),  -- 626262
    225 => (0=>"11011100", 1=>"01100010", 2=>"00000011"),  -- DC6203
    227 => (0=>"11011100", 1=>"11011100", 2=>"00000011"),  -- DCDC03
    228 => (0=>"00000011", 1=>"10100110", 2=>"11011100"),  -- 03A6DC
    230 => (0=>"10100110", 1=>"11011100", 2=>"11011100"),  -- A6DCDC
    232 => (0=>"10100110", 1=>"11011100", 2=>"10100110"),  -- A6DCA6
    234 => (0=>"10110111", 1=>"01110000", 2=>"01100010"),  -- B77062
    236 => (0=>"11110000", 1=>"10100110", 2=>"10010100"),  -- F0A694
    240 => (0=>"00000011", 1=>"11111111", 2=>"11111111"),  -- 03FFFF
    242 => (0=>"11111111", 1=>"00000011", 2=>"00000011"),  -- FF0303
    243 => (0=>"11111111", 1=>"10100110", 2=>"00000011"),  -- FFA603
    244 => (0=>"00000011", 1=>"00000011", 2=>"11111111"),  -- 0303FF
    245 => (0=>"11111111", 1=>"10100110", 2=>"10000100"),  -- FFA684
    247 => (0=>"11111111", 1=>"11111111", 2=>"11111111"),  -- FFFFFF
    248 => (0=>"10100110", 1=>"10100110", 2=>"11011100"),  -- A6A6DC
    249 => (0=>"10100110", 1=>"11011100", 2=>"10100110"),  -- A6DCA6
    250 => (0=>"11001100", 1=>"10010100", 2=>"01110000"),  -- CC9470
    251 => (0=>"10110111", 1=>"01110000", 2=>"01100010"),  -- B77062
    252 => (0=>"11001100", 1=>"01110000", 2=>"10000100"),  -- CC7084
    253 => (0=>"11110000", 1=>"10100110", 2=>"10010100"),  -- F0A694
		others => (others => "00000011")
  );
                                          
	constant sprite_pal : pal_a(0 to 255) :=
	(
    1 => (0=>"11111111", 1=>"00000011", 2=>"00000011"),  -- FF0303
    2 => (0=>"00000011", 1=>"11111111", 2=>"00000011"),  -- 03FF03
    3 => (0=>"11111111", 1=>"11111111", 2=>"00000011"),  -- FFFF03
    4 => (0=>"00000011", 1=>"00000011", 2=>"11111111"),  -- 0303FF
    5 => (0=>"11111111", 1=>"10100110", 2=>"00000011"),  -- FFA603
    7 => (0=>"11111111", 1=>"11111111", 2=>"11111111"),  -- FFFFFF
    9 => (0=>"11111111", 1=>"00000011", 2=>"00000011"),  -- FF0303
    10 => (0=>"00000011", 1=>"11111111", 2=>"00000011"),  -- 03FF03
    11 => (0=>"11111111", 1=>"11111111", 2=>"00000011"),  -- FFFF03
    12 => (0=>"00000011", 1=>"00000011", 2=>"11111111"),  -- 0303FF
    13 => (0=>"11111111", 1=>"00000011", 2=>"11111111"),  -- FF03FF
    14 => (0=>"00000011", 1=>"11111111", 2=>"11111111"),  -- 03FFFF
    15 => (0=>"11111111", 1=>"11111111", 2=>"11111111"),  -- FFFFFF
    17 => (0=>"11111111", 1=>"00000011", 2=>"00000011"),  -- FF0303
    18 => (0=>"01100010", 1=>"01100010", 2=>"01100010"),  -- 626262
    19 => (0=>"11111111", 1=>"11111111", 2=>"00000011"),  -- FFFF03
    20 => (0=>"00000011", 1=>"00000011", 2=>"11111111"),  -- 0303FF
    21 => (0=>"11111111", 1=>"00000011", 2=>"11111111"),  -- FF03FF
    22 => (0=>"00000011", 1=>"11111111", 2=>"11111111"),  -- 03FFFF
    23 => (0=>"11111111", 1=>"11111111", 2=>"11111111"),  -- FFFFFF
    25 => (0=>"11111111", 1=>"00000011", 2=>"00000011"),  -- FF0303
    26 => (0=>"00000011", 1=>"11111111", 2=>"00000011"),  -- 03FF03
    27 => (0=>"11111111", 1=>"10100110", 2=>"00000011"),  -- FFA603
    28 => (0=>"00000011", 1=>"00110001", 2=>"11111111"),  -- 0331FF
    29 => (0=>"11111111", 1=>"10100110", 2=>"10000100"),  -- FFA684
    30 => (0=>"00000011", 1=>"11111111", 2=>"11111111"),  -- 03FFFF
    31 => (0=>"11111111", 1=>"11111111", 2=>"11111111"),  -- FFFFFF
    33 => (0=>"11111111", 1=>"00000011", 2=>"00000011"),  -- FF0303
    34 => (0=>"00000011", 1=>"11111111", 2=>"00000011"),  -- 03FF03
    35 => (0=>"10100110", 1=>"01100010", 2=>"00000011"),  -- A66203
    36 => (0=>"00000011", 1=>"00110001", 2=>"11111111"),  -- 0331FF
    37 => (0=>"11111111", 1=>"10100110", 2=>"10000100"),  -- FFA684
    38 => (0=>"11111111", 1=>"11111111", 2=>"11111111"),  -- FFFFFF
    39 => (0=>"11111111", 1=>"11111111", 2=>"11111111"),  -- FFFFFF
    41 => (0=>"11011100", 1=>"00000011", 2=>"00000011"),  -- DC0303
    42 => (0=>"00000011", 1=>"11111111", 2=>"00000011"),  -- 03FF03
    43 => (0=>"11111111", 1=>"11111111", 2=>"00000011"),  -- FFFF03
    44 => (0=>"00000011", 1=>"10100110", 2=>"11111111"),  -- 03A6FF
    45 => (0=>"11111111", 1=>"10100110", 2=>"00000011"),  -- FFA603
    46 => (0=>"11111111", 1=>"11111111", 2=>"11111111"),  -- FFFFFF
    47 => (0=>"11111111", 1=>"11111111", 2=>"11111111"),  -- FFFFFF
    49 => (0=>"11011100", 1=>"00000011", 2=>"00000011"),  -- DC0303
    51 => (0=>"11111111", 1=>"11111111", 2=>"00000011"),  -- FFFF03
    52 => (0=>"00000011", 1=>"10100110", 2=>"11111111"),  -- 03A6FF
    53 => (0=>"11111111", 1=>"10100110", 2=>"00000011"),  -- FFA603
    54 => (0=>"11111111", 1=>"11111111", 2=>"11111111"),  -- FFFFFF
    55 => (0=>"11111111", 1=>"11111111", 2=>"11111111"),  -- FFFFFF
    57 => (0=>"11111111", 1=>"00000011", 2=>"00000011"),  -- FF0303
    58 => (0=>"11111111", 1=>"11111111", 2=>"11111111"),  -- FFFFFF
    59 => (0=>"11111111", 1=>"10100110", 2=>"00000011"),  -- FFA603
    60 => (0=>"00000011", 1=>"10000100", 2=>"11111111"),  -- 0384FF
    61 => (0=>"11111111", 1=>"11111111", 2=>"11111111"),  -- FFFFFF
    62 => (0=>"10100110", 1=>"11001100", 2=>"11001100"),  -- A6CCCC
    63 => (0=>"11110000", 1=>"11110000", 2=>"11110000"),  -- F0F0F0
    65 => (0=>"11111111", 1=>"00000011", 2=>"00000011"),  -- FF0303
    66 => (0=>"00000011", 1=>"11110000", 2=>"01100010"),  -- 03F062
    67 => (0=>"11111111", 1=>"11111111", 2=>"11111111"),  -- FFFFFF
    68 => (0=>"00000011", 1=>"01000001", 2=>"11111111"),  -- 0341FF
    69 => (0=>"11111111", 1=>"11111111", 2=>"11111111"),  -- FFFFFF
    71 => (0=>"11110000", 1=>"11110000", 2=>"11110000"),  -- F0F0F0
    73 => (0=>"11111111", 1=>"00000011", 2=>"00000011"),  -- FF0303
    75 => (0=>"11111111", 1=>"11111111", 2=>"11111111"),  -- FFFFFF
    76 => (0=>"00000011", 1=>"01000001", 2=>"11111111"),  -- 0341FF
    77 => (0=>"11111111", 1=>"11111111", 2=>"11111111"),  -- FFFFFF
    78 => (0=>"00000011", 1=>"11110000", 2=>"01100010"),  -- 03F062
    79 => (0=>"11110000", 1=>"11110000", 2=>"11110000"),  -- F0F0F0
    81 => (0=>"11111111", 1=>"00000011", 2=>"00000011"),  -- FF0303
    82 => (0=>"00000011", 1=>"10100110", 2=>"00000011"),  -- 03A603
    83 => (0=>"11111111", 1=>"11111111", 2=>"00000011"),  -- FFFF03
    84 => (0=>"00000011", 1=>"01000001", 2=>"11111111"),  -- 0341FF
    86 => (0=>"00000011", 1=>"11110000", 2=>"11110000"),  -- 03F0F0
    87 => (0=>"11110000", 1=>"11110000", 2=>"11110000"),  -- F0F0F0
    89 => (0=>"11111111", 1=>"00000011", 2=>"00000011"),  -- FF0303
    91 => (0=>"11111111", 1=>"11111111", 2=>"00000011"),  -- FFFF03
    92 => (0=>"00000011", 1=>"01000001", 2=>"11111111"),  -- 0341FF
    94 => (0=>"00000011", 1=>"11110000", 2=>"11110000"),  -- 03F0F0
    95 => (0=>"11110000", 1=>"11110000", 2=>"11110000"),  -- F0F0F0
    98 => (0=>"11110000", 1=>"10100110", 2=>"00000011"),  -- F0A603
    99 => (0=>"11110000", 1=>"10110111", 2=>"10000100"),  -- F0B784
    100 => (0=>"00000011", 1=>"10010100", 2=>"11011100"),  -- 0394DC
    101 => (0=>"11111111", 1=>"11001100", 2=>"10100110"),  -- FFCCA6
    102 => (0=>"11001100", 1=>"11110000", 2=>"11110000"),  -- CCF0F0
    103 => (0=>"11111111", 1=>"11111111", 2=>"11111111"),  -- FFFFFF
    105 => (0=>"01110000", 1=>"01000001", 2=>"00000011"),  -- 704103
    106 => (0=>"10100110", 1=>"10000100", 2=>"01010000"),  -- A68450
    107 => (0=>"11011100", 1=>"10100110", 2=>"00000011"),  -- DCA603
    109 => (0=>"10100110", 1=>"01100010", 2=>"00000011"),  -- A66203
    110 => (0=>"10010100", 1=>"10000100", 2=>"01110000"),  -- 948470
    111 => (0=>"10110111", 1=>"10100110", 2=>"10010100"),  -- B7A694
    113 => (0=>"11110000", 1=>"00110001", 2=>"00110001"),  -- F03131
    114 => (0=>"11111111", 1=>"11111111", 2=>"11111111"),  -- FFFFFF
    115 => (0=>"10100110", 1=>"01100010", 2=>"00000011"),  -- A66203
    116 => (0=>"00000011", 1=>"01000001", 2=>"11111111"),  -- 0341FF
    117 => (0=>"11111111", 1=>"10100110", 2=>"10000100"),  -- FFA684
    118 => (0=>"11111111", 1=>"11111111", 2=>"11111111"),  -- FFFFFF
    119 => (0=>"11110000", 1=>"11110000", 2=>"11110000"),  -- F0F0F0
    121 => (0=>"11111111", 1=>"00000011", 2=>"00000011"),  -- FF0303
    122 => (0=>"10000100", 1=>"11001100", 2=>"00000011"),  -- 84CC03
    123 => (0=>"11111111", 1=>"10110111", 2=>"00000011"),  -- FFB703
    124 => (0=>"00000011", 1=>"01000001", 2=>"11011100"),  -- 0341DC
    125 => (0=>"11111111", 1=>"11111111", 2=>"11111111"),  -- FFFFFF
    126 => (0=>"00000011", 1=>"10010100", 2=>"00000011"),  -- 039403
    127 => (0=>"11110000", 1=>"11110000", 2=>"11110000"),  -- F0F0F0
    129 => (0=>"11111111", 1=>"00000011", 2=>"00000011"),  -- FF0303
    130 => (0=>"00000011", 1=>"11111111", 2=>"00000011"),  -- 03FF03
    131 => (0=>"11111111", 1=>"11111111", 2=>"00000011"),  -- FFFF03
    132 => (0=>"00000011", 1=>"00000011", 2=>"11111111"),  -- 0303FF
    133 => (0=>"11111111", 1=>"10100110", 2=>"00000011"),  -- FFA603
    135 => (0=>"11111111", 1=>"11111111", 2=>"11111111"),  -- FFFFFF
    137 => (0=>"11111111", 1=>"00000011", 2=>"00000011"),  -- FF0303
    138 => (0=>"00000011", 1=>"11111111", 2=>"00000011"),  -- 03FF03
    139 => (0=>"11111111", 1=>"11111111", 2=>"00000011"),  -- FFFF03
    140 => (0=>"00000011", 1=>"00000011", 2=>"11111111"),  -- 0303FF
    141 => (0=>"11111111", 1=>"00000011", 2=>"11111111"),  -- FF03FF
    142 => (0=>"00000011", 1=>"11111111", 2=>"11111111"),  -- 03FFFF
    143 => (0=>"11111111", 1=>"11111111", 2=>"11111111"),  -- FFFFFF
    145 => (0=>"11111111", 1=>"00000011", 2=>"00000011"),  -- FF0303
    146 => (0=>"01100010", 1=>"01100010", 2=>"01100010"),  -- 626262
    147 => (0=>"11111111", 1=>"11111111", 2=>"00000011"),  -- FFFF03
    148 => (0=>"00000011", 1=>"00000011", 2=>"11111111"),  -- 0303FF
    149 => (0=>"11111111", 1=>"00000011", 2=>"11111111"),  -- FF03FF
    150 => (0=>"00000011", 1=>"11111111", 2=>"11111111"),  -- 03FFFF
    151 => (0=>"11111111", 1=>"11111111", 2=>"11111111"),  -- FFFFFF
    153 => (0=>"11111111", 1=>"00000011", 2=>"00000011"),  -- FF0303
    154 => (0=>"00000011", 1=>"11111111", 2=>"00000011"),  -- 03FF03
    155 => (0=>"11111111", 1=>"10100110", 2=>"00000011"),  -- FFA603
    156 => (0=>"00000011", 1=>"00110001", 2=>"11111111"),  -- 0331FF
    157 => (0=>"11111111", 1=>"10100110", 2=>"10000100"),  -- FFA684
    158 => (0=>"00000011", 1=>"11111111", 2=>"11111111"),  -- 03FFFF
    159 => (0=>"11111111", 1=>"11111111", 2=>"11111111"),  -- FFFFFF
    161 => (0=>"11111111", 1=>"00000011", 2=>"00000011"),  -- FF0303
    162 => (0=>"00000011", 1=>"11111111", 2=>"00000011"),  -- 03FF03
    163 => (0=>"10100110", 1=>"01100010", 2=>"00000011"),  -- A66203
    164 => (0=>"00000011", 1=>"00110001", 2=>"11111111"),  -- 0331FF
    165 => (0=>"11111111", 1=>"10100110", 2=>"10000100"),  -- FFA684
    166 => (0=>"11111111", 1=>"11111111", 2=>"11111111"),  -- FFFFFF
    167 => (0=>"11111111", 1=>"11111111", 2=>"11111111"),  -- FFFFFF
    169 => (0=>"11011100", 1=>"00000011", 2=>"00000011"),  -- DC0303
    170 => (0=>"00000011", 1=>"11111111", 2=>"00000011"),  -- 03FF03
    171 => (0=>"11111111", 1=>"11111111", 2=>"00000011"),  -- FFFF03
    172 => (0=>"00000011", 1=>"10100110", 2=>"11111111"),  -- 03A6FF
    173 => (0=>"11111111", 1=>"10100110", 2=>"00000011"),  -- FFA603
    174 => (0=>"11111111", 1=>"11111111", 2=>"11111111"),  -- FFFFFF
    175 => (0=>"11111111", 1=>"11111111", 2=>"11111111"),  -- FFFFFF
    177 => (0=>"11011100", 1=>"00000011", 2=>"00000011"),  -- DC0303
    179 => (0=>"11111111", 1=>"11111111", 2=>"00000011"),  -- FFFF03
    180 => (0=>"00000011", 1=>"10100110", 2=>"11111111"),  -- 03A6FF
    181 => (0=>"11111111", 1=>"10100110", 2=>"00000011"),  -- FFA603
    182 => (0=>"11111111", 1=>"11111111", 2=>"11111111"),  -- FFFFFF
    183 => (0=>"11111111", 1=>"11111111", 2=>"11111111"),  -- FFFFFF
    185 => (0=>"11111111", 1=>"00000011", 2=>"00000011"),  -- FF0303
    186 => (0=>"11111111", 1=>"11111111", 2=>"11111111"),  -- FFFFFF
    187 => (0=>"11111111", 1=>"10100110", 2=>"00000011"),  -- FFA603
    188 => (0=>"00000011", 1=>"10000100", 2=>"11111111"),  -- 0384FF
    189 => (0=>"11111111", 1=>"11111111", 2=>"11111111"),  -- FFFFFF
    190 => (0=>"10100110", 1=>"11001100", 2=>"11001100"),  -- A6CCCC
    191 => (0=>"11110000", 1=>"11110000", 2=>"11110000"),  -- F0F0F0
    193 => (0=>"11111111", 1=>"00000011", 2=>"00000011"),  -- FF0303
    194 => (0=>"00000011", 1=>"11110000", 2=>"01100010"),  -- 03F062
    195 => (0=>"11111111", 1=>"11111111", 2=>"11111111"),  -- FFFFFF
    196 => (0=>"00000011", 1=>"01000001", 2=>"11111111"),  -- 0341FF
    197 => (0=>"11111111", 1=>"11111111", 2=>"11111111"),  -- FFFFFF
    199 => (0=>"11110000", 1=>"11110000", 2=>"11110000"),  -- F0F0F0
    201 => (0=>"11111111", 1=>"00000011", 2=>"00000011"),  -- FF0303
    203 => (0=>"11111111", 1=>"11111111", 2=>"11111111"),  -- FFFFFF
    204 => (0=>"00000011", 1=>"01000001", 2=>"11111111"),  -- 0341FF
    205 => (0=>"11111111", 1=>"11111111", 2=>"11111111"),  -- FFFFFF
    206 => (0=>"00000011", 1=>"11110000", 2=>"01100010"),  -- 03F062
    207 => (0=>"11110000", 1=>"11110000", 2=>"11110000"),  -- F0F0F0
    209 => (0=>"11111111", 1=>"00000011", 2=>"00000011"),  -- FF0303
    210 => (0=>"00000011", 1=>"10100110", 2=>"00000011"),  -- 03A603
    211 => (0=>"11111111", 1=>"11111111", 2=>"00000011"),  -- FFFF03
    212 => (0=>"00000011", 1=>"01000001", 2=>"11111111"),  -- 0341FF
    214 => (0=>"00000011", 1=>"11110000", 2=>"11110000"),  -- 03F0F0
    215 => (0=>"11110000", 1=>"11110000", 2=>"11110000"),  -- F0F0F0
    217 => (0=>"11111111", 1=>"00000011", 2=>"00000011"),  -- FF0303
    219 => (0=>"11111111", 1=>"11111111", 2=>"00000011"),  -- FFFF03
    220 => (0=>"00000011", 1=>"01000001", 2=>"11111111"),  -- 0341FF
    222 => (0=>"00000011", 1=>"11110000", 2=>"11110000"),  -- 03F0F0
    223 => (0=>"11110000", 1=>"11110000", 2=>"11110000"),  -- F0F0F0
    226 => (0=>"11110000", 1=>"10100110", 2=>"00000011"),  -- F0A603
    227 => (0=>"11110000", 1=>"10110111", 2=>"10000100"),  -- F0B784
    228 => (0=>"00000011", 1=>"10010100", 2=>"11011100"),  -- 0394DC
    229 => (0=>"11111111", 1=>"11001100", 2=>"10100110"),  -- FFCCA6
    230 => (0=>"11001100", 1=>"11110000", 2=>"11110000"),  -- CCF0F0
    231 => (0=>"11111111", 1=>"11111111", 2=>"11111111"),  -- FFFFFF
    233 => (0=>"01110000", 1=>"01000001", 2=>"00000011"),  -- 704103
    234 => (0=>"10100110", 1=>"10000100", 2=>"01010000"),  -- A68450
    235 => (0=>"11011100", 1=>"10100110", 2=>"00000011"),  -- DCA603
    237 => (0=>"10100110", 1=>"01100010", 2=>"00000011"),  -- A66203
    238 => (0=>"10010100", 1=>"10000100", 2=>"01110000"),  -- 948470
    239 => (0=>"10110111", 1=>"10100110", 2=>"10010100"),  -- B7A694
    241 => (0=>"11110000", 1=>"00110001", 2=>"00110001"),  -- F03131
    242 => (0=>"11111111", 1=>"11111111", 2=>"11111111"),  -- FFFFFF
    243 => (0=>"10100110", 1=>"01100010", 2=>"00000011"),  -- A66203
    244 => (0=>"00000011", 1=>"01000001", 2=>"11111111"),  -- 0341FF
    245 => (0=>"11111111", 1=>"10100110", 2=>"10000100"),  -- FFA684
    246 => (0=>"11111111", 1=>"11111111", 2=>"11111111"),  -- FFFFFF
    247 => (0=>"11110000", 1=>"11110000", 2=>"11110000"),  -- F0F0F0
    249 => (0=>"11111111", 1=>"00000011", 2=>"00000011"),  -- FF0303
    250 => (0=>"10000100", 1=>"11001100", 2=>"00000011"),  -- 84CC03
    251 => (0=>"11111111", 1=>"10110111", 2=>"00000011"),  -- FFB703
    252 => (0=>"00000011", 1=>"01000001", 2=>"11011100"),  -- 0341DC
    253 => (0=>"11111111", 1=>"11111111", 2=>"11111111"),  -- FFFFFF
    254 => (0=>"00000011", 1=>"10010100", 2=>"00000011"),  -- 039403
    255 => (0=>"11110000", 1=>"11110000", 2=>"11110000"),  -- F0F0F0
		others => (others => "00000011")
	);

  -- table of sprite heights
  type prom_a is array (natural range <>) of integer range 0 to 3;
  constant sprite_prom : prom_a(0 to 31) :=
  (
    4 => 0,
    5 => 0,
    6 => 0,
    7 => 0,
    12 => 0,
    13 => 0,
    14 => 0,
    15 => 0,
    20 => 0,
    21 => 0,
    22 => 0,
    23 => 0,
    28 => 0,
    29 => 0,
    30 => 0,
    31 => 0,
    others => 1
  );
  
end package platform_variant_pkg;
