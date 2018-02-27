RFauxFactory
============

.. image:: https://badge.fury.io/rb/rfauxfactory.svg
    :target: https://badge.fury.io/rb/rfauxfactory

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


Generate bool values:
+++++++++++++++++++++

.. code-block:: ruby

    RFauxFactory.gen_boolean => false
    RFauxFactory.gen_boolean => true
    RFauxFactory.gen_boolean => true
