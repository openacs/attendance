ad_page_contract {

	Deletes a task after confirmation

    @author jopez@galileo.edu
    @creation-date Mar 2004
    @cvs-id $Id$

} {
	task_id:integer,notnull
	grade_id:integer,notnull
	return_url
}

set page_title "Remove Attendance Task"

set context ""


db_1row get_task_info { *SQL* }

set export_vars [export_form_vars task_id grade_id return_url]

ad_return_template
