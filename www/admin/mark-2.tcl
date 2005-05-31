ad_page_contract {
    
	Mark attendance for a given attendance task
    
    @author Hamilton Chua (hamilton.chua@gmail.com)
    @creation-date May 2005
    @cvs-id $Id$
} {
    cal_item_id:integer,notnull
    user_id:integer,multiple,optional
} 

# delete attendance for a cal_item_id
db_dml "delattendance" "delete from attendance_cal_item_map where cal_item_id = :cal_item_id"

if { [exists_and_not_null user_id ] } {
	
	foreach id $user_id {
		db_dml  "updatemap" "insert into attendance_cal_item_map (cal_item_id, user_id) values (:cal_item_id, :id)"
	}
}

ad_returnredirect -message "Attendance has been marked" "index"