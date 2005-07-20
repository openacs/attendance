<master>
<property name="title">@page_title;noquote@</property>
<property name="context">"@context;noquote@"</property>

Select the users to whom you would like to send an email.
<br /><br />

<form name="mark_attendance" action="@community_url@/spam" method="POST">
	<input type="hidden" name="referer" value="@return_url@">
	<listtemplate name="email_members"></listtemplate>
	<br />
	<input type="submit" value="Continue"> <input type=button onclick="history.back()" value="Cancel">
</form>
