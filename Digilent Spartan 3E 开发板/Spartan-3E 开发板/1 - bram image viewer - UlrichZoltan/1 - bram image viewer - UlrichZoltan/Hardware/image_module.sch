VERSION 6
BEGIN SCHEMATIC
    BEGIN ATTR DeviceFamilyName "spartan3"
        DELETE all:0
        EDITNAME all:0
        EDITTRAIT all:0
    END ATTR
    BEGIN NETLIST
        SIGNAL hmax(9:0)
        SIGNAL vmax(9:0)
        SIGNAL image_sph(9:0)
        SIGNAL image_spv(9:0)
        SIGNAL image_eph(9:0)
        SIGNAL image_epv(9:0)
        SIGNAL RESOLUTION
        SIGNAL BLANK
        SIGNAL SWITCH
        SIGNAL CLK
        SIGNAL RST
        SIGNAL LEFT
        SIGNAL MIDDLE
        SIGNAL RIGHT
        SIGNAL ZPOS(3:0)
        SIGNAL PS2_CLK
        SIGNAL PS2_DATA
        SIGNAL VCOUNT(10:0)
        SIGNAL HCOUNT(10:0)
        SIGNAL HEX1_OUT(7:0)
        SIGNAL HEX2_OUT(7:0)
        SIGNAL RED(3:0)
        SIGNAL GREEN(3:0)
        SIGNAL BLUE(3:0)
        SIGNAL COUNTER(1:0)
        SIGNAL new_event
        SIGNAL PIXEL_CLK
        SIGNAL WIDTH_IN(7:0)
        SIGNAL SET_WIDTH_IN
        SIGNAL HEIGHT_IN(7:0)
        SIGNAL SET_HEIGHT_IN
        SIGNAL PIXEL_COLOR_IN(3:0)
        SIGNAL WRITE_PIXEL_COLOR_IN
        SIGNAL CLEAR_WRITE_COUNTER_IN
        SIGNAL debug_btn
        SIGNAL BTN
        SIGNAL num_pixels(13:0)
        SIGNAL new_num_pixels
        SIGNAL red_botton_layer(3:0)
        SIGNAL green_bottom_layer(3:0)
        SIGNAL blue_bottom_layer(3:0)
        SIGNAL red_top_layer(3:0)
        SIGNAL green_top_layer(3:0)
        SIGNAL blue_top_layer(3:0)
        SIGNAL EVENT_TYPE
        SIGNAL NEW_KEY
        SIGNAL ASCII(6:0)
        SIGNAL inside_image
        SIGNAL XPOS(9:0)
        SIGNAL YPOS(9:0)
        PORT Input RESOLUTION
        PORT Input BLANK
        PORT Input SWITCH
        PORT Input CLK
        PORT Input RST
        PORT Output LEFT
        PORT Output MIDDLE
        PORT Output RIGHT
        PORT Output ZPOS(3:0)
        PORT BiDirectional PS2_CLK
        PORT BiDirectional PS2_DATA
        PORT Input VCOUNT(10:0)
        PORT Input HCOUNT(10:0)
        PORT Output HEX1_OUT(7:0)
        PORT Output HEX2_OUT(7:0)
        PORT Output RED(3:0)
        PORT Output GREEN(3:0)
        PORT Output BLUE(3:0)
        PORT Output COUNTER(1:0)
        PORT Input PIXEL_CLK
        PORT Input WIDTH_IN(7:0)
        PORT Input SET_WIDTH_IN
        PORT Input HEIGHT_IN(7:0)
        PORT Input SET_HEIGHT_IN
        PORT Input PIXEL_COLOR_IN(3:0)
        PORT Input WRITE_PIXEL_COLOR_IN
        PORT Input CLEAR_WRITE_COUNTER_IN
        PORT Input BTN
        PORT Input EVENT_TYPE
        PORT Input NEW_KEY
        PORT Input ASCII(6:0)
        BEGIN BLOCKDEF image_controller
            TIMESTAMP 2006 9 28 10 44 25
            RECTANGLE N 0 468 64 492 
            LINE N 64 480 0 480 
            RECTANGLE N 0 532 64 556 
            LINE N 64 544 0 544 
            RECTANGLE N 0 596 64 620 
            LINE N 64 608 0 608 
            RECTANGLE N 0 660 64 684 
            LINE N 64 672 0 672 
            RECTANGLE N 0 724 64 748 
            LINE N 64 736 0 736 
            RECTANGLE N 0 788 64 812 
            LINE N 64 800 0 800 
            RECTANGLE N 320 148 384 172 
            LINE N 320 160 384 160 
            RECTANGLE N 320 212 384 236 
            LINE N 320 224 384 224 
            RECTANGLE N 320 276 384 300 
            LINE N 320 288 384 288 
            LINE N 64 -352 0 -352 
            LINE N 64 -288 0 -288 
            RECTANGLE N 320 -364 384 -340 
            LINE N 320 -352 384 -352 
            RECTANGLE N 320 -300 384 -276 
            LINE N 320 -288 384 -288 
            RECTANGLE N 0 84 64 108 
            LINE N 64 96 0 96 
            RECTANGLE N 0 148 64 172 
            LINE N 64 160 0 160 
            LINE N 64 224 0 224 
            RECTANGLE N 320 -236 384 -212 
            LINE N 320 -224 384 -224 
            LINE N 64 32 0 32 
            LINE N 64 -96 0 -96 
            LINE N 64 -32 0 -32 
            RECTANGLE N 0 -172 64 -148 
            LINE N 64 -160 0 -160 
            RECTANGLE N 64 -384 320 960 
            LINE N 320 352 384 352 
            RECTANGLE N 0 852 64 876 
            LINE N 64 864 0 864 
            LINE N 64 928 0 928 
        END BLOCKDEF
        BEGIN BLOCKDEF mouse_module
            TIMESTAMP 2006 9 25 6 22 25
            LINE N 384 304 448 304 
            RECTANGLE N 384 164 448 188 
            LINE N 384 176 448 176 
            RECTANGLE N 384 228 448 252 
            LINE N 384 240 448 240 
            LINE N 64 -480 0 -480 
            LINE N 384 -480 448 -480 
            LINE N 384 -416 448 -416 
            LINE N 384 -352 448 -352 
            LINE N 64 -416 0 -416 
            LINE N 64 -352 0 -352 
            RECTANGLE N 0 -220 64 -196 
            LINE N 64 -208 0 -208 
            RECTANGLE N 0 -156 64 -132 
            LINE N 64 -144 0 -144 
            RECTANGLE N 0 -92 64 -68 
            LINE N 64 -80 0 -80 
            RECTANGLE N 0 -28 64 -4 
            LINE N 64 -16 0 -16 
            RECTANGLE N 0 36 64 60 
            LINE N 64 48 0 48 
            LINE N 64 112 0 112 
            RECTANGLE N 384 -108 448 -84 
            LINE N 384 -96 448 -96 
            RECTANGLE N 384 -44 448 -20 
            LINE N 384 -32 448 -32 
            RECTANGLE N 384 20 448 44 
            LINE N 384 32 448 32 
            RECTANGLE N 384 -300 448 -276 
            LINE N 384 -288 448 -288 
            LINE N 384 -224 448 -224 
            LINE N 384 -160 448 -160 
            LINE N 64 -288 0 -288 
            LINE N 64 176 0 176 
            RECTANGLE N 64 -512 384 336 
        END BLOCKDEF
        BEGIN BLOCKDEF image_motion_controller
            TIMESTAMP 2006 9 28 10 43 48
            RECTANGLE N 64 -384 560 512 
            LINE N 64 -352 0 -352 
            LINE N 64 -288 0 -288 
            LINE N 64 -160 0 -160 
            LINE N 64 -96 0 -96 
            LINE N 64 -32 0 -32 
            LINE N 64 -224 0 -224 
            RECTANGLE N 0 276 64 300 
            LINE N 64 288 0 288 
            LINE N 64 352 0 352 
            LINE N 64 480 0 480 
            RECTANGLE N 0 404 64 428 
            LINE N 64 416 0 416 
            RECTANGLE N 560 -364 624 -340 
            LINE N 560 -352 624 -352 
            RECTANGLE N 560 -300 624 -276 
            LINE N 560 -288 624 -288 
            RECTANGLE N 560 -236 624 -212 
            LINE N 560 -224 624 -224 
            RECTANGLE N 560 -172 624 -148 
            LINE N 560 -160 624 -160 
            RECTANGLE N 560 -108 624 -84 
            LINE N 560 -96 624 -96 
            RECTANGLE N 560 -44 624 -20 
            LINE N 560 -32 624 -32 
            LINE N 560 96 624 96 
            RECTANGLE N 560 20 624 44 
            LINE N 560 32 624 32 
            RECTANGLE N 0 20 64 44 
            LINE N 64 32 0 32 
            RECTANGLE N 0 84 64 108 
            LINE N 64 96 0 96 
            RECTANGLE N 0 148 64 172 
            LINE N 64 160 0 160 
            LINE N 64 224 0 224 
        END BLOCKDEF
        BEGIN BLOCKDEF effects_layer
            TIMESTAMP 2006 9 26 10 48 48
            LINE N 64 -416 0 -416 
            LINE N 64 -352 0 -352 
            LINE N 64 -288 0 -288 
            RECTANGLE N 336 -428 400 -404 
            LINE N 400 -416 336 -416 
            RECTANGLE N 336 -364 400 -340 
            LINE N 400 -352 336 -352 
            RECTANGLE N 336 -300 400 -276 
            LINE N 400 -288 336 -288 
            RECTANGLE N 0 -236 64 -212 
            LINE N 64 -224 0 -224 
            RECTANGLE N 0 -172 64 -148 
            LINE N 0 -160 64 -160 
            RECTANGLE N 0 -108 64 -84 
            LINE N 0 -96 64 -96 
            RECTANGLE N 0 -44 64 -20 
            LINE N 0 -32 64 -32 
            RECTANGLE N 64 -448 336 0 
            LINE N 400 -224 336 -224 
        END BLOCKDEF
        BEGIN BLOCKDEF pulse_debouncer
            TIMESTAMP 2006 9 28 10 47 48
            RECTANGLE N 64 -128 160 0 
            LINE N 64 -96 0 -96 
            LINE N 64 -32 0 -32 
            LINE N 160 -96 224 -96 
        END BLOCKDEF
        BEGIN BLOCK iMOUSE_MODULE mouse_module
            PIN CLK CLK
            PIN RST RST
            PIN SWITCH SWITCH
            PIN RESOLUTION RESOLUTION
            PIN HCOUNT(10:0) HCOUNT(10:0)
            PIN VCOUNT(10:0) VCOUNT(10:0)
            PIN RED_IN(3:0) red_top_layer(3:0)
            PIN GREEN_IN(3:0) green_top_layer(3:0)
            PIN BLUE_IN(3:0) blue_top_layer(3:0)
            PIN BLANK BLANK
            PIN PIXEL_CLK PIXEL_CLK
            PIN PS2_CLK PS2_CLK
            PIN PS2_DATA PS2_DATA
            PIN LEFT LEFT
            PIN MIDDLE MIDDLE
            PIN RIGHT RIGHT
            PIN XPOS(9:0) XPOS(9:0)
            PIN ZPOS(3:0) ZPOS(3:0)
            PIN RED_OUT(3:0) RED(3:0)
            PIN GREEN_OUT(3:0) GREEN(3:0)
            PIN BLUE_OUT(3:0) BLUE(3:0)
            PIN YPOS(9:0) YPOS(9:0)
            PIN NEW_EVENT new_event
        END BLOCK
        BEGIN BLOCK iIMAGE_MOTION_CONTROLLER image_motion_controller
            PIN clk CLK
            PIN switch SWITCH
            PIN left LEFT
            PIN middle MIDDLE
            PIN right RIGHT
            PIN resolution RESOLUTION
            PIN WIDTH_IN(7:0) WIDTH_IN(7:0)
            PIN SET_WIDTH_IN SET_WIDTH_IN
            PIN SET_HEIGHT_IN SET_HEIGHT_IN
            PIN HEIGHT_IN(7:0) HEIGHT_IN(7:0)
            PIN HMAX_OUT(9:0) hmax(9:0)
            PIN VMAX_OUT(9:0) vmax(9:0)
            PIN IMAGE_START_POS_H_OUT(9:0) image_sph(9:0)
            PIN IMAGE_START_POS_V_OUT(9:0) image_spv(9:0)
            PIN IMAGE_END_POS_H_OUT(9:0) image_eph(9:0)
            PIN IMAGE_END_POS_V_OUT(9:0) image_epv(9:0)
            PIN NEW_NUM_PIXELS_OUT new_num_pixels
            PIN NUM_PIXELS_OUT(13:0) num_pixels(13:0)
            PIN xpos(9:0) XPOS(9:0)
            PIN ypos(9:0) YPOS(9:0)
            PIN zpos(3:0) ZPOS(3:0)
            PIN new_event new_event
        END BLOCK
        BEGIN BLOCK iIMAGE_CONTROLLER image_controller
            PIN clk CLK
            PIN rst RST
            PIN btn debug_btn
            PIN write_pixel_color_in WRITE_PIXEL_COLOR_IN
            PIN clear_write_counter_in CLEAR_WRITE_COUNTER_IN
            PIN pixel_clk PIXEL_CLK
            PIN pixel_color_in(3:0) PIXEL_COLOR_IN(3:0)
            PIN hcount(10:0) HCOUNT(10:0)
            PIN vcount(10:0) VCOUNT(10:0)
            PIN HMAX(9:0) hmax(9:0)
            PIN VMAX(9:0) vmax(9:0)
            PIN IMAGE_START_POS_H(9:0) image_sph(9:0)
            PIN IMAGE_START_POS_V(9:0) image_spv(9:0)
            PIN IMAGE_END_POS_H(9:0) image_eph(9:0)
            PIN IMAGE_END_POS_V(9:0) image_epv(9:0)
            PIN hex1_out(7:0) HEX1_OUT(7:0)
            PIN hex2_out(7:0) HEX2_OUT(7:0)
            PIN red_out(3:0) red_botton_layer(3:0)
            PIN green_out(3:0) green_bottom_layer(3:0)
            PIN blue_out(3:0) blue_bottom_layer(3:0)
            PIN counter_out(1:0) COUNTER(1:0)
            PIN inside_image inside_image
            PIN NUM_PIXELS_IN(13:0) num_pixels(13:0)
            PIN NEW_NUM_PIXELS_IN new_num_pixels
        END BLOCK
        BEGIN BLOCK iEFFECTS_LAYER effects_layer
            PIN clk CLK
            PIN event_type EVENT_TYPE
            PIN new_key NEW_KEY
            PIN red_in(3:0) red_botton_layer(3:0)
            PIN green_in(3:0) green_bottom_layer(3:0)
            PIN blue_in(3:0) blue_bottom_layer(3:0)
            PIN ascii_in(6:0) ASCII(6:0)
            PIN red_out(3:0) red_top_layer(3:0)
            PIN green_out(3:0) green_top_layer(3:0)
            PIN blue_out(3:0) blue_top_layer(3:0)
            PIN inside_image inside_image
        END BLOCK
        BEGIN BLOCK iPULSE_DEBOUNCER pulse_debouncer
            PIN a BTN
            PIN clk CLK
            PIN b debug_btn
        END BLOCK
    END NETLIST
    BEGIN SHEET 1 3520 2720
        BEGIN INSTANCE iMOUSE_MODULE 368 1264 R0
        END INSTANCE
        BEGIN BRANCH hmax(9:0)
            WIRE 1856 1184 2208 1184
        END BRANCH
        BEGIN BRANCH vmax(9:0)
            WIRE 1856 1248 2208 1248
        END BRANCH
        BEGIN BRANCH image_sph(9:0)
            WIRE 1856 1312 2208 1312
        END BRANCH
        BEGIN BRANCH image_spv(9:0)
            WIRE 1856 1376 2208 1376
        END BRANCH
        BEGIN BRANCH image_eph(9:0)
            WIRE 1856 1440 2208 1440
        END BRANCH
        BEGIN BRANCH image_epv(9:0)
            WIRE 1856 1504 2208 1504
        END BRANCH
        BEGIN BRANCH SWITCH
            WIRE 224 912 336 912
            WIRE 336 912 368 912
            WIRE 336 672 336 912
            WIRE 336 672 1072 672
            WIRE 1072 672 1072 1248
            WIRE 1072 1248 1232 1248
        END BRANCH
        BEGIN BRANCH RST
            WIRE 224 848 320 848
            WIRE 320 848 368 848
            WIRE 320 416 2208 416
            WIRE 320 416 320 848
        END BRANCH
        BEGIN BRANCH PS2_CLK
            WIRE 816 1040 1296 1040
        END BRANCH
        BEGIN BRANCH PS2_DATA
            WIRE 816 1104 1296 1104
        END BRANCH
        BEGIN BRANCH VCOUNT(10:0)
            WIRE 224 1120 256 1120
            WIRE 256 1120 368 1120
            WIRE 256 656 256 1120
            WIRE 256 656 1776 656
            WIRE 1776 656 1776 864
            WIRE 1776 864 2208 864
        END BRANCH
        IOMARKER 1296 784 LEFT R0 28
        IOMARKER 1296 848 MIDDLE R0 28
        IOMARKER 1296 912 RIGHT R0 28
        IOMARKER 1296 976 ZPOS(3:0) R0 28
        IOMARKER 1296 1040 PS2_CLK R0 28
        IOMARKER 1296 1104 PS2_DATA R0 28
        IOMARKER 224 784 CLK R180 28
        IOMARKER 224 736 BLANK R180 28
        IOMARKER 224 848 RST R180 28
        IOMARKER 224 912 SWITCH R180 28
        IOMARKER 224 976 RESOLUTION R180 28
        IOMARKER 224 1056 HCOUNT(10:0) R180 28
        IOMARKER 224 1120 VCOUNT(10:0) R180 28
        BEGIN BRANCH HEX1_OUT(7:0)
            WIRE 2592 352 2624 352
        END BRANCH
        IOMARKER 2624 352 HEX1_OUT(7:0) R0 28
        BEGIN BRANCH HEX2_OUT(7:0)
            WIRE 2592 416 2624 416
        END BRANCH
        IOMARKER 2624 416 HEX2_OUT(7:0) R0 28
        BEGIN BRANCH RED(3:0)
            WIRE 816 1168 848 1168
        END BRANCH
        IOMARKER 848 1168 RED(3:0) R0 28
        BEGIN BRANCH GREEN(3:0)
            WIRE 816 1232 848 1232
        END BRANCH
        IOMARKER 848 1232 GREEN(3:0) R0 28
        BEGIN BRANCH BLUE(3:0)
            WIRE 816 1296 848 1296
        END BRANCH
        IOMARKER 848 1296 BLUE(3:0) R0 28
        BEGIN BRANCH BLANK
            WIRE 224 736 288 736
            WIRE 288 736 288 1376
            WIRE 288 1376 368 1376
        END BRANCH
        BEGIN BRANCH COUNTER(1:0)
            WIRE 2592 480 2624 480
        END BRANCH
        IOMARKER 2624 480 COUNTER(1:0) R0 28
        BEGIN INSTANCE iIMAGE_MOTION_CONTROLLER 1232 1536 R0
        END INSTANCE
        BEGIN BRANCH PIXEL_CLK
            WIRE 176 1440 176 2112
            WIRE 176 2112 2048 2112
            WIRE 176 1440 368 1440
            WIRE 1936 928 2048 928
            WIRE 2048 928 2048 2112
            WIRE 2048 928 2208 928
        END BRANCH
        BEGIN BRANCH WIDTH_IN(7:0)
            WIRE 1200 1824 1232 1824
        END BRANCH
        IOMARKER 1200 1824 WIDTH_IN(7:0) R180 28
        BEGIN BRANCH SET_WIDTH_IN
            WIRE 1200 1888 1232 1888
        END BRANCH
        IOMARKER 1200 1888 SET_WIDTH_IN R180 28
        BEGIN BRANCH HEIGHT_IN(7:0)
            WIRE 1200 1952 1232 1952
        END BRANCH
        IOMARKER 1200 1952 HEIGHT_IN(7:0) R180 28
        BEGIN BRANCH SET_HEIGHT_IN
            WIRE 1200 2016 1232 2016
        END BRANCH
        IOMARKER 1200 2016 SET_HEIGHT_IN R180 28
        BEGIN INSTANCE iIMAGE_CONTROLLER 2208 704 R0
        END INSTANCE
        BEGIN BRANCH PIXEL_COLOR_IN(3:0)
            WIRE 2176 544 2208 544
        END BRANCH
        IOMARKER 2176 544 PIXEL_COLOR_IN(3:0) R180 28
        BEGIN BRANCH WRITE_PIXEL_COLOR_IN
            WIRE 2176 608 2208 608
        END BRANCH
        IOMARKER 2176 608 WRITE_PIXEL_COLOR_IN R180 28
        BEGIN BRANCH CLEAR_WRITE_COUNTER_IN
            WIRE 2192 672 2208 672
        END BRANCH
        IOMARKER 1936 928 PIXEL_CLK R180 28
        IOMARKER 2192 672 CLEAR_WRITE_COUNTER_IN R180 28
        BEGIN BRANCH debug_btn
            WIRE 1712 736 2208 736
        END BRANCH
        BEGIN BRANCH CLK
            WIRE 224 784 304 784
            WIRE 304 784 368 784
            WIRE 304 784 304 2256
            WIRE 304 2256 640 2256
            WIRE 304 352 304 784
            WIRE 304 352 1168 352
            WIRE 1168 352 1168 1184
            WIRE 1168 1184 1232 1184
            WIRE 1168 352 1472 352
            WIRE 1472 352 1472 800
            WIRE 1472 800 1488 800
            WIRE 1472 352 2208 352
        END BRANCH
        BEGIN BRANCH BTN
            WIRE 1456 736 1488 736
        END BRANCH
        IOMARKER 1456 736 BTN R180 28
        BEGIN BRANCH HCOUNT(10:0)
            WIRE 224 1056 272 1056
            WIRE 272 1056 368 1056
            WIRE 272 640 272 1056
            WIRE 272 640 1792 640
            WIRE 1792 640 1792 800
            WIRE 1792 800 2208 800
        END BRANCH
        BEGIN BRANCH num_pixels(13:0)
            WIRE 1856 1568 2208 1568
        END BRANCH
        BEGIN BRANCH new_num_pixels
            WIRE 1856 1632 2208 1632
        END BRANCH
        BEGIN INSTANCE iEFFECTS_LAYER 640 2672 R0
        END INSTANCE
        BEGIN BRANCH red_botton_layer(3:0)
            WIRE 1040 2256 2672 2256
            WIRE 2592 864 2672 864
            WIRE 2672 864 2672 2256
        END BRANCH
        BEGIN BRANCH green_bottom_layer(3:0)
            WIRE 1040 2320 2656 2320
            WIRE 2592 928 2656 928
            WIRE 2656 928 2656 2320
        END BRANCH
        BEGIN BRANCH blue_bottom_layer(3:0)
            WIRE 1040 2384 2640 2384
            WIRE 2592 992 2640 992
            WIRE 2640 992 2640 2384
        END BRANCH
        BEGIN BRANCH red_top_layer(3:0)
            WIRE 352 1184 368 1184
            WIRE 352 1184 352 2512
            WIRE 352 2512 640 2512
        END BRANCH
        BEGIN BRANCH green_top_layer(3:0)
            WIRE 336 1248 368 1248
            WIRE 336 1248 336 2576
            WIRE 336 2576 640 2576
        END BRANCH
        BEGIN BRANCH blue_top_layer(3:0)
            WIRE 320 1312 368 1312
            WIRE 320 1312 320 2640
            WIRE 320 2640 640 2640
        END BRANCH
        BEGIN BRANCH EVENT_TYPE
            WIRE 608 2320 640 2320
        END BRANCH
        IOMARKER 608 2320 EVENT_TYPE R180 28
        BEGIN BRANCH NEW_KEY
            WIRE 576 2384 640 2384
        END BRANCH
        BEGIN BRANCH ASCII(6:0)
            WIRE 608 2448 640 2448
        END BRANCH
        IOMARKER 608 2448 ASCII(6:0) R180 28
        IOMARKER 576 2384 NEW_KEY R180 28
        BEGIN BRANCH inside_image
            WIRE 1040 2448 2624 2448
            WIRE 2592 1056 2624 1056
            WIRE 2624 1056 2624 2448
        END BRANCH
        BEGIN BRANCH LEFT
            WIRE 816 784 1152 784
            WIRE 1152 784 1296 784
            WIRE 1152 784 1152 1376
            WIRE 1152 1376 1232 1376
        END BRANCH
        BEGIN BRANCH RESOLUTION
            WIRE 224 976 352 976
            WIRE 352 976 368 976
            WIRE 352 688 352 976
            WIRE 352 688 1024 688
            WIRE 1024 688 1024 1312
            WIRE 1024 1312 1232 1312
        END BRANCH
        BEGIN BRANCH RIGHT
            WIRE 816 912 1120 912
            WIRE 1120 912 1296 912
            WIRE 1120 912 1120 1504
            WIRE 1120 1504 1232 1504
        END BRANCH
        BEGIN BRANCH new_event
            WIRE 816 1568 1024 1568
            WIRE 1024 1568 1024 1760
            WIRE 1024 1760 1232 1760
        END BRANCH
        BEGIN BRANCH XPOS(9:0)
            WIRE 816 1440 1072 1440
            WIRE 1072 1440 1072 1568
            WIRE 1072 1568 1232 1568
        END BRANCH
        BEGIN BRANCH ZPOS(3:0)
            WIRE 816 976 1088 976
            WIRE 1088 976 1296 976
            WIRE 1088 976 1088 1696
            WIRE 1088 1696 1232 1696
        END BRANCH
        BEGIN BRANCH YPOS(9:0)
            WIRE 816 1504 1056 1504
            WIRE 1056 1504 1056 1632
            WIRE 1056 1632 1232 1632
        END BRANCH
        BEGIN BRANCH MIDDLE
            WIRE 816 848 1136 848
            WIRE 1136 848 1136 1440
            WIRE 1136 1440 1232 1440
            WIRE 1136 848 1296 848
        END BRANCH
        BEGIN INSTANCE iPULSE_DEBOUNCER 1488 832 R0
        END INSTANCE
    END SHEET
END SCHEMATIC
