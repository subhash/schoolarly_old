function inviteStudent(){
    page = jQuery("#invite_student_dialog");
    page.dialog('open');
}

jQuery(function(){
    page = jQuery("#invite_student_dialog");
    page.dialog({
        autoOpen: false
    });
    jQuery('#new_student').ajaxForm(function(responseText, statusText){
        alert("Thank you for your form!");
		page = jQuery("#invite_student_dialog");
		page.dialog('close');				
    });
});


