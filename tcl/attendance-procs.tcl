ad_library {
    
    Library procs for attendance
    
    @author Hamilton Chua  (hamilton.chua@gmail.com)
    @creation-date 2005-05-17
    @cvs-id $Id$
}

namespace eval attendance {

ad_proc get_grade_info {
	-package_id:required
} {
	HAM (hamilton.chua@gmail.com)
	Retreives grade_id and grade_item_id from evaluation and sets them in the calling environment
} {

	uplevel 1 { db_0or1row "getgradeid" "select eg.grade_id as grade_id, eg.grade_item_id as grade_item_id, eg.grade_plural_name
   	 	from evaluation_grades eg, acs_objects ao, cr_items cri
		where cri.live_revision = eg.grade_id
          	and eg.grade_item_id = ao.object_id
   		and ao.context_id = :package_id
		and eg.grade_name = 'Attendance'" }
}

ad_proc create_task {
	-cal_item_id:required
	-grade_item_id:required
	{-package_id ""}
} {
	HAM (hamilton.chua@gmail.com)
	Create an attendance task
} {

	if { ![db_0or1row "checkmap" {} ] } {

		calendar::item::get -cal_item_id $cal_item_id -array cal_item_array
		
		set task_name $cal_item_array(name)
		set description ""
		set item_id [db_nextval acs_object_id_seq]
		set cal_start_date [template::util::date::from_ansi $cal_item_array(start_date_ansi) "YYYY-MM-DD HH24:MI:SS"]
		set cal_end_date [template::util::date::from_ansi $cal_item_array(end_date_ansi)  "YYYY-MM-DD HH24:MI:SS"]

		if {[empty_string_p $package_id]} {
			set package_id [ad_conn package_id]
		}
		
		set due_date_ansi $cal_item_array(start_date_ansi)
		set url ""		
	
		set storage_type "lob"
			
		set title [evaluation::safe_url_name -name $task_name]
		
		set revision_id [evaluation::new_task -new_item_p [ad_form_new_p -key grade_id] -item_id $item_id \
							-content_type evaluation_tasks \
							-content_table evaluation_tasks \
							-content_id task_id \
							-name $task_name \
							-description $description \
							-weight "0" \
							-grade_item_id $grade_item_id \
							-number_of_members "1" \
							-storage_type $storage_type \
							-due_date  $due_date_ansi \
							-requires_grade_p "f" \
							-title $title -package_id $package_id ]
					
		content::item::set_live_revision -revision_id $revision_id
		db_dml update_date {
			update evaluation_tasks set due_date = (select to_date(:due_date_ansi,'YYYY-MM-DD HH24:MI:SS') from dual)
			where task_id = :revision_id
		}
		
		db_dml "link_content" { }
		db_dml "set_storage_type" { }
		set content_length [string length $url]
		db_dml "content_size" { }
		db_dml "insert_cal_mapping" {  }

	}

}

ad_proc add_sessions {
	-community_id:required
	-grade_item_id:required
	{-package_id ""}
} {
	HAM (hamilton.chua@gmail.com)
	Check if there are calendar sessions for the section	
	Check if the session is already an evaluation task
	if not then create a task with the session's details
} {

	# let's retrieve sessions for this community
	set calendar_id [dotlrn_calendar::get_group_calendar_id -community_id $community_id]
	set item_type_id [db_string item_type_id "select item_type_id from cal_item_types where type='Session' and  calendar_id = :calendar_id"]

	if {[empty_string_p $package_id]} {
		set package_id [ad_conn package_id]
	}

	# create the task
	db_transaction {

		# check if each session has corresponding evaluation task, if none then add it
		db_foreach "cal_item" "select cal_item_id from cal_items where on_which_calendar = :calendar_id and item_type_id = :item_type_id" {

			attendance::create_task -cal_item_id $cal_item_id -grade_item_id $grade_item_id	-package_id $package_id
		
		}
	
	}
	

}

	
}