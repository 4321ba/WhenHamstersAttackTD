# When Hamsters Attack TD

## A projekt célja

A játékot a BME Mérnökinformatikus képzés Játékfejlesztés labor (VIIIMA24) c. tárgya keretében készítettem, nagyháziként.

## Felhasznált eszközök

A játék a Godot_v4.5.1-stable verzióban készült, Linux alatt, a C# nélküli verzióval. A programkód GDScript nyelvű, a vignette shader pedig GDShader, az [innen](https://godotshaders.com/shader/vignette/) származik, ezúton is köszönet.

Használva volt továbbá némelyik egyszerű kódolás részhez, illetve néhol követhető tutorialok készítéséhez a Google Gemini MI-je.

Verziókezeléshez a projekt felétől-kétharmadától használtam a git-et, a projekt, futtatható változatok, dokumentáció, és minden egyéb elérhető GitHubon [ezen](https://github.com/4321ba/WhenHamstersAttackTD) a linken.

## Architektúra

A játék két fő jelenetből áll: a főmenüből, és a játéktérből. A főmenü háttérnek példányosítja a játéktér egy lebutított változatát. Fájlkezelés és állapotmentés nincs.

Az ellenfelek egy közös jelenetből örökölnek, és a tornyok is. Külön scriptje nincs az egyes leszármazottaknak, csak egy közös az ellenfeleknek, és egy közös a tornyoknak.

## Felhasználói dokumentáció

A játék előzetes tudás nélkül navigálható és játszható kell legyen, a főmenüből elérhető Controls menüpont alatt megtalálható az irányítás. A tornyok és ellenfelek képességeit ki lehet tapasztalni. Ezek a következők: A legolcsóbb (recon) és a legdrágább (artillery) torony lényegében ugyanúgy viselkedik, csak az ára, látótávolsága, sebzése és kinézete más. A középső árú torony (rocket) területi sebzéssel rendelkezik, ezt jelzi a robbanás. Az ellenfelek (infantery, tank, vtb) leginkább csak vizuálisan, sebességben, életerőben és sebzésben különböznek.

30 körből áll a játék, ez után nyer a játékos. Ha előbb elfogy az élete, veszít.

Figyelem! A játékban Escape-pel behozható menü nem állítja meg a játékot.

### Tippek

Valószínűleg szükséged lesz az artillery-re a vtb-k ellen.

Az utolsó körhöz valószínűleg készíteni kell egy kis labirintust az ellenfeleknek, tornyokból.

## Lehetséges továbbfejlesztések

- Nézet mozgatásának intuitívabbá tétele
- Tornyok árának kiírása a képernyőre
- Első kör ne induljon el automatikusan (esetleg a többi se)
- Alul kiválasztható tornyok kattinthatóak legyenek, vagy legalább nyeljék el a kattintást
- Az a kör, ahol 2 vtb jön (kb 10-11.), legyen később (ha egy vtb-t nem tud a setup lelőni, akkor az az előző illetve abban a körben nagyon sok sebzést jelent)

