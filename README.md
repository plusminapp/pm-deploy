# `PlusMin`

**Versie**: 15 december 2025  
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

- docker 28.1.1 (inclusief docker compose)
- git
- Visual Studio Code met de Dev Containers extensie
- make GNU Make 3.81
- een plusmin account bij Asgardeo; vraag hier naar bij Ruud van Vliet.

Om buiten de dockers te bouwen:
- node.js 18/npm
- Java 21
- Maven 3.9.9


## Installatie

1. maak een folder waarin je de vier repositories wilt plaatsen, bijvoorbeeld `~/plusminapp`
2. clone de repositories in deze folder:
   ```bash
    git clone git@github.com:plusminapp/pm-database.git
    git clone git@github.com:plusminapp/pm-backend.git
    git clone git@github.com:plusminapp/pm-frontend.git
    git clone git@github.com:plusminapp/pm-deploy.git
   ```
3. kopieer `lcl/lcl.env` naar `dev/dev.env` en naar `stg/stg.env` in de pm-deploy folder. 
4. `cd` naar de folder pm-deploy:
    ```bash
    make lcl-all
    ```
4. open http://localhost:3035/ in de browser; dit is de frontend van PlusMin

## Initialisatie van de database
Zodra je met je Asgardeo account inlogt in de frontend, wordt een gebruiker aangemaakt.

Als je `http://localhost:3035/gebruikersprofiel` opent kun je een administratie-wrapper uploaden; dit is een JSON bestand dat de beginbalans, rekeningen en betalingen bevat. In de folder `~/plusminapp/pm-backend/src/test/resources/alex` en `~/plusminapp/pm-backend/src/test/resources/simon` zijn dit soort bestanden te vinden.

## Gebruik van de Swagger UI
Om de Swgagger UI te gebruiken, moet de gebruiker zijn ingelogd:
1. ga naar http://localhost:3035 (dit is de frontend) met de dev tools in de browser geopend
2. log in met je Asgardeo account
3. ga in de dev tools van de browser naar het tabblad 'Network'; klik op een XHR call; open de `Headers` tab en zoek naar de `Authorization` header; kopieer de waarde van deze header; plak het in een textbestand en haal de text `Bearer` (inclusief de spatie) weg; kopieer nu de rest van het token (op jwt.io kun je het token trouwens bekijken). 
4. ga naar http://localhost:3045/api/v1/swagger-ui/index.html. open met de `Authorize` knop de dialoog en plak het token. Klik op `Authorize` en daarna op `Close`.
5. Nu kun je de API gebruiken. Een test is bijvoorbeeld de `GET /gebruiker/zelf` in de gebruiker-controller (die heeft geen parameters of body nodig).


## Front end ontwikkelen in Visual Studio Code (met dank aan Vincent Olde Scholtenhuis van ilionx)
In het frontend project is een `.devcontainer` folder aanwezig. Als je de Dev Containers extensie van Visual Studio Code hebt geinstalleerd kun je met <shift>-<command> P de command palette openen en `Dev Containers: Reopen in Container` kiezen. Visual Studio Code zal nu de container opstarten en de frontend daarin openen. Met `npm run dev` kun je de frontend starten. De frontend is dan bereikbaar op http://localhost:5173/.
