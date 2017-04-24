(function(){
  chrome.browserAction.onClicked.addListener(function(tab) { 
    chrome.tabs.getSelected(null, function(tab) {  
      var url = tab.url;
      if ( url == ""){
        
        
        var options = {user_id: 1};
        // データ保存
        chrome.storage.sync.set(options, function(){});
      }else{
        // データ取得
        chrome.storage.sync.get(
          defaults,
          function(items) {
            var user_id = items.user_id;
            var xhr = new XMLHttpRequest();
            xhr.open("POST", "https://techacademy-sunaga.c9users.io/api/item_create", true);
            xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
            xhr.send("id="+user_id+"&url=" + url);
        });
      }
    });  
  });
})();