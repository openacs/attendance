if { ![info exists section] } {
    set section {}
}

if { ![info exists header_stuff] } {
    set header_stuff {}
}

if { ![info exists context_bar] } {
    set context_bar {}
}

if { [llength [info procs ::ds_show_p]] == 1 
     && [ds_show_p]
 } {
    set developer_support_p 1
} else {
    set developer_support_p 0
}
