function inviteStudent(){
    page = jQuery("#invite_student_dialog");
    page.dialog('open');
}

jQuery(function(){
    page = jQuery("#invite_student_dialog");
    page.dialog({
        autoOpen: false
    });
    jQuery('#invite_students_form').ajaxForm(function(){
        alert("Thank you for your form!");
		page = jQuery("#invite_student_dialog");
		page.dialog('close');				
    });
});


