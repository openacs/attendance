
ad_page_contract {
	Generate PDF for certificates
} -query {
    community_id:integer,optional
    user_id:multiple,optional
    image_file:trim,optional
    image_file.tmpfile:tmpfile,optional
}

if {![attendance_certificate::reportlab_available_p]} {
    ad_return_complaint 1 "ReportLab is not available. Please contact your system administrator."
    ad_script_abort
}
if {![exists_and_not_null community_id]} {
	set community_id [dotlrn_community::get_community_id_from_url]
}
if {![exists_and_not_null user_id]} {
    ad_returnredirect -message "Please select one or more users." "summary"
    ad_script_abort
}
# setup course section info

set package_id [ad_conn package_id] 

#setup multirow of user data we
# can't use multiple in a hidden variable and the multiple in
# ad_page_contract messes up the curly braces so throw them away to be
# safe since we might export user_id as a URL variable in a redirect
set user_id [split [string trim $user_id \{\}]]

ad_form -name certificates \
    -html { enctype multipart/form-data } \
    -export {user_id community_id} \
    -form {
    {image_info:text(inform),optional {label "Current logo image"}}
    {image_file:file(file),optional {label "Upload logo image"}}
    }
set site_wide_admin_p [permission::permission_p \
	 -object_id [acs_magic_object "security_context_root"] \
	 -party_id [ad_conn user_id] \
	 -privilege "admin"]
