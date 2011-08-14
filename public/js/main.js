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
          '<a href="#" id="talk-plus-hide">Hide</a>' +
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
              '<input id="talk-plus-add-name-btn" type="submit" value="Join"/>' +
            '</div>' + 
            '<div id="talk-plus-send" style="display: none;">' +
              '<input id="talk-plus-send-input" type="text"/>' +
              '<input id="talk-plus-submit-btn" type="submit" value="Send"/>' +
            '</div>' +
          '</form>' + 
          '<div id="talk-plus-hot-topic">' +
            '<h3>Hot Topics: </h3>' + 
            '<a href="www.talkpl.us/welcome/embeded_website?outside_link=http://taipei.startupweekend.org/">Startup Weekend Taipei</a>' +
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
        '<span class="talk-plus-msg-user">' + user + ' </span>' +
        '<span class="talk-plus-msg-msg">' + msg +'</span>' +
        '<span class="talk-plus-msg-time">'+ time +'</span>' +
      '</li>';
    }

  };



//--- controller ---------------------------------------------------------------------------------------

  var action = {
    
    _join : function( e ){
      var self, $msg_block ;
      
      e.preventDefault();
      
      self   = this;
      HOST   = window.location.host.split( ':' )[ 0 ];
      SOCKET = new WebSocket( 'ws://api.talkpl.us/websocket' );
      NAME   = $( '#talk-plus-name-input' ).val();

      $( '#talk-plus-join' ).hide();
      $( '#talk-plus-send' ).show();
      $( '#talk-plus-send-input' ).focus();
      
      $msg_block = $( '#talk-plus-msgs' ).find( 'ul' );
      
      SOCKET.onmessage = function( evt ){
        var obj = $.parseJSON( evt.data );
        
        if({}.toString.call( obj ) !== '[object Object]' ) return;
        
        self[ obj[ 'action' ]]( 
          $msg_block, 
          obj[ 'user' ].replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;"), 
          obj[ 'message' ].replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;"), 
          ( new Date()).toString( "HH:mm:ss" )
        );
      };

      $( '#talk-plus-form' ).submit( function( e ){
        var $input;
        
        e.preventDefault();
        
        $input = $( '#talk-plus-send-input' );

        SOCKET.send( $.toJSON({ 
          action: 'message', 
          message: $input.val()
        }));
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
    
    _msg : function( $msg_block, user, msg, time ){
      $msg_block.append( view.msg( user, msg, time ));
      $msg_block.parent().scrollTop( $msg_block.height());
    },
    
    init : function( $body ){
      if( typeof WebSocket !== 'undefined' ){
        $body.append( view.join());
        this.focus();
        this.join();
        this.hide();
      }else {
        $body.append( view.error());
      }
    },
    
    message : function( $msg_block, user, msg, time ){
      this._msg( $msg_block, user, msg, time );
    },
    
    control : function( $msg_block, user, msg, time ){
      this._msg( $msg_block, user, msg, time );
    },
    
    focus : function(){
      $( '#talk-plus-share-input' ).
        val( '<script>document.write("<script src="www.talkpl.us/welcome/js"></script>");</script>' ).
        mousedown( function( e ){
          e.preventDefault();
          $( this ).select();
        }).focus( function(){
          $( this ).select();
        });
      $( '#talk-plus-name-input' ).focus();
    },
    
    hide : function(){
      $( '#talk-plus-hide' ).click( function(){
        var $this = $( this );
        
        if( !$this.hasClass( 'talk-plus-hidden' )){
          $( '#talk-plus-wrap' ).css( 'height', 25 );
          $this.addClass( 'talk-plus-hidden' );
          $this.text( 'Show' );
        }else{
          $( '#talk-plus-wrap' ).css( 'height', '' );
          $this.removeClass( 'talk-plus-hidden' );
          $this.text( 'Hide' );
        }
      });
    },
    
    join : function(){
      var self, $input, $btn;
      
      self   = this;
      $input = $( '#talk-plus-title' );
      $btn   = $( '#talk-plus-add-name-btn' );
      
      $input.keydown( function( e ){
        if( e.keyCode === 13 ){
          $btn.click();
        }
      });
      
      $btn.click( function( e ){
        self._join( e );
      });
      
    }
  };
  
  
  
//--- execute ------------------------------------------------------------------------------------------

  $( function(){
    action.init( $( 'body' ));
  });

})( window, jQuery );