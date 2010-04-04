// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults


/**
 *
 * Added here to avoid InvalidAuthenticityToken error - refer to
 * http://henrik.nyh.se/2008/05/rails-authenticity-token-with-jquery
 *
 */
jQuery(document).ajaxSend(function(event, request, settings){
    if (typeof(AUTH_TOKEN) == "undefined") 
        return;
    // settings.data is a serialized string like "foo=bar&baz=boink" (or null)
    settings.data = settings.data || "";
    settings.data += (settings.data ? "&" : "") + "authenticity_token=" + encodeURIComponent(AUTH_TOKEN);
});


jQuery.noConflict();

jQuery(function(){
    bindDialogs();
    jQuery(".tabs").tabs();
    jQuery(".selectable").selectable({
        filter: '.selectFilter'
    });
    jQuery(".accordion").accordion({
        autoHeight: false,
        active: "#activate_this"
    });
    jQuery('.accordion .head').click(function(){
        this.next().toggle();
        return false;
    }).next().hide();
    
});

// Bind tabs
jQuery(document).ready(function(){
    jQuery('.tab-box div').hide(); // Hide all divs
    jQuery('.tab-box div:first').show(); // Show the first div
    jQuery('.tab-box ul li:first').addClass('active'); // Set the class for active state
    jQuery('.tab-box ul li a').click(function(){ // When link is clicked
        jQuery('.tab-box ul li').removeClass('active'); // Remove active class from links
        jQuery(this).parent().addClass('active'); //Set parent of clicked link class to active
        var currentTab = jQuery(this).attr('href'); // Set currentTab to value of href attribute
        jQuery('.tab-box div').hide(); // Hide all divs
        jQuery(currentTab).show(); // Show div with id equal to variable currentTab
        return false;
    });
});

function showTab(id){
    jQuery('#myhack ul li').removeClass('active');
    jQuery(this).parent().addClass('active');
    jQuery('#myhack div').hide();
    jQuery(id).show();
}

function bindDialogs(){
    jQuery(".jquery-dialog").dialog({
        autoOpen: false
    });
    jQuery(".jquery-dialog").bind('dialogclose', function(event, ui){
        jQuery(this).removeClass("open-dialog")
    });
}

function bindAccordion(){
    jQuery(".accordion").accordion({
        autoHeight: false,
        active: "#activate_this"
    });
    jQuery('.accordion .head').click(function(){
        this.next().toggle();
        return false;
    }).next().hide();
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
    //    jQuery("#" + id).dialog('open');
    jQuery("#" + id).addClass("open-dialog")
	t='Schoolarly'
    Modalbox.show($(id), { title: t, slideDownDuration: .10, slideUpDuration: .10, overlayDuration: .25 });
}

function openModalbox(html, t){
	Modalbox.show(html, { title: t, slideDownDuration: .10, slideUpDuration: .10, overlayDuration: .25 });
}

function refreshModalbox(html){
	Modalbox.show(html);
}

function closeDialogs(){
    //    jQuery(".jquery-dialog.open-dialog").dialog('close');
    //    $$(".jquery-dialog form").each(function(element){
    //        element.reset();
    //    });
    Modalbox.hide();
}

function closeModalbox(){
	Modalbox.hide();
}

function collectSelectedIndices(selectable, field){
    jQuery("#" + selectable).bind('selectablestop', function(event, ui){
        subject_indices = "";
        jQuery("#" + selectable + " .selectFilter.ui-selected").each(function(i){
            id = this.id;
            subject_indices += id + ",";
            jQuery("#" + field).val(subject_indices)
        });
    });
}

function hideShowDivs(hide_id, show_id){
    jQuery(hide_id).hide();
    jQuery(show_id).show();
}

