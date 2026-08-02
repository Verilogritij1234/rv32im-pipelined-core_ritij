.global _start
.text

_start:
    # ==========================================
    # 1. MULTIPLIER TEST
    # ==========================================
    addi x10, x0, 12      # Load 12 into x10
    addi x11, x0, 5       # Load 5 into x11
    
    # Run the hardware multiplier: 12 * 5 = 60 (Hex: 0x0000003c)
    mul  x12, x10, x11    

    # ==========================================
    # 2. MULTI-CYCLE DIVIDER TEST (Stall Trigger)
    # ==========================================
    addi x13, x0, 100     # Load 100 into x13
    addi x14, x0, 7       # Load 7 into x14
    
    # Run the hardware divider: 100 / 7 = 14 (Hex: 0x0000000e)
    # THIS WILL FREEZE YOUR PIPELINE!
    div  x15, x13, x14    
    
    # Run the modulo/remainder: 100 % 7 = 2 (Hex: 0x00000002)
    rem  x16, x13, x14    

    # ==========================================
    # 3. FORWARDING UNIT TEST
    # ==========================================
    # Immediately use the divider result to test data forwarding
    # x17 = 14 + 2 = 16 (Hex: 0x00000010)
    add  x17, x15, x16    
    
    # Final Accumulator: x17 = 16 + 60 = 76 (Hex: 0x0000004c)
    add  x17, x17, x12    

end:
    # Safe Halt to prevent running off the edge of the ROM
    jal x0, end