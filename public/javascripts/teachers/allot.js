	function readySelectable(subject_id){
		div_id = subject_id + "-klasses_selectable";
        jQuery(div_id ).bind('selectablestop', function(event, ui){
            klass_indices = "";
            jQuery(div_id + " " + 'td.ui-selected').each(function(i){
                id = this.id;
                klass_indices += "," + id;
            });
        });
}

	function showKlasses(subject_id){
		hideShowDivs("#klasses .klass-div", "#" + subject_id + "-klasses");
		readySelectable("#" + subject_id);
	}
	
