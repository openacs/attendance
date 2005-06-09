<master>
<property name="title">@page_title;noquote@</property>
<property name="context">"@context;noquote@"</property>

@message;noquote@

<form name="mark_attendance" action="mark-2" method="POST">
	<input type="hidden" name="cal_item_id" value="@cal_item_id@">
	<input type="hidden" name="return_url" value="@return_url@">
	<listtemplate name="eval_members"></listtemplate>
	<br />
	<input type="submit" value="Submit">
</form>