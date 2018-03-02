RFauxFactory
============

.. image:: https://badge.fury.io/rb/rfauxfactory.svg
    :target: https://badge.fury.io/rb/rfauxfactory

.. image:: https://coveralls.io/repos/github/SatelliteQE/RFauxFactory/badge.svg?branch=master
    :target: https://coveralls.io/github/SatelliteQE/RFauxFactory?branch=master

Generates random data for your tests. Ruby port for https://github.com/omaciel/fauxfactory.

Install RFauxFactory

.. code-block:: bash

    gem install rfauxfactory


Generate Strings with default length=10
+++++++++++++++++++++++++++++++++++++++

.. code-block:: ruby

    RFauxFactory.gen_alpha          => "iqXfCtcmOl"
    RFauxFactory.gen_latin1         => "âÍûçùÈíÂãÚ"
    RFauxFactory.gen_cjk            => "柕鈭鳬鴝藂豲醘晓怰匜"
    RFauxFactory.gen_utf8           => "빣졤𣀣𐜖𦝅Í샆𩀛ꢮ켆"
    RFauxFactory.gen_cyrillic       => "РӅӪѹёӖЀљҸѤ"
    RFauxFactory.gen_alphanumeric   => "2WKLdDNfrO"
    RFauxFactory.gen_numeric_string => "7667510623"
    RFauxFactory.gen_special        => "(`|,\\/^$/."
    RFauxFactory.gen_html           => "<applet>tFyFHLasnN</applet>"


Generate Strings with custom length
+++++++++++++++++++++++++++++++++++

.. code-block:: ruby

    RFauxFactory.gen_alpha 20  => "gtUAteMlmjfXivTEOXNL"

    # or

    RFauxFactory.gen_alpha length=20 => "YPxOXgWMrATxvHnCKmcy"


Generate Strings with the general gen_string function
+++++++++++++++++++++++++++++++++++++++++++++++++++++

allowed string types are:

- alpha
- alphanumeric
- cjk
- html
- latin1
- numeric
- utf8
- punctuation

.. code-block:: ruby

    RFauxFactory.gen_string :alpha        => "WXWkJJsgHB"
    RFauxFactory.gen_string :latin1       =>  "ÅÔÍÅõéþêÃÑ"
    RFauxFactory.gen_string :cjk          => "娎咅巁蹐猳瑣呺鮘桼汿"
    RFauxFactory.gen_string :utf8         => "衊𖣋䰛𤬱㱹筠𖡇𫑴軈𨳈"
    RFauxFactory.gen_string :cyrillic     => "БӮҨӠѴҞӘӦѱН"
    RFauxFactory.gen_string :alphanumeric => "cJ4iapthI8"
    RFauxFactory.gen_string :numeric      => "8572742737"
    RFauxFactory.gen_string :punctuation  => ">-}{%(``%]"
    RFauxFactory.gen_string :html         => "<big>WNoQefDcmE</big>"

    # or with custom length

    RFauxFactory.gen_string :alpha, 20 => "TuxtvmNwrfbuGaaQSEnM"

Generate Strings of all the supported types
+++++++++++++++++++++++++++++++++++++++++++

- With default fixed length 10:

.. code-block:: ruby

    RFauxFactory.gen_strings
    => {:alpha=>"RoRHnHUkPO",
        :alphanumeric=>"nr6SVx2up1",
        :cjk=>"勷笃儽痖跂飣煾籄綔庋",
        :cyrillic=>"ҕФҒқьѾљһІЏ",
        :html=>"<big>YhtxODnoFs</big>",
        :latin1=>"ÝäÈØÓÌãÝÙÌ",
        :numeric=>"6684366145",
        :utf8=>"㓆녵냔𫣾𝝙𦚾쬠𗧛䰢쭱",
        :punctuation=>"{<;%-:\\<_]"}


- With custom fixed length:

.. code-block:: ruby

    RFauxFactory.gen_strings 20
    => {:alpha=>"tXuyblxhHVvxSStxHRqe",
        :alphanumeric=>"EbBUUPl7xZP7OC1uZi5B",
        :cjk=>"圠黄炵鍁寥礟瓢丽粐遵暋歞乽匨霜謟姈迴楩螯",
        :cyrillic=>"ѻҢӍҩӷѣӼ҈ңФфѡӮЖѽҧѴџӋҎ",
        :html=>"<span>YMDuJumImvDvxKocHUwE</span>",
        :latin1=>"ïõêáÃÁÄÃõäêúÈÀÛÃúýïå",
        :numeric=>"66662825266228221074",
        :utf8=>"𠲹橝𨖟𐌿𬩱𡁲𤅽㺷𪯠𨨮𢡙𪵾獄𦩸𑈂𤉪𗔋妶ꯡಖ",
        :punctuation=>"\\,&{($|>`@_^!_{&$=]>"}

- With custom range length:

.. code-block:: ruby

    RFauxFactory.gen_strings (3..30)
    => {:alpha=>"humyNICJnf",
        :alphanumeric=>"hWraGEsBPrELdKI0x0CVpRMak",
        :cjk=>"烩稟醎渍葼釃枆鄴锐窫角菧妻慗饏镂鮺镬嬦",
        :cyrillic=>"хђѫӬӷӮюЕѸ",
        :html=>"<blink>yweAKvPxpTQAzRWCDAmxiyJ</blink>",
        :latin1=>"ÁóÁ",
        :numeric=>"626134543753572648033525",
        :utf8=>"ⱴ嫆𡋹𡗸",
        :punctuation=>"&@;??}:|\\@\"`[.+\\+|"}

- With excluding some string types:

.. code-block:: ruby

    RFauxFactory.gen_strings exclude: [:html, :punctuation]
    => {:alpha=>"IBlbvJkYQP",
        :alphanumeric=>"3KZHRSgbcB",
        :cjk=>"儫魹咳崙訔船鲓撊郸猡",
        :cyrillic=>"ӡҁӇѯӇӫэЗыѳ",
        :latin1=>"ìÜóÌáÓÛéÀâ",
        :numeric=>"8140474314",
        :utf8=>"𫐖𦷘𣒣瑩竰誎請𠼎粢裤"}


- We can also combine length and exclude options:

.. code-block:: ruby

    RFauxFactory.gen_strings (3..30), exclude: [:html, :punctuation]
    => {:alpha=>"aLc",
        :alphanumeric=>"wbfFxoQrL4TOpd8r5",
        :cjk=>"灢汍袌姩饇狶肌胃穨煍灔舨纡訴鷂彜窟趫",
        :cyrillic=>"ҥӤѪѦҫОПӿ",
        :latin1=>"ÌÙÕðñúÚõáÌÉ",
        :numeric=>"01526437887562321",
        :utf8=>"柚ᖹ𪮅捰Ʋ"}

Generate bool values:
+++++++++++++++++++++

.. code-block:: ruby

    RFauxFactory.gen_boolean => false
    RFauxFactory.gen_boolean => true
    RFauxFactory.gen_boolean => true
