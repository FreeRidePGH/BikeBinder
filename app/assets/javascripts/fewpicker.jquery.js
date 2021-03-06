// Few Picker version 0.1 GPL3 license
(function( $ ){

     var methods = {
	 init : function( options ) { 
	     
	     // Create some defaults, extending them with any options that were provided

	     var settings = $.extend( {
					  input: this,
					  colorsArray : 
					  [
					   'White', 
					   'Silver', 
					   'Gray ',
					   'Black', 
					   'Red', 
					   'Brown', 
					   'Tan',
					   'Maroon', 
					   'Yellow', 
					   'Gold', 
					   'Orange',
					   'Olive',
					   'DarkGreen',
					   'Green', 
					   'LightGreen', 
					   'Teal', 
					   'Blue', 
					   'LightBlue', 
					   'Navy',
					   'Pink', 
					   'Purple', 
					   ]
				      }, options );

	     // create and add table to DOM
	     // hide the picker initially
	     var tableMarkup = $(methods.createColorTable(settings.colorsArray)).hide(),
	     swatch =   '<div data-picker="swatch" ></div>',
	     coords = this.position();
	     
	     this.after(swatch);
	     $('div[data-picker="swatch"]').css({
					      'left': (coords.left + this.width()),
					      'top' : coords.top
					  });
	     this.after(tableMarkup);

	     var DomTableElement = this.next('table[data-picker]');
	   $('table[data-picker]').css(
	     {'left' : coords.left,
	      'top' : coords.top+30});
	     if (this.val()) {
		 var values = this.val().split(',');
		 this.siblings('[data-picker="swatch"]').css('backgroundColor', values[0]);

	     }
	     // add color clicking power
	     methods.registerClickHandlers(DomTableElement, this);
	     // conditionally show the picker
	     var showPicker = function(e){DomTableElement.show()};
	     this.focusin(showPicker);
	     this.click(showPicker);

	     // conditinally hide the picker
	     var hidePicker = function(e){DomTableElement.hide();}
	     this.dblclick(hidePicker);
	     $(document).keyup(function(e){
		     if(e.keyCode==27){DomTableElement.hide();} //esc
		 });

	 },
	 createColorTable : function(colorsArray) {
	     var length = colorsArray.length,
	     i,
	     rowsCount = Math.round(length/5),
	     tableBody = '', 
	     cells = '', 
	     row,
	     tableOuter;

	     for (i = 0; i<length; i++) {
	       var td = document.createElement('td'),
	       label = document.createElement('p'),
	       colorCircle = document.createElement('span');
	       
	       colorCircle.style.backgroundColor = colorsArray[i];
	       colorCircle.className = 'circleShadow';
	       td.dataset.color = colorsArray[i];
	       label.innerHTML = colorsArray[i];
	       td.innerHTML = colorCircle.outerHTML + label.outerHTML;
		 // outer html apparently is not supported inFF. I think it is only setting, not getting
	       cells+= td.outerHTML;
		 // when colorsArray length %10 has leftovers final case gets cut off, hence extra test condition
		 // add 1 to compensate for 0 index
		 if ( (i+1)%5 == 0 || (i+1) == length) {
		     row = "<tr>"+cells+"</tr>";
		     tableBody+= row;
		     cells = '';
		 }
	     }
	     tableOuter =  '<table  data-picker="true" id="color-grid">';
	     tableOuter+=    '<thead>';
	     tableOuter+=    '<th></th><th></th><th></th><th></th><th><i class="icon-remove"></i>close</th>';
	     tableOuter+=    '</thead>';
	     tableOuter+=    '<tbody>';
	     tableOuter+= tableBody;
	     tableOuter+=    '</tbody>';
	     tableOuter+=    '</table>';


	     return tableOuter;

	 },
	 registerClickHandlers : function(DomTableElement, input) { 
	     DomTableElement = DomTableElement || this.next('table[data-picker]');
	     // namespace click event
	     DomTableElement.on('click.fewPicker', 'td',  function(event) {
				    var currentCol = $(this).attr('data-color');
				    input.val(currentCol);
				 input.siblings('div[data-picker="swatch"]').css('backgroundColor', currentCol);
				 if (DomTableElement.length == 1) {
				     DomTableElement.hide();
				 }

			     });
	     // click event to close
	     DomTableElement.on('click.fewPicker', 'th', function(e){DomTableElement.hide()});
	 }
     };

     $.fn.fewPicker = function(method) {    
	 // Method calling logic
	 if ( methods[method] ) {
	     return methods[ method ].apply( this, Array.prototype.slice.call( arguments, 1 ));
	 } else if ( typeof method === 'object' || ! method ) {
	     return methods.init.apply( this, arguments );
	 } else {
	     $.error( 'Method ' +  method + ' does not exist on jQuery.fewPicker' );
	 }    
	 
	 // method madness

	 // there's no need to do $(this) because
	 // "this" is already a jquery object

	 // $(this) would be the same as $($('#element'));
         
	 //    this.fadeIn('normal', function(){

	 // the this keyword is a DOM element

	 //  });

     };
 })( jQuery );