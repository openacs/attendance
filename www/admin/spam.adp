<master>
<property name="title">@page_title;noquote@</property>
<property name="context">"@context;noquote@"</property>

<SCRIPT LANGUAGE="JavaScript">
function checkAll(field)
{
for (i = 0; i < field.length; i++)
	field[i].checked = true ;
}

function uncheckAll(field)
{
for (i = 0; i < field.length; i++)
	field[i].checked = false ;
}
//  End -->
</script>

Select the users to whom you would like to send an email.
<br /><br />

<a onClick="checkAll(document.mark_attendance.recipients);" class="button">Check All</a>&nbsp;<a onClick="uncheckAll(document.mark_attendance.recipients);" class="button">Uncheck All</a>
<br /><br />
<form name="mark_attendance" action="@community_url@/spam" method="POST">
	<input type="hidden" name="referer" value="@return_url@">
	<listtemplate name="email_members"></listtemplate>
	<br />
	<input type="submit" value="Continue"> <input type=button onclick="history.back()" value="Cancel">
</form>
