VERSION 6
BEGIN SCHEMATIC
    BEGIN ATTR DeviceFamilyName "spartan3"
        DELETE all:0
        EDITNAME all:0
        EDITTRAIT all:0
    END ATTR
    BEGIN NETLIST
        SIGNAL write
        SIGNAL epp_adr(7:0)
        SIGNAL epp_data(7:0)
        SIGNAL CLK
        SIGNAL RST
        SIGNAL EPP_ASTB
        SIGNAL EPP_DSTB
        SIGNAL EPP_WRITE
        SIGNAL EPP_ACK
        SIGNAL EPP_BUS(7:0)
        SIGNAL NEW_REQUEST_IN
        SIGNAL REQUEST_VALUE_IN(2:0)
        SIGNAL WIDTH_OUT(7:0)
        SIGNAL SET_WIDTH_OUT
        SIGNAL HEIGHT_OUT(7:0)
        SIGNAL SET_HEIGHT_OUT
        SIGNAL PIXEL_COLOR_OUT(3:0)
        SIGNAL WRITE_PIXEL_COLOR_OUT
        SIGNAL CLEAR_WRITE_COUNTER_OUT
        PORT Input CLK
        PORT Input RST
        PORT Input EPP_ASTB
        PORT Input EPP_DSTB
        PORT Input EPP_WRITE
        PORT Output EPP_ACK
        PORT BiDirectional EPP_BUS(7:0)
        PORT Input NEW_REQUEST_IN
        PORT Input REQUEST_VALUE_IN(2:0)
        PORT Output WIDTH_OUT(7:0)
        PORT Output SET_WIDTH_OUT
        PORT Output HEIGHT_OUT(7:0)
        PORT Output SET_HEIGHT_OUT
        PORT Output PIXEL_COLOR_OUT(3:0)
        PORT Output WRITE_PIXEL_COLOR_OUT
        PORT Output CLEAR_WRITE_COUNTER_OUT
        BEGIN BLOCKDEF command_dispatcher
            TIMESTAMP 2006 9 25 14 37 46
            LINE N 432 32 496 32 
            LINE N 64 -352 0 -352 
            LINE N 64 -256 0 -256 
            RECTANGLE N 0 -204 64 -180 
            LINE N 64 -192 0 -192 
            RECTANGLE N 0 -140 64 -116 
            LINE N 64 -128 0 -128 
            RECTANGLE N 432 -364 496 -340 
            LINE N 432 -352 496 -352 
            LINE N 432 -288 496 -288 
            RECTANGLE N 432 -236 496 -212 
            LINE N 432 -224 496 -224 
            LINE N 432 -160 496 -160 
            RECTANGLE N 432 -108 496 -84 
            LINE N 432 -96 496 -96 
            LINE N 432 -32 496 -32 
            RECTANGLE N 64 -384 432 64 
        END BLOCKDEF
        BEGIN BLOCKDEF epp_controller
            TIMESTAMP 2006 9 25 14 52 37
            LINE N 64 -416 0 -416 
            LINE N 64 -352 0 -352 
            LINE N 320 -416 384 -416 
            RECTANGLE N 320 -364 384 -340 
            LINE N 320 -352 384 -352 
            RECTANGLE N 320 -300 384 -276 
            LINE N 320 -288 384 -288 
            RECTANGLE N 64 -448 320 128 
            LINE N 64 -288 0 -288 
            LINE N 64 -224 0 -224 
            LINE N 64 -160 0 -160 
            LINE N 0 -96 64 -96 
            RECTANGLE N 0 -44 64 -20 
            LINE N 0 -32 64 -32 
            LINE N 64 32 0 32 
            RECTANGLE N 0 84 64 108 
            LINE N 64 96 0 96 
        END BLOCKDEF
        BEGIN BLOCK iCOMMAND_DISPATCHER command_dispatcher
            PIN clk CLK
            PIN write_in write
            PIN epp_adr_in(7:0) epp_adr(7:0)
            PIN epp_data_in(7:0) epp_data(7:0)
            PIN set_width_out SET_WIDTH_OUT
            PIN set_height_out SET_HEIGHT_OUT
            PIN write_pixel_color_out WRITE_PIXEL_COLOR_OUT
            PIN width_out(7:0) WIDTH_OUT(7:0)
            PIN height_out(7:0) HEIGHT_OUT(7:0)
            PIN pixel_color_out(3:0) PIXEL_COLOR_OUT(3:0)
            PIN clear_write_counter_out CLEAR_WRITE_COUNTER_OUT
        END BLOCK
        BEGIN BLOCK iEPP_CONTROLLER epp_controller
            PIN clk CLK
            PIN rst RST
            PIN write_out write
            PIN epp_adr_out(7:0) epp_adr(7:0)
            PIN epp_data_out(7:0) epp_data(7:0)
            PIN epp_astb EPP_ASTB
            PIN epp_dstb EPP_DSTB
            PIN epp_write EPP_WRITE
            PIN epp_ack EPP_ACK
            PIN epp_bus(7:0) EPP_BUS(7:0)
            PIN new_request_in NEW_REQUEST_IN
            PIN request_value_in(2:0) REQUEST_VALUE_IN(2:0)
        END BLOCK
    END NETLIST
    BEGIN SHEET 1 3520 2720
        BEGIN INSTANCE iEPP_CONTROLLER 800 832 R0
        END INSTANCE
        BEGIN INSTANCE iCOMMAND_DISPATCHER 1424 672 R0
        END INSTANCE
        BEGIN BRANCH write
            WIRE 1184 416 1424 416
        END BRANCH
        BEGIN BRANCH epp_adr(7:0)
            WIRE 1184 480 1424 480
        END BRANCH
        BEGIN BRANCH epp_data(7:0)
            WIRE 1184 544 1424 544
        END BRANCH
        BEGIN BRANCH CLK
            WIRE 592 320 752 320
            WIRE 752 320 752 416
            WIRE 752 416 800 416
            WIRE 752 320 1424 320
        END BRANCH
        BEGIN BRANCH RST
            WIRE 592 480 800 480
        END BRANCH
        IOMARKER 592 320 CLK R180 28
        IOMARKER 592 480 RST R180 28
        BEGIN BRANCH EPP_ASTB
            WIRE 656 544 784 544
            WIRE 784 544 800 544
        END BRANCH
        BEGIN BRANCH EPP_DSTB
            WIRE 656 608 784 608
            WIRE 784 608 800 608
        END BRANCH
        BEGIN BRANCH EPP_WRITE
            WIRE 672 672 784 672
            WIRE 784 672 800 672
        END BRANCH
        BEGIN BRANCH EPP_ACK
            WIRE 640 736 784 736
            WIRE 784 736 800 736
        END BRANCH
        BEGIN BRANCH EPP_BUS(7:0)
            WIRE 688 800 784 800
            WIRE 784 800 800 800
        END BRANCH
        BEGIN BRANCH NEW_REQUEST_IN
            WIRE 752 864 784 864
            WIRE 784 864 800 864
        END BRANCH
        BEGIN BRANCH REQUEST_VALUE_IN(2:0)
            WIRE 768 928 800 928
        END BRANCH
        IOMARKER 768 928 REQUEST_VALUE_IN(2:0) R180 28
        BEGIN BRANCH WIDTH_OUT(7:0)
            WIRE 1920 320 1952 320
        END BRANCH
        IOMARKER 1952 320 WIDTH_OUT(7:0) R0 28
        BEGIN BRANCH SET_WIDTH_OUT
            WIRE 1920 384 1952 384
        END BRANCH
        IOMARKER 1952 384 SET_WIDTH_OUT R0 28
        BEGIN BRANCH HEIGHT_OUT(7:0)
            WIRE 1920 448 1952 448
        END BRANCH
        IOMARKER 1952 448 HEIGHT_OUT(7:0) R0 28
        BEGIN BRANCH SET_HEIGHT_OUT
            WIRE 1920 512 1952 512
        END BRANCH
        IOMARKER 1952 512 SET_HEIGHT_OUT R0 28
        BEGIN BRANCH PIXEL_COLOR_OUT(3:0)
            WIRE 1920 576 1952 576
        END BRANCH
        IOMARKER 1952 576 PIXEL_COLOR_OUT(3:0) R0 28
        BEGIN BRANCH WRITE_PIXEL_COLOR_OUT
            WIRE 1920 640 1952 640
        END BRANCH
        IOMARKER 1952 640 WRITE_PIXEL_COLOR_OUT R0 28
        BEGIN BRANCH CLEAR_WRITE_COUNTER_OUT
            WIRE 1920 704 1952 704
        END BRANCH
        IOMARKER 1952 704 CLEAR_WRITE_COUNTER_OUT R0 28
        IOMARKER 656 544 EPP_ASTB R180 28
        IOMARKER 656 608 EPP_DSTB R180 28
        IOMARKER 672 672 EPP_WRITE R180 28
        IOMARKER 640 736 EPP_ACK R180 28
        IOMARKER 688 800 EPP_BUS(7:0) R180 28
        IOMARKER 752 864 NEW_REQUEST_IN R180 28
    END SHEET
END SCHEMATIC
