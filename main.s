#include <xc.inc>

extrn	sensor_setup, sensor_trigger, compare_distance
extrn	motor_setup, Forward, Backward, Left, Right, Stop, motor_test
extrn	T1_setup, CCP_setup, CCP_reset, CCP_Interrupt
extrn	Keypad_Setup, Keypad_Read
extrn	Forward, Backward, Left, Right
extrn	US_measuring

global	safety_dist_h, safety_dist_l
    
psect	udata_acs
safety_dist_h:	ds 1				    ; Reserve 1 byte for safety distance high
safety_dist_l:	ds 1				    ; Reserve 1 byte for safety distance low
key_value:	ds 1				        ; Reserve 1 byte for keypad value
    
psect code, abs
 
rst:
    org 0x0
    goto setup
    
interrupt:
    org 0x08
    goto    CCP_Interrupt    

setup:
    call	motor_setup			        ; Initialize motor setup
    call	Keypad_Setup			    ; Initialize keypad setup
    call	sensor_setup			    ; Initialize sensor setup
    call	CCP_setup			        ; Initialize CCP module
    call	T1_setup
     
    movlw	0x03				        ; Setup the safety distance 27.5 cm
    movwf	safety_dist_h, A
    movlw	0x26
    movwf	safety_dist_l, A	    
    
main_loop:
    call	sensor_trigger              ; Send ultrasonic pulse
    call	Keypad_Read                 ; Read from Keypad
    call	compare_distance            ; Compare distance reading with safety distance
    goto	main_loop                    

end rst
