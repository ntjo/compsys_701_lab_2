onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Analog-Step -height 74 -max 7730.0000000000009 -min -7730.0 -radix decimal /testtoplevel/asp_dac/channel_0
add wave -noupdate -format Analog-Step -height 74 -max 7692.0 -min -7693.0 -radix decimal /testtoplevel/asp_dac/channel_1
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {119431 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 243
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {393772 ns}
