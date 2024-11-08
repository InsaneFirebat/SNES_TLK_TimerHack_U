
macro a8()
    SEP #$20
endmacro

macro a16()
    REP #$20
endmacro

macro i8()
    SEP #$10
endmacro

macro ai8()
    SEP #$30
endmacro

macro ai16()
    REP #$30
endmacro

macro i16()
    REP #$10
endmacro

macro item_index_to_vram_index()
    ; Find screen position from Y (item number)
    TYA : ASL #5
    CLC : ADC #$0146 : TAX
endmacro


; ----------------
; Main Menu Macros
; ----------------

macro cm_header(title)
; text to be drawn above the menu items
    db !PALETTE_HEADER, "<title>", #$FF
endmacro

macro cm_footer(title)
; optional text below the menu items
    dw #$F007 : db !PALETTE_HEADER, "<title>", #$FF
endmacro

macro cm_version_header(title, major, minor, build, rev_1, rev_2)
; header text with automatic version number appended
if !VERSION_REV_1 ;              ^ = lowercase v
    db !PALETTE_HEADER, "<title> ^<major>.<minor>.<build>"
if !DEV_BUILD
    db #$FF
else
    db ".<rev_1><rev_2>", #$FF
endif
else
if !VERSION_REV_2
    db !PALETTE_HEADER, "<title> ^<major>.<minor>.<build>"
if !DEV_BUILD
    db #$FF
else
    db ".<rev_2>", #$FF
endif
else
    db !PALETTE_HEADER, "<title> ^<major>.<minor>.<build>", #$FF
endif
endif
endmacro

macro cm_numfield(title, addr, min, max, increment, heldincrement, jsltarget)
; Allows editing an 8-bit value at the specified address
    dw !ACTION_NUMFIELD
    dl <addr>
    db <min>, <max>, <increment>, <heldincrement>
    dw <jsltarget>
    db !PALETTE_TEXT, "<title>", #$FF
endmacro

macro cm_numfield_8bit(title, addr, min, max, increment, heldincrement, jsltarget)
; Allows editing an 8-bit value at an 8-bit address
    dw !ACTION_NUMFIELD_8BIT
    dl <addr>
    db <min>, <max>, <increment>, <heldincrement>
    dw <jsltarget>
    db !PALETTE_TEXT, "<title>", #$FF
endmacro

macro cm_numfield_decimal(title, addr, min, max, increment, heldincrement, jsltarget)
; Allows editing an 8-bit value in decimal
    dw !ACTION_NUMFIELD_DECIMAL
    dl <addr>
    db <min>, <max>, <increment>, <heldincrement>
    dw <jsltarget>
    db !PALETTE_TEXT, "<title>", #$FF
endmacro

macro cm_numfield_word(title, addr, min, max, increment, heldincrement, jsltarget)
; Allows editing a 16-bit value at the specified address
    dw !ACTION_NUMFIELD_WORD
    dl <addr>
    dw <min>, <max>, <increment>, <heldincrement>
    dw <jsltarget>
    db !PALETTE_TEXT, "<title>", #$FF
endmacro

macro cm_numfield_hex(title, addr, min, max, increment, heldincrement, jsltarget)
; Allows editing an 8-bit value displayed in hexadecimal
    dw !ACTION_NUMFIELD_HEX
    dl <addr>
    db <min>, <max>, <increment>, <heldincrement>
    dw <jsltarget>
    db !PALETTE_TEXT, "<title>", #$FF
endmacro

macro cm_numfield_hex_word(title, addr)
; Allows displaying a 16-bit value in hexadecimal
    dw !ACTION_NUMFIELD_HEX_WORD
    dl <addr>
    db !PALETTE_TEXT, "<title>", #$FF
endmacro

macro cm_numfield_time(title, addr, routine, argument)
; Allows displaying a two digit base60 value in decimal
    dw !ACTION_NUMFIELD_TIME
    dl <addr>
    dw <routine>
    dw <argument>
    db !PALETTE_TEXT, "<title>", #$FF
endmacro

macro cm_numfield_color(title, addr, jsltarget)
; Allows editing an 8-bit value in increments consistent with SNES color values
    dw !ACTION_NUMFIELD_COLOR
    dl <addr>
    dw <jsltarget>
    db !PALETTE_TEXT, "<title>", #$FF
endmacro

