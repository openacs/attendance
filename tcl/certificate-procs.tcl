ad_library {
    Procedures to support certificate printing
}

namespace eval attendance_certificate {}

ad_proc -private attendance_certificate::reportlab_available_p {
} {
    Check if reportlab is avialable
} {
    catch {exec python -V} python

	set python_version [lindex [split $python] 1]
	set python_version [split $python_version .]
	set python_path "python[join [lrange $python_version 0 1] .]"
	foreach p {/usr/lib/ /usr/local/ /usr/local/lib/} {
	    if {[file exists ${p}${python_path}/site-packages/reportlab]} {
		return 1
	    }
	}
    
    return 0
}

ad_proc -private attendance_certificate::trml2pdf_command {
} {
    command to pass to exec for trml2pdf
} {

}
