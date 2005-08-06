	<listtemplate name="session_list"></listtemplate>
	<ul>
		<li><a href="@calendar_url@cal-item-new?item_type_id=@item_type_id@&calendar_id=@calendar_id@&view=day&return_url=@current_url@" >Create New Session</a>

<if @show_non_session_calendar_links@>
		<li><a href="@calendar_url@cal-item-new?calendar_id=@calendar_id@&view=day" target="blank">Create Calendar Event(Any Type)</a>
		<li><a href="@calendar_url@calendar-item-types?calendar_id=@calendar_id@" target="blank">Add New Event Type</a> - Experts only!
</if>
	</ul>