macro cm_numfield_sound(title, addr, min, max, increment, heldincrement, jsltarget)
; Allows editing an 8-bit value and playing a sound when pressing Y
    dw !ACTION_NUMFIELD_SOUND
    dl <addr>
    db <min>, <max>, <increment>, <heldincrement>
    dw <jsltarget>
    db !PALETTE_TEXT, "<title>", #$FF
endmacro

macro cm_toggle(title, addr, value, jsltarget)
; toggle between zero (OFF) and value (ON)
    dw !ACTION_TOGGLE
    dl <addr>
    db <value>
    dw <jsltarget>
    db !PALETTE_TEXT, "<title>", #$FF
endmacro

macro cm_toggle_inverted(title, addr, value, jsltarget)
; for toggles where zero = ON
    dw !ACTION_TOGGLE_INVERTED
    dl <addr>
    db <value>
    dw <jsltarget>
    db !PALETTE_TEXT, "<title>", #$FF
endmacro

macro cm_toggle_bit(title, addr, mask, jsltarget)
; toggle specific bits, draw OFF if bits cleared
    dw !ACTION_TOGGLE_BIT
    dl <addr>
    dw <mask>
    dw <jsltarget>
    db !PALETTE_TEXT, "<title>", #$FF
endmacro

macro cm_toggle_bit_inverted(title, addr, mask, jsltarget)
; toggle specific bits, draw ON if bits cleared
    dw !ACTION_TOGGLE_BIT_INVERTED
    dl <addr>
    dw <mask>
    dw <jsltarget>
    db !PALETTE_TEXT, "<title>", #$FF
endmacro

macro cm_jsl(title, routine, argument)
; run code when menu item executed
    dw !ACTION_JSL
    dw <routine>
    dw <argument>
    db !PALETTE_TEXT, "<title>", #$FF
endmacro

macro cm_jsl_submenu(title, routine, argument)
; only used within submenu and mainmenu macros
    dw !ACTION_JSL_SUBMENU
    dw <routine>
    dw <argument>
    db !PALETTE_TEXT, "<title>", #$FF
endmacro

macro cm_mainmenu(title, target)
; runs action_mainmenu to set the bank of the next menu and continue into action_submenu
; can only used for submenus listed on the mainmenu
    %cm_jsl("<title>", #action_mainmenu, <target>)
endmacro

macro cm_submenu(title, target)
; run action_submenu to load the next menu from the same bank
    %cm_jsl_submenu("<title>", #action_submenu, <target>)
endmacro

macro cm_ctrl_shortcut(title, addr)
; configure controller shortcuts
    dw !ACTION_CTRL_SHORTCUT
    dl <addr>
    db !PALETTE_TEXT, "<title>", #$FF
endmacro

macro cm_ctrl_input(title, addr, routine, argument)
; configure controller bindings
    dw !ACTION_CTRL_INPUT
    dl <addr>
    dw <routine>
    dw <argument>
    db !PALETTE_TEXT, "<title>", #$FF
endmacro

macro palettemenu(title, pointer, addr)
    %cm_submenu("<title>", <pointer>)
    
<pointer>:
    dw #palettes_hex_red
    dw #palettes_hex_green
    dw #palettes_hex_blue
    dw #$FFFF
    dw #palettes_dec_red
    dw #palettes_dec_green
    dw #palettes_dec_blue
    dw #$FFFF
    dw #<pointer>_hex_hi
    dw #<pointer>_hex_lo
    dw #$0000
    %cm_header("<title>")
    %cm_footer("THREE WAYS TO EDIT COLORS")

<pointer>_hex_hi:
    %cm_numfield_hex("SNES BGR - HI BYTE", !ram_pal_hi, 0, 255, 1, 8, .routine)
  .routine
    %a8() ; ram_pal_hi already in A
    XBA : LDA !ram_pal_lo
    %a16()
    STA <addr>
    JMP cm_update_colors

<pointer>_hex_lo:
    %cm_numfield_hex("SNES BGR - LO BYTE", !ram_pal_lo, 0, 255, 1, 8, .routine)
  .routine
    %a8() ; ram_pal_lo already in A
    XBA : LDA !ram_pal_hi : XBA
    %a16()
    STA <addr>
    JMP cm_update_colors
}
endmacro

macro setupRGB(addr)
    LDX.w #<addr> ; addr
    LDA.b #<addr>>>16 ; bank
    RTS
endmacro

macro setmenubank()
    PHK : PHK : PLA
    STA !ram_cm_menu_bank
endmacro

macro cm_fixdp()
    PHD
    PEA $0000 : PLD
endmacro
