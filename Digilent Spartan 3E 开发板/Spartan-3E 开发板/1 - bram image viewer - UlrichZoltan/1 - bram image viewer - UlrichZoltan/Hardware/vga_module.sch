VERSION 6
BEGIN SCHEMATIC
    BEGIN ATTR DeviceFamilyName "spartan3"
        DELETE all:0
        EDITNAME all:0
        EDITTRAIT all:0
    END ATTR
    BEGIN NETLIST
        SIGNAL RST
        SIGNAL RESOLUTION
        SIGNAL XLXN_84
        SIGNAL XLXN_85
        SIGNAL XLXN_86(10:0)
        SIGNAL XLXN_87(10:0)
        SIGNAL HS
        SIGNAL VS
        SIGNAL BLANK
        SIGNAL HCOUNT(10:0)
        SIGNAL VCOUNT(10:0)
        SIGNAL CLK_25MHz
        SIGNAL CLK_40MHz
        SIGNAL XLXN_95
        SIGNAL XLXN_96
        SIGNAL XLXN_97
        SIGNAL XLXN_98
        SIGNAL XLXN_101(10:0)
        SIGNAL XLXN_102(10:0)
        PORT Input RST
        PORT Input RESOLUTION
        PORT Output HS
        PORT Output VS
        PORT Output BLANK
        PORT Output HCOUNT(10:0)
        PORT Output VCOUNT(10:0)
        PORT Input CLK_25MHz
        PORT Input CLK_40MHz
        BEGIN BLOCKDEF vga_controller_640_60
            TIMESTAMP 2006 9 24 13 7 51
            LINE N 64 -480 0 -480 
            LINE N 64 -416 0 -416 
            RECTANGLE N 64 -512 336 -192 
            LINE N 336 -480 400 -480 
            LINE N 336 -416 400 -416 
            LINE N 336 -352 400 -352 
            RECTANGLE N 336 -300 400 -276 
            LINE N 336 -288 400 -288 
            RECTANGLE N 336 -236 400 -212 
            LINE N 336 -224 400 -224 
        END BLOCKDEF
        BEGIN BLOCKDEF vga_selector
            TIMESTAMP 2006 9 23 10 32 21
            RECTANGLE N 68 -1652 392 -944 
            LINE N 68 -1616 16 -1616 
            LINE N 68 -1552 16 -1552 
            LINE N 68 -1488 16 -1488 
            LINE N 68 -1424 16 -1424 
            LINE N 68 -1360 16 -1360 
            LINE N 68 -1296 16 -1296 
            RECTANGLE N 16 -1244 68 -1220 
            LINE N 68 -1232 16 -1232 
            RECTANGLE N 16 -1116 68 -1092 
            LINE N 68 -1104 16 -1104 
            RECTANGLE N 16 -1052 68 -1028 
            LINE N 68 -1040 20 -1040 
            LINE N 68 -976 20 -976 
            LINE N 68 -1168 16 -1168 
            RECTANGLE N 16 -1180 68 -1156 
            LINE N 392 -1616 444 -1616 
            LINE N 392 -1552 448 -1552 
            LINE N 448 -1488 392 -1488 
            LINE N 392 -1424 448 -1424 
            RECTANGLE N 392 -1436 448 -1412 
            LINE N 392 -1360 448 -1360 
            RECTANGLE N 392 -1372 448 -1348 
        END BLOCKDEF
        BEGIN BLOCKDEF vga_controller_800_60
            TIMESTAMP 2006 9 18 11 53 28
            RECTANGLE N 64 -320 320 0 
            LINE N 64 -288 0 -288 
            LINE N 64 -32 0 -32 
            LINE N 320 -288 384 -288 
            LINE N 320 -224 384 -224 
            LINE N 320 -160 384 -160 
            RECTANGLE N 320 -108 384 -84 
            LINE N 320 -96 384 -96 
            RECTANGLE N 320 -44 384 -20 
            LINE N 320 -32 384 -32 
        END BLOCKDEF
        BEGIN BLOCK iVGA_640_60 vga_controller_640_60
            PIN rst RST
            PIN pixel_clk CLK_25MHz
            PIN HS XLXN_96
            PIN VS XLXN_97
            PIN blank XLXN_98
            PIN hcount(10:0) XLXN_101(10:0)
            PIN vcount(10:0) XLXN_102(10:0)
        END BLOCK
        BEGIN BLOCK iVGA_SELECTOR vga_selector
            PIN HS_640_60 XLXN_96
            PIN VS_640_60 XLXN_97
            PIN HS_800_60 XLXN_95
            PIN VS_800_60 XLXN_84
            PIN blank_640_60 XLXN_98
            PIN hcount_640_60(10:0) XLXN_101(10:0)
            PIN vcount_640_60(10:0) XLXN_102(10:0)
            PIN blank_800_60 XLXN_85
            PIN hcount_800_60(10:0) XLXN_87(10:0)
            PIN vcount_800_60(10:0) XLXN_86(10:0)
            PIN resolution RESOLUTION
            PIN hs HS
            PIN vs VS
            PIN blank BLANK
            PIN hcount(10:0) HCOUNT(10:0)
            PIN vcount(10:0) VCOUNT(10:0)
        END BLOCK
        BEGIN BLOCK iVGA_800_60 vga_controller_800_60
            PIN rst RST
            PIN pixel_clk CLK_40MHz
            PIN HS XLXN_95
            PIN VS XLXN_84
            PIN blank XLXN_85
            PIN vcount(10:0) XLXN_86(10:0)
            PIN hcount(10:0) XLXN_87(10:0)
        END BLOCK
    END NETLIST
    BEGIN SHEET 1 3520 2720
        BEGIN INSTANCE iVGA_800_60 1488 848 R0
        END INSTANCE
        BEGIN INSTANCE iVGA_SELECTOR 2432 1792 R0
        END INSTANCE
        BEGIN BRANCH RST
            WIRE 1312 176 1408 176
            WIRE 1408 176 1408 560
            WIRE 1408 560 1488 560
            WIRE 1408 176 1472 176
        END BRANCH
        BEGIN BRANCH XLXN_84
            WIRE 1872 624 1936 624
            WIRE 1936 624 1936 688
            WIRE 1936 688 2224 688
            WIRE 2224 368 2224 688
            WIRE 2224 368 2448 368
        END BRANCH
        BEGIN BRANCH XLXN_85
            WIRE 1872 688 1920 688
            WIRE 1920 496 1920 688
            WIRE 1920 496 2448 496
        END BRANCH
        BEGIN BRANCH XLXN_86(10:0)
            WIRE 1872 752 2448 752
        END BRANCH
        BEGIN BRANCH XLXN_87(10:0)
            WIRE 1872 816 1936 816
            WIRE 1936 768 1936 816
            WIRE 1936 768 2304 768
            WIRE 2304 688 2304 768
            WIRE 2304 688 2448 688
        END BRANCH
        BEGIN BRANCH HS
            WIRE 2880 176 2912 176
        END BRANCH
        IOMARKER 2912 176 HS R0 28
        BEGIN BRANCH VS
            WIRE 2880 240 2912 240
        END BRANCH
        IOMARKER 2912 240 VS R0 28
        BEGIN BRANCH BLANK
            WIRE 2880 304 2912 304
        END BRANCH
        IOMARKER 2912 304 BLANK R0 28
        BEGIN BRANCH HCOUNT(10:0)
            WIRE 2880 368 2912 368
        END BRANCH
        IOMARKER 2912 368 HCOUNT(10:0) R0 28
        BEGIN BRANCH VCOUNT(10:0)
            WIRE 2880 432 2912 432
        END BRANCH
        IOMARKER 2912 432 VCOUNT(10:0) R0 28
        IOMARKER 1312 176 RST R180 28
        IOMARKER 1312 240 CLK_25MHz R180 28
        BEGIN BRANCH CLK_25MHz
            WIRE 1312 240 1472 240
        END BRANCH
        BEGIN INSTANCE iVGA_640_60 1472 656 R0
        END INSTANCE
        BEGIN BRANCH CLK_40MHz
            WIRE 1312 304 1344 304
            WIRE 1344 304 1344 816
            WIRE 1344 816 1488 816
        END BRANCH
        IOMARKER 1312 304 CLK_40MHz R180 28
        IOMARKER 1312 352 RESOLUTION R180 28
        BEGIN BRANCH RESOLUTION
            WIRE 1312 352 1376 352
            WIRE 1376 64 1376 352
            WIRE 1376 64 1952 64
            WIRE 1952 64 1952 816
            WIRE 1952 816 2448 816
        END BRANCH
        BEGIN BRANCH XLXN_95
            WIRE 1872 560 2160 560
            WIRE 2160 304 2160 560
            WIRE 2160 304 2448 304
        END BRANCH
        BEGIN BRANCH XLXN_96
            WIRE 1872 176 1888 176
            WIRE 1888 176 2448 176
        END BRANCH
        BEGIN BRANCH XLXN_97
            WIRE 1872 240 2448 240
        END BRANCH
        BEGIN BRANCH XLXN_98
            WIRE 1872 304 2144 304
            WIRE 2144 304 2144 432
            WIRE 2144 432 2448 432
        END BRANCH
        BEGIN BRANCH XLXN_101(10:0)
            WIRE 1872 368 2176 368
            WIRE 2176 368 2176 560
            WIRE 2176 560 2448 560
        END BRANCH
        BEGIN BRANCH XLXN_102(10:0)
            WIRE 1872 432 2128 432
            WIRE 2128 432 2128 624
            WIRE 2128 624 2448 624
        END BRANCH
    END SHEET
END SCHEMATIC
