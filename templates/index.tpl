<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
  <title>ちんこまんこ.jp</title>
  <link rel="stylesheet" type="text/css" href="/media/css/default.css" />
  <script type="text/javascript" src="http://code.jquery.com/jquery-1.5.2.min.js"></script>
</head>
<body>
<div class="page">
  <div class="header"><h1>ちんこまんこ.jp</div>
  <div class="main">
    {% if message %}
    <div class="flash">
    {{ message }}
    </div>
    {% endif %}
    <form action="/" method="post" name="main">
      <div class="field seq attention">
        <span class="inplace"><input type="text" id="main.subdomain" class="text_field" name="subdomain" />.ちんこまんこ.jp</span>
        を取得
      </div>
      <div class="fieldsets">
        <fieldset class="first">
          <legend class="field sxs">
            <input type="radio" id="main.entry_type.0" name="entry_type" value="0">
            <label for="main.entry_type.0">CNAMEエントリを追加する</label>
          </legend>
          <div class="field seq">
            <label for="main.domain_name">ドメイン名</label>
            <input type="text" id="main.domain_name" class="text_field" name="domain_name" value="" />
          </div>
        </fieldset>
        <fieldset>
          <legend>
            <input type="radio" name="entry_type" value="1" id="main.entry_type.1">
            <label for="main.entry_type.1">リダイレクトを追加する</label>
          </legend>
          <div class="field seq">
            <label for="main.url">リダイレクト先URL</label>
            <input type="text" id="main.url" class="text_field" name="domain_name" value="" />
          </div>
        </fieldset>
      </div>
      <div class="form_footer">
        <input type="submit" class="submit_button" value="生成する" />
      </div>
    </form>
    <script type="text/javascript">
      var f = $("script:last").prev("form");
      var radios = f.find(":radio");
      radios.change(function(e) {
        radios.each(function() {
          var c = $(this).parents("legend");
          c[["removeClass", "addClass"][+this.checked]].call(c, "focused");
        });
      });
    </script>
  </div>
</div>
</body>
</html>
{#
vim: sts=2 sw=2 ts=2 et
#}
