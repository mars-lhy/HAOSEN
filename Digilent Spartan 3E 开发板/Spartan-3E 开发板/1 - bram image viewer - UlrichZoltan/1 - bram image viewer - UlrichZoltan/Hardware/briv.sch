VERSION 6
BEGIN SCHEMATIC
    BEGIN ATTR DeviceFamilyName "spartan3"
        DELETE all:0
        EDITNAME all:0
        EDITTRAIT all:0
    END ATTR
    BEGIN NETLIST
        SIGNAL DISPLAY(7:0)
        SIGNAL ANODES(3:0)
        SIGNAL resolution
        SIGNAL CLK
        SIGNAL PS2_CLK_KB
        SIGNAL PS2_DATA_KB
        SIGNAL HS
        SIGNAL VS
        SIGNAL RST
        SIGNAL clk_25MHz
        SIGNAL clk_40MHz
        SIGNAL new_request
        SIGNAL request_value(2:0)
        SIGNAL HEX1(7:0)
        SIGNAL HEX2(7:0)
        SIGNAL width(7:0)
        SIGNAL set_width
        SIGNAL height(7:0)
        SIGNAL set_height
        SIGNAL pixel_color(3:0)
        SIGNAL write_pixel_color
        SIGNAL clear_write_counter
        SIGNAL reset
        SIGNAL EPP_ASTB
        SIGNAL EPP_DSTB
        SIGNAL EPP_WRITE
        SIGNAL EPP_ACK
        SIGNAL EPP_BUS(7:0)
        SIGNAL pixel_clk
        SIGNAL XLXN_368
        SIGNAL blank
        SIGNAL HCOUNT(10:0)
        SIGNAL VCOUNT(10:0)
        SIGNAL BTN
        SIGNAL LEFT
        SIGNAL MIDDLE
        SIGNAL RIGHT
        SIGNAL ZPOS(3:0)
        SIGNAL RED(3:0)
        SIGNAL GREEN(3:0)
        SIGNAL BLUE(3:0)
        SIGNAL PS2_CLK_MS
        SIGNAL PS2_DATA_MS
        SIGNAL COUNTER(1:0)
        SIGNAL ASCII(6:0)
        SIGNAL new_key
        SIGNAL event_type
        PORT Output DISPLAY(7:0)
        PORT Output ANODES(3:0)
        PORT Input CLK
        PORT BiDirectional PS2_CLK_KB
        PORT BiDirectional PS2_DATA_KB
        PORT Output HS
        PORT Output VS
        PORT Input RST
        PORT Input EPP_ASTB
        PORT Input EPP_DSTB
        PORT Input EPP_WRITE
        PORT Output EPP_ACK
        PORT BiDirectional EPP_BUS(7:0)
        PORT Input BTN
        PORT Output LEFT
        PORT Output MIDDLE
        PORT Output RIGHT
        PORT Output ZPOS(3:0)
        PORT Output RED(3:0)
        PORT Output GREEN(3:0)
        PORT Output BLUE(3:0)
        PORT BiDirectional PS2_CLK_MS
        PORT BiDirectional PS2_DATA_MS
        PORT Output COUNTER(1:0)
        BEGIN BLOCKDEF hex_decoder
            TIMESTAMP 2006 10 10 11 52 29
            LINE N 64 -160 0 -160 
            RECTANGLE N 320 -172 384 -148 
            LINE N 320 -160 384 -160 
            RECTANGLE N 0 -108 64 -84 
            LINE N 64 -96 0 -96 
            RECTANGLE N 0 -44 64 -20 
            LINE N 64 -32 0 -32 
            RECTANGLE N 64 -192 320 0 
            RECTANGLE N 320 -44 384 -20 
            LINE N 320 -32 384 -32 
        END BLOCKDEF
        BEGIN BLOCKDEF vga_module
            TIMESTAMP 2006 9 23 12 3 20
            LINE N 416 -352 480 -352 
            LINE N 416 -288 480 -288 
            LINE N 416 -224 480 -224 
            RECTANGLE N 416 -172 480 -148 
            LINE N 416 -160 480 -160 
            RECTANGLE N 416 -108 480 -84 
            LINE N 416 -96 480 -96 
            RECTANGLE N 64 -384 416 -64 
            LINE N 64 -352 0 -352 
            LINE N 64 -288 0 -288 
            LINE N 64 -224 0 -224 
            LINE N 64 -160 0 -160 
        END BLOCKDEF
        BEGIN BLOCKDEF keyboard_control_module
            TIMESTAMP 2006 9 28 10 57 10
            RECTANGLE N 320 20 384 44 
            LINE N 320 32 384 32 
            LINE N 320 96 384 96 
            LINE N 320 160 384 160 
            LINE N 320 -352 384 -352 
            LINE N 320 -224 384 -224 
            RECTANGLE N 320 -172 384 -148 
            LINE N 320 -160 384 -160 
            LINE N 320 -96 384 -96 
            LINE N 320 -32 384 -32 
            LINE N 64 -352 0 -352 
            LINE N 64 -288 0 -288 
            LINE N 320 -288 384 -288 
            RECTANGLE N 64 -384 320 192 
        END BLOCKDEF
        BEGIN BLOCKDEF dcm_module
            TIMESTAMP 2006 9 23 10 38 48
            LINE N 64 -288 0 -288 
            LINE N 320 -288 384 -288 
            LINE N 64 -224 0 -224 
            RECTANGLE N 64 -320 320 -128 
            LINE N 320 -224 384 -224 
            LINE N 320 -160 384 -160 
        END BLOCKDEF
        BEGIN BLOCKDEF pixel_clock_switcher
            TIMESTAMP 2006 9 23 10 43 31
            RECTANGLE N 64 -192 320 0 
            LINE N 64 -160 0 -160 
            LINE N 64 -96 0 -96 
            LINE N 64 -32 0 -32 
            LINE N 320 -160 384 -160 
        END BLOCKDEF
        BEGIN BLOCKDEF image_module
            TIMESTAMP 2006 9 26 10 27 8
            LINE N 64 288 0 288 
            LINE N 64 352 0 352 
            RECTANGLE N 0 404 64 428 
            LINE N 64 416 0 416 
            LINE N 64 -736 0 -736 
            LINE N 64 -672 0 -672 
            RECTANGLE N 0 -620 64 -596 
            LINE N 64 -608 0 -608 
            LINE N 64 -544 0 -544 
            RECTANGLE N 0 -492 64 -468 
            LINE N 64 -480 0 -480 
            LINE N 64 -416 0 -416 
            RECTANGLE N 0 -364 64 -340 
            LINE N 64 -352 0 -352 
            LINE N 64 -288 0 -288 
            LINE N 64 -224 0 -224 
            RECTANGLE N 544 -748 608 -724 
            LINE N 544 -736 608 -736 
            RECTANGLE N 544 -684 608 -660 
            LINE N 544 -672 608 -672 
            LINE N 64 -160 0 -160 
            RECTANGLE N 0 -108 64 -84 
            LINE N 64 -96 0 -96 
            RECTANGLE N 0 -44 64 -20 
            LINE N 64 -32 0 -32 
            LINE N 64 96 0 96 
            LINE N 64 160 0 160 
            LINE N 64 32 0 32 
            LINE N 64 224 0 224 
            LINE N 544 -608 608 -608 
            LINE N 544 -544 608 -544 
            LINE N 544 -480 608 -480 
            RECTANGLE N 544 -364 608 -340 
            LINE N 544 -352 608 -352 
            RECTANGLE N 544 -300 608 -276 
            LINE N 544 -288 608 -288 
            RECTANGLE N 544 -236 608 -212 
            LINE N 544 -224 608 -224 
            LINE N 544 -160 608 -160 
            RECTANGLE N 544 -428 608 -404 
            LINE N 544 -416 608 -416 
            LINE N 544 -96 608 -96 
            LINE N 544 -32 608 -32 
            RECTANGLE N 544 -44 608 -20 
            RECTANGLE N 64 -768 544 448 
        END BLOCKDEF
        BEGIN BLOCKDEF epp_data_module
            TIMESTAMP 2006 9 25 15 18 49
            RECTANGLE N 64 -576 624 0 
            LINE N 64 -544 0 -544 
            LINE N 64 -480 0 -480 
            LINE N 64 -416 0 -416 
            LINE N 64 -352 0 -352 
            LINE N 64 -288 0 -288 
            LINE N 0 -224 64 -224 
            RECTANGLE N 0 -172 64 -148 
            LINE N 0 -160 64 -160 
            LINE N 64 -96 0 -96 
            RECTANGLE N 0 -44 64 -20 
            LINE N 64 -32 0 -32 
            RECTANGLE N 624 -556 688 -532 
            LINE N 624 -544 688 -544 
            LINE N 624 -480 688 -480 
            RECTANGLE N 624 -428 688 -404 
            LINE N 624 -416 688 -416 
            LINE N 624 -352 688 -352 
            RECTANGLE N 624 -300 688 -276 
            LINE N 624 -288 688 -288 
            LINE N 624 -224 688 -224 
            LINE N 624 -160 688 -160 
        END BLOCKDEF
        BEGIN BLOCK iVGA_MODULE vga_module
            PIN HS HS
            PIN VS VS
            PIN BLANK blank
            PIN HCOUNT(10:0) HCOUNT(10:0)
            PIN VCOUNT(10:0) VCOUNT(10:0)
            PIN RESOLUTION resolution
            PIN CLK_25MHz clk_25MHz
            PIN CLK_40MHz clk_40MHz
            PIN RST reset
        END BLOCK
        BEGIN BLOCK iHexDecoder hex_decoder
            PIN clk CLK
            PIN datain1(7:0) HEX1(7:0)
            PIN datain2(7:0) HEX2(7:0)
            PIN display_sseg(7:0) DISPLAY(7:0)
            PIN anodes(3:0) ANODES(3:0)
        END BLOCK
        BEGIN BLOCK iKEYBOARD_CONTROL_MODULE keyboard_control_module
            PIN RST reset
            PIN CLK CLK
            PIN PS2_CLK_KB PS2_CLK_KB
            PIN PS2_DATA_KB PS2_DATA_KB
            PIN ASCII(6:0) ASCII(6:0)
            PIN ready new_key
            PIN SWITCH XLXN_368
            PIN RESOLUTION resolution
            PIN NEW_REQUEST_OUT new_request
            PIN REQUEST_OUT(2:0) request_value(2:0)
            PIN event_type event_type
        END BLOCK
        BEGIN BLOCK iDCM_MODULE dcm_module
            PIN CLK CLK
            PIN RST RST
            PIN CLK_25MHz clk_25MHz
            PIN CLK_40MHz clk_40MHz
            PIN RESET reset
        END BLOCK
        BEGIN BLOCK iPIXEL_CLOCK_SWITCHER pixel_clock_switcher
            PIN pixel_clk_25MHz clk_25MHz
            PIN pixel_clk_40MHz clk_40MHz
            PIN resolution resolution
            PIN pixel_clk pixel_clk
        END BLOCK
        BEGIN BLOCK iIMAGE_MODULE image_module
            PIN RESOLUTION resolution
            PIN BLANK blank
            PIN SWITCH XLXN_368
            PIN CLK CLK
            PIN RST reset
            PIN VCOUNT(10:0) VCOUNT(10:0)
            PIN HCOUNT(10:0) HCOUNT(10:0)
            PIN PIXEL_CLK pixel_clk
            PIN WIDTH_IN(7:0) width(7:0)
            PIN SET_WIDTH_IN set_width
            PIN HEIGHT_IN(7:0) height(7:0)
            PIN SET_HEIGHT_IN set_height
            PIN PIXEL_COLOR_IN(3:0) pixel_color(3:0)
            PIN WRITE_PIXEL_COLOR_IN write_pixel_color
            PIN CLEAR_WRITE_COUNTER_IN clear_write_counter
            PIN BTN BTN
            PIN PS2_CLK PS2_CLK_MS
            PIN PS2_DATA PS2_DATA_MS
            PIN LEFT LEFT
            PIN MIDDLE MIDDLE
            PIN RIGHT RIGHT
            PIN ZPOS(3:0) ZPOS(3:0)
            PIN HEX1_OUT(7:0) HEX1(7:0)
            PIN HEX2_OUT(7:0) HEX2(7:0)
            PIN RED(3:0) RED(3:0)
            PIN GREEN(3:0) GREEN(3:0)
            PIN BLUE(3:0) BLUE(3:0)
            PIN COUNTER(1:0) COUNTER(1:0)
            PIN EVENT_TYPE event_type
            PIN NEW_KEY new_key
            PIN ASCII(6:0) ASCII(6:0)
        END BLOCK
        BEGIN BLOCK iEPP_DATA_MODULE epp_data_module
            PIN CLK CLK
            PIN RST reset
            PIN EPP_ASTB EPP_ASTB
            PIN EPP_DSTB EPP_DSTB
            PIN EPP_WRITE EPP_WRITE
            PIN EPP_ACK EPP_ACK
            PIN EPP_BUS(7:0) EPP_BUS(7:0)
            PIN NEW_REQUEST_IN new_request
            PIN REQUEST_VALUE_IN(2:0) request_value(2:0)
            PIN WIDTH_OUT(7:0) width(7:0)
            PIN SET_WIDTH_OUT set_width
            PIN HEIGHT_OUT(7:0) height(7:0)
            PIN SET_HEIGHT_OUT set_height
            PIN PIXEL_COLOR_OUT(3:0) pixel_color(3:0)
            PIN WRITE_PIXEL_COLOR_OUT write_pixel_color
            PIN CLEAR_WRITE_COUNTER_OUT clear_write_counter
        END BLOCK
    END NETLIST
    BEGIN SHEET 1 3520 2720
        BEGIN INSTANCE iVGA_MODULE 1984 1920 R0
        END INSTANCE
        BEGIN INSTANCE iHexDecoder 2800 320 R0
        END INSTANCE
        BEGIN BRANCH DISPLAY(7:0)
            WIRE 3184 160 3248 160
        END BRANCH
        BEGIN BRANCH ANODES(3:0)
            WIRE 3184 288 3248 288
        END BRANCH
        IOMARKER 3248 160 DISPLAY(7:0) R0 28
        IOMARKER 3248 288 ANODES(3:0) R0 28
        BEGIN INSTANCE iKEYBOARD_CONTROL_MODULE 112 1216 R0
        END INSTANCE
        BEGIN BRANCH PS2_CLK_KB
            WIRE 496 1120 528 1120
        END BRANCH
        IOMARKER 528 1120 PS2_CLK_KB R0 28
        BEGIN BRANCH PS2_DATA_KB
            WIRE 496 1184 528 1184
        END BRANCH
        BEGIN BRANCH HS
            WIRE 2464 1568 2736 1568
        END BRANCH
        BEGIN BRANCH VS
            WIRE 2464 1632 2736 1632
        END BRANCH
        IOMARKER 2736 1568 HS R0 28
        IOMARKER 2736 1632 VS R0 28
        IOMARKER 672 1632 CLK R180 28
        BEGIN BRANCH RST
            WIRE 672 1696 784 1696
        END BRANCH
        IOMARKER 672 1696 RST R180 28
        BEGIN INSTANCE iDCM_MODULE 784 1920 R0
        END INSTANCE
        IOMARKER 528 1184 PS2_DATA_KB R0 28
        BEGIN INSTANCE iPIXEL_CLOCK_SWITCHER 944 1424 R0
        END INSTANCE
        BEGIN BRANCH clk_25MHz
            WIRE 864 1264 944 1264
            WIRE 864 1264 864 1488
            WIRE 864 1488 1232 1488
            WIRE 1232 1488 1232 1632
            WIRE 1232 1632 1984 1632
            WIRE 1168 1632 1232 1632
        END BRANCH
        BEGIN BRANCH clk_40MHz
            WIRE 880 1328 944 1328
            WIRE 880 1328 880 1472
            WIRE 880 1472 1216 1472
            WIRE 1216 1472 1216 1696
            WIRE 1216 1696 1984 1696
            WIRE 1168 1696 1216 1696
        END BRANCH
        BEGIN BRANCH CLK
            WIRE 32 224 32 864
            WIRE 32 864 112 864
            WIRE 32 864 32 1568
            WIRE 32 1568 704 1568
            WIRE 704 1568 704 1632
            WIRE 704 1632 784 1632
            WIRE 32 224 736 224
            WIRE 736 224 736 352
            WIRE 672 1632 704 1632
            WIRE 736 128 1472 128
            WIRE 1472 128 1472 160
            WIRE 1472 160 2800 160
            WIRE 1472 160 1472 224
            WIRE 1472 224 1824 224
            WIRE 736 128 736 224
        END BRANCH
        BEGIN BRANCH HEX1(7:0)
            WIRE 2432 224 2800 224
        END BRANCH
        BEGIN BRANCH HEX2(7:0)
            WIRE 2432 288 2800 288
        END BRANCH
        BEGIN BRANCH new_request
            WIRE 496 992 608 992
            WIRE 608 800 736 800
            WIRE 608 800 608 992
        END BRANCH
        BEGIN BRANCH request_value(2:0)
            WIRE 496 1056 624 1056
            WIRE 624 864 624 1056
            WIRE 624 864 736 864
        END BRANCH
        BEGIN INSTANCE iEPP_DATA_MODULE 736 896 R0
        END INSTANCE
        BEGIN BRANCH reset
            WIRE 80 80 80 928
            WIRE 80 928 112 928
            WIRE 80 80 720 80
            WIRE 720 80 1600 80
            WIRE 1600 80 1600 288
            WIRE 1600 288 1600 1760
            WIRE 1600 1760 1984 1760
            WIRE 1600 288 1824 288
            WIRE 720 80 720 416
            WIRE 720 416 736 416
            WIRE 1168 1760 1600 1760
        END BRANCH
        BEGIN BRANCH EPP_ASTB
            WIRE 704 480 736 480
        END BRANCH
        IOMARKER 704 480 EPP_ASTB R180 28
        BEGIN BRANCH EPP_DSTB
            WIRE 704 544 736 544
        END BRANCH
        IOMARKER 704 544 EPP_DSTB R180 28
        BEGIN BRANCH EPP_WRITE
            WIRE 704 608 736 608
        END BRANCH
        IOMARKER 704 608 EPP_WRITE R180 28
        BEGIN BRANCH EPP_ACK
            WIRE 704 672 736 672
        END BRANCH
        IOMARKER 704 672 EPP_ACK R180 28
        BEGIN BRANCH EPP_BUS(7:0)
            WIRE 704 736 736 736
        END BRANCH
        IOMARKER 704 736 EPP_BUS(7:0) R180 28
        BEGIN BRANCH resolution
            WIRE 496 928 928 928
            WIRE 928 928 928 1392
            WIRE 928 1392 944 1392
            WIRE 928 928 1632 928
            WIRE 1632 928 1632 1056
            WIRE 1632 1056 1632 1568
            WIRE 1632 1568 1984 1568
            WIRE 1632 1056 1824 1056
        END BRANCH
        BEGIN BRANCH pixel_clk
            WIRE 1328 1264 1648 1264
            WIRE 1648 1184 1648 1264
            WIRE 1648 1184 1824 1184
        END BRANCH
        BEGIN BRANCH XLXN_368
            WIRE 496 864 576 864
            WIRE 576 864 576 1008
            WIRE 576 1008 1616 1008
            WIRE 1616 992 1616 1008
            WIRE 1616 992 1824 992
        END BRANCH
        BEGIN BRANCH HCOUNT(10:0)
            WIRE 1760 864 1824 864
            WIRE 1760 864 1760 1472
            WIRE 1760 1472 2512 1472
            WIRE 2512 1472 2512 1760
            WIRE 2464 1760 2512 1760
        END BRANCH
        BEGIN BRANCH blank
            WIRE 1776 800 1824 800
            WIRE 1776 800 1776 1488
            WIRE 1776 1488 2528 1488
            WIRE 2528 1488 2528 1696
            WIRE 2464 1696 2528 1696
        END BRANCH
        BEGIN BRANCH clear_write_counter
            WIRE 1424 736 1824 736
        END BRANCH
        BEGIN BRANCH write_pixel_color
            WIRE 1424 672 1824 672
        END BRANCH
        BEGIN BRANCH pixel_color(3:0)
            WIRE 1424 608 1824 608
        END BRANCH
        BEGIN BRANCH set_height
            WIRE 1424 544 1824 544
        END BRANCH
        BEGIN BRANCH height(7:0)
            WIRE 1424 480 1824 480
        END BRANCH
        BEGIN BRANCH set_width
            WIRE 1424 416 1824 416
        END BRANCH
        BEGIN BRANCH width(7:0)
            WIRE 1424 352 1824 352
        END BRANCH
        BEGIN INSTANCE iIMAGE_MODULE 1824 960 R0
        END INSTANCE
        BEGIN BRANCH VCOUNT(10:0)
            WIRE 1744 928 1824 928
            WIRE 1744 928 1744 1456
            WIRE 1744 1456 2496 1456
            WIRE 2496 1456 2496 1824
            WIRE 2464 1824 2496 1824
        END BRANCH
        BEGIN BRANCH BTN
            WIRE 1504 1120 1808 1120
            WIRE 1808 1120 1824 1120
        END BRANCH
        IOMARKER 1504 1120 BTN R180 28
        BEGIN BRANCH LEFT
            WIRE 2432 352 2464 352
        END BRANCH
        IOMARKER 2464 352 LEFT R0 28
        BEGIN BRANCH MIDDLE
            WIRE 2432 416 2464 416
        END BRANCH
        IOMARKER 2464 416 MIDDLE R0 28
        BEGIN BRANCH RIGHT
            WIRE 2432 480 2464 480
        END BRANCH
        IOMARKER 2464 480 RIGHT R0 28
        BEGIN BRANCH ZPOS(3:0)
            WIRE 2432 544 2464 544
        END BRANCH
        IOMARKER 2464 544 ZPOS(3:0) R0 28
        BEGIN BRANCH RED(3:0)
            WIRE 2432 608 2464 608
        END BRANCH
        IOMARKER 2464 608 RED(3:0) R0 28
        BEGIN BRANCH GREEN(3:0)
            WIRE 2432 672 2464 672
        END BRANCH
        IOMARKER 2464 672 GREEN(3:0) R0 28
        BEGIN BRANCH BLUE(3:0)
            WIRE 2432 736 2464 736
        END BRANCH
        IOMARKER 2464 736 BLUE(3:0) R0 28
        BEGIN BRANCH PS2_CLK_MS
            WIRE 2432 800 2464 800
        END BRANCH
        IOMARKER 2464 800 PS2_CLK_MS R0 28
        BEGIN BRANCH PS2_DATA_MS
            WIRE 2432 864 2464 864
        END BRANCH
        IOMARKER 2464 864 PS2_DATA_MS R0 28
        BEGIN BRANCH COUNTER(1:0)
            WIRE 2432 928 2464 928
        END BRANCH
        IOMARKER 2464 928 COUNTER(1:0) R0 28
        BEGIN BRANCH ASCII(6:0)
            WIRE 496 1248 560 1248
            WIRE 560 1248 560 1440
            WIRE 560 1440 1392 1440
            WIRE 1392 1376 1392 1440
            WIRE 1392 1376 1824 1376
        END BRANCH
        BEGIN BRANCH new_key
            WIRE 496 1312 512 1312
            WIRE 512 976 512 1312
            WIRE 512 976 1392 976
            WIRE 1392 976 1392 1312
            WIRE 1392 1312 1824 1312
        END BRANCH
        BEGIN BRANCH event_type
            WIRE 496 1376 592 1376
            WIRE 592 1216 592 1376
            WIRE 592 1216 1376 1216
            WIRE 1376 1216 1376 1248
            WIRE 1376 1248 1824 1248
        END BRANCH
    END SHEET
END SCHEMATIC
