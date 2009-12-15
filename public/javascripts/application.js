// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

jQuery.noConflict();

jQuery(function(){
    bindDialogs();
    jQuery(".tabs").tabs();
    jQuery(".tablesorter").tablesorter({
        sortList: [[0, 0]]
    });
    jQuery(".selectable").selectable({
        filter: '.selectFilter'
    });
    jQuery("#accordion").accordion({
        autoHeight: false,
        active: "#activate_this"
    });
    jQuery('.accordion .head').click(function(){
        this.next().toggle();
        return false;
    }).next().hide();
    
});

function bindDialogs(){
    jQuery(".jquery-dialog").dialog({
        autoOpen: false
    });
    jQuery(".jquery-dialog").bind('dialogclose', function(event, ui){
        jQuery(this).removeClass("open-dialog")
    });
}

function bindDialog(id){
    jQuery("#" + id).addClass("jquery-dialog")
    jQuery("#" + id).dialog({
        autoOpen: false
    });
    
    jQuery("#" + id).bind('dialogclose', function(event, ui){
        jQuery(this).removeClass("open-dialog")
    });
}

function openDialog(id){
    jQuery("#" + id).dialog('open');
    jQuery("#" + id).addClass("open-dialog")
}

function closeDialogs(){
    jQuery(".jquery-dialog.open-dialog").dialog('close');
    $$(".jquery-dialog form").each(function(element){
        element.reset();
    });
}

function hideShowDivs(hide_id, show_id){
    jQuery(hide_id).hide();
    jQuery(show_id).show();
}



