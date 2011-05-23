<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
  <title>ちんこまんこ.jp</title>
  <link rel="stylesheet" type="text/css" href="/media/css/default.css" />
  <script type="text/javascript" src="http://code.jquery.com/jquery-1.5.2.min.js"></script>
  <script type="text/javascript">

  var _gaq = _gaq || [];
  _gaq.push(['_setAccount', 'UA-23508204-1']);
  _gaq.push(['_trackPageview']);

  (function() {
    var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
  })();

</script>
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
        <span class="inplace"><input type="text" id="main.subdomain" class="text_field" name="subdomain" value="{{ subdomain }}" />.ちんこまんこ.jp</span>
        を取得
      </div>
      <div class="fieldsets">
        <fieldset class="first field-redirect">
          <legend>
            <input type="radio" name="entry_type" value="0" id="main.entry_type.0" {%if (entry_type == '0') %}checked="checked"{% endif %}>
            <label for="main.entry_type.0">リダイレクトする</label>
          </legend>
          <div class="field seq">
            <label for="main.url">リダイレクト先URL</label>
            <input type="text" id="main.url" class="text_field" name="url" value="{{ url }}" />
            <p class="description">転送アドレスを指定します。</p>
          </div>
        </fieldset>
        <fieldset class="field-cname">
          <legend class="field sxs">
            <input type="radio" id="main.entry_type.1" name="entry_type" value="1" {%if (entry_type == '1') %}checked="checked"{% endif %}>
            <label for="main.entry_type.1">CNAMEエントリを追加する</label>
          </legend>
          <div class="field seq">
            <label for="main.domain_name">ドメイン名</label>
            <input type="text" id="main.domain_name" class="text_field" name="domain_name" value="{{ domain_name }}" />
          </div>
          <p class="description">上級者向けです。ちんこまんこ.jp の DNS に CNAME エントリを追加します。</p>
        </fieldset>
      </div>
      <div class="form_footer">
        <input type="submit" class="submit_button" value="生成する" />
      </div>
    </form>
    <script type="text/javascript">
      var f = $("script:last").prev("form");
      var radios = f.find(":radio");
      function onRadioChange(e) {
        radios.each(function() {
          var c = $(this).parents("legend");
          c[["removeClass", "addClass"][+this.checked]].call(c, "focused");
          $(this).parents("fieldset").find(".text_field").attr("disabled", !this.checked);
        });
      }
      radios.change(onRadioChange);
      $(onRadioChange);
      var subdomainField = f.find("[name='subdomain']");
      var urlField = f.find("[name='url']");
      var redirect = f.find(".field-redirect");
      function onUrlFieldChange() {
        if (subdomainField.val() != "" && urlField.val() != "") {
          var desc = redirect.find(".field .description")
            .html('http://<span class="subdomain"></span>.ちんこまんこ.jp/ にアクセスすると、' + 
                    '<span class="url"></span>に転送されます。');
          desc.find(".subdomain").text(subdomainField.val());
          desc.find(".url").text(urlField.val());
        }
      }
      subdomainField.keyup(onUrlFieldChange);
      urlField.keyup(onUrlFieldChange);
    </script>
  </div>
</div>
</body>
</html>
{#
vim: sts=2 sw=2 ts=2 et
#}
