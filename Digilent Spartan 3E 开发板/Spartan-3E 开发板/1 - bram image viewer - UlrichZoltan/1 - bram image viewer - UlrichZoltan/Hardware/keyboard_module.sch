VERSION 6
BEGIN SCHEMATIC
    BEGIN ATTR DeviceFamilyName "spartan3"
        DELETE all:0
        EDITNAME all:0
        EDITTRAIT all:0
    END ATTR
    BEGIN NETLIST
        SIGNAL XLXN_6
        SIGNAL XLXN_7
        SIGNAL XLXN_8
        SIGNAL XLXN_9
        SIGNAL XLXN_10(7:0)
        SIGNAL XLXN_11(7:0)
        SIGNAL CLK
        SIGNAL RST
        SIGNAL PS2_CLK_KB
        SIGNAL PS2_DATA_KB
        SIGNAL SHIFT
        SIGNAL CTRL
        SIGNAL ALT
        SIGNAL READY
        SIGNAL ASCII_OUT(6:0)
        SIGNAL EVENT_TYPE
        PORT Input CLK
        PORT Input RST
        PORT BiDirectional PS2_CLK_KB
        PORT BiDirectional PS2_DATA_KB
        PORT Output SHIFT
        PORT Output CTRL
        PORT Output ALT
        PORT Output READY
        PORT Output ASCII_OUT(6:0)
        PORT Output EVENT_TYPE
        BEGIN BLOCKDEF keyboard_controller
            TIMESTAMP 2006 9 24 18 8 51
            LINE N 320 32 384 32 
            LINE N 64 -416 0 -416 
            LINE N 64 -352 0 -352 
            LINE N 64 -288 0 -288 
            LINE N 320 -416 384 -416 
            LINE N 320 -352 384 -352 
            LINE N 320 -288 384 -288 
            LINE N 320 -224 384 -224 
            RECTANGLE N 320 -172 384 -148 
            LINE N 320 -160 384 -160 
            LINE N 0 -224 64 -224 
            LINE N 64 -160 0 -160 
            LINE N 64 -96 0 -96 
            RECTANGLE N 0 -44 64 -20 
            LINE N 64 -32 0 -32 
            RECTANGLE N 0 20 64 44 
            LINE N 0 32 64 32 
            RECTANGLE N 64 -448 320 64 
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
        BEGIN BLOCK iKEYBOARD_CONTROLLER keyboard_controller
            PIN clk CLK
            PIN rst RST
            PIN read XLXN_6
            PIN err XLXN_9
            PIN busy XLXN_8
            PIN rx_data(7:0) XLXN_10(7:0)
            PIN write XLXN_7
            PIN shift SHIFT
            PIN ctrl CTRL
            PIN alt ALT
            PIN ready READY
            PIN tx_data(7:0) XLXN_11(7:0)
            PIN ascii(6:0) ASCII_OUT(6:0)
            PIN event_type EVENT_TYPE
        END BLOCK
        BEGIN BLOCK iPS2_INTERFACE_KEYBOARD ps2interface
            PIN clk CLK
            PIN read XLXN_6
            PIN rst RST
            PIN rx_data(7:0) XLXN_10(7:0)
            PIN tx_data(7:0) XLXN_11(7:0)
            PIN busy XLXN_8
            PIN err XLXN_9
            PIN write XLXN_7
            PIN ps2_clk PS2_CLK_KB
            PIN ps2_data PS2_DATA_KB
        END BLOCK
    END NETLIST
    BEGIN SHEET 1 3520 2720
        BEGIN INSTANCE iPS2_INTERFACE_KEYBOARD 416 752 R0
        END INSTANCE
        BEGIN BRANCH XLXN_6
            WIRE 800 400 960 400
        END BRANCH
        BEGIN BRANCH XLXN_7
            WIRE 800 464 960 464
        END BRANCH
        BEGIN BRANCH XLXN_8
            WIRE 800 528 960 528
        END BRANCH
        BEGIN BRANCH XLXN_9
            WIRE 800 592 960 592
        END BRANCH
        BEGIN BRANCH XLXN_10(7:0)
            WIRE 800 656 960 656
        END BRANCH
        BEGIN BRANCH XLXN_11(7:0)
            WIRE 800 720 960 720
        END BRANCH
        BEGIN INSTANCE iKEYBOARD_CONTROLLER 960 688 R0
        END INSTANCE
        BEGIN BRANCH CLK
            WIRE 272 272 336 272
            WIRE 336 272 336 400
            WIRE 336 400 416 400
            WIRE 336 272 960 272
        END BRANCH
        BEGIN BRANCH RST
            WIRE 272 336 352 336
            WIRE 352 336 352 464
            WIRE 352 464 416 464
            WIRE 352 336 960 336
        END BRANCH
        IOMARKER 272 272 CLK R180 28
        IOMARKER 272 336 RST R180 28
        BEGIN BRANCH PS2_CLK_KB
            WIRE 384 656 416 656
        END BRANCH
        IOMARKER 384 656 PS2_CLK_KB R180 28
        BEGIN BRANCH PS2_DATA_KB
            WIRE 384 720 416 720
        END BRANCH
        IOMARKER 384 720 PS2_DATA_KB R180 28
        BEGIN BRANCH SHIFT
            WIRE 1344 272 1376 272
        END BRANCH
        IOMARKER 1376 272 SHIFT R0 28
        BEGIN BRANCH CTRL
            WIRE 1344 336 1376 336
        END BRANCH
        IOMARKER 1376 336 CTRL R0 28
        BEGIN BRANCH ALT
            WIRE 1344 400 1376 400
        END BRANCH
        IOMARKER 1376 400 ALT R0 28
        BEGIN BRANCH READY
            WIRE 1344 464 1376 464
        END BRANCH
        IOMARKER 1376 464 READY R0 28
        BEGIN BRANCH ASCII_OUT(6:0)
            WIRE 1344 528 1376 528
        END BRANCH
        IOMARKER 1376 528 ASCII_OUT(6:0) R0 28
        BEGIN BRANCH EVENT_TYPE
            WIRE 1344 720 1376 720
        END BRANCH
        IOMARKER 1376 720 EVENT_TYPE R0 28
    END SHEET
END SCHEMATIC
