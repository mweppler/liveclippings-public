/* Author: @mattweppler

*/

var delay=function(){var a=0;return function(b,c){clearTimeout(a),a=setTimeout(b,c)}}()
// commpress js...
var pageInformation = function() {
    var url = location.href;
    var paths = url.split('/');
    // Remove any empty elements from paths array
    for(i=0;i<paths.length;i++)paths[i]==''&&(paths.splice(i,1),--i);
    // 0 = protocol, 1 = domain, 2 = controller, 3 = action, 4 = id
    return paths;
}

// clipping new/create from 
$(document).ready(function(){if(document.location.pathname=="/clipping/new"||document.location.pathname=="/clipping/create"){function a(a,b){$.each($("tr"),function(){a.indexOf($(this).find("label").attr("for"))!=-1?$(this).css("display",b=="show"?"":"none"):$(this).css("display",b=="show"?"none":"")})}a(["content_type"],"show"),$("input[name=content_type]").bind("change",function(){$(this).val()==="html"?a(["title","summary","content"],"hide"):a(["url"],"hide")})}});

// delete following relationship
$(document).ready(function(){if(document.location.pathname=="/followings"){var a,b=$("<div></div>").html("Are you sure you want to delete this relationship?").dialog({autoOpen:!1,buttons:{yes:function(){window.location.href=a},no:function(){$(this).dialog("close")}},modal:!0,title:"Delete Relationship?"});$(".polaroid-small").click(function(c){c.preventDefault(),a=$("a",this).attr("href"),b.dialog("open")})}});

// form text box hints.
(function(a){a.fn.textboxhint=function(b){var c=a.extend({},a.fn.textboxhint.defaults,b);return a(this).filter(":text,textarea").each(function(){a(this).val()==""&&a(this).focus(function(){a(this).attr("typedValue")==""&&a(this).removeClass(c.classname).val("")}).blur(function(){a(this).attr("typedValue",a(this).val()),a(this).val()==""&&a(this).addClass(c.classname).val(c.hint)}).blur()})},a.fn.textboxhint.defaults={hint:"Please enter a value",classname:"hint-text"}})(jQuery);

$("#clippings-search-textbox").textboxhint({hint:'live search...',classname:'hint-text'});

// clippings live search
$("#clippings-search-textbox").keypress(function(a){a.keyCode==13&&a.preventDefault()}),$("#clippings-search-textbox").bind("keyup",function(){$("#clippings-search-loader").addClass("orange-loader"),delay(function(){var a=$("#clippings-search-form"),b=a.attr("action"),c=a.serialize();$.get(b,c,function(a){$("#clippings-search-loader").removeClass("orange-loader"),$("#clippings-list").html(a)})},1e3)});
