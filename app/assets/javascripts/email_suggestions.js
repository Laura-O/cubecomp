function competitorEmailSuggestion() {
  var hideEmailSuggestion = function() {
    $('span#email_suggestion').hide();
    $('a#email_suggestion_link').html('');
  };

  $('#competitor_email').on('blur', function() {
    $(this).mailcheck({
      suggested: function(element, suggestion) {
        $('span#email_suggestion').show();

        $('a#email_suggestion_link').click(function() {
          $('#competitor_email').val(suggestion.full);
          hideEmailSuggestion();
        });

        $('a#email_suggestion_link').html(suggestion.full);
      },
      empty: function(element) { hideEmailSuggestion(); }
    });
  });
};
