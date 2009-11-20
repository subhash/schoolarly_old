function inviteStudent(){
    page = jQuery("#invite_student_dialog");
    jQuery('#new_student').resetForm();
    page.dialog('open');
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

jQuery(function(){
    page = jQuery("#invite_student_dialog");
    page.dialog({
        autoOpen: false
    });
    jQuery('#new_student').ajaxForm({
        success: handleResponse,
        error: handleError
    });
});


