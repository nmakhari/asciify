document.addEventListener("turbolinks:load", function () {
  $input = $("[data-behavior='autocomplete']");

  var options = {
    getValue: "title",
    url: function (phrase) {
      return "/search.json?q=" + phrase;
    },
    categories: [
      {
        listLocation: "uploads",
        header: "<strong>Uploads</strong>",
      },
      {
        listLocation: "tags",
        header: "<strong>Tags</strong>",
      },
    ],
    list: {
      onChooseEvent: function () {
        var url = $input.getSelectedItemData().url;
        $input.val("");
        Turbolinks.visit(url);
      },
    },
  };

  $input.easyAutocomplete(options);
});
