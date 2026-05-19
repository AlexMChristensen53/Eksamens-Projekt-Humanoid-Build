# Fagord-ordliste – Wattson-arm-projektet

Formålet med denne fil er at hjælpe dig med at **forklare hvert fagord til eksamen** uden at gå i stå. For hvert ord:

- **Hvad det er** (kort, i hverdagssprog hvis muligt)
- **Hvorfor det er vigtigt i netop dit projekt**

Brug det som forberedelse til den mundtlige prøve. Hvis du kan forklare alle disse uden at åbne rapporten, er du i god form.

---

## 1. Robotten og dens dele

### Humanoid robot
**Hvad:** En robot udformet som et menneske – torso, hoved, arme, ben.
**Hvorfor vigtigt:** Wattson hører til denne kategori. Det forklarer hvorfor armen har en *antropomorf* (menneskelignende) kinematik med 7 frihedsgrader – det er kopieret fra menneskets skulder, albue og håndled.

### Frihedsgrad (DOF – Degrees of Freedom)
**Hvad:** Antallet af uafhængige bevægelsesakser i et mekanisk system. En menneskelig arm har 7.
**Hvorfor vigtigt:** Når armen har 7 DOF (skulder pitch/roll/yaw, albue pitch, underarm yaw, håndled pitch/roll), kan håndens position **og** orientering nås på flere måder. Det er forudsætningen for naturlig bevægelse, men gør også styringen kompleks.

### Antropomorf
**Hvad:** "Menneskelignende" – konstrueret efter den menneskelige krop.
**Hvorfor vigtigt:** Begrunder hvorfor leddene er placeret som de er, og hvorfor 7 DOF er valgt frem for fx 6.

### Pitch / roll / yaw
**Hvad:** De tre rotationsakser:
- **Pitch** = nik (op/ned)
- **Roll** = vrid om længdeaksen
- **Yaw** = drej (venstre/højre)

**Hvorfor vigtigt:** Du bruger termerne til at beskrive hvert led i armen. Skulderen alene har alle tre.

### Aktuator
**Hvad:** En komponent der omsætter elektrisk energi til mekanisk bevægelse. I dit projekt: servoer.
**Hvorfor vigtigt:** Aktuatorerne er det der får armen til at bevæge sig. Uden korrekt valg og forsyning sker der ingenting.

### Led (engelsk: joint)
**Hvad:** Et bevægeligt sted i den mekaniske struktur.
**Hvorfor vigtigt:** Armen har 7 aktive led. Hvert led har en servo og en software-grænse for hvor langt det må bevæge sig.

---

## 2. 3D-print

### FDM (Fused Deposition Modeling)
**Hvad:** Den mest almindelige 3D-print-teknik. Smelter plastik-filament og lægger det lag på lag.
**Hvorfor vigtigt:** Hele Wattson er printet med FDM. Det er billigt og fleksibelt, men giver nogle særlige svagheder (se *anisotropi*).

### Filament
**Hvad:** Plastiktråden der bliver smeltet i 3D-printeren. Typiske materialer: PLA, PETG, ABS, nylon.
**Hvorfor vigtigt:** Materialevalget afgør hvor stivt, stærkt og varmebestandigt et led bliver.

### Lag (layer)
**Hvad:** Den enkelte stribe plastik printeren lægger ned. Tykkelse typisk 0,1–0,3 mm.
**Hvorfor vigtigt:** Retningen lagene ligger i (print-orientering) afgør hvor stærk delen er i hvilken retning – fordi printet er stærkere *langs* lagene end *vinkelret* på dem.

### Anisotropi
**Hvad:** At materialets egenskaber afhænger af retning. Modsætningen er *isotropt* (ens i alle retninger), som fx støbt plastik er.
**Hvorfor vigtigt:** Det er **det vigtigste fagord at kende** ved 3D-print. Et trykt led kan brække under last hvis lagene ligger på tværs af belastningsretningen. Det forklarer hvorfor print-orientering er et bevidst valg, ikke et tilfælde.

### Infill
**Hvad:** Mønstret indeni en printet del – fx 20 % gitter. Resten er hult.
**Hvorfor vigtigt:** Højere infill = stærkere og tungere del. Trade-off mellem styrke og vægt. Relevant for armens led der både skal være stive nok og lette nok til at servoerne kan løfte dem.

