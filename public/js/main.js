;( function( window, $ ){
  
  document.write( '<link type="text/css" rel="stylesheet" media="screen" href="http://www.talkpl.us/css/main.css">' );
  
  
  
//--- config -------------------------------------------------------------------------------------------
  
  var HOST, SOCKET, NAME, CHANNEL, CHANNELNAME;
  
  CHANNEL = 1;
  CHANNELNAME = 'Startup Weekend Taipei';


//--- view ---------------------------------------------------------------------------------------------

  var view = {

    layout : function( yeild ){
      return '<div id="talk-plus-wrap">' + yeild + '</div>';
    },

    join : function(){
      var yeild = 
      '<div id="talk-plus-header">' +
        '<div id="talk-plus-chatroom-name">' +
          '<h3>' + CHANNELNAME + '</h3>' +
          '<a href="#">More</a>' +
        '</div>' +
        '<div id="talk-plus-share">' + 
          '<h3>Share:</h3>' + 
          '<input id="talk-plus-share-input"/>' +
          '<a class="talk-plus-link" href="#">Link</a>' + 
          '<a class="talk-plus-script" href="#">Script</a>' +
        '</div>' +
      '</div>' +
      '<div id="talk-plus-content">' + 
        '<div id="talk-plus-msgs"><ul></ul></div>' + 
        '<div id="talk-plus-users"></div>' + 
      '</div>' +
      '<div id="talk-plus-footer">' + 
        '<div id="talk-plus-form-wrap">' +
          '<form id="talk-plus-form">' +
            '<div id="talk-plus-join">' +
              '<label id="talk-plus-title">Name: </label>' + 
              '<input id="talk-plus-name-input" type="text"/>' +
              '<input id="talk-plus-add-name-btn" type="submit" />' +
            '</div>' + 
            '<div id="talk-plus-send" style="display: none;">' +
              '<input id="talk-plus-send-input" type="text"/>' +
              '<input id="talk-plus-submit" type="submit" />' +
            '</div>' +
          '</form>' + 
          '<div id="talk-plus-hot-top">' +
            '<h3>Hot Topics: </h3>' + 
          '</div>' +
        '</div>' +
      '</div>';

      return this.layout( yeild );
    },

    error : function(){
      var yeild = '<div id="talk-plus-content">' +
        '<p>This browser has no native WebSocket support. Use a WebKit nightly or Google Chrome.</p>' +
      '</div>';

      return this.layout( yeild );
    },

    msg : function( user, msg, time ){
      return '<li>' +
        '<span>' + user + '</span>' +
        '<span>' + msg +'</span>' +
        '<span>'+ time +'</span>' +
      '</li>';
    }

  };



//--- model --------------------------------------------------------------------------------------------
  
  var model = {
    
    join : function( e ){
      var self, $msg_block ;
      
      e.preventDefault();
      
      self      = this;
      HOST      = window.location.host.split( ':' )[ 0 ];
      SOCKET    = new WebSocket( 'ws://127.0.0.1:3000/websocket' );
      // SOCKET = new WebSocket( 'ws://api.talkpl.us/websocket' );
      NAME      = $( '#talk-plus-name-input' ).val();

      $( '#talk-plus-join' ).hide();
      $( '#talk-plus-send' ).show();
      
      $msg_block = $( '#talk-plus-msgs' ).find( 'ul' );
      
      SOCKET.onmessage = function( evt ){
        var obj = $.parseJSON( evt.data );
        
        if({}.toString.call( obj ) !== '[object Object]' ) return;
        
        self[ obj[ 'action' ]]( 
          $msg_block, 
          obj[ 'user' ], 
          obj[ 'message' ], 
          ( new Date()).toString( "HH:mm:ss" )
        );
      };

      $( '#talk-plus-form' ).submit( function( e ){
        var $input;
        
        e.preventDefault();
        
        $input = $( '#talk-plus-send-input' );

        SOCKET.send( $.toJSON({ action: 'message', message: $input.val()}));
        $input.val( '' );
      });

      // send name when joining
      SOCKET.onopen = function(){
        SOCKET.send( $.toJSON({ 
          action : 'join', 
          user: NAME, 
          channel: CHANNEL 
        }));
      };
    },
    
    message : function( $msg_block, user, msg, time ){
      $msg_block.append( view.msg( user + ': ', msg, time ));
    },
    
    control : function( $msg_block, user, msg, time ){
      $msg_block.append( view.msg( user, msg, time ));
    }
  };



//--- controller ---------------------------------------------------------------------------------------

  var action = {
    
    init : function( $body ){
      if( typeof WebSocket !== 'undefined' ){
        $body.append( view.join());
        this.join();
      }else {
        $body.append( view.error());
      }
    },
    
    join : function(){
      var $input, $btn;
      
      $input = $( '#talk-plus-title' );
      $btn   = $( '#talk-plus-add-name-btn' );
      
      $input.keydown( function( e ){
        if( e.keyCode === 13 ){
          $btn.click();
        }
      });
      
      $btn.click( function( e ){
        model.join( e );
      });
      
    },
    
    leave : function(){
      
    },
    
    send : function( $form ){
      $form.submit( function( e ){
        var $input, msg;
        
        e.preventDefault();
        
        $input = $( this ).find( '#talk-plus-input' );
        msg    = $input.val();
        
        SOCKET.send( $.toJSON({ action : 'message', message : msg }));
        $input.val( '' );
      });
    }
  };
  
  
  
//--- execute ------------------------------------------------------------------------------------------

  $( function(){
    var $body;
    
    $body = $( 'body' );
    
    action.init( $body );
    
  });

})( window, jQuery );
