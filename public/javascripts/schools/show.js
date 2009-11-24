jQuery(function(){
	jQuery("#school_tabs").tabs();
    jQuery("#school_tabs li");
	
    jQuery("#invite_student_dialog").dialog({
        autoOpen: false
    });
    jQuery("#invite_student_link").click(inviteStudent);
    jQuery('#new_student').ajaxForm({
        success: handleResponse,
        error: handleError
    });
});

function inviteStudent(){
    page = jQuery("#invite_student_dialog");
    jQuery('#new_student').resetForm();
    page.dialog('open');
	return false;
}

function handleResponse(data, textStatus){
    jQuery('#new_student').resetForm();
    page = jQuery("#invite_student_dialog");
    page.dialog('close');
    jQuery('#notice').html(data);
}

function handleError(request, textStatus, errorThrown){
    jQuery('#invite_student_dialog').html(request.responseText);
    jQuery('#new_student').ajaxForm({
        success: handleResponse,
        error: handleError
    });
}