### Support
**Hvad:** Ekstra-materiale printeren lægger ned for at understøtte overhæng under printning. Fjernes bagefter.
**Hvorfor vigtigt:** Skal med i fremstillingen, fjernes manuelt, og kan efterlade overflader der skal pudses/efterbehandles.

### Tolerancer
**Hvad:** Hvor præcist en del er printet i forhold til 3D-modellen. FDM-printere har typisk ±0,1–0,3 mm.
**Hvorfor vigtigt:** Når to printede dele skal passe sammen (fx aksel i hul), kan de blive enten for stramme eller for løse. Det er en hyppig kilde til problemer ved samling.

### Kryb (creep)
**Hvad:** At et plastmateriale langsomt deformeres når det udsættes for vedvarende last – selv under brudsgrænsen.
**Hvorfor vigtigt:** Et led der konstant skal holde armen oppe mod tyngdekraften, kan med tiden "give efter". Det er en konsekvens af at vælge 3D-printet plast som strukturmateriale.

### Slid (på bevægelige interfaces)
**Hvad:** At to overflader der gnider mod hinanden langsomt slider hinanden væk.
**Hvorfor vigtigt:** Når et printet led drejer på en printet aksel, opstår slid hurtigere end på et metal-leje. Påvirker repeterbarheden over tid.

---

## 3. Elektronik

### Servo / servomotor
**Hvad:** En motor med indbygget positions-feedback og elektronik der gør at den kan bevæges til en specifik vinkel.
**Hvorfor vigtigt:** Dit projekts hovedaktuator. Du sender en *ønsket position*, og servoen klarer selv reguleringen.

### Bus-servo (intelligent servo)
**Hvad:** En servo med indbygget mikrocontroller, der kommunikerer over en seriel bus (TTL) i stedet for traditionel PWM-styring. Eksempel: Waveshare ST3215, Dynamixel.
**Hvorfor vigtigt:** Bus-servoer kan dele én datalinje – mange servoer på samme bus, hver med eget ID. De giver også feedback (faktisk position, temperatur, strømforbrug). Det er kernen i hvorfor armens 7 servoer kan styres fra én ESP32.

### TTL-serial (halv-duplex)
**Hvad:** En enkel seriel kommunikationsstandard hvor data sendes én bit ad gangen over én datalinje. "Halv-duplex" = der kan kun sendes i én retning ad gangen.
**Hvorfor vigtigt:** Det er protokollen ST3215-servoerne taler. ESP32'en sender en kommando, alle servoer lytter, men kun den med rette ID svarer – derefter kan ESP32'en sende næste kommando.

### Daisy-chain
**Hvad:** Komponenter koblet i serie efter hinanden, ikke i stjerne. Hver komponent har et indgangs- og udgangsstik.
**Hvorfor vigtigt:** Armens servoer er forbundet i daisy-chain på den serielle bus – det betyder simpel kabelføring, men hvis ét stik er dårligt, dør hele kæden efter det punkt.

### ID (servo-ID)
**Hvad:** Et entydigt nummer hver bus-servo har. ST3215-servoerne i armen har ID 1–7.
**Hvorfor vigtigt:** Når ESP32'en sender en kommando, indeholder den et ID – kun den servo svarer. Hvis to servoer ved et uheld har samme ID, kollapser kommunikationen.

### Encoder
**Hvad:** En sensor der måler en aksels vinkel. ST3215 bruger en *magnetisk encoder* (magnet + Hall-sensor).
**Hvorfor vigtigt:** Det er encoderen der gør at servoen ved hvor den **er**, så den kan regulere hen mod hvor den **skal være**. Uden den er PID-regulering ikke mulig.

### Mikrocontroller
**Hvad:** En lille computer på én chip, beregnet til at styre hardware. ESP32 i dit projekt.
**Hvorfor vigtigt:** ESP32'en oversætter mellem ROS-verdenen (Jetson, USB) og hardware-verdenen (TTL-bus, servo-protokol). Den er broen.

