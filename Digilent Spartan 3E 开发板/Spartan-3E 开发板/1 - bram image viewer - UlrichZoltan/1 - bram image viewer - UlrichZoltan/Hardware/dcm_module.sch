VERSION 6
BEGIN SCHEMATIC
    BEGIN ATTR DeviceFamilyName "spartan3"
        DELETE all:0
        EDITNAME all:0
        EDITTRAIT all:0
    END ATTR
    BEGIN NETLIST
        SIGNAL CLK
        SIGNAL CLK_25MHz
        SIGNAL RST
        SIGNAL XLXN_2
        SIGNAL CLK_40MHz
        SIGNAL RESET
        PORT Input CLK
        PORT Output CLK_25MHz
        PORT Input RST
        PORT Output CLK_40MHz
        PORT Output RESET
        BEGIN BLOCKDEF dcm_25mhz
            TIMESTAMP 2006 9 18 12 24 20
            RECTANGLE N 64 -64 320 64 
            LINE N 64 -32 0 -32 
            LINE N 64 32 0 32 
            LINE N 320 -32 384 -32 
            LINE N 320 32 384 32 
        END BLOCKDEF
        BEGIN BLOCKDEF dcm_40mhz
            TIMESTAMP 2006 9 18 12 23 15
            RECTANGLE N 64 -128 320 0 
            LINE N 64 -96 0 -96 
            LINE N 64 -32 0 -32 
            LINE N 320 -96 384 -96 
            LINE N 320 -32 384 -32 
        END BLOCKDEF
        BEGIN BLOCK iDCM_25MHz dcm_25mhz
            PIN CLKIN_IN CLK
            PIN RST_IN RST
            PIN CLKFX_OUT CLK_25MHz
            PIN RESET_OUT XLXN_2
        END BLOCK
        BEGIN BLOCK iDCM_40MHz dcm_40mhz
            PIN CLKIN_IN CLK
            PIN RST_IN XLXN_2
            PIN CLKFX_OUT CLK_40MHz
            PIN RESET_OUT RESET
        END BLOCK
    END NETLIST
    BEGIN SHEET 1 3520 2720
        BEGIN BRANCH CLK_25MHz
            WIRE 1088 336 1296 336
        END BRANCH
        IOMARKER 1296 336 CLK_25MHz R0 28
        IOMARKER 144 336 CLK R180 28
        IOMARKER 144 400 RST R180 28
        BEGIN BRANCH RST
            WIRE 144 400 704 400
        END BRANCH
        BEGIN INSTANCE iDCM_25MHz 704 368 R0
        END INSTANCE
        BEGIN INSTANCE iDCM_40MHz 704 752 R0
        END INSTANCE
        BEGIN BRANCH XLXN_2
            WIRE 640 464 1168 464
            WIRE 640 464 640 720
            WIRE 640 720 704 720
            WIRE 1088 400 1168 400
            WIRE 1168 400 1168 464
        END BRANCH
        BEGIN BRANCH CLK_40MHz
            WIRE 1088 656 1296 656
        END BRANCH
        IOMARKER 1296 656 CLK_40MHz R0 28
        BEGIN BRANCH CLK
            WIRE 144 336 688 336
            WIRE 688 336 704 336
            WIRE 688 336 688 656
            WIRE 688 656 704 656
        END BRANCH
        BEGIN BRANCH RESET
            WIRE 1088 720 1104 720
            WIRE 1104 720 1296 720
        END BRANCH
        IOMARKER 1296 720 RESET R0 28
    END SHEET
END SCHEMATIC
