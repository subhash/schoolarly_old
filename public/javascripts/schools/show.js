function inviteStudent(){
    page = jQuery("#invite_student_dialog");
	jQuery('#new_student').clearForm();
    page.dialog('open');
}

function handleResponse(responseText, statusText){
    alert("Thank you for your form!");	
//    page = jQuery("#invite_student_dialog");
//    page.dialog('close');
}

function validate(formData, jqForm, options){
	return true;
}

jQuery(function(){
    page = jQuery("#invite_student_dialog");
    page.dialog({
        autoOpen: false
    });
    jQuery('#new_student').ajaxForm({
        beforeSubmit: validate,
		target: '#new_student',
        success: handleResponse
    });
});