if {$site_wide_admin_p} {
    ad_form -extend -name certificates -form {
	{set_sw_submit:text(submit) {label "Make site wide default"}}
    }
}
ad_form -extend -name certificates -form {
    {use_sw_submit:text(submit) {label "Use site wide default"}}
    {certificate:text,optional {label ""} {html {size 60}}}
    {this_certifies:text,optional {label ""} {html {size 60}}}
    {attended:text,optional {label ""} {html {size 60}}}
    {community_name:text,optional {label ""} {html {size 60}}}
    {instructors:text(textarea),optional {label ""} {html {cols 60}}}
    {date:text,optional {label ""} {html {size 30}}}
    {description_label:text,optional {label ""} {html {size 30}}}
    {course_description:text(textarea),optional {label ""} {html {cols 60}}}
    {signature_1:text(textarea),optional {label ""} {html {cols 30}}}
    {signature_2:text(textarea),optional {label ""} {html {cols 30}}}
    {signature_3:text(textarea),optional {label ""} {html {cols 30}}}
    {signature_4:text(textarea),optional {label ""} {html {cols 30}}}
    {signature_5:text(textarea),optional {label ""} {html {cols 30}}}
    {signature_6:text(textarea),optional {label ""} {html {cols 30}}}
    {continuing_ed_credit_info:text(textarea) {label ""} {html {cols 70 rows 6}}}
} -on_request {
    set image_id [db_string get_image_info "select item_id from cr_items where parent_id=:package_id" -default ""]
    if {$image_id ne ""} {
	set image_info "<img src='../image/${image_id}' alt='Certificate logo image' height='200'/>"
    } else {
	set image_info "No current logo image"
    }

    set certificate [_ attendance.CERTIFICATE_OF_ATTENDANCE]
    set this_certifies [_ attendance.This_certifies_that]
    set attended [_ attendance.Attended]
    set date [_ attendance.Date]
    set description_label [_ attendance.Description]
    set continuing_ed_credit_info [_ attendance.Continuting_Education_Credit_Information]

    set community_name [dotlrn_community::get_community_name $community_id]
    set course_description [dotlrn_community::get_community_description -community_id $community_id]
    set instructors [dotlrn_ecommerce::section::instructors $community_id ""]
    
} -on_submit {
    # setup new image if uploaded
    set image_id [db_string get_image_info "select item_id from cr_items where parent_id=:package_id" -default ""]	
    if {[info exists image_file] \
	    && [set tmp_filename [template::util::file::get_property tmp_filename $image_file]] ne ""} {
	set filename [template::util::file::get_property filename $image_file]
	if {$image_id ne ""} {
	    set image_revision_id \
	    [cr_import_content \
		 -storage_type file \
		 -image_only \
		 -title $filename \
		 -package_id $package_id \
		 -item_id $image_id \
		 $package_id \
		 $tmp_filename \
		 [file size $tmp_filename] \
		 [template::util::file::get_property mime_type $image_file] \
				   $filename]
	} else {
	    set image_revision_id \
	    [cr_import_content \
		 -storage_type file \
		 -image_only \
		 -title $filename \
		 -package_id $package_id \
		 $package_id \
		 $tmp_filename \
		 [file size $tmp_filename] \
		 [template::util::file::get_property mime_type $image_file] \
				   $filename]
	}
	content::item::set_live_revision -revision_id $image_revision_id
	if {$image_id eq ""} {
	    set image_id [content::revision::item_id -revision_id $image_revision_id]
	}
    }

    if {[info exists use_sw_submit] && $use_sw_submit ne ""} {
	if {$image_id eq ""} {
	    set image_id [content::item::new \
			      -name [ns_mktemp XXXXXX] \
			      -parent_id $package_id \
			      -content_type "image"]
	}
	set image_id [content::revision::copy \
			  -revision_id [content::item::get_latest_revision \
					    -item_id \
					    [content::item::get_id \
						 -item_path "__attendance_default_logo_image" \
						 -root_folder_id [dotlrn::get_package_id]]] \
			  -target_item_id $image_id]
	content::item::set_live_revision -revision_id [content::item::get_latest_revision -item_id $image_id]
	
	ad_returnredirect -message "Using site wide default" [export_vars -base "certificates" {user_id community_id certificate certifies_that attended description_label course_description community_name instructors signature_1 signature_2 signature_3 signature_4 signature_5 signature_6 continuting_ed_credit_info}]
    }

    if {[info exists set_sw_submit] && $set_sw_submit ne ""} {
	# handle site-wide-image button
	# check permissions
	permission::require_permission \
	    -object_id [acs_magic_object "security_context_root"] \
	    -party_id [ad_conn user_id] \
	    -privilege "admin"
	if {$image_id ne ""} {
	    # can't use content::item::copy it only allows folder parents
	    if {[set site_wide_image_id [content::item::get_id \
					     -item_path "__attendance_default_logo_image" \
					     -root_folder_id [dotlrn::get_package_id]]] eq ""} {
		
		
		set site_wide_image_id \
		    [content::item::new \
			 -name "__attendance_default_logo_image" \
			 -parent_id [dotlrn::get_package_id] \
			 -content_type image]
	    }
	    content::revision::copy \
		-revision_id [content::item::get_live_revision \
		     -item_id $image_id] \
		-target_item_id $site_wide_image_id 
	    content::item::set_live_revision -revision_id [content::item::get_live_revision -item_id $site_wide_image_id]
	}
	ad_returnredirect -message "Using site wide default" [export_vars -base "certificates" {user_id community_id certificate certifies_that attended description_label course_description community_name instructors signature_1 signature_2 signature_3 signature_4 signature_5 signature_6 continuting_ed_credit_info}]

    }

    set user_id [split $user_id]
    template::multirow create users name
    foreach user $user_id {
	acs_user::get -user_id $user -array user_array
	template::multirow append users $user_array(name)
    }

    set vars [list community_name $community_name course_description $course_description instructors $instructors &users users certificate $certificate this_certifies $this_certifies attended $attended date $date description_label $description_label continuing_ed_credit_info $continuing_ed_credit_info]

    if {$image_id ne ""} {
	set image_cr_file_path [cr_fs_path][db_string get_path "select content from cr_revisions cr, cr_items ci where ci.item_id=:image_id and ci.live_revision=cr.revision_id" -default ""]
	if {[file exists $image_cr_file_path]} {
	    lappend vars image_cr_file_path $image_cr_file_path
	}
    }

    foreach i {1 2 3 4 5 6} {
	set signature_${i} [string map {"&" "&amp;" "<" "&lt;" ">" "&gt;" "\n" {</para><para  style="sigData">}} [set signature_${i}]]
	lappend vars signature_${i} [set signature_${i}]
    }
    
    set rml [template::adp_include /packages/attendance/lib/attendance-portrait $vars]
    
    set rml_tmpname [ns_mktemp /var/tmp/attendance_rml_XXXXXX]
    set fd [open $rml_tmpname w]
    puts $fd $rml
    close $fd
    set pdf_tmpname [ns_mktemp /var/tmp/attendance_pdf_XXXXXX].pdf
    if {[catch {exec [acs_root_dir]/packages/attendance/bin/trml2pdf/trml2pdf/trml2pdf.py ${rml_tmpname} >> $pdf_tmpname} errmsg]} {
	
	ad_return_complaint 1 "$errmsg"
	
    }
    ns_set put [ad_conn outputheaders] content-disposition "attachment; filename=certificates-[util_text_to_url -text ${community_name}]-[clock format [clock seconds] -format "%Y%m%d-%H%M"].pdf"
    ns_returnfile 200 application/pdf $pdf_tmpname
    file delete $rml_tmpname
    file delete $pdf_tmpname
    ad_script_abort
}

ad_return_template