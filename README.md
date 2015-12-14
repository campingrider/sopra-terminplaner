# sopra-terminplaner
Programmier-Übungsaufgabe im Softwaregrundprojekt: Wochenplaner

Work in progress...

## Einrichtung und Konfiguration ##

Das System baut auf Apache Tomcat als Webserver auf, eine entsprechend präparierte MySQL-Datenbank muss bereitgestellt werden. Die Zugangsdaten zu Datenbank und Mailserver sind in den entsprechenden Dateien maildata.jsp und dbdata.jsp einzutragen. Zum Schutz der persönlichen Daten setzt das System https voraus, tomcat muss also entsprechend für https eingerichtet werden - die korrekte Adresse muss schließlich in maildata.jsp hinterlegt werden, damit die Aktivierungslinks generiert werden können.

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
