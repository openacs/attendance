ad_library {

    Attendance Package APM callbacks library
    
    Procedures that deal with installing, instantiating, mounting.

    @creation-date May 2005
    @author Hamilton Chua (hamilton.chua@gmail.com))
    @cvs-id $Id$
}

namespace eval attendance {}
namespace eval attendance::apm_callback {}

ad_proc -public attendance::apm_callback::package_instantiate { 
    -package_id:required
} {

    Define Attendance folders

} {

    set creation_user [ad_conn user_id]
    set creation_ip [ad_conn peeraddr]
    set attendance_name "Attendance"
    set attendance_singular_name "Attendance"
    set attendance_desc ""


    db_transaction {

		set folder_id [content::folder::new -name "evaluation_grades_$package_id" -label "evaluation_grades_$package_id" -package_id $package_id ]
		content::folder::register_content_type -folder_id $folder_id -content_type evaluation_grades -include_subtypes t

		set folder_id [content::folder::new -name "evaluation_tasks_$package_id" -label "evaluation_tasks_$package_id" -package_id $package_id ]
		content::folder::register_content_type -folder_id $folder_id -content_type evaluation_tasks -include_subtypes t
    }

    set attendance_item_id [db_nextval acs_object_id_seq]
    set revision_id [evaluation::new_grade -new_item_p 1 -item_id $attendance_item_id -content_type evaluation_grades -content_table evaluation_grades -content_id grade_id -name $attendance_singular_name -plural_name $attendance_name -description $attendance_desc -weight 40 -package_id $package_id]
    content::item::set_live_revision -revision_id $revision_id

}