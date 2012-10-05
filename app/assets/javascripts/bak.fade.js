
$(document).ready(function(){  
  
   //Adjust height of overlay to fill screen when page loads  
   $("#fuzz").css("height", $(document).height());  
  
   //When the link that triggers the message is clicked fade in overlay/msgbox  
   $(".alert").click(function(){ 
      $('#msgbawx').load('/users/new') 
      $("#fuzz").fadeIn();  
      return false;  
   });  
  
   //When the message box is closed, fade out  
   $(".close").click(function(){  
      $("#fuzz").fadeOut();  
      return false;  
   });
   
   //Fade signin box on
   $(".signin").click(function(){  
      $("#sid").fadeIn();  
      return false;  
   });  

   
  $(".listneed").click(function(){  
      $("#fuzz").fadeIn();  
      return false;  
   });  

  $(".initiate_exchange").click(function(){  
      var listing_id = $this.attr('href');
      $('#msgbawx').load('/users/initiate_exchange/')
      $("#fuzz").fadeIn();  
      return false;  
   });  

   //fade out signin box


   //When Clicked outside of message box, close Box    
  $(document).mouseup(function (e){
    var container = $("#fuzz");

    if (container.has(e.target).length === 0)
    {
        container.fadeOut();
    }
});
});  
  
//Adjust height of overlay to fill screen when browser gets resized  
$(window).bind("resize", function(){  
   $("#fuzz").css("height", $(window).height());  
});  