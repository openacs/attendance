ad_page_contract {

    Create a calendar session type, and redirect back to return_url
	
    @author Hamilton Chua (hamilton.chua@gmail.com)

} {
	{calendar_id}
	{return_url}
}

set item_type_id [calendar::item_type_new -calendar_id $calendar_id -type "Session"]

ad_returnredirect $return_url