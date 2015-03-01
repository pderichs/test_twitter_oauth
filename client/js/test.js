var url = "http://localhost:4567/twitter?url=statuses/home_timeline.json?count=20";
$(function() {
  $.getJSON(url,
    function(response) {
      $.each(response,
        function(index, item) {
          var elem = $('<li/>').text(item.text);
          $('#tweets').append(elem);
        }
      );
    }
  );
});
