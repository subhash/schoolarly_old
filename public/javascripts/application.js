// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

jQuery.noConflict();

jQuery(function(){
    jQuery(".jquery-dialog").dialog({
        autoOpen: false
    });
});

function openDialog(id){
    jQuery("#" + id).dialog('open');
	jQuery("#" + id).addClass("open-dialog")
}
