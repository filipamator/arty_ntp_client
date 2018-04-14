
 add_fsm_encoding \
       {UART_TX.r_SM_Main} \
       { }  \
       {{000 000} {001 001} {010 010} {011 011} {100 100} }

 add_fsm_encoding \
       {arp_decoder.ST} \
       { }  \
       {{000 000} {001 010} {010 011} {011 100} {100 001} }

 add_fsm_encoding \
       {axis_eth.e_state} \
       { }  \
       {{000 00} {001 01} {010 10} {100 11} }
