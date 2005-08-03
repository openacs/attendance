ad_page_contract {

	List all attendees
	Get a calendar item id.
	Retrieve the users who are either present/absent for that calendar event
	Redirect to the dotlrn/spam.tcl

    @author Hamilton Chua (hamilton.chua@gmail.com)
    @creation-date 2004-05-17
    @version $Id$

} {
	item_id:integer,notnull
	{check ""}
	{return_url ""}
}


# set some variables
set community_id [dotlrn_community::get_community_id]
set community_url [dotlrn_community::get_community_url $community_id]
set page_title "Email Attendees"
set context ""

template::list::create \
    -name email_members \
    -key recipients \
    -multirow email_members \
    -elements {
	member_name { 
		label "Name"
	}
	attendance {
		label "Attendance"
	}
	send_email {
		label "Send Email"
	    	display_template { <input type=checkbox name=\"recipients\" value=\"@email_members.user_id@\">  }
	}
     }

template::multirow create email_members user_id member_name attendance send_email

set users [dotlrn_community::list_users  $community_id]
set cal_item_id $item_id

foreach user $users {	
	if { [db_0or1row "checkattendance" "select user_id from attendance_cal_item_map where cal_item_id = :cal_item_id and user_id = [ns_set get $user user_id]"] } {
		set attendance "Present"		
	} else {
		set attendance "Absent"
	}
	template::multirow append email_members "[ns_set get $user user_id]" "[ns_set get $user first_names] [ns_set get $user last_name]" "$attendance" ""
}
