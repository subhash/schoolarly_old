jQuery(function(){
	jQuery("#school_tabs").tabs();
    jQuery("#school_tabs li");
    jQuery('#new_student').ajaxForm({
        success: handleResponse,
        error: handleError
    });
});

function handleResponse(data, textStatus){
	alert(data);
    jQuery('#new_student').resetForm();
    page = jQuery("#invite-student-dialog");
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