### ESP32
**Hvad:** En specifik mikrocontroller-familie fra Espressif – billig, kraftig, har Wi-Fi og Bluetooth (selvom det ikke bruges her).
**Hvorfor vigtigt:** Det konkrete valg af mikrocontroller. Hver servogruppe har sin egen ESP32.

### USB-serial / virtuel COM-port
**Hvad:** Når en mikrocontroller forbindes til en computer via USB, fremstår den ofte som en seriel port (`/dev/ttyUSBx` på Linux, `COMx` på Windows).
**Hvorfor vigtigt:** Det er sådan Jetsonen "ser" ESP32'erne. Plug-in-rækkefølgen kan ændre hvilken USB-port der får hvilket nummer – en typisk fejlkilde.

### Strømbudget
**Hvad:** En beregning af det samlede strømforbrug ved værste tilfælde, så strømforsyning og kabler kan dimensioneres korrekt.
**Hvorfor vigtigt:** Hvis du undervurderer strømmen, falder spændingen, og servoerne fejler uforudsigeligt. Det er et af de mest klassiske fejl-områder ved integration.

### Kabeltværsnit
**Hvad:** Hvor tyk en leder er (mm² eller AWG). Tykkere leder = mindre modstand = mindre spændingsfald.
**Hvorfor vigtigt:** For tynde kabler til høj strøm bliver varme og giver spændingsfald. Skal indgå i strømbudgettet.

### Trækaflastning
**Hvad:** En mekanisk fastholdelse af et kabel, så træk i kablet ikke overføres direkte til loddepunktet eller stikket.
**Hvorfor vigtigt:** Uden trækaflastning brækker ledninger af ved gentagne bevægelser – især i en arm der bevæger sig.

---

## 4. Styring og regulering

### Styring (open-loop)
**Hvad:** At sende en kommando uden at måle om den faktisk udføres.
**Hvorfor vigtigt:** Du sender ikke "open-loop"-kommandoer direkte – men begrebet er forudsætningen for at forstå hvorfor regulering er nødvendigt.

### Regulering (closed-loop / lukket sløjfe)
**Hvad:** At måle systemets faktiske tilstand, sammenligne med det ønskede, og justere indgreb ud fra forskellen (*fejlen*).
**Hvorfor vigtigt:** Det er det servoerne gør internt med deres PID-løkke. Uden regulering ville de bare drive forbi målet.

### PID-regulering
**Hvad:** Den mest brugte type closed-loop regulator. Reagerer på:
- **P (proportional):** "Hvor langt er jeg fra målet?" – større fejl, kraftigere indgreb
- **I (integral):** "Hvor længe har jeg været forkert?" – fjerner blivende afvigelser
- **D (differential):** "Hvor hurtigt nærmer jeg mig målet?" – dæmper og forhindrer overshoot

**Hvorfor vigtigt:** Hver af dine 7 servoer har en intern PID-løkke. Konfigurationsfilen `servo_arm_left_params.json` indeholder `gain_P`, `gain_I`, `gain_D` pr. servo. Du skal kunne forklare hvad disse tre gør, hvis du bliver spurgt.

### Setpoint / referenceværdi
**Hvad:** Den ønskede værdi som regulatoren skal nå.
**Hvorfor vigtigt:** Når slider-GUI'en sender en vinkel til en servo, er det setpointet. Servoens interne PID forsøger at bringe den faktiske position derhen.

### Overshoot
**Hvad:** Når et system "skyder forbi" målet før det stabiliserer sig.
**Hvorfor vigtigt:** Et tegn på at P-leddet er for højt eller D-leddet for lavt. Synligt under PID-tuning.

### Indsvingningstid
**Hvad:** Hvor lang tid der går fra setpointet ændres til systemet er stabilt inden for en accepteret fejl.
**Hvorfor vigtigt:** Mål for hvor "kvik" reguleringen er. Indgår i en kvalitetsvurdering af PID-indstillingen.

### Repeterbarhed
**Hvad:** Hvor præcist samme position rammes ved gentagne forsøg.
**Hvorfor vigtigt:** Et nøgletal når armen testes. Lav repeterbarhed kan skyldes mekanisk slør, dårlig PID-tuning eller temperaturdrift.

