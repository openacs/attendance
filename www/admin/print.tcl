ad_page_contract {
    
	Display printer friendly attendance page
    
    @author hamilton.chua@gmail.com
    @creation-date May 2005
    @cvs-id $Id$
} {
    item_id:integer,notnull
    {return_url ""}
} 

# initial vars
set page_title "Attendance"
set context $page_title
set community_id [dotlrn_community::get_community_id]

# task info

db_1row "getgradeid" "select task_id, task_name, due_date from evaluation_tasks where task_item_id = :item_id"
set cal_item_id [db_string "get_cal_id" "select cal_item_id from evaluation_cal_task_map where task_item_id =:item_id"]

calendar::item::get -cal_item_id $cal_item_id -array cal_item_info

set message "<p>Attendance for <b>$task_name</b> on $cal_item_info(full_start_date)</p>"

set elements {member_name {label "Member Name"}}

append elements { present {
		label "Present"
	    	display_template { <input type=checkbox name=\"user_id\" value=\"@eval_members.user_id@\"  <if @eval_members.present@>checked</if>>  }
		} }

template::list::create \
    -name eval_members \
    -multirow eval_members \
    -elements $elements

set users [dotlrn_community::list_users $community_id]

template::multirow create eval_members user_id member_name present

foreach user $users {
	set present [db_0or1row "checkattendance" "select user_id from attendance_cal_item_map where cal_item_id = :cal_item_id and user_id = [ns_set get $user user_id]"]
	template::multirow append eval_members "[ns_set get $user user_id]" "[ns_set get $user first_names] [ns_set get $user last_name]" "$present"
}
