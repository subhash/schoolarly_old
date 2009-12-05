// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

jQuery.noConflict();

jQuery(function(){
    jQuery(".jquery-dialog").dialog({
        autoOpen: false
    });
    jQuery(".jquery-dialog").bind('dialogclose', function(event, ui){
        jQuery(this).removeClass("open-dialog")
    });
    jQuery(".tabs").tabs();
    jQuery(".tablesorter").tablesorter({
        sortList: [[0, 0]]
    });
    jQuery(".selectable").selectable({
        filter: '.selectFilter'
    });
    
});

function openDialog(id){
    jQuery("#" + id).dialog('open');
    jQuery("#" + id).addClass("open-dialog")
}

function closeDialogs(){
    $$(".jquery-dialog form").each(function(element){
        element.reset();
    });
    jQuery(".jquery-dialog.open-dialog").dialog('close');
}

function hideShowDivs(hide_id, show_id){
    jQuery(hide_id).hide();
    jQuery(show_id).show();
}



