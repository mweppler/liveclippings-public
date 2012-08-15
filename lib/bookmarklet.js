(function () {
  function clipit(pubpriv){
    var d=document, z=d.createElement('script'), b=d.body, l=d.location, tt='';
    try{
      if(!b)
        throw(0);
      tt = d.title;
      d.title='(Saving...) '+d.title;
      z.setAttribute('src',l.protocol+'//yoursite.com/clipping/create?content_type=html&public='+pubpriv+'&url='+encodeURIComponent(l.href));
      b.appendChild(z);
      d.title = tt;
      return 0;
    } catch(e) {
      alert('The page has not loaded. Please try again in a moment.');
    }
  }
  function getScript(url, success) {
    var script = document.createElement('script');
    script.src = url;
    var head = document.getElementsByTagName('head')[0];
    var completed = false;
    script.onload = script.onreadystatechange = function () {
      if (!completed && (!this.readyState || this.readyState == 'loaded' || this.readyState == 'complete')) {
        completed = true;
        success();
        script.onload = script.onreadystatechange = null;
        head.removeChild(script);
      }
    };
    head.appendChild(script);
  }
  function getStylesheet(url) {
    var stylesheet = document.createElement('link');
    stylesheet.href = url;
    stylesheet.rel = 'stylesheet'
    stylesheet.type = 'text/css'
    var head = document.getElementsByTagName('head')[0];
    head.appendChild(stylesheet);
  }
  getScript('http://ajax.googleapis.com/ajax/libs/jquery/1.6.2/jquery.min.js', function () {
    getScript('http://ajax.googleapis.com/ajax/libs/jqueryui/1.7.2/jquery-ui.min.js', function () {
      getStylesheet('http://ajax.googleapis.com/ajax/libs/jqueryui/1.7.2/themes/smoothness/jquery-ui.css');
      var $dialog = $('<div></div>').dialog({
        autoOpen: false,
        buttons: {
          'Yes': function() {
            clipit(1);
            $(this).dialog('close');
          },
          'No': function() {
            clipit(0);
            $(this).dialog('close');
          }
        },
        height: 'auto',
        modal: true,
        title: 'Would you like to make this url public?',
        width: 'auto'
      });
      $dialog.html(document.location.href);
      $dialog.dialog('open');
    });
  });
})();
