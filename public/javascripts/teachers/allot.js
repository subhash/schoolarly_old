	function readySelectable(div_id){
        jQuery("#" + div_id ).bind('selectablestop', function(event, ui){
            klass_indices = "";
            jQuery("#" + div_id + " " + 'td.ui-selected').each(function(i){
                id = this.id;
                klass_indices += "," + id;
            });
        });		
}


