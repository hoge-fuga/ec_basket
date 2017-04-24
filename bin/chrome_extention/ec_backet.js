(function(){
  chrome.browserAction.onClicked.addListener(function(tab) { 
    chrome.tabs.getSelected(null, function(tab) {  
      var url = tab.url;
      if ( url.indexOf('ec-basket.herokuapp.com/users/') != -1 ){
        var urls = url.split("/");
        var user_id = urls[urls.length-1]; 
        alert("User ID : " + user_id + " Registered!!");
        // データ保存
        chrome.storage.local.set({user_id: user_id, env: "p"}, function(){});
        
      }else if( url.indexOf('https://techacademy-sunaga.c9users.io/users/') != -1){
        var urls = url.split("/");
        var user_id = urls[urls.length-1]; 
        alert("User ID : " + user_id + " Registered!!");
        // データ保存
        chrome.storage.local.set({user_id: user_id, env: "d"}, function(){});
        
      }else{
        // データ取得
        chrome.storage.local.get(
          ["user_id", "env"],
          function(vals) {
            var user_id = vals.user_id;
            var env = vals.env;
            alert("商品を追加しました！");
            var xhr = new XMLHttpRequest();
            if(env == "p"){
              xhr.open("POST", "https://ec-basket.herokuapp.com/api/item_create", true);
            }else{
              xhr.open("POST", "https://techacademy-sunaga.c9users.io/api/item_create", true);
            }
            xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
            xhr.send("id="+user_id+"&url=" + encodeURIComponent(url));
        });
      }
    });  
  });
})();