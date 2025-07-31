# `PlusMin`

**Versie**: 12 juni 2025  
**Auteur**: Ruud van Vliet

## Overzicht

Voor functionele informatie over dit project: zie https://plusmingereedschapskist.nl.

Deze README richt zich op het uitleggen hoe de applicatie is opgebouwd en (lokaal) kan worden gebouwd/gestart.

## Structuur

Het project omvat 6 repositories:

- pm-frontend: een vite/React frontend
- pm-backend: een Spring Boot/Kotlin/Maven backend die op /api/v1 een API ontsluit, die op /api/v1/swagger-ui/index.html
  kan worden bekeken
- pm-database: een Postgresql database
- pm-deploy: dit project dat het builden en starten van de vorige 3 projecten faciliteert

Twee niet noodzakelijke repositories:

- pm-docs: de doumentatie die op https://plusmingereedschapskist.nl wordt ontsloten
- camt053parser: is een apart deelproject om `camt053` betaalbestanden in te kunnen lezen; het is nu '
  uitgecommentarieerd';

De repositories zijn geplubiceerd op https://github.com/orgs/plusminapp/repositories

## Vereisten

- Java 17
- Maven 3.9.9
- docker 28.1.1 (inclusief docker compose)
- Visual Studio Code met de Dev Containers extensie
- make GNU Make 3.81


- een plusmin account bij Asgardeo; vraag hier naar bij Ruud van Vliet.

## Installatie

1. maak een folder waarin je de vier repositories wilt plaatsen, bijvoorbeeld `~/plusminapp`
2. clone de repositories in deze folder:
   ```bash
    git clone git@github.com:plusminapp/pm-database.git
    git clone git@github.com:plusminapp/pm-backend.git
    git clone git@github.com:plusminapp/pm-frontend.git
    git clone git@github.com:plusminapp/pm-deploy.git
   ```
3. kopieer `lcl/lcl.env naar dev.`
4. open de folder pm-deploy:
    ```bash
    make lcl-all
    ```
4. open http://localhost:3035/ in de browser; dit is de frontend van PlusMin

## Initialisatie van de database
Zodra je met je Asgardeo account inlogt in de frontend, wordt een gebruiker (met 2 periodes, zie de database) aangemaakt.

In de folder `~/plusminapp/pm-backend/src/test/resources/alex` is een bestand `0-gebruikers.sql` aanwezig. Deze sql zorgt ervoor dat de gebruiker de `ROLE_COORDINATOR` krijgt waardoor die (o.a.) gebruikers mag aanpassen.

In dezefde folder staat een bestand `1-gebruiker.json`; de json spreekt voor zich; de gebruiker wordt gematched op het email adres. De json **moet worden aangepast** en aangeboden via de swagger UI van de backend (zie de volgende paragraaf). het voegt automatisch periodes toe vanaf de periode januari/februari 2025.

Daarnaast staat er ook een bestand `2-rekeningen.json`. Dit bestand kan worden aangeboden via de swagger UI van de backend met de `POST /rekening/hulpvrager/{hulpvragerId}` in de rekening controller. De `hulpvragerId` is de database-id van de gebruiker en zal uit de database moeten worden opgehaald (of uit een XHR call via de developpers tools in de browser). In de frontend op de `/profiel` pagina kun je het rekeningschema onder `Potjes en bijbehorende budgetten` bekijken.

Betalingen kunnen daarna handmatig worden ingevoerd via de kasboekpagina (met de grote + knop rechtsonderin) in de frontend (http://localhost:3035/kasboek). Betalingen kunnen ook met de OCR (Optical Character Recognition, de knop met de camera bovenin de kasboek pagina) van een schermafbeelding van de bank app op je telefoon worden aangemaakt. 

Om bulk betalingen toe te voegen kan het `3-betalingen.json` bestand als inspiratie dienen. Dit bestand kan worden aangeboden via de swagger UI van de backend met de `POST /betalingen/hulpvrager/{hulpvragerId}/list` in de betalingen controller. Het voegt betalingen toe voor de periode januari/februari 2025 

Om de betalingingen naar de overige periodes te kopiëren kan de `PUT /demo/hulpvrager/{hulpvragerId}/configureer` worden gebruikt. Hierdoor worden alle periodes gevuld met betalingen en vervolgens elke nacht de betalingen voor 'vandaag' naar de huidige periode gekopieerd. Dit is handig om de app te kunnen demo-en en testen. 


## Gebruik van de Swagger UI
Om de Swgagger UI te gebruiken, moet de gebruiker zijn ingelogd:
1. ga naar http://localhost:3035 (dit is de frontend) met de dev tools in de browser geopend
2. log in met je Asgardeo account
3. ga in de dev tools van de browser naar het tabblad 'Network'; klik op een XHR call; open de `Headers` tab en zoek naar de `Authorization` header; kopieer de waarde van deze header; plak het in een textbestand en haal de text `Bearer` (inclusief de spatie) weg; kopieer nu de rest van het token (op jwt.io kun je het token trouwens bekijken). 
4. ga naar http://localhost:3045/api/v1/swagger-ui/index.html. open met de `Authorize` knop de dialoog en plak het token. Klik op `Authorize` en daarna op `Close`.
5. Nu kun je de API gebruiken. Een test is bijvoorbeeld de `GET /gebruiker/zelf` in de gebruiker-controller (die heeft geen parameters of body nodig).


## Front end ontwikkelen in Visual Studio Code (met dank aan Vincent Olde Scholtenhuis van ilionx)
In het frontend project is een `.devcontainer` folder aanwezig. Als je de Dev Containers extensie van Visual Studio Code hebt geinstalleerd kun je met <shift>-<command> P de command palette openen en `Dev Containers: Reopen in Container` kiezen. Visual Studio Code zal nu de container opstarten en de frontend daarin openen. Met `npm run dev` kun je de frontend starten. De frontend is dan bereikbaar op http://localhost:5173/.