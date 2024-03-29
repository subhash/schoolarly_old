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
    jQuery('div.tab').hide(); // Hide all divs
    jQuery('div.tab-header').hide();
    jQuery('a.tab-link').click(function(){ // When link is clicked
        jQuery('a.tab-link').removeClass('current'); // Remove active class from links
        jQuery(this).addClass('current'); //Set parent of clicked link class to active
        var currentTab = jQuery(this).attr('href') + '-section'; // Set currentTab to value of href attribute
        jQuery('div.tab').hide(); // Hide all divs
        jQuery('div.tab-header').hide();
        jQuery(currentTab).show(); // Show div with id equal to variable currentTab
        jQuery(currentTab + '-header').show();
        jQuery('#calendar').fullCalendar('render');
		jQuery('#class-calendar').fullCalendar('render');
		jQuery('#school-calendar').fullCalendar('render');
        return true;
    });
    jQuery('a.tab-link:first').click();
});

jQuery(document).ready(function(){
    var tab = window.location.hash;
    if (tab) 
        jQuery(tab + '-link').click();
    initPanes();
});

function refetchEvents(){
	jQuery('#calendar').fullCalendar( 'refetchEvents' );
	jQuery('#school-calendar').fullCalendar( 'refetchEvents' );
	jQuery('#class-calendar').fullCalendar( 'refetchEvents' );
}
function initMultiSelect(){
    jQuery(".multiselect").multiselect({
        sortable: false
    });
}

//function initDateTimePicker(){
//    jQuery('.datetimepicker').datetimepicker({
//        ampm: true,
//        dateFormat: 'M dd, yy'
//    });
//}

function initPanes(){
    jQuery('div.pane').hide();
    jQuery('a.pane-link').click(function(){
        jQuery('a.pane-link').removeClass('active');
        jQuery(this).addClass('active');
        var currentPane = jQuery(this).attr('href');
        jQuery('div.pane').hide();
        jQuery(currentPane).show();
        return false;
    });
    jQuery('a.pane-link:first').click();
}

function refreshPanes(){
	if (jQuery('div.pane').length == 0)
		return;
    jQuery('div.pane').hide();
    var currentPane = jQuery('a.pane-link.active').attr('href');
    jQuery(currentPane).show();
}

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


function openModalbox(html, t, height){
    if (height) {
        Modalbox.show(html, {
            title: t,
            slideDownDuration: .10,
            slideUpDuration: .10,
            overlayDuration: .25,
            overlayOpacity: .50,
            overlayClose: false,
            height: height,
            afterLoad: function(){
                initMultiSelect();
            }
        });
    }
    else {
        Modalbox.show(html, {
            title: t,
            slideDownDuration: .10,
            slideUpDuration: .10,
            overlayDuration: .25,
            overlayOpacity: .50,
            overlayClose: false,
            afterLoad: function(){
                initMultiSelect();
            }
        });
    }
}

function refreshModalbox(html, t, height){
    if (height && t) {
        Modalbox.show(html, {
            title: t,
            height: height,
            afterLoad: function(){
                initMultiSelect();
            }
        });
    }
    else 
        if (height) {
            Modalbox.show(html, {
                height: height,
                afterLoad: function(){
                    initMultiSelect();
                }
            });
        }
        else {
            Modalbox.show(html, {
                afterLoad: function(){
                    initMultiSelect();
                }
            });
        }
}

function closeModalbox(){
    Modalbox.hide();
}

function openTab(tab){
    jQuery('#' + tab + '-tab-link').click();
}

function closeDialogs(){
    //    jQuery(".jquery-dialog.open-dialog").dialog('close');
    //    $$(".jquery-dialog form").each(function(element){
    //        element.reset();
    //    });
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

function scoreCheck(value, colname){
    switch (value) {
        case 'N':
		case 'n':
        case 'A':
		case 'a':
		case '':
            return [true, ""];		
    }
    maxValue = colname.substring(colname.indexOf('(') + 1, colname.indexOf(')'));
	value = parseFloat(value);
    if (value >= 0 && value <= maxValue) 
        return [true, ""];
    else 
        return [false, "Please enter value between 0 and "+maxValue];
}


function hideShowDivs(hide_id, show_id){
    jQuery(hide_id).hide();
    jQuery(show_id).show();
}

(function($){
    $.extend($.ui.multiselect, {
        locale: {
            addAll: 'Add all',
            removeAll: 'Remove all',
            itemsCount: 'selected'
        }
    });
})(jQuery);


