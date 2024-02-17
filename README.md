News app dokumentaatio 
Tekijät: Aku Koskela ja Jami Suomalainen

Sovelluksella voi etsiä uutisia suomeksi ja englanniksi omaa hakuasanaa käyttäen. Sovellus käyttää NewsAPI-rajapintaa, josta uutisten tiedot haetaan.  
Sovellus käyttää firebase cli kirjastoa, jonka avulla sovellus on yhdistetty firebase autentikaatioon ja firebase tietokantaan. Kirjastosta on myös otettu sign in ja register viewit.
Sovellus käyttää NewsAPI-rajapintaa josta se hakee uutiset. 
Sovellus ei käytä muita puhelimen ominaisuukisa kuin kirjoittamista.
Sovelluksessa on aiemmin jo mainitut sign in ja register näkymät jotka saadaa firebase kirjastosta. Lisäksi sovelluksessa on Home näkymä, jossa näkyy käyttäjän 3 viimeistä hakusanaa ja niistä painamalla pystyy hakemaan samalla sanalla uudestaan. Näkymässä näkyy myös hakunappi jota painamalla pääsee kirjoittamaan hakusanan. Kun haku on tehty siirytään newsDashboard näkymään, johon on listattu kaikki uutiset, jotka ovat suodattuneet hakusanalla ja kielellä. Yhtä uutista klikattaessa päästään näkymään, jossa kyseisen uutisen tiedot näytetään paremmin. Näkymässä on myös linkki, jonka kautta uutista pääsee lukemaan uutissivulle.
Sovelluksessa ei ole hyödynnetty tekoälyä
