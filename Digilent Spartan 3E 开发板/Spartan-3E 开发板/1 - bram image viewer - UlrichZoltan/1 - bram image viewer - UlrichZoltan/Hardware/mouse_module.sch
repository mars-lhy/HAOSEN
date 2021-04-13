VERSION 6
BEGIN SCHEMATIC
    BEGIN ATTR DeviceFamilyName "spartan3"
        DELETE all:0
        EDITNAME all:0
        EDITTRAIT all:0
    END ATTR
    BEGIN NETLIST
        SIGNAL rx_data(7:0)
        SIGNAL tx_data(7:0)
        SIGNAL read
        SIGNAL write
        SIGNAL err
        SIGNAL setx
        SIGNAL sety
        SIGNAL setmax_x
        SIGNAL setmax_y
        SIGNAL VALUE(9:0)
        SIGNAL CLK
        SIGNAL RST
        SIGNAL PS2_CLK
        SIGNAL PS2_DATA
        SIGNAL SWITCH
        SIGNAL RESOLUTION
        SIGNAL LEFT
        SIGNAL MIDDLE
        SIGNAL RIGHT
        SIGNAL XPOS(9:0)
        SIGNAL ZPOS(3:0)
        SIGNAL RED_OUT(3:0)
        SIGNAL GREEN_OUT(3:0)
        SIGNAL BLUE_OUT(3:0)
        SIGNAL HCOUNT(10:0)
        SIGNAL VCOUNT(10:0)
        SIGNAL RED_IN(3:0)
        SIGNAL GREEN_IN(3:0)
        SIGNAL BLUE_IN(3:0)
        SIGNAL YPOS(9:0)
        SIGNAL BLANK
        SIGNAL PIXEL_CLK
        SIGNAL NEW_EVENT
        PORT Input CLK
        PORT Input RST
        PORT BiDirectional PS2_CLK
        PORT BiDirectional PS2_DATA
        PORT Input SWITCH
        PORT Input RESOLUTION
        PORT Output LEFT
        PORT Output MIDDLE
        PORT Output RIGHT
        PORT Output XPOS(9:0)
        PORT Output ZPOS(3:0)
        PORT Output RED_OUT(3:0)
        PORT Output GREEN_OUT(3:0)
        PORT Output BLUE_OUT(3:0)
        PORT Input HCOUNT(10:0)
        PORT Input VCOUNT(10:0)
        PORT Input RED_IN(3:0)
        PORT Input GREEN_IN(3:0)
        PORT Input BLUE_IN(3:0)
        PORT Output YPOS(9:0)
        PORT Input BLANK
        PORT Input PIXEL_CLK
        PORT Output NEW_EVENT
        BEGIN BLOCKDEF mouse_controller
            TIMESTAMP 2006 9 25 6 22 2
            LINE N 64 -672 0 -672 
            LINE N 64 -480 0 -480 
            LINE N 64 -416 0 -416 
            LINE N 64 -352 0 -352 
            LINE N 64 -288 0 -288 
            LINE N 64 -224 0 -224 
            RECTANGLE N 0 -172 64 -148 
            LINE N 64 -160 0 -160 
            LINE N 320 -672 384 -672 
            LINE N 320 -592 384 -592 
            LINE N 320 -512 384 -512 
            RECTANGLE N 0 -44 64 -20 
            LINE N 64 -32 0 -32 
            RECTANGLE N 0 -108 64 -84 
            LINE N 0 -96 64 -96 
            LINE N 64 -640 0 -640 
            LINE N 64 -608 0 -608 
            LINE N 0 -544 64 -544 
            RECTANGLE N 320 -204 384 -180 
            LINE N 320 -192 384 -192 
            RECTANGLE N 320 -124 384 -100 
            LINE N 320 -112 384 -112 
            RECTANGLE N 320 -44 384 -20 
            LINE N 320 -32 384 -32 
            RECTANGLE N 64 -704 320 0 
            LINE N 320 -448 384 -448 
        END BLOCKDEF
        BEGIN BLOCKDEF ps2interface
            TIMESTAMP 2006 9 20 11 3 34
            LINE N 64 -352 0 -352 
            LINE N 320 -352 384 -352 
            RECTANGLE N 64 -388 320 0 
            LINE N 64 -288 0 -288 
            RECTANGLE N 320 -108 384 -84 
            LINE N 320 -96 384 -96 
            RECTANGLE N 320 -44 384 -20 
            LINE N 384 -32 320 -32 
            LINE N 320 -224 384 -224 
            LINE N 320 -160 384 -160 
            LINE N 384 -288 320 -288 
            LINE N 0 -96 64 -96 
            LINE N 0 -32 64 -32 
        END BLOCKDEF
        BEGIN BLOCKDEF mouse_displayer
            TIMESTAMP 2006 9 25 6 11 57
            LINE N 64 32 0 32 
            LINE N 64 -544 0 -544 
            LINE N 64 -480 0 -480 
            RECTANGLE N 0 -428 64 -404 
            LINE N 64 -416 0 -416 
            RECTANGLE N 0 -364 64 -340 
            LINE N 64 -352 0 -352 
            RECTANGLE N 0 -300 64 -276 
            LINE N 64 -288 0 -288 
            RECTANGLE N 0 -236 64 -212 
            LINE N 64 -224 0 -224 
            RECTANGLE N 0 -172 64 -148 
            LINE N 64 -160 0 -160 
            RECTANGLE N 0 -108 64 -84 
            LINE N 64 -96 0 -96 
            RECTANGLE N 0 -44 64 -20 
            LINE N 64 -32 0 -32 
            RECTANGLE N 320 -556 384 -532 
            LINE N 320 -544 384 -544 
            RECTANGLE N 320 -300 384 -276 
            LINE N 320 -288 384 -288 
            RECTANGLE N 320 -44 384 -20 
            LINE N 320 -32 384 -32 
            RECTANGLE N 64 -576 320 64 
        END BLOCKDEF
        BEGIN BLOCKDEF resolution_mouse_informer
            TIMESTAMP 2006 9 28 10 36 21
            LINE N 64 -288 0 -288 
            LINE N 64 -208 0 -208 
            LINE N 64 -128 0 -128 
            LINE N 320 -288 384 -288 
            LINE N 320 -224 384 -224 
            LINE N 320 -160 384 -160 
            LINE N 320 -96 384 -96 
            RECTANGLE N 320 -44 384 -20 
            LINE N 320 -32 384 -32 
            RECTANGLE N 64 -320 320 0 
            LINE N 64 -48 0 -48 
        END BLOCKDEF
        BEGIN BLOCK iMOUSE_CONTROLLER mouse_controller
            PIN clk CLK
            PIN rst RST
            PIN read read
            PIN err err
            PIN setx setx
            PIN sety sety
            PIN setmax_x setmax_x
            PIN setmax_y setmax_y
            PIN rx_data(7:0) rx_data(7:0)
            PIN value(9:0) VALUE(9:0)
            PIN left LEFT
            PIN middle MIDDLE
            PIN right RIGHT
            PIN write write
            PIN xpos(9:0) XPOS(9:0)
            PIN ypos(9:0) YPOS(9:0)
            PIN zpos(3:0) ZPOS(3:0)
            PIN tx_data(7:0) tx_data(7:0)
            PIN new_event NEW_EVENT
        END BLOCK
        BEGIN BLOCK iPS2_INTERFACE_MOUSE ps2interface
            PIN clk CLK
            PIN read read
            PIN rst RST
            PIN rx_data(7:0) rx_data(7:0)
            PIN tx_data(7:0) tx_data(7:0)
            PIN busy
            PIN err err
            PIN write write
            PIN ps2_clk PS2_CLK
            PIN ps2_data PS2_DATA
        END BLOCK
        BEGIN BLOCK iMOUSE_DISPLAYER mouse_displayer
            PIN clk CLK
            PIN pixel_clk PIXEL_CLK
            PIN blank BLANK
            PIN xpos(9:0) XPOS(9:0)
            PIN ypos(9:0) YPOS(9:0)
            PIN hcount(10:0) HCOUNT(10:0)
            PIN vcount(10:0) VCOUNT(10:0)
            PIN red_in(3:0) RED_IN(3:0)
            PIN green_in(3:0) GREEN_IN(3:0)
            PIN blue_in(3:0) BLUE_IN(3:0)
            PIN red_out(3:0) RED_OUT(3:0)
            PIN green_out(3:0) GREEN_OUT(3:0)
            PIN blue_out(3:0) BLUE_OUT(3:0)
        END BLOCK
        BEGIN BLOCK XLXI_1 resolution_mouse_informer
            PIN clk CLK
            PIN rst RST
            PIN resolution RESOLUTION
            PIN switch SWITCH
            PIN setx setx
            PIN sety sety
            PIN setmax_x setmax_x
            PIN setmax_y setmax_y
            PIN value(9:0) VALUE(9:0)
        END BLOCK
    END NETLIST
    BEGIN SHEET 1 3520 2720
        BEGIN INSTANCE iMOUSE_CONTROLLER 1456 928 R0
        END INSTANCE
        BEGIN INSTANCE iPS2_INTERFACE_MOUSE 688 864 R0
        END INSTANCE
        BEGIN BRANCH rx_data(7:0)
            WIRE 1072 768 1456 768
        END BRANCH
        BEGIN BRANCH tx_data(7:0)
            WIRE 1072 832 1456 832
        END BRANCH
        BEGIN BRANCH read
            WIRE 1072 512 1264 512
            WIRE 1264 320 1264 512
            WIRE 1264 320 1456 320
        END BRANCH
        BEGIN BRANCH write
            WIRE 1072 576 1280 576
            WIRE 1280 384 1280 576
            WIRE 1280 384 1456 384
        END BRANCH
        BEGIN BRANCH err
            WIRE 1072 704 1296 704
            WIRE 1296 448 1296 704
            WIRE 1296 448 1456 448
        END BRANCH
        BEGIN BRANCH VALUE(9:0)
            WIRE 1072 1296 1376 1296
            WIRE 1376 896 1376 1296
            WIRE 1376 896 1456 896
        END BRANCH
        BEGIN BRANCH setx
            WIRE 1072 1040 1312 1040
            WIRE 1312 512 1312 1040
            WIRE 1312 512 1456 512
        END BRANCH
        BEGIN BRANCH sety
            WIRE 1072 1104 1328 1104
            WIRE 1328 576 1328 1104
            WIRE 1328 576 1456 576
        END BRANCH
        BEGIN BRANCH setmax_x
            WIRE 1072 1168 1344 1168
            WIRE 1344 640 1456 640
            WIRE 1344 640 1344 1168
        END BRANCH
        BEGIN BRANCH setmax_y
            WIRE 1072 1232 1360 1232
            WIRE 1360 704 1360 1232
            WIRE 1360 704 1456 704
        END BRANCH
        BEGIN BRANCH CLK
            WIRE 512 256 608 256
            WIRE 608 256 608 512
            WIRE 608 512 688 512
            WIRE 608 512 608 1040
            WIRE 608 1040 688 1040
            WIRE 608 256 1392 256
            WIRE 1392 256 1456 256
            WIRE 1392 256 1392 960
            WIRE 1392 960 2256 960
        END BRANCH
        BEGIN BRANCH RST
            WIRE 512 288 624 288
            WIRE 624 288 624 576
            WIRE 624 576 624 1120
            WIRE 624 1120 688 1120
            WIRE 624 576 688 576
            WIRE 624 288 1456 288
        END BRANCH
        BEGIN BRANCH PS2_CLK
            WIRE 496 768 672 768
            WIRE 672 768 688 768
        END BRANCH
        BEGIN BRANCH PS2_DATA
            WIRE 496 832 672 832
            WIRE 672 832 688 832
        END BRANCH
        BEGIN BRANCH SWITCH
            WIRE 448 1200 672 1200
            WIRE 672 1200 688 1200
        END BRANCH
        BEGIN BRANCH RESOLUTION
            WIRE 512 1280 672 1280
            WIRE 672 1280 688 1280
        END BRANCH
        BEGIN BRANCH LEFT
            WIRE 1840 256 1856 256
            WIRE 1856 256 1872 256
        END BRANCH
        BEGIN BRANCH MIDDLE
            WIRE 1840 336 1872 336
        END BRANCH
        IOMARKER 1872 336 MIDDLE R0 28
        BEGIN BRANCH RIGHT
            WIRE 1840 416 1872 416
        END BRANCH
        IOMARKER 1872 416 RIGHT R0 28
        BEGIN BRANCH XPOS(9:0)
            WIRE 1840 736 1856 736
            WIRE 1856 736 2048 736
            WIRE 2048 736 2048 1088
            WIRE 2048 1088 2256 1088
            WIRE 2048 736 2128 736
        END BRANCH
        IOMARKER 512 256 CLK R180 28
        IOMARKER 512 288 RST R180 28
        IOMARKER 496 768 PS2_CLK R180 28
        IOMARKER 496 832 PS2_DATA R180 28
        IOMARKER 448 1200 SWITCH R180 28
        BEGIN BRANCH ZPOS(3:0)
            WIRE 1840 896 1856 896
            WIRE 1856 896 2128 896
        END BRANCH
        BEGIN INSTANCE iMOUSE_DISPLAYER 2256 1504 R0
        END INSTANCE
        BEGIN BRANCH RED_OUT(3:0)
            WIRE 2640 960 2656 960
            WIRE 2656 960 2672 960
        END BRANCH
        BEGIN BRANCH GREEN_OUT(3:0)
            WIRE 2640 1216 2656 1216
            WIRE 2656 1216 2672 1216
        END BRANCH
        BEGIN BRANCH BLUE_OUT(3:0)
            WIRE 2640 1472 2656 1472
            WIRE 2656 1472 2672 1472
        END BRANCH
        BEGIN BRANCH HCOUNT(10:0)
            WIRE 2224 1216 2240 1216
            WIRE 2240 1216 2256 1216
        END BRANCH
        BEGIN BRANCH VCOUNT(10:0)
            WIRE 2224 1280 2240 1280
            WIRE 2240 1280 2256 1280
        END BRANCH
        BEGIN BRANCH RED_IN(3:0)
            WIRE 2192 1344 2240 1344
            WIRE 2240 1344 2256 1344
        END BRANCH
        BEGIN BRANCH GREEN_IN(3:0)
            WIRE 2224 1408 2240 1408
            WIRE 2240 1408 2256 1408
        END BRANCH
        BEGIN BRANCH BLUE_IN(3:0)
            WIRE 2224 1472 2240 1472
            WIRE 2240 1472 2256 1472
        END BRANCH
        IOMARKER 2672 960 RED_OUT(3:0) R0 28
        IOMARKER 2672 1216 GREEN_OUT(3:0) R0 28
        IOMARKER 2672 1472 BLUE_OUT(3:0) R0 28
        IOMARKER 2224 1216 HCOUNT(10:0) R180 28
        IOMARKER 2224 1280 VCOUNT(10:0) R180 28
        IOMARKER 2224 1408 GREEN_IN(3:0) R180 28
        IOMARKER 2224 1472 BLUE_IN(3:0) R180 28
        IOMARKER 2128 896 ZPOS(3:0) R0 28
        BEGIN BRANCH YPOS(9:0)
            WIRE 1840 816 2032 816
            WIRE 2032 816 2032 1152
            WIRE 2032 1152 2256 1152
            WIRE 2032 816 2128 816
        END BRANCH
        IOMARKER 2192 1344 RED_IN(3:0) R180 28
        BEGIN BRANCH BLANK
            WIRE 2224 1024 2256 1024
        END BRANCH
        IOMARKER 2224 1024 BLANK R180 28
        IOMARKER 1872 256 LEFT R0 28
        IOMARKER 2128 816 YPOS(9:0) R0 28
        IOMARKER 2128 736 XPOS(9:0) R0 28
        IOMARKER 512 1280 RESOLUTION R180 28
        BEGIN BRANCH PIXEL_CLK
            WIRE 2224 1536 2256 1536
        END BRANCH
        IOMARKER 2224 1536 PIXEL_CLK R180 28
        BEGIN BRANCH NEW_EVENT
            WIRE 1840 480 1872 480
        END BRANCH
        IOMARKER 1872 480 NEW_EVENT R0 28
        BEGIN INSTANCE XLXI_1 688 1328 R0
        END INSTANCE
    END SHEET
END SCHEMATIC
