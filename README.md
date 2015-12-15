# sopra-terminplaner
Programmier-Übungsaufgabe im Softwaregrundprojekt: Wochenplaner

Released.

## Einrichtung und Konfiguration ##

Das System baut auf Apache Tomcat als Webserver auf, die benötigten Tabellen werden durch das System eigenhändig erstellt. Die Zugangsdaten zu Datenbank und Mailserver sind in den entsprechenden Dateien maildata.jsp und dbdata.jsp einzutragen. Zum Schutz der persönlichen Daten setzt das System https voraus, tomcat muss also entsprechend für https eingerichtet werden - die korrekte Adresse muss schließlich in maildata.jsp hinterlegt werden, damit die Aktivierungslinks generiert werden können.

Bei der Einrichtung der beteiligten Server muss besonders auf die Zeichenkodierung geachtet werden, da Tomcat und vor allem der MySQL-Connector-Java sich gerne weigern, die Daten in utf-8 zu schicken - im Zweifelsfall muss auf nicht-ASCII-Zeichen verzichtet werden, da die Datenbank sonst im Bereich des Wochenplaners bei falsch maskierten Zeichen im Veranstaltungstitel bestimmte Änderungen verweigert.

Zusätzliche libs (zu platzieren in %CATALINA_HOME%/lib), die für tomcat benötigt werden:

### Für die Datenbankverbindung ###
* mysql-connector-java-3.1.14-bin.jar  
  -> Download: https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-3.1.14.zip
  
### Für den E-Mail-Versand via Mailserver ###
* activation.jar (JavaBeans Activation Framework)  
  -> Download: http://download.oracle.com/otn-pub/java/jaf/1.1.1/jaf-1_1_1.zip
* javax.mail.jar (Java Mail API)  
  -> Download: http://java.net/projects/javamail/downloads/download/javax.mail.jar

Ein Fehlen der Bibliotheken führt zu Unbenutzbarkeit des Systems.
