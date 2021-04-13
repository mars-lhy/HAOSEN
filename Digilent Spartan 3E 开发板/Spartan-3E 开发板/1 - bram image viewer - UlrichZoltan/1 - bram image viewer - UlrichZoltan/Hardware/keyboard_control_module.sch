VERSION 6
BEGIN SCHEMATIC
    BEGIN ATTR DeviceFamilyName "spartan3"
        DELETE all:0
        EDITNAME all:0
        EDITTRAIT all:0
    END ATTR
    BEGIN NETLIST
        SIGNAL ASCII(6:0)
        SIGNAL ready
        SIGNAL RST
        SIGNAL CLK
        SIGNAL PS2_CLK_KB
        SIGNAL PS2_DATA_KB
        SIGNAL SWITCH
        SIGNAL RESOLUTION
        SIGNAL NEW_REQUEST_OUT
        SIGNAL REQUEST_OUT(2:0)
        SIGNAL event_type
        SIGNAL XLXN_1
        SIGNAL XLXN_2
        SIGNAL XLXN_3
        SIGNAL XLXN_10
        SIGNAL ctrl
        SIGNAL XLXN_12
        SIGNAL XLXN_13(6:0)
        PORT Output ASCII(6:0)
        PORT Output ready
        PORT Input RST
        PORT Input CLK
        PORT BiDirectional PS2_CLK_KB
        PORT BiDirectional PS2_DATA_KB
        PORT Output SWITCH
        PORT Output RESOLUTION
        PORT Output NEW_REQUEST_OUT
        PORT Output REQUEST_OUT(2:0)
        PORT Output event_type
        BEGIN BLOCKDEF keyboard_module
            TIMESTAMP 2006 9 24 18 9 12
            LINE N 320 -96 384 -96 
            LINE N 64 -416 0 -416 
            LINE N 320 -416 384 -416 
            LINE N 320 -352 384 -352 
            LINE N 320 -288 384 -288 
            LINE N 320 -224 384 -224 
            RECTANGLE N 320 -172 384 -148 
            LINE N 320 -160 384 -160 
            LINE N 64 -352 0 -352 
            LINE N 0 -288 64 -288 
            LINE N 0 -224 64 -224 
            RECTANGLE N 64 -448 320 -64 
        END BLOCKDEF
        BEGIN BLOCKDEF resolution_switcher
            TIMESTAMP 2006 9 28 10 53 58
            LINE N 64 -160 0 -160 
            LINE N 64 -96 0 -96 
            LINE N 320 -160 384 -160 
            RECTANGLE N 64 -192 320 128 
            LINE N 64 -32 0 -32 
            LINE N 64 32 0 32 
            RECTANGLE N 0 84 64 108 
            LINE N 64 96 0 96 
            LINE N 320 -96 384 -96 
        END BLOCKDEF
        BEGIN BLOCKDEF request_controller
            TIMESTAMP 2006 9 24 18 10 46
            LINE N 64 32 0 32 
            LINE N 64 -160 0 -160 
            LINE N 64 -96 0 -96 
            RECTANGLE N 0 -44 64 -20 
            LINE N 64 -32 0 -32 
            LINE N 320 -160 384 -160 
            RECTANGLE N 320 -44 384 -20 
            LINE N 320 -32 384 -32 
            RECTANGLE N 64 -192 320 64 
        END BLOCKDEF
        BEGIN BLOCK iKEYBOARD_MODULE keyboard_module
            PIN CLK CLK
            PIN RST RST
            PIN PS2_CLK_KB PS2_CLK_KB
            PIN PS2_DATA_KB PS2_DATA_KB
            PIN SHIFT
            PIN CTRL ctrl
            PIN ALT
            PIN READY ready
            PIN ASCII_OUT(6:0) ASCII(6:0)
            PIN EVENT_TYPE event_type
        END BLOCK
        BEGIN BLOCK iRESOLUTION_SWITCHER resolution_switcher
            PIN clk CLK
            PIN rst RST
            PIN switch SWITCH
            PIN ctrl ctrl
            PIN ready ready
            PIN ascii(6:0) ASCII(6:0)
            PIN resolution RESOLUTION
        END BLOCK
        BEGIN BLOCK iREQUEST_CONTROLLER request_controller
            PIN clk CLK
            PIN ready_in ready
            PIN ascii_in(6:0) ASCII(6:0)
            PIN new_request_out NEW_REQUEST_OUT
            PIN request_out(2:0) REQUEST_OUT(2:0)
            PIN event_type_in event_type
        END BLOCK
    END NETLIST
    BEGIN SHEET 1 3520 2720
        BEGIN INSTANCE iKEYBOARD_MODULE 976 784 R0
        END INSTANCE
        BEGIN BRANCH PS2_CLK_KB
            WIRE 928 496 976 496
        END BRANCH
        BEGIN BRANCH PS2_DATA_KB
            WIRE 944 560 976 560
        END BRANCH
        IOMARKER 944 560 PS2_DATA_KB R180 28
        IOMARKER 928 496 PS2_CLK_KB R180 28
        IOMARKER 832 368 CLK R180 28
        IOMARKER 832 256 RST R180 28
        BEGIN INSTANCE iREQUEST_CONTROLLER 1664 944 R0
        END INSTANCE
        BEGIN BRANCH NEW_REQUEST_OUT
            WIRE 2048 784 2080 784
        END BRANCH
        IOMARKER 2080 784 NEW_REQUEST_OUT R0 28
        BEGIN BRANCH REQUEST_OUT(2:0)
            WIRE 2048 912 2080 912
        END BRANCH
        IOMARKER 2080 912 REQUEST_OUT(2:0) R0 28
        IOMARKER 2208 736 ready R0 28
        IOMARKER 2208 688 event_type R0 28
        IOMARKER 2208 640 ASCII(6:0) R0 28
        BEGIN INSTANCE iRESOLUTION_SWITCHER 1664 512 R0
        END INSTANCE
        BEGIN BRANCH CLK
            WIRE 832 368 928 368
            WIRE 928 368 976 368
            WIRE 928 272 928 368
            WIRE 928 272 1536 272
            WIRE 1536 272 1536 352
            WIRE 1536 352 1536 784
            WIRE 1536 784 1664 784
            WIRE 1536 352 1664 352
        END BRANCH
        BEGIN BRANCH RST
            WIRE 832 256 912 256
            WIRE 912 256 912 432
            WIRE 912 432 976 432
            WIRE 912 256 1552 256
            WIRE 1552 256 1552 416
            WIRE 1552 416 1664 416
        END BRANCH
        BEGIN BRANCH ASCII(6:0)
            WIRE 1360 624 1584 624
            WIRE 1584 624 1584 672
            WIRE 1584 672 1584 912
            WIRE 1584 912 1664 912
            WIRE 1584 672 2112 672
            WIRE 1584 608 1664 608
            WIRE 1584 608 1584 624
            WIRE 2112 640 2208 640
            WIRE 2112 640 2112 672
        END BRANCH
        BEGIN BRANCH ready
            WIRE 1360 560 1568 560
            WIRE 1568 560 1568 736
            WIRE 1568 736 1568 848
            WIRE 1568 848 1664 848
            WIRE 1568 736 2208 736
            WIRE 1568 544 1664 544
            WIRE 1568 544 1568 560
        END BRANCH
        BEGIN BRANCH SWITCH
            WIRE 2048 352 2112 352
        END BRANCH
        BEGIN BRANCH RESOLUTION
            WIRE 2048 416 2112 416
        END BRANCH
        IOMARKER 2112 352 SWITCH R0 28
        IOMARKER 2112 416 RESOLUTION R0 28
        BEGIN BRANCH event_type
            WIRE 1360 688 1504 688
            WIRE 1504 688 1504 976
            WIRE 1504 976 1664 976
            WIRE 1504 688 2208 688
        END BRANCH
        BEGIN BRANCH ctrl
            WIRE 1360 432 1504 432
            WIRE 1504 432 1504 480
            WIRE 1504 480 1664 480
        END BRANCH
    END SHEET
END SCHEMATIC
