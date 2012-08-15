/* Author: @mattweppler

*/

// delay function: http://stackoverflow.com/questions/1909441/jquery-keyup-delay
var delay = (function(){
  var timer = 0;
  return function(callback, ms){
    clearTimeout (timer);
    timer = setTimeout(callback, ms);
  };
})();

// clipping new/create from 
$(document).ready(function() {
  if (document.location.pathname == '/clipping/new' || document.location.pathname == '/clipping/create') {
    function displayFormFields(array, display) {
      $.each($('tr'), function() {
        if (array.indexOf($(this).find('label').attr('for')) != -1) {
          $(this).css('display', display == 'show' ? '' : 'none');
        } else {
          $(this).css('display', display == 'show' ? 'none' : '');
        }
      });
    }
    displayFormFields(['content_type'], 'show');
    $('input[name=content_type]').bind('change', function() {
      if ($(this).val() === 'html') {
        displayFormFields(['title','summary','content'], 'hide');
      } else {
        displayFormFields(['url'], 'hide');
      }
    });
  }
});

// delete following relationship
$(document).ready(function() {
  if (document.location.pathname == '/followings') {
    var $relationship;
    var $dialog = $('<div></div>')
  		.html('Are you sure you want to delete this relationship?')
  		.dialog({
  			autoOpen: false,
  			buttons: {
  			  'yes': function() {
  			    window.location.href = $relationship;
  			  },
  			  'no': function() {
  			    $(this).dialog('close');
  			  }
  			},
  			modal: true,
  			title: 'Delete Relationship?'
  		});
  	$('.polaroid-small').click(function(e) {
  		e.preventDefault();
  	  $relationship = $('a', this).attr('href');
  		$dialog.dialog('open');
  	});
  }
});

/**
 * Form text box hints.
 * http://blog.amnuts.com/2009/02/17/text-box-hint-values-with-jquery/
 *
 * This plug-in will allow you to set a 'hint' on a text box or
 * textarea.  The hint will only display when there is no value
 * that the user has typed in, or that is default in the form.
 *
 * You can define the hint value, either as an option passed to
 * the plug-in or by altering the default values.  You can also
 * set the hint class name in the same way.
 *
 * Examples of use:
 *
 *     $('form *').textboxhint();
 *
 *     $('.date').textboxhint({
 *         hint: 'YYYY-MM-DD'
 *     });
 *
 *     $.fn.textboxhint.defaults.hint = 'Enter some text';
 *     $('textarea').textboxhint({ classname: 'blurred' });
 *
 * @copyright Copyright (c) 2009,
 *            Andrew Collington, andy@amnuts.com
 * @license New BSD License
 */
(function($) {
  $.fn.textboxhint = function(userOptions) {
      var options = $.extend({}, $.fn.textboxhint.defaults, userOptions);
      return $(this).filter(':text,textarea').each(function(){
      if ($(this).val() == '') {
        $(this).focus(function(){
          if ($(this).attr('typedValue') == '') {
            $(this).removeClass(options.classname).val('');
          }
        }).blur(function(){
          $(this).attr('typedValue', $(this).val());
          if ($(this).val() == '') {
            $(this).addClass(options.classname).val(options.hint);
          }
        }).blur();
      }
    });
  };
  $.fn.textboxhint.defaults = {
    hint: 'Please enter a value',
    classname: 'hint-text'
  };
})(jQuery);

$("#clippings-search-textbox").textboxhint({hint:'live search...',classname:'hint-text'});

// clippings live search
$('#clippings-search-textbox').keypress(function(event) {
  if(event.keyCode==13){
    event.preventDefault();
  }
});
$("#clippings-search-textbox").bind("keyup", function() {
  $("#clippings-search-loader").addClass("orange-loader");
  delay(function(){
    var form = $("#clippings-search-form");
    var url = form.attr("action");
    var formData = form.serialize();
    $.get(url, formData, function(html) {
      $("#clippings-search-loader").removeClass("orange-loader");
      $("#clippings-list").html(html);
    });
  }, 1000 );
});


