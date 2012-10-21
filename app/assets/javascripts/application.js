// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require handlebars-1.0.rc.1.js
//= require bootstrap.min
//= require jquery.purr
//= require best_in_place


/*jQuery.ajaxSetup({ 
  beforeSend: function(xhr) {
  	xhr.setRequestHeader("Accept", "text/javascript")
  }
});*/

jQuery.fn.submitWithAjax = function() {
  this.submit(function() {
    $.post($(this).attr("action"), $(this).serialize(), null, "script");
    return false;
  })
};
//functions 
jQuery.fn.insertTemplateAjax = function(path, dataobject, insert_method){
    var o = $(this[0]);
    var source;
    var template;

    $.ajax({
        url: path, //ex. /assets/templates/mytemplate.handlebars
        cache: true,
        success: function(data) {
            source    = data
            template  = Handlebars.compile(source);
            console.log(dataobject);

            switch(insert_method){
              case "append":
              case "behind":
              case "after":
              case "concat":
              case "a":
                if(dataobject != null)
                  o.append(template(dataobject));
                else
                  o.append(template);
                break;
              case "before":
              case "front":
              case "b":
                if(dataobject != null)
                  o.before(template(dataobject));
                else
                  o.before(template);
                break;
              case "ow":
              case "over":
              case "overwrite":
              case "replace":
                if(dataobject != null)
                  o.replaceWith(template(dataobject));
                else
                  o.replaceWith(template);
                break;
              case "insert":
              default: 
                if(dataobject != null)
                  o.html(template(dataobject));
                else
                  o.html(template);
                break;
            }
              
        }               
    });         
};