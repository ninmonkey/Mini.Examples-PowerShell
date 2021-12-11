Configures system devices.

Serial port:       MODE COMm[:] [BAUD=b] [PARITY=p] [DATA=d] [STOP=s]
                                [to=on|off] [xon=on|off] [odsr=on|off]
                                [octs=on|off] [dtr=on|off|hs]
                                [rts=on|off|hs|tg] [idsr=on|off]

Device Status:     MODE [device] [/STATUS]

Redirect printing: MODE LPTn[:]=COMm[:]

Select code page:  MODE CON[:] CP SELECT=yyy

Code page status:  MODE CON[:] CP [/STATUS]

Display mode:      MODE CON[:] [COLS=c] [LINES=n]

Typematic rate:    MODE CON[:] [RATE=r DELAY=d]