### Gear-ratio (udveksling)
**Hvad:** Forholdet mellem servo-aksens omdrejning og leddets omdrejning. Hvis et led har gear 2:1 betyder det at servoen skal dreje 2 grader for at leddet drejer 1 grad.
**Hvorfor vigtigt:** Bruges i konfigurationsfilen til at oversætte mellem "led-vinkel" (det vi tænker i) og "servo-vinkel" (det servoen forstår).

### Software-grænse (angle_software_min / max)
**Hvad:** En grænseværdi i softwaren der forhindrer servoen i at bevæge et led ud over hvad mekanikken kan tåle.
**Hvorfor vigtigt:** Hvis disse grænser er forkerte, kan armen ramme sig selv eller låse. De skal kalibreres for hvert led under idriftsættelse.

### Kalibrering
**Hvad:** At fastlægge sammenhængen mellem servoens "rå" position og leddets faktiske vinkel – inklusive nulpunkt og grænser.
**Hvorfor vigtigt:** Uden kalibrering peger en kommando om "albue 90°" ikke nødvendigvis på 90° i virkeligheden. Det er en obligatorisk del af idriftsættelsen.

---

## 5. Software og kommunikation

### ROS 2 (Robot Operating System 2)
**Hvad:** En *middleware* (mellemlag-software) til robotapplikationer. Tilbyder en standardiseret måde at lade software-komponenter ("noder") tale sammen.
**Hvorfor vigtigt:** Hele Wattsons software er bygget på ROS 2. Du arbejder *inden* i dette økosystem – du opfinder ikke kommunikationen selv.

### ROS 2 Humble
**Hvad:** En specifik LTS-udgave af ROS 2 (LTS = Long Term Support).
**Hvorfor vigtigt:** Det er den version Wattson kører. Den bestemmer hvilke pakker og versioner der virker sammen.

### Node
**Hvad:** Et selvstændigt program i et ROS-system. Hver node har et formål – fx servo-styring, kamera-aflæsning, sliders.
**Hvorfor vigtigt:** I dit projekt er `wattson_servo_manager_node` den vigtigste node – den taler med ESP32'en og udstiller positionerne som ROS-topics.

### Topic
**Hvad:** En navngivet kommunikationskanal mellem noder. En node *publicerer* data på topicet, andre noder *subscriber*.
**Hvorfor vigtigt:** Det er sådan slider-GUI'en og servo-manager-noden hænger sammen: GUI'en publicerer på et joint-command-topic, servo-manageren subscriber på det.

### Publish / Subscribe (pub/sub)
**Hvad:** Kommunikationsmodellen i ROS. En udgiver behøver ikke vide hvem der lytter, og omvendt.
**Hvorfor vigtigt:** Det er grunden til at man kan tilføje fx en logger-node uden at ændre i servo-manager-noden.

### Launch-fil
**Hvad:** En Python-fil (i ROS 2) der starter en eller flere noder med specifikke parametre i én kommando.
**Hvorfor vigtigt:** `slider_control.launch.py` starter både GUI-noden, servo-manager-noden og indlæser konfigurationen – uden at du behøver starte hver del manuelt.

### JSON-konfigurationsfil
**Hvad:** Et tekstformat til strukturerede data – nøgle/værdi-par i hierarki.
**Hvorfor vigtigt:** Servokonfigurationen ligger som JSON. Du kan **læse den, ændre den og forklare værdierne** uden at kompilere noget om – det er et stort plus ved idriftsættelse.

### Workspace
**Hvad:** Den mappe der indeholder alle pakkerne i et ROS-projekt.
**Hvorfor vigtigt:** Hele Wattsons kode ligger i ét workspace. Du kompilerer det med `colcon build` og kører noderne derfra.

### Jetson Orin Nano
**Hvad:** En lille indlejret computer fra NVIDIA, med GPU-acceleration egnet til AI/robotik.
**Hvorfor vigtigt:** Det er hjernen i Wattson. Den kører Linux + ROS 2 + dine noder.

### SSH
**Hvad:** Secure Shell – en protokol til at logge ind på en anden computer over netværk og styre den fra et terminal-vindue.
**Hvorfor vigtigt:** Du arbejder ikke fysisk på Jetsonen – du SSH'er ind fra din egen PC og kører kommandoer derfra.

---

## 6. Idriftsættelse og metode

