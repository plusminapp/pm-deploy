# Epics

Onderstaand een (niet geprioriteerde) lijst met Epics voor de PlusMin app.

#### Ontkoppelen van de hoofdmodules
Kern van de app zijn 3 hoofdmodules: budgetteren, aflossen en sparen; deze zijn nu alle drie afhankelijk van budgetteren maar moeten los van elkaar kunnen werken.

#### AI voor toewijzen potjes en budgetten
AI een voorstel laten doen voor het toewijzen van een betaling aan een potje/budget, bijvoorkeur helemaal in de front end

#### Papieren huishoudboekje OCRen
Op basis van een foto van een pagina van een huishoudboekje betalingen registreren.

#### Internatinalisation
In de hele stack (pm-frontend, pm-backend en pm-database) alle teksten, die aan de gebruiker worden getoond,vertaalbaar maken.

#### Project inrichting
Een tool en structuur definiëren om de ontwikkel workflows in te richten; issues onderverdelen in (bijvoorbeeld) epics, stories, bugs en tasks, inclusief de onderlinge samenhang; issues kunnen toewijzen en de voortgang monitiren.

#### Authenticatie (1)
Gebruiker authenticatie mogelijkmaken zonder gebruik te maken van Asgardeo, bijvoorbeeld door een eeuwig durend token en een eigen issuer-url (zie application.yml in pm-backend).

#### Authenticatie (2)
Gebruiker koppelen op basis van de `sub` in de JWT, en dus geen email (nu als username) mee sturen; hiermee wordt een volledige ontkoppeling van persoongegevens bereikt.

#### CI/CD en tests opzetten
Zowel voor pm-frontend als pm-backend tests opzetten en invullen die in een CI/CD pipeline worden uitgevoerd.

#### Reserveringen aka spaarpotjes
Reserveringen inbouwen (zowel pm-database, pm-backend als pm-frontend). Een reserving is een potje dat opzij wordt gezet om een grote aanschaf in de toekomst te kunnen betalen waarvoor maandelijk geld opzij wordt gezet.

#### Schermen om de app te configureren voor een gebruiker
Opzetten van schermen om rekeningen, budgetten, aflossingen en tzt reserveringen (aka spaarpotjes) in te kunnen richten en wijzigen voor een gebruiker.

#### Periode afsluiten
Een periode moet worden afgesloten om de periode te evalueren, de saldi weer recht te zetten en herinrichting te doen op punten die niet goed gingen (budgetten verplaatsen, etc.).

#### Initialisatie script
Een script om een initiele database vulling te maken waardoor de app (functioneel) testbaar wordt.

#### Signalen
Een signaal is een melding aan de gebruiker dat er iets wetenswaardigs is gebeurd, bijvoorbeeld dat een nieuwe periode is gestart en de oude kan worden afgesloten, of bijvoorbeeld dat het maandbudget is overschreden; in eerste instantie het mechanisme inbouwen, zodanig dat het eenvoudig is om nieuwe signalen toe te voegen.