### Idriftsættelse (commissioning)
**Hvad:** Processen med at få et færdigbygget system til at fungere som tænkt – kalibrering, test, fejlfinding, dokumentation.
**Hvorfor vigtigt:** Det er dit projekts **kernedisciplin**. Du har ikke designet robotten – du *idriftsætter* en kopi af et eksisterende design. Det er en legitim ingeniør-disciplin og fuld §4-relevant.

### Integration
**Hvad:** At samle separate komponenter til ét fungerende system.
**Hvorfor vigtigt:** Dit projekt er primært et integrationsprojekt: mekanik + el + software → fungerende arm.

### Modulær tilgang
**Hvad:** At dele et stort system op i selvstændige enheder der kan bygges, testes og udskiftes uafhængigt.
**Hvorfor vigtigt:** Det er din **afgrænsnings-begrundelse**: én arm er et modul. Den kan stå alene og demonstrerer alle systemets aspekter.

### Iterativ proces
**Hvad:** En arbejdsform hvor man arbejder i gentagne sløjfer af "byg lidt → test → ret → byg lidt mere".
**Hvorfor vigtigt:** Det er sådan dit projekt faktisk er udført, og det er noget af det censor gerne vil høre om: hvilke problemer opstod, hvordan diagnosticerede du dem, hvad rettede du.

### Trade-off
**Hvad:** Et bevidst valg mellem to ting der ikke kan opfyldes samtidigt – fx vægt vs. styrke.
**Hvorfor vigtigt:** Vis at du har overvejet alternativer, ikke bare gjort det første der faldt dig ind. Hører hjemme i diskussionskapitlet.

---

## 7. Akademiske/rapport-begreber

### Problemformulering
**Hvad:** Det centrale spørgsmål rapporten besvarer. I dit tilfælde: hvordan integreres en humanoid robot fra eksisterende design til funktionel enhed.
**Hvorfor vigtigt:** Den styrer alt. Hvert kapitel skal kunne kobles tilbage hertil. Konklusionen er et direkte svar på den.

### Afgrænsning
**Hvad:** Hvad rapporten *ikke* dækker, og hvorfor.
**Hvorfor vigtigt:** En god afgrænsning beskytter dig – den anden arm, ben og hoved er ikke en del af bedømmelsen.

### Målgruppe
**Hvad:** Hvem rapporten er skrevet til.
**Hvorfor vigtigt:** Bestemmer sprogniveau og hvor meget der skal forklares. Din målgruppe er teknikere/ingeniører – det betyder fagord er OK, men højeste niveaus teori skal kort forklares.

### Normalside
**Hvad:** En standardiseret side på 2400 tegn inkl. mellemrum (Danmarks-standard). Ikke det samme som en faktisk side i PDF'en.
**Hvorfor vigtigt:** Dine 20 sider er normalsider. Figurer, kode og tabeller tæller ikke med.

### Studieordningens §1 og §4
**Hvad:** §1 = læringsmål for hele uddannelsen. §4 = krav til det afsluttende eksamensprojekt.
**Hvorfor vigtigt:** §4 kræver at rapporten dokumenterer "praksis og central anvendt teori og metode" – derfor er kapitel 2 om teori vigtigt, ikke bare praksis-beskrivelser.

### Praksisnær problemstilling
**Hvad:** En opgave hentet fra virkeligt arbejde, ikke et konstrueret eksempel.
**Hvorfor vigtigt:** Din opgave er stillet af Teknologisk Institut – det er det §4 efterspørger.

### Censor
**Hvad:** En ekstern bedømmer, uafhængig af din uddannelse.
**Hvorfor vigtigt:** Han/hun har **ikke** fulgt dit forløb. Rapporten skal stå alene og kunne læses uden indforstået baggrund.

---

## Tips til mundtlig forsvar

Hvis du bliver spurgt om et fagord du ikke kender ordret, så:

1. **Bryd ordet ned i dele** du kender. "Anisotropi" = aniso (ikke ens) + tropi (retning) → ulig efter retning.
2. **Giv et eksempel fra dit projekt** før du giver definitionen. Det viser at du har forstået, ikke memoreret.
3. **Knyt det altid til dit eget arbejde**: "I min arm valgte jeg X fordi Y…" frem for "X er generelt set Y."
